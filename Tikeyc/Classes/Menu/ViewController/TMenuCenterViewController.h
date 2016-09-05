//
//  TMenuCenterViewController.h
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TMainMenuViewController.h"
@class TMainMenuViewController;
//由开发者自定义继承TMenuCenterViewController设置centerViewController,本项目由TMainViewController担任
@interface TMenuCenterViewController : UIViewController

//weak避免循环引用,导致无法释放的问题，因为在TMainMenuViewController.view调用了addSubview:TMenuCenterViewController.view
@property (nonatomic,weak)TMainMenuViewController *mainMenuViewController;

@end
