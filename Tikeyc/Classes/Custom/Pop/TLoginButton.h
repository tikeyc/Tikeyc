//
//  TLoginButton.h
//  Popping
//
//  Created by André Schneider on 12.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>


////////////////////////////////旋转的layer
@interface TSpinerLayer : CAShapeLayer

- (instancetype)initWithFrame:(CGRect)frame;

- (void)animation;

- (void)stopAnimation;

@end


////////////////////////////////

typedef void(^Completion)();

@interface TLoginButton : UIButton

@property (nonatomic,retain) TSpinerLayer *spiner;

- (void)setCompletion:(Completion)completion;

/*
 *执行加载提示动画，按钮变成圆，并旋转
 */
- (void)startAnimation;

/*
 *错误提示动画，晃动
 */
- (void)errorRevertAnimationCompletion:(Completion)completion;

/*
 *成功跳转动画，全屏放大
 */
- (void)exitAnimationCompletion:(Completion)completion;

@end
