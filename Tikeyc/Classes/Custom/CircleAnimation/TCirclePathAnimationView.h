//
//  TCirclePathAnimationView.h
//  Tikeyc
//
//  Created by ways on 2017/5/15.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^MenuIconClick)(NSInteger index);

@interface TCirclePathAnimationView : UIView


@property (nonatomic,copy)MenuIconClick menuIconClick;

- (instancetype)initWithFrame:(CGRect)frame
                        icons:(NSArray *)iconImgNames
                       titles:(NSArray *)iconTitles
                    clickIcon:(MenuIconClick)menuIconClick;




/////////////

- (void)startCircleLayerAnimation;
- (void)startIconAnimations;

@end
