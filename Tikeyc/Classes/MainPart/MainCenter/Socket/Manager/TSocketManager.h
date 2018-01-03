//
//  TSocketManager.h
//  Tikeyc
//
//  Created by ways on 2017/10/11.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSocketManager : NSObject


+ (instancetype)share;
- (int)connect;
- (void)disConnect;
- (void)sendMsg:(NSString *)msg;

@end
