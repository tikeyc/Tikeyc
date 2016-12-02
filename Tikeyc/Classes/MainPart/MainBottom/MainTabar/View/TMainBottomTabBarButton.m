//
//  TMainBottomTabBarButton.m
//  Tikeyc
//
//  Created by ways on 2016/11/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainBottomTabBarButton.h"


@interface TMainBottomTabBarButton ()

@end

@implementation TMainBottomTabBarButton

- (id)initWithFrame:(CGRect)rect withNormalImageName:(NSString *)normalImageName withHighlightedImageName:(NSString *)highlightedImageName withLabelTitle:(NSString *)title{
    self = [super initWithFrame:rect];
    if (self) {
        self.normalImage = [UIImage imageNamed:normalImageName];
        self.highlightedImage = [UIImage imageNamed:highlightedImageName];
        self.title = title;
        self.backgroundColor = TColor_RGB(91, 91, 91);
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews{
    //
    _iconImage = [[UIImageView alloc] init];
    _iconImage.backgroundColor = [UIColor clearColor];
    _iconImage.frame = CGRectMake((self.width - _normalImage.size.width/*25*/)/2, 4, _normalImage.size.width/*25*/, _normalImage.size.height/*23*/);
    _iconImage.image = _normalImage;
    [self addSubview:_iconImage];
    //
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconImage.bottom + 3, self.width, 15)];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:12.0f];
    _label.textColor = TColor_RGB(255, 255, 255);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = self.title;
    [self addSubview:_label];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    _iconImage.image = selected ? _highlightedImage : _normalImage;
}


- (void)setTitle:(NSString *)title{
    if (_title != title) {
        _title = nil;
        _title = title;
    }
    _label.text = _title;
}


@end
