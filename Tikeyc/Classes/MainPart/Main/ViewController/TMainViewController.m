//
//  TMainViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainViewController.h"

#import <Intents/Intents.h>
#import <IntentsUI/IntentsUI.h>
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
    
    TsetNavigationItem_titleView_withImgName(@"main_title")
    //
    [self initRACSignal];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.mainMenuViewController removePanGestureRecognizerTarget:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.mainMenuViewController removePanGestureRecognizerTarget:NO];
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









