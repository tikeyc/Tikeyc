//
//  TBaseNavigationViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/15.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TBaseNavigationViewController.h"

@interface TBaseNavigationViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)id interactivePopGestureRecognizerDelegate;

@end

@implementation TBaseNavigationViewController


- (void)dealloc
{
    [SVProgressHUD dismiss];
    [TNotificationCenter removeObserver:self];
    [self removeObserverBlocks];
    NSLog(@"%@ 成功销毁了，无内存泄漏",self);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

+ (void)initialize
{
    // 当导航栏用在TBaseNavigationViewController中appearance才会生效
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    //    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    [bar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionary];
    titleAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    titleAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [bar setTitleTextAttributes:titleAttrs];
    
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initPanBackControllerRecognizer];
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



#pragma mark - 屏幕旋转控制方法

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}




/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([viewController isKindOfClass:NSClassFromString(@"TWebViewController")]) {
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            [button setTitle:@"返回" forState:UIControlStateNormal];
            [button sizeToFit];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            
            button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        }else{
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            
            button.frame = CGRectMake(0, 0, 44, 44);
            [button setImage:[UIImage imageNamed:@"common_back_barItem_button"] forState:UIControlStateNormal];
        }
        //            @weakify(self);
        TWeakSelf(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            //                @strongify(self);
            [weakself popViewControllerAnimated:YES];
        }];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}


- (void)initPanBackControllerRecognizer{
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    _panBackGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    
    // 设置手势代理，拦截手势触发
    _panBackGestureRecognizer.delegate = self;
    
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:_panBackGestureRecognizer];
    
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    //此方法只是为了去掉警告
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    // 当前页面是特定页，不响应滑动手势
    UIViewController *vc = [self.childViewControllers lastObject];
    
    if ([vc isKindOfClass:[NSClassFromString(@"特定页控制器") class]]) {
        return NO;
    }
    
    return YES;
}
@end















