//
//  TPopMenuPathIconView.m
//  Tikeyc
//
//  Created by ways on 16/9/9.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TPopMenuPathIconView.h"

@interface TPopMenuPathIconView ()<POPAnimationDelegate> {
    BOOL _isDrawingCircle;
    BOOL _isMenuPresented;
    CGFloat _direction;
    CGPoint _gesturePosition;
}
@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic, strong) NSArray *iconImgNames;

@end

@implementation TPopMenuPathIconView

- (instancetype)initWithFrame:(CGRect)frame
                    direction:(TPopMenuPathIconAnimationDirection)direction
                        icons:(NSArray *)iconImgNames
                    clickIcon:(MenuIconClick)menuIconClick{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconImgNames = [NSArray arrayWithArray:iconImgNames];
        self.menuIconClick = menuIconClick;
        
        switch (direction) {
            case TPopMenuPathIconAnimationDirectionRight:
                _direction = 0.0;
                break;
            case TPopMenuPathIconAnimationDirectionBottom:
                _direction = M_PI/2;
                break;
            case TPopMenuPathIconAnimationDirectionLeft:
                _direction = M_PI;
                break;
            case TPopMenuPathIconAnimationDirectionTop:
                _direction = M_PI*3/2;
                break;
                
            default:
                break;
        }
        self.backgroundColor = [UIColor whiteColor];
        
        //
        [self startCircleAnimation];
        
    }
    return self;
}

- (void)startCircleAnimation{
    int radius = 45;
    CGPoint location = CGPointMake(self.width/2, self.height - radius);
    self.circle = [CAShapeLayer layer];
    self.circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(location.x - radius,
                                                                          location.y - radius,
                                                                          radius*2,
                                                                          radius*2)
                                                  cornerRadius:radius].CGPath;
    
    // Configure the apperence of the circle
    self.circle.fillColor = [UIColor clearColor].CGColor;
    self.circle.strokeColor = TColor_RGB(51, 184, 252).CGColor;
    self.circle.lineWidth = 2;
    self.circle.strokeEnd = 0.0;
    // Add to parent layer
    [self.layer addSublayer:self.circle];
    
    POPBasicAnimation *draw = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    draw.fromValue = @(0.0);
    draw.toValue = @(1.0);
    draw.duration = 0.4;
    draw.beginTime = CACurrentMediaTime() + 0.5;
    draw.delegate = self;
    [draw setValue:@"draw" forKey:@"animName"];
    draw.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.circle pop_addAnimation:draw forKey:@"draw"];
}

- (void)presentSubmenu {
    //@[[UIImage imageNamed:@"twitterIcon"],[UIImage imageNamed:@"facebookIcon"],[UIImage imageNamed:@"dribbbleIcon"],[UIImage imageNamed:@"downloadIcon"]];
    
    NSMutableArray *iconViews = [[NSMutableArray alloc]init];
    //    _isMenuPresented = YES;
    CGFloat size = 60;
    _gesturePosition = CGPointMake(self.width/2, self.height - size);
    NSInteger i = 0;
    for (NSString *iconImgName in self.iconImgNames) {
        
        UIButton *iconView = [UIButton buttonWithType:UIButtonTypeCustom];
        iconView.showsTouchWhenHighlighted = YES;
        UIImage *image = [UIImage imageNamed:iconImgName];
        if (image) {
            [iconView setImage:image forState:UIControlStateNormal];
        }else{
            iconView.backgroundColor = [UIColor greenColor];
        }
        iconView.tag = i;
        [iconView addTarget:self action:@selector(iconViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        iconView.frame = CGRectMake(_gesturePosition.x - size/2,
                                    _gesturePosition.y - size/2,
                                    size,
                                    size);
        iconView.alpha = 0.0;
        [self addSubview:iconView];
        [iconViews addObject:iconView];
        i++;
    }
    
    NSInteger nIcons = [self.iconImgNames count];
    int iconNumber = 0;
    
    
    for (UIImageView *icon in iconViews) {
        POPBasicAnimation *alpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        alpha.toValue = @(1.0);
        alpha.duration = 0.3;
        alpha.beginTime = CACurrentMediaTime() + iconNumber*0.1;
        [icon pop_addAnimation:alpha forKey:@"alpha"];
        
        POPDecayAnimation *push = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        CGFloat angle = [self angleForIcon:iconNumber numberOfIcons:nIcons];
        CGFloat velocity = 1000;
        push.beginTime = CACurrentMediaTime() + iconNumber*0.1;
        push.deceleration = 0.991;
        push.velocity = [NSValue valueWithCGPoint:CGPointMake(velocity * cosf(angle), velocity * sinf(angle))];
        [icon pop_addAnimation:push forKey:@"push"];
        
        iconNumber += 1;
    }
}

- (CGFloat) angleForIcon:(NSInteger)iconNumber numberOfIcons:(NSInteger)nIcons {
    CGFloat interSpace = 0.8; //Number of radians between 2 icons
    CGFloat totalAngle = (nIcons -1) * interSpace;
    CGFloat startAngle = _direction - totalAngle/2;
    
    return startAngle + iconNumber*interSpace;
}

#pragma mark - POPAnimationDelegate

- (void)pop_animationDidStart:(POPAnimation *)anim{
    
}


- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if (finished) {
        if ([[anim valueForKey:@"animName"] isEqualToString:@"draw"]) {
            //Animation drwaing the circle has finished
//            _isDrawingCircle = NO;
            self.circle.fillColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_center_menu_animation_bgIcon"]].CGColor;
            [self presentSubmenu];
            
        } else if ([[anim valueForKey:@"animName"] isEqualToString:@"removeCircle"]) {
            //Animation removing the circle has finished
//            [self.circle removeFromSuperlayer];
        }
    }
}


#pragma mark - Actions method

- (void)iconViewButtonAction:(UIButton *)button{
    button.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        button.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    if (self.menuIconClick) {
        self.menuIconClick(button.tag);
    }
}

@end
