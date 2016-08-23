//
//  TReactiveCocoaLearningViewController.h
//  Tikeyc
//
//  Created by ways on 16/8/19.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RACdelegate <NSObject>

@optional
- (void)testReplaceRACdelegate1;
- (void)testReplaceRACdelegate2;

@end

@interface TReactiveCocoaLearningViewController : UIViewController<RACdelegate>

/*
 * ReactiveCocoa框架学习笔记 ReactiveCocoa框架学习笔记
 * ReactiveCocoa框架学习笔记 ReactiveCocoa框架学习笔记
 */


@property (nonatomic,weak)id<RACdelegate> replaceRACdelegate;

@end
