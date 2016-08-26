//
//  TLoginViewModel.h
//  Tikeyc
//
//  Created by ways on 16/8/26.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TLoginModel.h"

@interface TLoginViewModel : NSObject


@property (nonatomic,strong)TLoginModel *loginModel;

@property (nonatomic,strong)RACSignal *loginButtonEnableSignal;
@property (nonatomic,assign)BOOL loginButtonEnable;

@property (nonatomic,strong)RACCommand *requestCommand;

- (instancetype)initLoginViewModel;


@end
