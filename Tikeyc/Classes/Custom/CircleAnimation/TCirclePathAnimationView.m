//
//  TCirclePathAnimationView.m
//  Tikeyc
//
//  Created by ways on 2017/5/15.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TCirclePathAnimationView.h"

#define TCirclePathIcon_text_width 100

typedef void (^ClickIconBlock) (id result);

@interface TCirclePathIcon : UIView{
    UIImage *_image;
    NSString *_title;
}

@property (nonatomic,copy)ClickIconBlock clickBlock;

@property (nonatomic,strong)UIBezierPath *animationPath;

@end


@implementation TCirclePathIcon



- (id)initWithImageName:(NSString *)imageName withLabelTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _image = [UIImage imageNamed:imageName];
        _title = title;
        self.bounds = CGRectMake(0, 0, _image.size.width + TCirclePathIcon_text_width, _image.size.height);
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    //
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.frame = CGRectMake(0, 0, _image.size.width, _image.size.height);
    [iconButton setImage:_image forState:UIControlStateNormal];
    iconButton.showsTouchWhenHighlighted = YES;
    [iconButton addTarget:self action:@selector(clickIcon:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:iconButton];
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iconButton.right, 0, TCirclePathIcon_text_width, self.height)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = TColor_RGB(255, 255, 255);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _title;
    [label sizeToFit];
    label.layer.shadowOffset = CGSizeMake(5, 5);
    label.layer.shadowOpacity = 0.5;
    [self addSubview:label];
}

#pragma mark - Actions method


- (void)clickIcon:(UIButton *)button{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

@end


@interface TCirclePathAnimationView ()<CAAnimationDelegate>{
    NSInteger _currentIconIndex;
}

@property (nonatomic,strong)CAShapeLayer *bigShapeLayer;
@property (nonatomic, strong) NSArray *iconImgNames;
@property (nonatomic, strong) NSArray *iconTitles;
@property (nonatomic, strong) NSMutableArray *iconViews;

@end

@implementation TCirclePathAnimationView

- (instancetype)initWithFrame:(CGRect)frame
                        icons:(NSArray *)iconImgNames
                       titles:(NSArray *)iconTitles
                    clickIcon:(MenuIconClick)menuIconClick {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.iconImgNames = [NSArray arrayWithArray:iconImgNames];
        self.iconTitles = [NSArray arrayWithArray:iconTitles];
        self.menuIconClick = menuIconClick;
        
        [self initSubViews];
    }
    
    return self;
}


#pragma mark - init

- (void)initSubViews {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"luanch.jpg"]];
    ////////
    CGPoint center = CGPointMake(0, self.height/2);
    CGFloat radius = self.width - 150;
    CGFloat startAngle = [TKCAppTools huDuFromdu:90.0];
    CGFloat endAngle = [TKCAppTools huDuFromdu:-90.0];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center
                                                              radius:radius
                                                          startAngle:startAngle
                                                            endAngle:endAngle
                                                           clockwise:NO];
    
    _bigShapeLayer = [CAShapeLayer layer];
    _bigShapeLayer.strokeColor = [UIColor redColor].CGColor;
    _bigShapeLayer.lineWidth = 10;
    _bigShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _bigShapeLayer.path = bezierPath.CGPath;
    
    [self.layer addSublayer:_bigShapeLayer];
    self.layer.masksToBounds = YES;
    
    ////////
    
    ////////
    _currentIconIndex = 0;
    _iconViews = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    NSInteger count = self.iconImgNames.count + 1;
    CGFloat judge = ((CGFloat)self.iconImgNames.count*1.0)/2.0;
//    NSArray *iconEndAngles = @[@([TKCAppTools huDuFromdu:60]),@([TKCAppTools huDuFromdu:30]),@([TKCAppTools huDuFromdu:0]),
//                               @([TKCAppTools huDuFromdu:-30]),@([TKCAppTools huDuFromdu:-60])];
    for (NSString *iconImgName in self.iconImgNames) {
        
        TCirclePathIcon *iconView = [[TCirclePathIcon alloc] initWithImageName:iconImgName withLabelTitle:self.iconTitles[i]];
        
        //        UIImage *image = [UIImage imageNamed:iconImgName];
        //        if (image) {
        //            [iconView setImage:image forState:UIControlStateNormal];
        //        }else{
        //            iconView.backgroundColor = [UIColor greenColor];
        //        }
        iconView.tag = i;
        TWeakSelf(self)
        iconView.clickBlock = ^(TCirclePathIcon *control){
            control.transform = CGAffineTransformMakeScale(0.8, 0.8);
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                control.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
            
            if (weakself.menuIconClick) {
                weakself.menuIconClick(control.tag);
            }
        };
        float offx = [TKCAppTools sin:(180.0/count)*(i + 1)];
        float offy = [TKCAppTools cos:(180.0/count)*(i + 1)];
        if (i == 0) {
            radius += (iconView.width - TCirclePathIcon_text_width)/2;
        }
        iconView.center = CGPointMake(radius*offx, radius*offy + self.height/2);
        CGFloat du = (180.0/count)*(i + 1);
        if (i >= judge) {
            du = (du - 90)*-1;
        } else {
            du = 90 - du;
        }
        CGFloat iconEndAngle = [TKCAppTools huDuFromdu:du];
        iconView.animationPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:iconEndAngle clockwise:NO];
        [self addSubview:iconView];
        iconView.hidden = YES;
        [_iconViews addObject:iconView];
        i++;
    }
    [_iconViews reverse];//倒序数组
    ////////
    
//    [self startCircleLayerAnimation];
    
    [self startIconAnimations];
}



#pragma mark - animation


- (void)startCircleLayerAnimation {
    POPBasicAnimation *draw = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    draw.fromValue = @(0.0);
    draw.toValue = @(1.0);
    draw.duration = 1;
    draw.beginTime = CACurrentMediaTime();
    [draw setValue:@"draw" forKey:@"animName"];
    draw.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.bigShapeLayer pop_addAnimation:draw forKey:@"draw"];
}

- (void)startIconAnimations {
    NSInteger i = 0;
    CGFloat duration = 0.8;
    
    for (TCirclePathIcon *icon in _iconViews) {
        icon.hidden = YES;
        CGFloat delayTime = i*duration/_iconViews.count;
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.delegate = self;
        pathAnimation.duration = duration - delayTime;
        pathAnimation.beginTime = CACurrentMediaTime() + delayTime;
        if (i == 1) {
            pathAnimation.duration = duration - 0.12;
        }
        if (i == 2) {//不知道为何第三个icon快了
            pathAnimation.duration = duration + 0.08;
        }
//        pathAnimation.fillMode = kCAFillModeForwards;
//        pathAnimation.removedOnCompletion = NO;
        pathAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.calculationMode = kCAAnimationLinear;
        pathAnimation.path = icon.animationPath.CGPath;
        i += 1;
        
        [icon.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
    }
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {

    if (_currentIconIndex >= _iconViews.count) return;
    [_iconViews[_currentIconIndex] setHidden:NO];
    ++_currentIconIndex;
    if (_currentIconIndex >= _iconViews.count) {
        _currentIconIndex = 0;
    }
}

@end









