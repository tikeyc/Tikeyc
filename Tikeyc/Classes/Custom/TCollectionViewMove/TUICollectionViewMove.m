//
//  TUICollectionViewMove.m
//  Tikeyc
//
//  Created by ways on 2016/12/6.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TUICollectionViewMove.h"

@interface TUICollectionViewMove ()
//////

@property (nonatomic,strong)UILongPressGestureRecognizer *longShakeGesture;
@property (nonatomic,strong)UILongPressGestureRecognizer *longMoveGesture;

@end

@implementation TUICollectionViewMove

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initPropertyActions];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initPropertyActions];
    
    
}


#pragma mark - init

- (void)initPropertyActions{
    //
    [self addRecognize];
    
//    UICollectionViewCell *cell = [self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//    UIView *tempCell = [cell snapshotViewAfterScreenUpdates:YES];//截图
}



- (void)addRecognize{
    
    //添加长按抖动手势
    
    if(!_longShakeGesture){
        
        _longShakeGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
    }
    
    //长按响应时间
    
    _longShakeGesture.minimumPressDuration = 1;
    
    [self addGestureRecognizer:_longShakeGesture];
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longMoveGesture {
    
    //判断手势状态
    
    switch (longMoveGesture.state) {
            
        case UIGestureRecognizerStateBegan:{
            
            //判断手势落点位置是否在路径上
            
            NSIndexPath *indexPath = [self indexPathForItemAtPoint:[longMoveGesture locationInView:self]];
            
            self.isBegin = YES;
            
//            [self removeGestureRecognizer:_longShakeGesture];
            
            [self addlongMoveGesture];
            
            //                [self addSureButton];
            
            [self reloadData];
            
            NSLog(@"1");
        }
            
            break;
            
        case UIGestureRecognizerStateChanged:{
            
            NSLog(@"2");
            
            break;
            
        }
            
        case UIGestureRecognizerStateEnded:
            
            NSLog(@"3");
            
            break;
            
        default:
            
            NSLog(@"4");
            
            break;
            
    }
    
}

//开始抖动

- (void)starShakeCell:(UICollectionViewCell*)cell{
    
    CABasicAnimation *animation = (CABasicAnimation *)[cell.layer animationForKey:@"rotation"];
    
    if (animation == nil) {
        
        [self shakeImage:cell];
        
    }else {
        
        //        [self resume:cell];
        
    }
}

//停止抖动
- (void)stopShakeCell:(UICollectionViewCell*)cell{
    [cell.layer removeAllAnimations];
    [cell.layer removeAnimationForKey:@"rotation"];
    
    self.isBegin = NO;
//    [self removeGestureRecognizer:self.longShakeGesture];
    [self removeGestureRecognizer:self.longMoveGesture];
    if (!cell) {
        [self reloadData];
    }
    
}

- (void)shakeImage:(UICollectionViewCell*)cell {
    
    //创建动画对象,绕Z轴旋转
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置属性，周期时长
    
    [animation setDuration:0.08];
    
    //抖动角度
    
    animation.fromValue = @(-M_1_PI/2);
    
    animation.toValue = @(M_1_PI/2);
    
    //重复次数，无限大
    
    animation.repeatCount = HUGE_VAL;
    
    //恢复原样
    
    animation.autoreverses = YES;
    
    //锚点设置为图片中心，绕中心抖动
    
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [cell.layer addAnimation:animation forKey:@"rotation"];
    
}

//移动手势的添加

- (void)addlongMoveGesture{
    
    //此处给其增加长按手势，用此手势触发cell移动效果
    
    if(!_longMoveGesture){
        
        _longMoveGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongMoveGesture:)];
        
    }
    
    _longMoveGesture.minimumPressDuration = 0;
    
    [self addGestureRecognizer:_longMoveGesture];
    
}

//监听手势，并设置其允许移动cell和交换资源

- (void)handlelongMoveGesture:(UILongPressGestureRecognizer *)longMoveGesture {
    
    //判断手势状态
    
    switch (longMoveGesture.state) {
            
        case UIGestureRecognizerStateBegan:{
            
            //判断手势落点位置是否在路径上
            
            NSIndexPath *indexPath = [self indexPathForItemAtPoint:[longMoveGesture locationInView:self]];
            
            [self beginInteractiveMovementForItemAtIndexPath:indexPath];
            
        }
            
            break;
            
        case UIGestureRecognizerStateChanged:{
            
            NSIndexPath* indexPath = [self indexPathForItemAtPoint:[longMoveGesture locationInView:self]];
            
            //移动过程当中随时更新cell位置
            
            [self updateInteractiveMovementTargetPosition:[longMoveGesture locationInView:self]];
            
            break;
            
        }
            
        case UIGestureRecognizerStateEnded:
            
            //移动结束后关闭cell移动
            
            [self endInteractiveMovement];
            
            break;
            
        default:
            
            [self endInteractiveMovement];
            
            //            [_vibrate cancelInteractiveMovement];
            
            break;
            
    }
    
}

@end
