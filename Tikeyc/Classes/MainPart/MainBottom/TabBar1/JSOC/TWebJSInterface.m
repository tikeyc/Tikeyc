//
//  TWebJSInterface.m
//  Tikeyc
//
//  Created by ways on 2017/6/9.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TWebJSInterface.h"

@implementation TWebJSInterface

- (NSString *)test:(NSString *)params1 :(NSString *)params2 {
    NSLog(@"  test  did  params1 =%@  ,params2 =%@ ",params1,params2);
    [self show:params1 :params2];
    return @"js调用OC成功并返回了该字符串给js";
}


- (void)show:(NSString *)params1 :(NSString *)params2 {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [TAlertView showWithTitle:@"js调用OC成功并显示js传过来的值"
                          message:nil
                cancelButtonTitle:@"取消"
                otherButtonTitles:@[params1,params2]
                             type:UIAlertControllerStyleActionSheet
                    andParentView:nil
                        andAction:^(NSInteger buttonIndex) {
                            
                        }];
    });
    
}

@end
