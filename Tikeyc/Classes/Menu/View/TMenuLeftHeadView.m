//
//  TMenuLeftHeadView.m
//  Tikeyc
//
//  Created by ways on 16/8/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMenuLeftHeadView.h"

@implementation TMenuLeftHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    [[self.userQRCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"RQ Code 功能暂未实现...");
    }];
    
    //延迟调用是因为第一时间self.userPhotoImgView.bounds 都是0
    [self performSelector:@selector(setSubViewProperty) withObject:nil afterDelay:1];
}

#pragma mark - init

- (void)setSubViewProperty{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_background"]];;
    //
    [TKCAppTools setViewCornerCircleWithView:self.userPhotoImgView];
    [TKCAppTools setViewCornerCircleWithView:self.userQRCodeButton];
    
}

@end
