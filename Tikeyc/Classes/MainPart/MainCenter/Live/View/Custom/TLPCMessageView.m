//
//  TLPCMessageView.m
//  Tikeyc
//
//  Created by ways on 16/9/26.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLPCMessageView.h"

#define rankView_width 40

#define TLPCMessage_text_system_font_value 12

@implementation TLPCMessageView



- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
        
    }
    return self;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initSubviews];
}


- (void)initSubviews{
    //用户输入信息：
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 21)];
    _messageLabel.numberOfLines = 0;
    _messageLabel.textColor = [UIColor redColor];
    _messageLabel.font = TSystemFontSize(TLPCMessage_text_system_font_value);
    [self addSubview:_messageLabel];
    //用户
    _userControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, rankView_width, TLPCMessage_text_system_font_value)];
    [_userControl addTarget:self action:@selector(clickUserControl:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userControl];
    //用户等级
    UIView *rankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, TLPCMessage_text_system_font_value)];
    rankView.clipsToBounds = YES;
    rankView.backgroundColor = TColor_RGB(63, 164, 48);
    rankView.userInteractionEnabled = NO;
    UIImageView *rankImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_myaccount_reddiamond"]];
    rankImg.size = CGSizeMake(12, 12);
    [rankView addSubview:rankImg];
    UILabel *rankMumLabel = [[UILabel alloc] initWithFrame:CGRectMake(rankImg.right + 5, 0, 24, TLPCMessage_text_system_font_value)];
    rankMumLabel.textColor = [UIColor yellowColor];
    rankMumLabel.font = TSystemFontSize(TLPCMessage_text_system_font_value);
    rankMumLabel.text = @"110";
    [rankMumLabel sizeToFit];
    [rankView addSubview:rankMumLabel];
    [_userControl addSubview:rankView];
    //用户昵称
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(rankView.right + 2, 0, 60, 21)];
    _nickNameLabel.textColor = [UIColor yellowColor];
    _nickNameLabel.font = TSystemFontSize(TLPCMessage_text_system_font_value);
    _nickNameLabel.text = @"💕💖阿福卡💕💖:";
    [_nickNameLabel sizeToFit];
    [_userControl addSubview:_nickNameLabel];
    NSDictionary *attr = @{NSFontAttributeName:TSystemFontSize(TLPCMessage_text_system_font_value)};
    CGFloat width = [_nickNameLabel.text sizeWithAttributes:attr].width;//求出字体的宽度
    //用户输入信息：
    _userControl.width = rankView_width + width;
    NSInteger numWords =  4*_userControl.width/TLPCMessage_text_system_font_value;//字占位划分
    NSString *message = @"偶哪里够看了空间及管理卡UI额若IQ而，⬆️🎁💕💖😌❤️";
    for (int i = 0; i < numWords; i++) {
        message = [@" " stringByAppendingString:message];
    }
    _messageLabel.text = message;
    [_messageLabel sizeToFit];
}



#pragma mark - Actions Method

- (void)clickUserControl:(UIControl *)control{
    NSLog(@"clickUserControl");
}


#pragma mark - set

- (void)setMessageModel:(TPLCMessageModel *)messageModel{
    _messageModel = messageModel;
    
    //
    _nickNameLabel.text = @"💕💖阿福卡💕💖:";
    [_nickNameLabel sizeToFit];
    NSDictionary *attr = @{NSFontAttributeName:TSystemFontSize(TLPCMessage_text_system_font_value)};
    CGFloat width = [_nickNameLabel.text sizeWithAttributes:attr].width;//求出字体的宽度
    //用户输入信息：
    _userControl.width = rankView_width + width;
    NSInteger numWords =  4*_userControl.width/TLPCMessage_text_system_font_value;//字占位划分
    NSString *message = [messageModel.message stringByAppendingString:@"偶哪里够看了空间及管理卡UI额若IQ而，⬆️🎁💕💖😌❤️偶哪里够看了空间及管理卡UI额若IQ而，⬆️🎁💕💖😌❤️偶哪里够看了空间及管理卡UI额若IQ而，⬆️🎁💕💖😌❤️偶哪里够看了空间及管理卡UI额若IQ而，⬆️🎁💕💖😌❤️偶哪里够看了空间及管理卡UI额若IQ而，⬆️🎁💕💖😌❤️"];
    for (int i = 0; i < numWords; i++) {
        message = [@" " stringByAppendingString:message];
    }
    _messageLabel.text = message;
    [_messageLabel sizeToFit];
    self.height = _messageLabel.bottom;
}


@end










