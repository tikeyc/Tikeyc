//
//  TServiceTool.m
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//



#import "TServiceTool.h"


@implementation TNetManager

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
    return self;
}

#pragma mark - Public
+ (instancetype)shareManager
{
    static TNetManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}



@end


@implementation TServiceTool


#pragma mark - 网络监测
+ (void)networkMonitoring
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi状态");
//                [TAlertView showWithTitle:@"提示" message:@"正在使用WiFi" cancelButtonTitle:@"知道了" otherButtonTitles:nil type:UIAlertControllerStyleAlert  andParentView:nil andAction:^(NSInteger buttonIndex) {
//                    NSLog(@"%ld",(long)buttonIndex);
//                } ];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [TAlertView showWithTitle:@"提示" message:@"正在使用移动数据流量" cancelButtonTitle:@"知道了" otherButtonTitles:nil type:UIAlertControllerStyleAlert andParentView:nil andAction:^(NSInteger buttonIndex) {
                    NSLog(@"%ld",(long)buttonIndex);
                } ];
                
                YYReachability *reach = [YYReachability reachability];
                YYReachabilityWWANStatus wwanStatus = reach.wwanStatus;
                switch (wwanStatus) {
                    case YYReachabilityWWANStatusNone:
                    {
                        NSLog(@"蜂窝网络");
                        break;
                    }
                    case YYReachabilityWWANStatus2G:
                    {
                        NSLog(@"2G");
                        break;
                    }
                    case YYReachabilityWWANStatus3G:
                    {
                        NSLog(@"3G");
                        break;
                    }
                    case YYReachabilityWWANStatus4G:
                    {
                        NSLog(@"4G");
                        break;
                    }
                    default:
                        break;
                }
                
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
}


+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    TNetManager *mgr = [TNetManager shareManager];
    NSURLSessionDataTask *task = [mgr GET:URLString parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"%@",error);
        failure(task,error);
    }];;
    return task;
}


+ (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSURLSessionDataTask *task = [[TNetManager shareManager] POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"%@",error);
        failure(task,error);
    }];
    return task;
}

+ (void)cancel
{
    // 取消网络请求
    [[TNetManager shareManager].operationQueue cancelAllOperations];
    
    // 取消任务中的所有网络请求
    //    [[TNetManager shareManager].tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 杀死Session
    //    [[TNetManager shareManager] invalidateSessionCancelingTasks:YES];
}


@end
