//
//  TMenuLeftHeadView.h
//  Tikeyc
//
//  Created by ways on 16/8/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMenuLeftHeadView : UIView


@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImgView;
@property (strong, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userDescriptionLabel;

@property (strong, nonatomic) IBOutlet UIButton *userQRCodeButton;


@end
