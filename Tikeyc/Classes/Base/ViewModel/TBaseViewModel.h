//
//  TBaseViewModel.h
//  Tikeyc
//
//  Created by ways on 2016/10/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBaseViewModel : NSObject


@property (nonatomic,strong)RACCommand *requestCommand;

@property (nonatomic,copy)NSString *requestURL;


@end
