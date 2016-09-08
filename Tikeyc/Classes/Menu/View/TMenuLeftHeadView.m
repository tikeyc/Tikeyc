//
//  TMenuLeftHeadView.m
//  Tikeyc
//
//  Created by ways on 16/8/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMenuLeftHeadView.h"

#import "TMenuLeftTableViewController.h"
#import "TSelectQRCodeTypeViewController.h"

@implementation TMenuLeftHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    [[self.userQRCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"RQ Code 功能暂未实现...");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LeftView" bundle:[NSBundle mainBundle]];
        TSelectQRCodeTypeViewController *codeVC = [storyboard instantiateViewControllerWithIdentifier:@"TSelectQRCodeTypeViewController"];
        
        if ([self.viewController isKindOfClass:[TMenuLeftTableViewController class]]) {
            [((TMenuLeftTableViewController*)self.viewController).mainMenuViewController showCenterControllerWithAnimation:YES toShowNextController:codeVC];
        }
    }];
    
    //延迟调用是因为第一时间self.userPhotoImgView.bounds 都是0
    [self performSelector:@selector(setSubViewProperty) withObject:nil afterDelay:0];
}

#pragma mark - init

- (void)setSubViewProperty{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_background"]];
    //
    UIImage *cornerImg = [self.userPhotoImgView.image imageByRoundCornerRadius:self.userPhotoImgView.image.size.width/2];
    self.userPhotoImgView.image = cornerImg;
//    [TKCAppTools setViewCornerCircleWithView:self.userPhotoImgView];
//    [TKCAppTools setViewCornerCircleWithView:self.userQRCodeButton];
    UIImage *cornerImg2 = [self.userQRCodeButton.currentImage imageByRoundCornerRadius:self.userQRCodeButton.currentImage.size.width/2];
    [self.userQRCodeButton setImage:cornerImg2 forState:UIControlStateNormal];
    
}

@end
