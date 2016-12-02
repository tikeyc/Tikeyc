//
//  TMainBottomTabBarController.m
//  Tikeyc
//
//  Created by ways on 2016/11/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainBottomTabBarController.h"

#import "TBaseNavigationViewController.h"


@interface TMainBottomTabBarController ()<UITabBarControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic,strong)NSArray *tabTtitleNames;
@property (nonatomic,strong)NSArray *tabNormalImageNames;
@property (nonatomic,strong)NSArray *tabHighlightedImageNames;



@end

@implementation TMainBottomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [TNotificationCenter addObserver:self selector:@selector(languageChanged) name:@"LANGUAGE_DIDCHANGE_NOTIFICATION" object:nil];

    [self initTabBarViewControllers];
    
    [self createTabbar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 

- (NSArray *)tabTtitleNames{
    if (!_tabTtitleNames) {
        //    _tabTtitleNames = @[MyLocalizedString(@"home.tabBarTitle", nil),MyLocalizedString(@"nearbyShop.tabBarTitle", nil),MyLocalizedString(@"user.tabBarTitle", nil),MyLocalizedString(@"setting.tabBarTitle", nil)];
        _tabTtitleNames = @[@"MainBottom1",@"MainBottom2",@"MainBottom3",@"MainBottom4",@"MainBottom5"];
    }
    
    return _tabTtitleNames;
}

- (NSArray *)tabNormalImageNames{
    if (!_tabNormalImageNames) {
        _tabHighlightedImageNames = @[@"tabBar_home_Normal",@"tabBar_near_Normal",@"tabBar_near_Normal",@"tabBar_account_Normal",@"tabBar_setting_Normal"];
    }
    return _tabNormalImageNames;
}

- (NSArray *)tabHighlightedImageNames{
    if (!_tabHighlightedImageNames) {
        _tabHighlightedImageNames = @[@"tabBar_home_Selected",@"tabBar_near_Selected",@"tabBar_near_Selected",@"tabBar_account_Selected",@"tabBar_setting_Selected"];
    }
    return _tabHighlightedImageNames;
}



- (void)initTabBarViewControllers{
    _tabBarItems = [NSMutableArray array];
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    for (int i = 0; i < self.tabTtitleNames.count; i++) {
        NSString *storyboarName = [@"MainBottomTabBar" stringByAppendingString:[@(i+1) stringValue]];
        UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:storyboarName bundle:mainBundle];
        TBaseNavigationViewController *viewController = [stroyboard instantiateInitialViewController];
        [viewControllers addObject:viewController];
        
        //
        UIImage *image = [UIImage imageNamed:self.tabNormalImageNames[i]];
        UIImage *selectedImage = [UIImage imageNamed:self.tabHighlightedImageNames[i]];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//必要代码
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:self.tabTtitleNames[i] image:image selectedImage:selectedImage];
        viewController.tabBarItem = tabBarItem;
        [_tabBarItems addObject:tabBarItem];
    }
    
    self.viewControllers = viewControllers;
}


- (void)createTabbar{
    self.tabBar.backgroundColor = TColor_RGB(91, 91, 91);
    //
    

    
    
}


#pragma mark - NSNotificationCenter

- (void)languageChanged{
    for (int i = 0; i < _tabBarItems.count; i++) {
        UITabBarItem *tabBarItem = _tabBarItems[i];
        NSString *title = self.tabTtitleNames[i];
        tabBarItem.title = title;
    }
}

#pragma mark - Actions Method




#pragma mark - UINavigationControllerDelegate

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    NSLog(@"willShowViewController:%@",viewController);
//    
//    //    if (navigationController.viewControllers.count >=2) {
//    //        self.tabBar.hidden = YES;
//    //    }else{
//    //        self.tabBar.hidden = NO;
//    //    }
//    
//}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    NSLog(@"selectedIndex--:%ld,selectViewController--:%@",tabBarController.selectedIndex,viewController);
    
    switch (tabBarController.selectedIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}


@end
