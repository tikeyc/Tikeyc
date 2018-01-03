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
        [self addTarget:self action:@selector(clickIcon:) forControlEvents:UIControlEventTouchUpInside];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    //
    _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconButton.frame = CGRectMake(0, 0, _image.size.width, _image.size.height);
    [_iconButton setImage:_image forState:UIControlStateNormal];
    _iconButton.showsTouchWhenHighlighted = YES;
    [_iconButton addTarget:self action:@selector(clickIcon:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_iconButton];
    //
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconButton.bottom + 6, _iconButton.width, 13)];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:13.0f];
    _label.textColor = TColor_RGB(0, 0, 0);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = _title;
    [_label sizeToFit];
    _label.left = (self.width - _label.width)/2;
    _label.layer.shadowOffset = CGSizeMake(5, 5);
    _label.layer.shadowOpacity = 0.5;
    [self addSubview:_label];
}

#pragma mark - Actions method


- (void)clickIcon:(id)button{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

@end
