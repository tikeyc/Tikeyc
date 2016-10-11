//
//  TLPCShareAnimation.m
//  Tikeyc
//
//  Created by ways on 16/9/29.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLPCShareAnimation.h"

@interface TLPCShareAnimation ()<CAAnimationDelegate>

@end

@implementation TLPCShareAnimation

- (void)dealloc
{
    [self stopAnimation];
    NSLog(@"shareAnimation dealloc");
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initSubView];
}

#pragma mark - animation

- (void)initSubView{
    [self addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    //
    _startNum = 0;
    _stopNum = 0;
    _shareImgViews = [NSMutableArray array];
    TWeakSelf(self)
    for (int i = 0; i < 10; i++) {
        UIImage *image = [UIImage imageNamed:@"yipitiezhiNormal"];
        _shareImgView = [[UIImageView alloc] initWithImage:image];
        _shareImgView.size = image.size;
        [self addSubview:_shareImgView];
        
        [_shareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(0));
//            make.top.equalTo(@(0));
            make.centerX.equalTo(weakself.mas_centerX);
            make.centerY.equalTo(weakself.mas_centerY).offset(-30);
        }];
        _shareImgView.hidden = YES;
        [_shareImgViews addObject:_shareImgView];
    }
    
    
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself startAnimation];
    });
    
}



#pragma mark - animation

- (void)startAnimation{
    if (_isAnimation) {
        return;
    }
    _isAnimation = YES;
    for (int i = 0; i < _shareImgViews.count; i++) {
        UIImageView *shareImgView = _shareImgViews[i];
        
        if (!_animation) {
            _animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            _animation.delegate = self;
            _animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            _animation.duration = 5.0;
            _animation.repeatCount = HUGE_VALF;
            _animation.fillMode = kCAFillModeForwards;
        }
        CGPoint pointControl1;
        CGPoint pointControl2;
        if (i % 2) {//可以设置随机数arc4random() % (x + 1) 做随机贝塞尔曲线动画
            pointControl1 = CGPointMake(shareImgView.center.x - 80, shareImgView.top - 150);
            pointControl2 = CGPointMake(shareImgView.center.x + 80, shareImgView.top - 250);
        }else{
            pointControl2 = CGPointMake(shareImgView.center.x - 80, shareImgView.top - 150);
            pointControl1 = CGPointMake(shareImgView.center.x + 80, shareImgView.top - 250);
        }
        
        UIBezierPath *moveBezierPath = [UIBezierPath bezierPath];
        [moveBezierPath moveToPoint:shareImgView.center];
        [moveBezierPath addCurveToPoint:CGPointMake(shareImgView.center.x, shareImgView.top - 300) controlPoint1:pointControl1 controlPoint2:pointControl2];
        _animation.path = moveBezierPath.CGPath;
        _animation.beginTime = CACurrentMediaTime() + i;
        [shareImgView.layer addAnimation:_animation forKey:@"share_move"];
    }

}

- (void)stopAnimation{
    for (int i = 0; i < _shareImgViews.count; i++) {
        UIImageView *shareImgView = _shareImgViews[i];
        shareImgView.hidden = YES;
        [shareImgView.layer removeAllAnimations];
    }
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim{
    UIImageView *shareImgView = _shareImgViews[_startNum];
    shareImgView.hidden = NO;
    _startNum++;
    if (_startNum >= _shareImgViews.count) {
        _startNum = 0;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    CAKeyframeAnimation *cab = (CAKeyframeAnimation *)anim;
    if ([cab.keyPath isEqualToString:@"position"]){
        UIImageView *shareImgView = _shareImgViews[_stopNum];
        shareImgView.hidden = YES;
        _stopNum++;
        if (_stopNum >= _shareImgViews.count) {
            _stopNum = 0;
        }
        
    }
}

@end








