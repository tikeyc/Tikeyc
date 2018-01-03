//
//  TWebJSInterface.h
//  Tikeyc
//
//  Created by ways on 2017/6/9.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSObjectProtocol <JSExport>

- (NSString *)test:(NSString *)params1 :(NSString *)params2;

@end

@interface TWebJSInterface : NSObject<TestJSObjectProtocol>


@end
