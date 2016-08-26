//
//  WSLoginButton.h
//  Popping
//
//  Created by André Schneider on 12.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSpinerLayer : CAShapeLayer

- (instancetype)initWithFrame:(CGRect)frame;

- (void)animation;

- (void)stopAnimation;

@end

typedef void(^Completion)();

@interface TLoginButton : UIButton

@property (nonatomic,retain) TSpinerLayer *spiner;

- (void)setCompletion:(Completion)completion;

- (void)startAnimation;

- (void)errorRevertAnimationCompletion:(Completion)completion;

- (void)exitAnimationCompletion:(Completion)completion;

@end
