//
//  TBaseNavigationViewController.h
//  Tikeyc
//
//  Created by ways on 16/8/15.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBaseNavigationViewController : UINavigationController

// 创建全屏滑动手势
@property (nonatomic,strong)UIPanGestureRecognizer *panBackGestureRecognizer;

@end
