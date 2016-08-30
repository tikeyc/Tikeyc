//
//  TLoginViewModel.m
//  Tikeyc
//
//  Created by ways on 16/8/26.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLoginViewModel.h"

@implementation TLoginViewModel

- (instancetype)initLoginViewModel{
    self = [super init];
    
    if (self) {
        
        [self initialBind];
    }
    
    return self;
}

- (TLoginModel *)loginModel{
    if (!_loginModel) {
        _loginModel = [[TLoginModel alloc] init];
    }
    return _loginModel;
}

- (void)initialBind{
    
    TWeakSelf(self)
    self.loginButtonEnableSignal = [RACSignal combineLatest:@[RACObserve(self.loginModel,userName),RACObserve(self.loginModel, userPassword)] reduce:^id(NSString *userName,NSString *userPassword){
        id value = @([[userName lowercaseString] isEqualToString:@"tikeyc"] && userPassword.length >= 6);
        weakself.loginButtonEnable = [value boolValue];
        return value;
    }];
    
    // 处理登录业务逻辑
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            // 模仿网络延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [subscriber sendNext:@"登录成功"];
                
                // 数据传送完毕，必须调用完成，否则命令永远处于执行状态
                [subscriber sendCompleted];
            });
            
            return nil;
            /*
            [TServiceTool GET:nil parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:@"登录成功"];
                
                // 数据传送完毕，必须调用完成，否则命令永远处于执行状态
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendNext:error];
                
                // 数据传送完毕，必须调用完成，否则命令永远处于执行状态
                [subscriber sendCompleted];
                [subscriber sendError:error];
            }];
             
             return nil;
            */
            
        }];
        
        
        return signal;
    }];
    
    //监听登录产生的数据
    [_requestCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        
    }];
    
    // 监听登录状态
    [[_requestCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x isEqualToNumber:@(YES)]) {
            
            // 正在登录ing...
            // 用蒙版提示
            [SVProgressHUD showWithStatus:@"正在登录..."];
            
            
        }else
        {
            // 登录成功
            // 隐藏蒙版
            [SVProgressHUD dismiss];
            
            
        }
    }];
    
}


@end












