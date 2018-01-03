//
//  TWebSokectManager.h
//  Tikeyc
//
//  Created by ways on 2017/11/9.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    disConnectByUser ,
    disConnectByServer,
} DisConnectType;

@interface TWebSocketManager : NSObject


+ (instancetype)share;

- (void)connect;
- (void)disConnect;

- (void)sendMsg:(NSString *)msg;

- (void)ping;

@end
