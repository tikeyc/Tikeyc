//
//  TCocoaAsyncSocketManager.h
//  Tikeyc
//
//  Created by ways on 2017/11/8.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCocoaAsyncSocketManager : NSObject



+ (instancetype)share;

- (BOOL)connect;
- (void)disConnect;

- (void)sendMsg:(NSString *)msg;
- (void)pullTheMsg;

@end
