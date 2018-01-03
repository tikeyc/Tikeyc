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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ((TBaseNavigationViewController *)self.navigationController).panBackGestureRecognizer.enabled = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ((TBaseNavigationViewController *)self.navigationController).panBackGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self initSubViewProperty];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

//是否旋转
-(BOOL)shouldAutorotate{
    return YES;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
//只对present VC有效
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
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







