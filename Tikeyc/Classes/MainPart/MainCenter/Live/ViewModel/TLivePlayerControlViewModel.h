//
//  TLivePlayerControlViewModel.h
//  Tikeyc
//
//  Created by ways on 16/9/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BarrageKit.h"

@interface TLivePlayerControlViewModel : NSObject

@property (nonatomic,strong)BarrageManager *manager;

@property (nonatomic,strong)RACCommand *requestCommand;



/**
 创建弹幕

 @param barrageSuperView 弹幕显示的区域
 */
- (void)creatBarrageViewWithSuperView:(UIView *)barrageSuperView;


@end
