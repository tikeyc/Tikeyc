//
//  TMainMenuViewController.h
//  Tikeyc
//
//  Created by ways on 16/8/15.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Pan_left_MaxWith self.view.frame.size.width*3/4
#define Pan_right_MaxWith self.view.frame.size.width*1/3
#define Center_Animation_durition 1.0

@interface TMainMenuViewController : UIViewController

/*前置断言：我设置了centerViewController必须有值，不然会崩溃（有提示崩溃原因），因为不设置centerViewController就没必要用该menu控制器了
 *leftViewController rightViewController 可以为 nil
 */
- (instancetype _Nullable)initMainMenuWithCenterViewController:(UIViewController *_Nullable)centerViewController
                                  leftViewController:(UIViewController *_Nullable)leftViewController
                                 rightViewController:(UIViewController *_Nullable)rightViewController;

- (instancetype _Nullable)initMainMenuWithCenterViewController:(UIViewController *_Nullable)centerViewController;

@property (nonatomic,strong,readonly)UIViewController *_Nullable centerViewController;
@property (nonatomic,strong)UIViewController *_Nullable leftViewController;
@property (nonatomic,strong)UIViewController *_Nullable rightViewController;
@property (nonatomic,copy)NSString *_Nullable testString;

@property (nonatomic,strong)UIPanGestureRecognizer *_Nullable panGestureRecognizer;//公开以便在其他控制器屏蔽滑动功能


@property (nonatomic,assign)BOOL showLeftBarButtonItem;//是否显示leftBarButton
@property (nonatomic,assign)BOOL showRighBarButtonItem;//是否显示rightBarButton


@end
