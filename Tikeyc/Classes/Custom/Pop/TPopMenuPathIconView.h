//
//  TPopMenuPathIconView.h
//  Tikeyc
//
//  Created by ways on 16/9/9.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TPopMenuPathIconAnimationDirectionRight = 0,
    TPopMenuPathIconAnimationDirectionBottom,
    TPopMenuPathIconAnimationDirectionLeft,
    TPopMenuPathIconAnimationDirectionTop,
} TPopMenuPathIconAnimationDirection;

typedef UIViewController* (^MenuIconClick)(NSInteger index, BOOL is3DTouch);

@interface TPopMenuPathIconView : UIView

@property (nonatomic,copy)MenuIconClick menuIconClick;

- (instancetype)initWithFrame:(CGRect)frame
                    direction:(TPopMenuPathIconAnimationDirection)direction
                        icons:(NSArray *)iconImgNames
                        titles:(NSArray *)iconTitles
                    clickIcon:(MenuIconClick)menuIconClick;




@end
