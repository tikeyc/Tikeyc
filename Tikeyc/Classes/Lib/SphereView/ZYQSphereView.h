//
//  ZYQSphereView.h
//  SphereViewSample
//
//  Created by Zhao Yiqi on 13-12-8.
//  Copyright (c) 2013年 Zhao Yiqi. All rights reserved.
//

#import "PFAxisDirection.h"

@interface ZYQSphereView : UIView {
	NSMutableDictionary *pointMap; 
	
	CGPoint originalLocationInView;
	CGPoint previousLocationInView;
	
	PFAxisDirection lastXAxisDirection;
	PFAxisDirection lastYAxisDirection;
	
	CGRect originalSphereViewBounds;
}

@property(nonatomic,assign)BOOL isPanTimerStart;
@property(nonatomic,getter = isTimerStart,readonly)BOOL isTimerStart;

/***新增加的属性speed 及 miniScallValue***/
/**add by tikeyc 20170601
 *其实是每秒旋转的角度，角度越大速度越快 默认1
 */
@property (nonatomic,assign)CGFloat speed;
/**add by tikeyc 20170601
 *其实是在球体背后的视图最小的缩小值，越大球体更明显 默认0.3 (范围0 ~ 1)
 *如果为0后面的视图缩小到了消失的情况
 */
@property (nonatomic,assign)CGFloat miniScallValue;
/***新增加的属性speed 及 miniScallValue***/

- (void)setItems:(NSArray *)items;

-(void)timerStart;

-(void)timerStop;

@end
