//
//  BarrageScene.m
//  BarrageKit
//
//  Created by jiachenmu on 16/8/26.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "BarrageManager.h"
#import "BarrageScene.h"

@implementation BarrageScene

- (instancetype)initWithModel:(BarrageModel *)model {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Model:(BarrageModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
       self.model = model;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"弹幕 dealloc");
}


#pragma mark - init

- (void)setupUI {
    
    //icon
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [TKCAppTools setViewCornerCircleWithView:_iconImgView];
    _iconImgView.backgroundColor = TRandomColor_RGB;
    [self addSubview:_iconImgView];
    //nickName
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImgView.frame) + 5, 0, 30, 12)];
    _nickNameLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:_nickNameLabel];
    // message
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:_titleLabel];
    
    // button
    _voteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    _voteButton.hidden = true;
    _voteButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_voteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_voteButton setTitle:@"Vote" forState:UIControlStateNormal];
    [self addSubview:_voteButton];
}

#pragma mark - set

- (void)setModel:(BarrageModel *)model {
    _model = model;
    
    [self layoutSubviewsProperty];
}

//计算初始Frame
- (void)layoutSubviewsProperty {
    /* 1. setup UI (基础UI设置) */
    _titleLabel.attributedText = _model.message;
    //    _titleLabel.textColor = _model.textColor;
    
    /* 2. determine barrage's type  (判断弹幕类型) */
    switch (_model.barrageType) {
        case BarrageDisplayTypeVote:
            // --投票类型--
            _iconImgView.hidden = YES;
            _nickNameLabel.hidden = YES;
            //
            [_titleLabel sizeToFit];
            _voteButton.hidden = NO;
            [_voteButton sizeToFit];
            CGRect frame = _voteButton.frame;
            frame.origin.x = CGRectGetMaxX(_titleLabel.frame);
            frame.origin.y = CGRectGetMinY(_titleLabel.frame);
            frame.size.height = CGRectGetHeight(_titleLabel.frame);
            _voteButton.frame = frame;
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(_titleLabel.frame) + CGRectGetWidth(_voteButton.frame), CGRectGetHeight(_titleLabel.frame));
            break;
        case BarrageDisplayTypeIconText://add by tikeyc
            // --头像加文字--
            _voteButton.hidden = true;
            //
            _iconImgView.image = [UIImage imageNamed:@"danmu.jpg"];
            _nickNameLabel.attributedText = _model.nickName;
            [_nickNameLabel sizeToFit];
            //
            //            [_titleLabel sizeToFit];
            _titleLabel.frame = CGRectMake(CGRectGetMaxX(_iconImgView.frame) + 5, CGRectGetMaxY(_nickNameLabel.frame), CGRectGetWidth(_nickNameLabel.frame), 12);
            [TKCAppTools setViewCornerCircleWithView:_titleLabel];
            _titleLabel.backgroundColor = TColor_RGBA(0, 0, 0, 0.3);
            //
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(_iconImgView.frame) + 5 + CGRectGetWidth(_nickNameLabel.frame), CGRectGetHeight(_iconImgView.frame));
            break;
        case BarrageDisplayTypeOther:
            // --其他类型--
            
            break;
        default:
            // --BarrageDisplayTypeDefault--
            _iconImgView.hidden = YES;
            _nickNameLabel.hidden = YES;
            //
            _voteButton.hidden = YES;
            [_titleLabel sizeToFit];
            self.bounds = _titleLabel.bounds;
            break;
    }
    
    //计算弹幕随机初始位置
    self.frame = [self calculateBarrageSceneFrameWithModel:_model];
}

