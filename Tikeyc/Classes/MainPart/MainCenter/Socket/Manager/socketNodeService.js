
/*
 1服务器调用 socket(...) 创建socket；
 2服务器调用 listen(...) 设置缓冲区；
 3服务器通过 accept(...)接受客户端请求建立连接；
 4服务器与客户端建立连接之后，就可以通过 send(...)/receive(...)向客户端发送或从客户端接收数据；
 5服务器调用 close 关闭 socket；=
 */

/*如果你本机有node的解释器，那么直接在终端进入该源代码文件目录中输入：
 node socketNodeService.js 即可开启该服务器
 */
var net = require('net');
var HOST = '127.0.0.1';
var PORT = 6969;

// 创建一个TCP服务器实例，调用listen函数开始监听指定端口
// 传入net.createServer()的回调函数将作为”connection“事件的处理函数
// 在每一个“connection”事件中，该回调函数接收到的socket对象是唯一的
net.createServer(function(sock) {
                 
                 // 我们获得一个连接 - 该连接自动关联一个socket对象
                 console.log('CONNECTED: ' +
                             sock.remoteAddress + ':' + sock.remotePort);
                 sock.write('服务端发出：连接成功');
                 // 为这个socket实例添加一个"data"事件处理函数
                 sock.on('data', function(data) {
                         console.log('DATA ' + sock.remoteAddress + ': ' + data);
                         // 回发该数据，客户端将收到来自服务端的数据
                         sock.write('You said "' + data + '"');
                         });
                 // 为这个socket实例添加一个"close"事件处理函数
                 sock.on('close', function(data) {
                         console.log('CLOSED: ' +
                                     sock.remoteAddress + ' ' + sock.remotePort);
                         });
                 }).listen(PORT, HOST);

console.log('Server listening on ' + HOST +':'+ PORT);
