//
//  TTopImgBottomTextControl.h
//  Tikeyc
//
//  Created by ways on 16/9/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CliciIconBlock) (id result);

@interface TTopImgBottomTextControl : UIControl

@property (nonatomic,strong)UIButton *iconButton;
@property (nonatomic,strong)UILabel *label;

@property (nonatomic,copy)CliciIconBlock clickBlock;

- (id)initWithImageName:(NSString *)imageName withLabelTitle:(NSString *)title;

@end
