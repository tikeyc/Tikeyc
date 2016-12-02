//
//  TEchartsLineViewController.m
//  Tikeyc
//
//  Created by ways on 16/10/8.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TEchartsLineViewController.h"

#import "TBaseNavigationViewController.h"

#import "iOS-Echarts.h"
#import "TEchartsTypeListController.h"

#import "TEchartsViewModel.h"


NSString *const lineAndBarOption = @"线柱混合(可滑动)";

@interface TEchartsLineViewController ()

@property (nonatomic,strong)TEchartsViewModel *echartsViewModel;

@property (strong, nonatomic) IBOutlet UIScrollView *echartBaseScrollView;
@property (strong, nonatomic) IBOutlet PYEchartsView *echartsView;
@end

@implementation TEchartsLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = lineAndBarOption;

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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self initSubViewProperty];
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

#pragma mark - init

- (void)test{
    self.echartBaseScrollView.contentSize = CGSizeMake(31*50, 0);
    
}

- (void)initSubViewProperty{
    
    [self performSelector:@selector(test) withObject:nil afterDelay:0.3];
    self.echartsView.frame = CGRectMake(0, 0, 31*50, kScreenWidth);
    [self.echartBaseScrollView addSubview:self.echartsView];
//    [self.echartsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(0));
//        make.bottom.equalTo(@(0));
//        make.left.equalTo(@(0));
//        make.width.equalTo(@(31*40));
//    }];
    //
    
    NSArray *results = [self loadData];
    dispatch_async(dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT), ^{
        
    });
    PYOption *option = [self.echartsViewModel lineAndBarOption:results];
    [self.echartsView setOption:option];
    [self.echartsView loadEcharts];
    
    [self.echartsView addHandlerForAction:PYEchartActionLegendSelected withBlock:^(NSDictionary *params) {
        NSLog(@"%@",params);
        
    }];
    
}

- (NSArray *)loadData{
    
//    self.echartsViewModel.requestURL = @"http://192.168.7.151:8087/m/ws/inventory!getCarModelOrderSale.do?userId=1&regionId=0&carModelId=Total&regionType=0&timeType=1&queryDate=201610&ticketNo=㊙️";
//    @weakify(self)
//    [self.echartsViewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *result) {
//        @strongify(self)
//        if ([result isKindOfClass:[NSDictionary class]] && [result[@"lives"] isKindOfClass:[NSArray class]]) {
//            
//            
//            
//        }
//        
//    }];
//    [self.echartsViewModel.requestCommand execute:nil];
    
    NSString *regionJsonPath = [[NSBundle mainBundle] pathForResource:@"lineBarJson" ofType:@"geojson"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:regionJsonPath];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    NSArray *results = result[@"data"];
    
    return results;
}

@end
