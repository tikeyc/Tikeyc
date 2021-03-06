//
//  TLoginButton.m
//  Popping
//
//  Created by André Schneider on 12.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "TLoginButton.h"
#import "POP.h"

@implementation TSpinerLayer

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super init];
    if (self) {
        CGFloat radius = (CGRectGetHeight(frame) / 2) * 0.5;
        self.frame = CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame));
        CGPoint center = CGPointMake(CGRectGetHeight(frame) / 2, CGRectGetMidY(self.bounds));
        CGFloat startAngel = 0 - M_PI_2;
        CGFloat endAngle = M_PI * 2 - M_PI_2;
        BOOL clockwise = true;
        self.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngel endAngle:endAngle clockwise:clockwise].CGPath;
        self.fillColor = nil;
        self.strokeColor = [UIColor whiteColor].CGColor;
        self.lineWidth = 1;
        
        self.strokeEnd = 0.4;
        self.hidden = true;
    }
    
    return self;
}

- (void)animation
{
    self.hidden = false;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = 0;
    rotate.toValue = @(M_PI * 2);
    rotate.duration = 0.4;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotate.repeatCount = HUGE;
    rotate.fillMode = kCAFillModeForwards;
    rotate.removedOnCompletion = false;
    [self addAnimation:rotate forKey:rotate.keyPath];
}

- (void)stopAnimation
{
    [self removeAllAnimations];
    self.hidden = true;
}

@end


@interface TLoginButton ()<CAAnimationDelegate>

@property (nonatomic,assign) CFTimeInterval shrinkDuration;

@property (nonatomic,retain) CAMediaTimingFunction *shrinkCurve;

@property (nonatomic,retain) CAMediaTimingFunction *expandCurve;

@property (nonatomic,strong) Completion block;

@property (nonatomic,retain) UIColor *color;

@end

@implementation TLoginButton

-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViewAndProperty];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self performSelector:@selector(initSubViewAndProperty) withObject:nil afterDelay:0.1];
}

#pragma mark - init

- (void)initSubViewAndProperty{
    _spiner = [[TSpinerLayer alloc] initWithFrame:self.frame];
    _shrinkCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    _expandCurve = [CAMediaTimingFunction functionWithControlPoints:0.95 :0.02 :1 :0.05];
    //
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    self.clipsToBounds = true;
    self.shrinkDuration = 0.1;
    [self.layer addSublayer:_spiner];
    //
    [self addTarget];
}

#pragma mark - set

-(void)setCompletion:(Completion)completion
{
    _block = completion;
}

-(void)addTarget{

    [self addTarget:self action:@selector(scaleToSmall)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    
    [self addTarget:self action:@selector(scaleAnimation)
   forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit];
    
}


#pragma mark - Actions Method

- (void)scaleToSmall
{
    typeof(self) __weak weak = self;
    
    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weak.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)scaleAnimation
{
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weak.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
//    [self startAnimation];//该动画在外部催动启动，不然存在BUG，因为外部和内部都addTarget了UIControlEventTouchUpInside事件，执行先后顺序不定(在RAC下)
}


#pragma mark - Animation Method

-(void)didStopAnimation{
    
    [self.layer removeAllAnimations];
}

-(void)revert{
    
    CABasicAnimation *backgroundColor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColor.toValue  = (__bridge id)self.backgroundColor.CGColor;
    backgroundColor.duration = 0.1f;
    backgroundColor.timingFunction = _shrinkCurve;
    backgroundColor.fillMode = kCAFillModeForwards;
    backgroundColor.removedOnCompletion = false;
    [self.layer addAnimation:backgroundColor forKey:@"backgroundColors"];
    
}

-(void)startAnimation{
    
    [self performSelector:@selector(revert) withObject:nil afterDelay:0.f];
    //
    CABasicAnimation *shrinkAnim = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    shrinkAnim.fromValue = [NSValue valueWithCGSize:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    shrinkAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds))];
    shrinkAnim.duration = _shrinkDuration;
    shrinkAnim.timingFunction = _shrinkCurve;
    shrinkAnim.fillMode = kCAFillModeForwards;
    shrinkAnim.removedOnCompletion = false;
    [self.layer addAnimation:shrinkAnim forKey:shrinkAnim.keyPath];
    //
    [_spiner animation];
    [self setUserInteractionEnabled:false];
    
    
}

-(void)errorRevertAnimationCompletion:(Completion)completion
{
    _block = completion;
    //
    CABasicAnimation *shrinkAnim = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    shrinkAnim.fromValue = @(CGRectGetHeight(self.bounds));
    shrinkAnim.toValue = @(CGRectGetWidth(self.bounds));
    shrinkAnim.duration = _shrinkDuration;
    shrinkAnim.timingFunction = _shrinkCurve;
    shrinkAnim.fillMode = kCAFillModeForwards;
    shrinkAnim.removedOnCompletion = false;
    _color = self.backgroundColor;
    
    //
//    CABasicAnimation *backgroundColor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
//    backgroundColor.toValue  = (__bridge id)[UIColor redColor].CGColor;
//    backgroundColor.duration = 0.1f;
//    backgroundColor.timingFunction = _shrinkCurve;
//    backgroundColor.fillMode = kCAFillModeForwards;
//    backgroundColor.removedOnCompletion = false;
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = self.layer.position;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;
    keyFrame.delegate = (id)self;
    self.layer.position = point;
    
//    [self.layer addAnimation:backgroundColor forKey:backgroundColor.keyPath];
    [self.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
    [self.layer addAnimation:shrinkAnim forKey:shrinkAnim.keyPath];
    //
    [_spiner stopAnimation];
    [self setUserInteractionEnabled:false];
}

-(void)exitAnimationCompletion:(Completion)completion{
    
    _block = completion;
    [self setTitle:nil forState:UIControlStateNormal];
    //
    CABasicAnimation *expandAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnim.fromValue = @(1.0);
    expandAnim.toValue = @(33.0);
    expandAnim.timingFunction = _expandCurve;
    expandAnim.duration = 0.3;
    expandAnim.delegate = (id)self;
    expandAnim.fillMode = kCAFillModeForwards;
    expandAnim.removedOnCompletion = false;
    [self.layer addAnimation:expandAnim forKey:expandAnim.keyPath];
    //
    [_spiner stopAnimation];
    [self setUserInteractionEnabled:false];
}



#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    CABasicAnimation *cab = (CABasicAnimation *)anim;
    if ([cab.keyPath isEqualToString:@"transform.scale"] || [cab.keyPath isEqualToString:@"position"]) {
        [self setUserInteractionEnabled:true];
        if (_block) {
            _block();
        }
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(didStopAnimation) userInfo:nil repeats:nil];
    }
}



@end
