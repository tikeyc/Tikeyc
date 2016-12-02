//
//  TMainBottomTabBarButton.h
//  Tikeyc
//
//  Created by ways on 2016/11/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMainBottomTabBarButton : UIControl


@property (nonatomic,strong)UIImageView *iconImage;
@property (nonatomic,strong)UILabel *label;

@property (nonatomic,strong)UIImage *normalImage;
@property (nonatomic,strong)UIImage *highlightedImage;


@property (nonatomic,copy)NSString *title;

- (id)initWithFrame:(CGRect)rect withNormalImageName:(NSString *)imageName withHighlightedImageName:(NSString *)imageName withLabelTitle:(NSString *)title;

@end
