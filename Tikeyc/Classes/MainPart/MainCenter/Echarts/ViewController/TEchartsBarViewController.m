//
//  TEchartsBarViewController.m
//  Tikeyc
//
//  Created by ways on 16/10/8.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TEchartsBarViewController.h"

#import "TBaseNavigationViewController.h"

#import "iOS-Echarts.h"

#import "TEchartsViewModel.h"

NSString *const lineAndStackedBarOption = @"叠加柱状图";

@interface TEchartsBarViewController ()

@property (nonatomic,strong)TEchartsViewModel *echartsViewModel;

@property (strong, nonatomic) IBOutlet PYEchartsView *echartsView;

@end

@implementation TEchartsBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = lineAndStackedBarOption;
    
    
    [self initSubViewProperty];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ((TBaseNavigationViewController *)self.navigationController).panBackGestureRecognizer.enabled = NO;
    
    TApplicationDelegate.deviceInterfaceOrientationMask = UIInterfaceOrientationMaskLandscape;
    /*需要先设置一次正向
     *再设置希望的方向
     *不然存在BUG：当横着屏幕push进当前控制器时，第一次进来视图不会旋转至横屏状态。但当pop后再push进来视图却又可以旋转至横屏状态了
     */
    [TKCAppTools constraintRotationDeviceWithUIDeviceOrientation:UIDeviceOrientationPortrait];
    [TKCAppTools constraintRotationDeviceWithUIDeviceOrientation:UIDeviceOrientationLandscapeLeft];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ((TBaseNavigationViewController *)self.navigationController).panBackGestureRecognizer.enabled = YES;
    
    TApplicationDelegate.deviceInterfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    /*需要先设置一次横向
     *再设置希望的方向
     *不然存在BUG：当横着屏幕push进当前控制器时，已经横屏了，当用户竖着手机点击pop后视图不会旋转至竖屏状态
     */
    [TKCAppTools constraintRotationDeviceWithUIDeviceOrientation:UIDeviceOrientationLandscapeLeft];
    [TKCAppTools constraintRotationDeviceWithUIDeviceOrientation:UIDeviceOrientationPortrait];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - get

- (TEchartsViewModel *)echartsViewModel{
    if (!_echartsViewModel) {
        _echartsViewModel = [[TEchartsViewModel alloc] init];
    }
    return _echartsViewModel;
}

#pragma mrk - init

- (void)initSubViewProperty{
    NSArray *results = [self loadData];
    PYOption *option = [self.echartsViewModel lineAndStackedBarOption:results];
    [self.echartsView setOption:option];
    [self.echartsView loadEcharts];
    
    [self.echartsView addHandlerForAction:PYEchartActionLegendSelected withBlock:^(NSDictionary *params) {
        NSLog(@"%@",params);
        
    }];
}

- (NSArray *)loadData{
    
    NSString *regionJsonPath = [[NSBundle mainBundle] pathForResource:@"lineBarJson" ofType:@"geojson"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:regionJsonPath];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    NSArray *results = result[@"data"];
    
    return results;
}
@end







