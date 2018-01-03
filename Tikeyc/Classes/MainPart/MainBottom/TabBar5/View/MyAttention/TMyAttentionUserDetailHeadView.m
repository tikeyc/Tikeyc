//
//  MyAttentionUserDetailHeadView.m
//  LoveShare
//
//  Created by ways on 2017/5/5.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TMyAttentionUserDetailHeadView.h"

@interface TMyAttentionUserDetailHeadView ()

- (IBAction)backButtonClickAction:(UIButton *)sender;
- (IBAction)userAttentionButtonClickAction:(UIButton *)sender;



@end

@implementation TMyAttentionUserDetailHeadView


+ (instancetype)loadFromNib {
    TMyAttentionUserDetailHeadView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:NULL] lastObject];
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [self initProperty];
}

#pragma mark - init

- (void)initProperty {
    self.userAttentionNumLabel.text = @"100\n关注";
    self.userFanseNumLabel.text = @"10万\n粉丝";
}

#pragma mark - actions

- (IBAction)backButtonClickAction:(UIButton *)sender {
    
    [self.viewController.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)userAttentionButtonClickAction:(UIButton *)sender {
}
@end