//MARK: 随机计算弹幕的初始Frame
-(CGRect) calculateBarrageSceneFrameWithModel:(BarrageModel *)model {
    CGPoint originPoint;
    CGRect sourceFrame = CGRectZero;
    switch (model.displayLocation) {
        case BarrageDisplayLocationTypeDefault:
            sourceFrame = model.bindView.bounds;
            break;
        case BarrageDisplayLocationTypeTop:
            sourceFrame = CGRectMake(0, 0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds) / 3.0);
            break;
        case BarrageDisplayLocationTypeCenter:
            sourceFrame = CGRectMake(0, CGRectGetHeight(model.bindView.bounds) / 3.0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds) / 3.0);
            break;
        case BarrageDisplayLocationTypeBottom:
            sourceFrame = CGRectMake(0, CGRectGetHeight(model.bindView.bounds) / 3.0 * 2.0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds) / 3.0);
            break;
        default:
            break;
    }
    switch (model.direction) {
        case BarrageScrollDirectRightToLeft:
            originPoint = CGPointMake(CGRectGetMaxX(sourceFrame), RandomBetween(0, CGRectGetHeight(sourceFrame) - CGRectGetHeight(self.bounds)));
            break;
        case BarrageScrollDirectLeftToRight:
            originPoint = CGPointMake(-CGRectGetWidth(self.bounds), RandomBetween(0, CGRectGetHeight(sourceFrame) - CGRectGetHeight(self.bounds)));
            break;
        case BarrageScrollDirectBottomToTop:
            originPoint = CGPointMake(RandomBetween(0, CGRectGetWidth(sourceFrame)), CGRectGetMaxY(sourceFrame) + CGRectGetHeight(self.bounds));
            break;
        case BarrageScrollDirectTopToBottom:
            originPoint = CGPointMake(RandomBetween(0, CGRectGetWidth(sourceFrame)), -CGRectGetHeight(self.bounds));
            break;
        default:
            break;
    }
    
    CGRect frame = self.frame;
    frame.origin = originPoint;
    
    /*下面方法暂未实现弹幕不重叠问题 因为是随机确定弹幕运行的弹道的
     *想在随机弹道的情况下解决不重叠的问题（如果根据弹幕高度来固定弹道以及弹道数量不会有此问题出现）
     * 
     *思路：。。。
     
    if (model.direction == BarrageScrollDirectRightToLeft) {
        BOOL isExitOverlap = false;
        BarrageScene *overlapView;
        for (BarrageScene *barrageScene in [BarrageManager shareManager].barrageScenes) {
            if ( self.layer.presentationLayer.left > barrageScene.layer.presentationLayer.right){
                NSLog(@"isExitOverlap YES %@",NSStringFromCGRect(self.layer.presentationLayer.frame));
                NSLog(@"isExitOverlap YES %@",NSStringFromCGRect(barrageScene.layer.presentationLayer.frame));
                break;
            }else{
                NSLog(@"isExitOverlap NO %@",NSStringFromCGRect(self.layer.presentationLayer.frame));
                NSLog(@"isExitOverlap NO %@",NSStringFromCGRect(barrageScene.layer.presentationLayer.frame));
            }
            
            
        }
        BarrageScene *barrageScene = [[BarrageManager shareManager].barrageScenes lastObject];
        if ( self.layer.left < barrageScene.layer.presentationLayer.right &&( (self.layer.top >= barrageScene.layer.presentationLayer.top && self.layer.top <= barrageScene.bottom) || (self.layer.bottom >= barrageScene.layer.presentationLayer.top && self.layer.bottom <= barrageScene.layer.presentationLayer.bottom))) {
            isExitOverlap = YES;
            overlapView = barrageScene;
            NSLog(@"isExitOverlap YES");
            //        break;
        }else{
            isExitOverlap = NO;
            NSLog(@"isExitOverlap NO");
        }
        //
        if (isExitOverlap) {
            NSLog(@"isExitOverlap YES %@",NSStringFromCGRect(self.frame));
            NSLog(@"isExitOverlap YES %@",NSStringFromCGRect(overlapView.layer.presentationLayer.frame));
            CGRect frame = self.frame;
            frame.origin = CGPointMake(overlapView.layer.presentationLayer.right + 40, overlapView.layer.presentationLayer.top);
            return frame;
        }

    }*/
    
    
    return frame;
}


#pragma mark - Actions

// 加入到SuperView后 开始滚动
- (void)scroll {

    //计算动画距离、时间   calculate time of scroll barrage
    CGFloat distance = 0.0;
    CGPoint goalPoint = CGPointZero;
    switch (_model.direction) {
        case BarrageScrollDirectRightToLeft:
            distance = CGRectGetWidth(_model.bindView.bounds);
            goalPoint = CGPointMake(-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame));
            break;
        case BarrageScrollDirectLeftToRight:
            distance = CGRectGetWidth(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetWidth(_model.bindView.bounds) + CGRectGetWidth(self.frame), CGRectGetMinY(self.frame));
            break;
        case BarrageScrollDirectBottomToTop:
            distance = CGRectGetHeight(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetMinX(self.frame), -CGRectGetHeight(self.frame));
            break;
        case BarrageScrollDirectTopToBottom:
            distance = CGRectGetHeight(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetMinX(self.frame), CGRectGetHeight(self.frame) + CGRectGetMaxY(_model.bindView.bounds));
            break;
        default:
            break;
    }
    NSTimeInterval time = distance / _model.speed;
//    time = 10.0;
    CGRect goalFrame = self.frame;
    goalFrame.origin = goalPoint;
    // layer执行动画
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    animation.removedOnCompletion = true;
    animation.autoreverses = false;
    animation.fillMode = kCAFillModeForwards;
    
    animation.beginTime = CACurrentMediaTime();
    [animation setToValue:[NSValue valueWithCGPoint:CenterPoint(goalFrame)]];
    [animation setDuration:time];
    [self.layer addAnimation:animation forKey:@"kAnimation_BarrageScene"];
}

- (void)pause {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

- (void)resume {
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    self.layer.speed = 1.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

- (void)close {
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}



#pragma mark - AnimatonDelegate

// stop
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        __weak typeof(self) SELF = self;
        
        if (_animationDidStopBlock) {
            _animationDidStopBlock(SELF);
        }
    }
}

#pragma mark - touch

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"hitTest~~~");
    if ([_voteButton pointInside:point withEvent:event]) {
        NSLog(@"click~~~");
    }
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
}

#pragma mark - Other Method

//随机返回某个区间范围内的值 return a ` float ` Between `smallerNumber ` and ` largerNumber `
float RandomBetween(float smallerNumber, float largerNumber) {
    //设置精确的位数
    int precision = 100;
    //先取得他们之间的差值
    float subtraction = largerNumber - smallerNumber;
    //取绝对值
    subtraction = ABS(subtraction);
    //乘以精度的位数
    subtraction *= precision;
    //在差值间随机
    float randomNumber = arc4random() % ((int)subtraction+1);
    //随机的结果除以精度的位数
    randomNumber /= precision;
    //将随机的值加到较小的值上
    float result = MIN(smallerNumber, largerNumber) + randomNumber;
    //返回结果
    return result;
}

//返回一个Frame的中心点
CGPoint CenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

@end








