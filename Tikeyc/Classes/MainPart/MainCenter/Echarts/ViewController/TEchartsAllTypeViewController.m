//
//  TEchartsAllTypeViewController.m
//  Tikeyc
//
//  Created by ways on 2016/10/19.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TEchartsAllTypeViewController.h"

#import "TBaseNavigationViewController.h"

#import "TEchartsViewModel.h"
#import "TEchartsMapViewModel.h"

NSString *const basicAreaOption = @"标准面积图";
NSString *const stackedAreaOption = @"堆积面积图(可以在堆积柱状图，标准柱状图等切换)";
NSString *const irregularLine2Option = @"不等距折线图(下边有时间区域选择)";

NSString *const timeLineOption = @"装逼统计(含时间轴)";
NSString *const forceGuideOption = @"力导向图";

NSString *const standardPieOption = @"标准饼图";
NSString *const nestedPieOption = @"嵌套饼图(饼图和环形图)";

NSString *const basicChinaMapOption = @"中国基础地图";
NSString *const basicChinaMapCityOption = @"中国基础地图(城市)";

NSString *const basicWorldMapOption = @"世界基础地图";
NSString *const showMapMarkLine = @"地图标线(模拟迁徙)";



@interface TEchartsAllTypeViewController ()<PYEchartsViewDelegate>{
    
    NSString *_lastSelectedMapProvinceName;//中国基础地图 模式下
    NSString *_lastSelectedMapCityeName;//中国基础地图 模式下
    
}

@property (nonatomic,strong)TEchartsViewModel *echartsViewModel;
@property (nonatomic,strong)TEchartsMapViewModel *echartsMapViewModel;

@property (strong, nonatomic) IBOutlet PYEchartsView *echartsView;

@end

