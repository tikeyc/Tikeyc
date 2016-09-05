//
//  TMenuCenterViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMenuCenterViewController.h"


//由开发者自定义继承TMenuCenterViewController设置centerViewController,本项目由TMainViewController担任
@interface TMenuCenterViewController ()

@end

@implementation TMenuCenterViewController

- (void)dealloc
{
    NSLog(@"%@ 成功销毁了，无内存泄漏",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
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


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [TAppDelegateManager gotoLoginController];
}

@end
