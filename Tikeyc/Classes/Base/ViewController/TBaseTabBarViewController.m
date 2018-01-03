//
//  TBaseTabBarViewController.m
//  Tikeyc
//
//  Created by ways on 2016/11/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TBaseTabBarViewController.h"

@interface TBaseTabBarViewController ()

@end

@implementation TBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


//是否跟随屏幕旋转
-(BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}
//支持旋转的方向有哪些
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}
//控制 vc present进来的横竖屏和进入方向 ，支持的旋转方向必须包含改返回值的方向 （详细的说明见下文）
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end