@implementation TEchartsAllTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [SVProgressHUD show];
    // 鸡 = -8  9 = 鸡  鸡 = -10   11 = 鸡  这个过程鸡升值了 11块一个鸡
    //（赚+3 - 8）（亏-2 + 9） (赚+1 - 10) （+11）
    // -5 + 7 - 9 + 11 = 2 + 2 = 4
    if ([self.title isEqualToString:forceGuideOption] ||
        [self.title isEqualToString:standardPieOption] ||
        [self.title isEqualToString:nestedPieOption]){
        //无需横屏
        self.shouldNotLandscapeDevice = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ((TBaseNavigationViewController *)self.navigationController).panBackGestureRecognizer.enabled = NO;
    
    if (!self.shouldNotLandscapeDevice) {
        TApplicationDelegate.deviceInterfaceOrientationMask = UIInterfaceOrientationMaskLandscape;
        /*需要先设置一次正向
         *再设置希望的方向
         *不然存在BUG：当横着屏幕push进当前控制器时，第一次进来视图不会旋转至横屏状态。但当pop后再push进来视图却又可以旋转至横屏状态了
         */
        [TKCAppTools constraintRotationDeviceWithUIDeviceOrientation:UIDeviceOrientationPortrait];
        [TKCAppTools constraintRotationDeviceWithUIDeviceOrientation:UIDeviceOrientationLandscapeLeft];
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ((TBaseNavigationViewController *)self.navigationController).panBackGestureRecognizer.enabled = YES;
    
    if (!self.shouldNotLandscapeDevice) {
        TApplicationDelegate.deviceInterfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
        /*需要先设置一次横向
         *再设置希望的方向
         *不然存在BUG：当横着屏幕push进当前控制器时，已经横屏了，当用户竖着手机点击pop后视图不会旋转至竖屏状态
         */
        [TKCAppTools constraintRotationDeviceWithUIDeviceOrientation:UIDeviceOrientationLandscapeLeft];
        [TKCAppTools constraintRotationDeviceWithUIDeviceOrientation:UIDeviceOrientationPortrait];
    }
    
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
- (TEchartsMapViewModel *)echartsMapViewModel{
    if (!_echartsMapViewModel) {
        _echartsMapViewModel = [[TEchartsMapViewModel alloc] init];
    }
    return _echartsMapViewModel;
}


#pragma mark - init Echarts option


- (void)initSubViewProperty{
    
    self.echartsView.eDelegate = self;
    PYOption *option;
    if ([self.title isEqualToString:basicAreaOption]) {
        option = [TEchartsViewModel basicAreaOption];
        
    }else if ([self.title isEqualToString:stackedAreaOption]){
        option = [TEchartsViewModel stackedAreaOption];
        
    }else if ([self.title isEqualToString:irregularLine2Option]){
        option = [TEchartsViewModel irregularLine2Option];
        
    }else if ([self.title isEqualToString:timeLineOption]){
        option = [TEchartsViewModel timeLineOption];
        
    }else if ([self.title isEqualToString:forceGuideOption]){
        option = [TEchartsViewModel forceGuideOption];
        self.shouldNotLandscapeDevice = YES;
    }else if ([self.title isEqualToString:standardPieOption]){
        option = [TEchartsViewModel standardPieOption];
        self.shouldNotLandscapeDevice = YES;
    }else if ([self.title isEqualToString:nestedPieOption]){
        option = [TEchartsViewModel nestedPieOption];
        self.shouldNotLandscapeDevice = YES;
    }else if ([self.title isEqualToString:basicChinaMapOption]){
        option = [TEchartsMapViewModel basicChinaMapOption];
        TWeakSelf(self)
        [self.echartsView addHandlerForAction:PYEchartActionMapSelected withBlock:^(NSDictionary *params) {
            NSLog(@"target---%@",params[@"target"]);
            NSDictionary *selected = params[@"selected"];//所有点击过的州 或国家 或省 或市
            NSString *selectedProvince;// = params[@"target"];
            NSString *name;//当前选择的州 或国家 或省 或市 的名字 同事也存在于series的datas数组中（元素是字典）字典中的name字段的value
            //形如:series.datas = @[ @{@"name":@"北京",@"selected":@"false"}, @{@"name":@"广东",@"selected":@"true"}]
            NSMutableArray *datas = (NSMutableArray *)(((PYSeries *)option.series[0]).data);//获取第一个地图的data，当前设置的是中国地图
            for (int i = 0 ; i < datas.count; i++) {
                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary *)datas[i]];
                name = dataDic[@"name"];
//                [data setObject:@([selected[name] boolValue]) forKey:@"selected"];

                if (name == _lastSelectedMapProvinceName) {
                    [dataDic setObject:@(false) forKey:@"selected"];
                    [datas replaceObjectAtIndex:i withObject:dataDic];
                }
                if ([selected[name] boolValue] && !selectedProvince) {
                    selectedProvince = name;
                    [datas replaceObjectAtIndex:i withObject:dataDic];
                    _lastSelectedMapProvinceName = selectedProvince;
                }
            }
            ((PYSeries *)option.series[0]).data = datas;
             if (selectedProvince == nil) {
                 option.legend = nil;
                 option.dataZoom = nil;
                 [weakself.echartsView refreshEchartsWithOption:option];
                 NSLog(@"not create series2");
                 return;
                 
             }
            //
            PYSeries *series2 = [TEchartsMapViewModel basicChinaPrivinceMapSeriesWithPrivinceName:selectedProvince];
            option.series = [[NSMutableArray alloc] initWithArray:option.series];//防止option.series为空 尽管不会发生
            if (option.series.count > 1) {
                [option.series replaceObjectAtIndex:1 withObject:series2];
            } else {
                [option.series addObject:series2];
            }
            
            [weakself.echartsView refreshEchartsWithOption:option];
        }];
    }else if ([self.title isEqualToString:basicChinaMapCityOption]){
        option = [TEchartsMapViewModel basicChinaMapCityOptionWithPrivinceName:@"广东"/*self.selectedPrivinceName*/ selectedCityName:@"广州市"/*self.selectedCityName*/];
    }else if ([self.title isEqualToString:basicWorldMapOption]){
        option = [TEchartsMapViewModel basicWorldMapOption];
    }else if ([self.title isEqualToString:showMapMarkLine]){
        option = [TEchartsMapViewModel showMapMarkLine];
    }

    
    [self.echartsView setOption:option];
    [self.echartsView loadEcharts];
}




#pragma mark - PYEchartsViewDelegate

- (BOOL)echartsView:(PYEchartsView *)echartsView didReceivedLinkURL:(NSURL *)url{
    
    return YES;
}


- (void)echartsViewDidFinishLoad:(PYEchartsView *)echartsView{
    [SVProgressHUD dismiss];
    NSLog(@"echartsViewDidFinishLoad");
}


@end

















