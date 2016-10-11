//
//  TTopImgBottomTextControl.m
//  Tikeyc
//
//  Created by ways on 16/9/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TTopImgBottomTextControl.h"

@implementation TTopImgBottomTextControl

{
    UIImage *_image;
    NSString *_title;
}

- (id)initWithImageName:(NSString *)imageName withLabelTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _image = [UIImage imageNamed:imageName];
        _title = title;
        self.bounds = CGRectMake(0, 0, _image.size.width, _image.size.height + 6 + 13);
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    //
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.frame = CGRectMake(0, 0, _image.size.width, _image.size.height);
    [iconButton setImage:_image forState:UIControlStateNormal];
    iconButton.showsTouchWhenHighlighted = YES;
    [iconButton addTarget:self action:@selector(clickIcon:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:iconButton];
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iconButton.bottom + 6, iconButton.width, 13)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = TColor_RGB(0, 0, 0);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _title;
    [label sizeToFit];
    label.left = (self.width - label.width)/2;
    label.layer.shadowOffset = CGSizeMake(5, 5);
    label.layer.shadowOpacity = 0.5;
    [self addSubview:label];
}

#pragma mark - Actions method


- (void)clickIcon:(UIButton *)button{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

@end
