//
//  TLPCMessageView.h
//  Tikeyc
//
//  Created by ways on 16/9/26.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPLCMessageModel.h"

@interface TLPCMessageView : UIView


@property (nonatomic,strong)UIControl *userControl;//用户superView
@property (nonatomic,strong)UILabel *nickNameLabel;//用户昵称
@property (nonatomic,strong)UILabel *messageLabel;//用户输入信息：


@property (nonatomic,strong)TPLCMessageModel *messageModel;


@end
