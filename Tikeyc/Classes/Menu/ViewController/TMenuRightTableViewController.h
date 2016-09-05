//
//  TMenuRightTableViewController.h
//  Tikeyc
//
//  Created by ways on 16/8/16.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TMainMenuViewController.h"
@class TMainMenuViewController;

@interface TMenuRightTableViewController : UITableViewController

//weak避免循环引用,导致无法释放的问题，因为在TMainMenuViewController.view调用了addSubview:TMenuRightTableViewController.view
@property (nonatomic,weak)TMainMenuViewController *mainMenuViewController;

@end
