//
//  TMainViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainViewController.h"


#import "TBaseNavigationViewController.h"
#import "TMainViewController.h"

#import "TMainTopViewController.h"
#import "TMainCenterViewController.h"
#import "TMainBottomViewController.h"

#import "TMainViewModel.h"

@interface TMainViewController ()

@property (nonatomic,strong)TMainViewModel *mainViewModel;

@end

@implementation TMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"main_title"];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:image];
    titleView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.navigationItem.titleView = titleView;

    //
    [self initRACSignal];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*直接使用[self.mainMenuViewController removePanGestureRecognizerTarget:NO];有bug
     *因为是在viewWillAppear和viewWillDisappear中判断menu滑动显示menu手势，先滑动后使用的是系统滑动返回手势，显示一点点上一层级的控制器才判断和设置menu_pan的enable。需要毫秒级的时间差来过度，不然偶尔会出现始终可以滑动显示menu
     */
    [TNotificationCenter postNotificationName:TNotificationName_Set_menuPanEnable object:@(true)];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TNotificationCenter postNotificationName:TNotificationName_Set_menuPanEnable object:@(false)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - init

- (TMainViewModel *)mainViewModel{
    if (!_mainViewModel) {
        _mainViewModel = [[TMainViewModel alloc] init];
    }
    return _mainViewModel;
}

- (void)initRACSignal{
    
    /*直接使用[self.mainMenuViewController removePanGestureRecognizerTarget:NO];有bug
     *因为是在viewWillAppear和viewWillDisappear中判断menu滑动显示menu手势，先滑动后使用的是系统滑动返回手势，显示一点点上一层级的控制器才判断和设置menu_pan的enable。需要毫秒级的时间差来过度，不然偶尔会出现始终可以滑动显示menu
     *因此使用通知
     */
    TWeakSelf(self)
    [[TNotificationCenter rac_addObserverForName:TNotificationName_Set_menuPanEnable object:nil] subscribeNext:^(NSNotification *notification) {
//        notification
        
        if ([notification.object boolValue]) {
            NSLog(@"set enable YES");
            [weakself.mainMenuViewController removePanGestureRecognizerTarget:NO];
        }else{
            NSLog(@"set enable NO");
            [weakself.mainMenuViewController removePanGestureRecognizerTarget:YES];
        }
    }];
    
    //
    //
    TMainTopViewController *topVC = [TStoryboardWithName(@"MainTop") instantiateInitialViewController];
    TBaseNavigationViewController *mainTopNAVC = [[TBaseNavigationViewController alloc] initWithRootViewController:topVC];
    [self addChildViewController:mainTopNAVC];
    
    TMainCenterViewController *mainCenterVC = [TStoryboardWithName(@"MainCenter") instantiateInitialViewController];
    [self addChildViewController:mainCenterVC];
    self.selectedIndex = 1;//default value
    self.selectedViewController = mainCenterVC;//default value
    
    TMainBottomViewController *bottomVC = [TStoryboardWithName(@"MainBottom") instantiateInitialViewController];
    TBaseNavigationViewController *mainBottomNAVC = [[TBaseNavigationViewController alloc] initWithRootViewController:bottomVC];
    [self addChildViewController:mainBottomNAVC];
    
    [self.mainViewModel creatTopCenterBottomViewControllerToAddViewController:self];
    
}

#pragma mark - set


@end








