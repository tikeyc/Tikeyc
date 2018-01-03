//
//  TServiceTool.h
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//




#import <Foundation/Foundation.h>

#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface TNetManager : AFHTTPSessionManager

/**
 *  单例
 */
+ (instancetype)shareManager;

@end



@interface TServiceTool : NSObject

//网络监测
+ (void)networkMonitoring;


+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


+ (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

+ (void)cancel;


@end

NS_ASSUME_NONNULL_END












