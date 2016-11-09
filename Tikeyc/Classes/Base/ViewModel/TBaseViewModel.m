//
//  TBaseViewModel.m
//  Tikeyc
//
//  Created by ways on 2016/10/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TBaseViewModel.h"

@implementation TBaseViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initRACSignal];
    }
    return self;
}


#pragma mark - init bind

- (void)initRACSignal{
    
    @weakify(self)
    ////////////////////////////request
    self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [TServiceTool GET:self.requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [subscriber sendCompleted];
                [subscriber sendError:error];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
    
    //
    /**
     在子类中再设置一下方法并做相应的特殊处理
     此处做一些公共处理，如登录失效跳转登录页等
     */
    [self.requestCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *result) {
        @strongify(self)
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"lives"] isKindOfClass:[NSArray class]]) {

        }
    }];
    
    /**
     //按理来说总共会执行3此监听请求执行状态，默认会执行一次（所以skip跳过第一次）。
     
     @param x 请求正在执行时x为1，介绍时x为0
     */
    [[self.requestCommand.executing skip:1] subscribeNext:^(id x) {
        [x boolValue] ? [SVProgressHUD show] : [SVProgressHUD dismiss];
    }];
    ////////////////////////////request
    
    
}


@end
