//
//  TSocketManager.m
//  Tikeyc
//
//  Created by ways on 2017/10/11.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TSocketManager.h"

#import "sys/types.h"
#import "sys/socket.h"
#import "netinet/in.h"
#import "arpa/inet.h"

/*
 //socket 创建并初始化 socket，返回该 socket 的文件描述符，如果描述符为 -1 表示创建失败。
 int socket(int addressFamily, int type,int protocol)
 //关闭socket连接
 int close(int socketFileDescriptor)
 //将 socket 与特定主机地址与端口号绑定，成功绑定返回0，失败返回 -1。
 int bind(int socketFileDescriptor,sockaddr *addressToBind,int addressStructLength)
 //接受客户端连接请求并将客户端的网络地址信息保存到 clientAddress 中。
 int accept(int socketFileDescriptor,sockaddr *clientAddress, int clientAddressStructLength)
 //客户端向特定网络地址的服务器发送连接请求，连接成功返回0，失败返回 -1。
 int connect(int socketFileDescriptor,sockaddr *serverAddress, int serverAddressLength)
 //使用 DNS 查找特定主机名字对应的 IP 地址。如果找不到对应的 IP 地址则返回 NULL。
 hostent* gethostbyname(char *hostname)
 //通过 socket 发送数据，发送成功返回成功发送的字节数，否则返回 -1。
 int send(int socketFileDescriptor, char *buffer, int bufferLength, int flags)
 //从 socket 中读取数据，读取成功返回成功读取的字节数，否则返回 -1。
 int receive(int socketFileDescriptor,char *buffer, int bufferLength, int flags)
 //通过UDP socket 发送数据到特定的网络地址，发送成功返回成功发送的字节数，否则返回 -1。
 int sendto(int socketFileDescriptor,char *buffer, int bufferLength, int flags, sockaddr *destinationAddress, int destinationAddressLength)
 //从UDP socket 中读取数据，并保存发送者的网络地址信息，读取成功返回成功读取的字节数，否则返回 -1 。
 int recvfrom(int socketFileDescriptor,char *buffer, int bufferLength, int flags, sockaddr *fromAddress, int *fromAddressLength)
 */

@interface TSocketManager()

@property (nonatomic,assign)int clientScoket;

@end

@implementation TSocketManager


+ (instancetype)share
{
    static dispatch_once_t onceToken;
    static TSocketManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance initScoket];
        [instance pullMsg];
    });
    return instance;
}

/**
 简单的IM客户端需要做如下4件事：
 
 1客户端调用 socket(...) 创建socket；
 2客户端调用 connect(...) 向服务器发起连接请求以建立连接；
 3客户端与服务器建立连接之后，就可以通过send(...)/receive(...)向客户端发送或从客户端接收数据；
 4客户端调用 close 关闭 socket；
 */
- (int)initScoket
{
    //每次连接前，先断开连接
    if (_clientScoket != 0) {
        [self disConnect];
        _clientScoket = 0;
    }
    
    //1创建客户端socket
    _clientScoket = CreateClinetSocket();
    
    //服务器Ip
    const char * server_ip = "127.0.0.1";
    //服务器端口
    short server_port = 6969;
    //等于0说明连接失败
    int client_socket = ConnectionToServer(_clientScoket,server_ip, server_port);
    if (client_socket == 0) {
        printf("Connect to server error\n");
        return client_socket;
    }
    //走到这说明连接成功
    printf("Connect to server ok\n");
    return client_socket;
}
//1客户端调用 socket(...) 创建socket
static int CreateClinetSocket()
{
    int ClinetSocket = 0;
    //创建一个socket,返回值为Int。（注scoket其实就是Int类型）
    //第一个参数addressFamily IPv4(AF_INET) 或 IPv6(AF_INET6)。
    //第二个参数 type 表示 socket 的类型，通常是流stream(SOCK_STREAM) 或数据报文datagram(SOCK_DGRAM)
    //第三个参数 protocol 参数通常设置为0，以便让系统自动为选择我们合适的协议，对于 stream socket 来说会是 TCP 协议(IPPROTO_TCP)，而对于 datagram来说会是 UDP 协议(IPPROTO_UDP)。
    ClinetSocket = socket(AF_INET, SOCK_STREAM, 0);
    return ClinetSocket;
}
//2客户端调用 connect(...) 向服务器发起连接请求以建立连接；
static int ConnectionToServer(int client_socket,const char * server_ip,unsigned short port)
{
    
    //生成一个sockaddr_in类型结构体
    struct sockaddr_in sAddr = {0};
    sAddr.sin_len = sizeof(sAddr);
    //设置IPv4
    sAddr.sin_family = AF_INET;
    
    //inet_aton是一个改进的方法来将一个字符串IP地址转换为一个32位的网络序列IP地址
    //如果这个函数成功，函数的返回值非零，如果输入地址不正确则会返回零。
    inet_aton(server_ip, &sAddr.sin_addr);
    
    //htons是将整型变量从主机字节顺序转变成网络字节顺序，赋值端口号
    sAddr.sin_port = htons(port);
    
    //用scoket和服务端地址，发起连接。
    //客户端向特定网络地址的服务器发送连接请求，连接成功返回0，失败返回 -1。
    //注意：该接口调用会阻塞当前线程，直到服务器返回。
    if (connect(client_socket, (struct sockaddr *)&sAddr, sizeof(sAddr)) == 0) {
        return client_socket;
    }
    return 0;
}

#pragma mark - 新线程来接收消息

- (void)pullMsg
{
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(recieveAction) object:nil];
    [thread start];
}

#pragma mark - 对外逻辑

- (int)connect
{
    return [self initScoket];
}
//4客户端调用 close 关闭 socket；
- (void)disConnect
{
    //关闭连接
    close(self.clientScoket);
}

//3客户端与服务器建立连接之后，就可以通过send(...)/receive(...)向客户端发送或从客户端接收数据；
- (void)sendMsg:(NSString *)msg
{
    
    const char *send_Message = [msg UTF8String];
    send(self.clientScoket,send_Message,strlen(send_Message) + 1,0);
    
}

//收取服务端发送的消息
- (void)recieveAction{
    while (1) {
        char recv_Message[1024] = {0};
        recv(self.clientScoket, recv_Message, sizeof(recv_Message), 0);
        printf("%s\n",recv_Message);
    }
}

@end
