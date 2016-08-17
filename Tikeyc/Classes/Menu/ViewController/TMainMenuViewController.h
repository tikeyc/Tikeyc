//
//  TMainMenuViewController.h
//  Tikeyc
//
//  Created by ways on 16/8/15.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TBaseViewController.h"

#import "TMenuCenterViewController.h"
#import "TMenuLeftTableViewController.h"
#import "TMenuRightTableViewController.h"


@interface TMainMenuViewController : UIViewController

/*前置断言：我设置了centerViewController必须有值，不然会崩溃（有提示崩溃原因），因为不设置centerViewController就没必要用该menu控制器了
 *leftViewController rightViewController 可以为 nil
 */
- (instancetype _Nullable)initMainMenuWithCenterViewController:(TMenuCenterViewController *_Nullable)centerViewController
                                  leftViewController:(TMenuLeftTableViewController *_Nullable)leftViewController
                                 rightViewController:(TMenuRightTableViewController *_Nullable)rightViewController;

- (instancetype _Nullable)initMainMenuWithCenterViewController:(TMenuCenterViewController *_Nullable)centerViewController;

@property (nonatomic,strong,readonly)TMenuCenterViewController *_Nullable centerViewController;
@property (nonatomic,strong)TMenuLeftTableViewController *_Nullable leftViewController;
@property (nonatomic,strong)TMenuRightTableViewController *_Nullable rightViewController;
@property (nonatomic,copy)NSString *_Nullable testString;

@property (nonatomic,strong)UIPanGestureRecognizer *_Nullable panGestureRecognizer;//公开以便在其他控制器屏蔽滑动功能


@property (nonatomic,assign)BOOL showLeftBarButtonItem;//是否显示leftBarButton
@property (nonatomic,assign)BOOL showRighBarButtonItem;//是否显示rightBarButton


@end
