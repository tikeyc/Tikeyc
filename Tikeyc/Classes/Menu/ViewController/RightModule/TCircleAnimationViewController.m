//
//  TCircleAnimationViewController.m
//  Tikeyc
//
//  Created by ways on 2017/5/15.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TCircleAnimationViewController.h"

#import "TCirclePathAnimationView.h"

@interface TCircleAnimationViewController ()


@property (nonatomic,strong)TCirclePathAnimationView *circlePathAnimationView;


@end

@implementation TCircleAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initProperty];
    
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

- (TCirclePathAnimationView *)circlePathAnimationView {
    if (_circlePathAnimationView == nil) {
        _circlePathAnimationView = [[TCirclePathAnimationView alloc] initWithFrame:CGRectMake(0, 0, TScreenWidth, TScreenHeight - kAppStatusBarHeight - kAppNavigationBarHeight)
                                                                             icons:@[@"service_certification_30x30_",@"service_earnMoney_30x30_",@"service_my_30x30_",@"service_certification_30x30_",@"service_my_30x30_"]
                                                                            titles:@[@"test01 test01 test01",@"test2 test2 test2",@"test3 test3 test3",@"test4 test4 test4",@"test5 test5 test5"]
                                                                         clickIcon:^(NSInteger index) {
                                                                             
                                                                         }];
        [self.view addSubview:_circlePathAnimationView];
    }
    return _circlePathAnimationView;
}



- (void)initProperty {
    [self circlePathAnimationView];
    

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [button setTitle:@"点击此处开启动画" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(starAnimation) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
}



#pragma mark - 

- (void)starAnimation {
//    [self.circlePathAnimationView startCircleLayerAnimation];
    [self.circlePathAnimationView startIconAnimations];
}

@end







