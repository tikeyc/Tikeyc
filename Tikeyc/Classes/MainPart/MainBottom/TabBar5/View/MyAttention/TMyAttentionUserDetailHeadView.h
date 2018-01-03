//
//  MyAttentionUserDetailHeadView.h
//  LoveShare
//
//  Created by ways on 2017/5/5.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMyAttentionUserDetailHeadView : UIView

@property (strong, nonatomic) IBOutlet UIButton *userIconImagView;
@property (strong, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userAttentionNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *userFanseNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *userAttentionButton;

+ (instancetype)loadFromNib;

@end
