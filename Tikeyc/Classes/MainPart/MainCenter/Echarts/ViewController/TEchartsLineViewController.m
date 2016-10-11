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
@interface TEchartsLineViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *echartBaseScrollView;
@property (strong, nonatomic) IBOutlet PYEchartsView *echartsView;
@end

@implementation TEchartsLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Line";
    
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
    PYOption *option = [self standardLineOption:results];
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

- (PYOption *)standardLineOption:(NSArray *)result {
    //X轴
    NSMutableArray *xAxisValues = [NSMutableArray array];
    //Y轴会自动调整
    //订单计划---Y轴value
    NSMutableArray *yOrderPlanValues = [NSMutableArray array];
    //订单实绩---Y轴value
    NSMutableArray *yOrderactualValues = [NSMutableArray array];
    //达成率---Y轴value
    NSMutableArray *yOrderfinishRateValues = [NSMutableArray array];
    
    for (int i = 0; i < result.count; i++) {
        [xAxisValues addObject:@(i+1)];
        //
        NSDictionary *orderDic = result[i][@"order"];
        [yOrderPlanValues addObject:orderDic[@"planVal"]];
        [yOrderactualValues addObject:orderDic[@"actualVal"]];
        [yOrderfinishRateValues addObject:[orderDic[@"finishRate"] stringByReplacingOccurrencesOfString:@"%" withString:@""]];
        
    }
    
    
    
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"合计订单全国情况")
            .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                textStyle.colorEqual(PYRGBA(211, 211, 211, 1));
            }]);
        }])
//        .colorEqual(@[PYRGBA(2, 111, 2, 1),PYRGBA(2, 111, 222, 1),PYRGBA(222, 111, 2, 1)])也可以这样控制系列的颜色或itemStyleProp.colorEqual(PYRGBA(192, 212, 233, 1))
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@80);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"订单计划",@"订单实绩",@"达成率"]);//需与addSeries的name一一对应才能点击显/隐生效
            legend.xEqual(@200);
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory)
            .boundaryGapEqual(@YES)
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(NO);
            }])
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO);
            }])
            .addDataArr(xAxisValues);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue)
//            .addDataArr(@[@(0),@(500),@(1000),@(1500),@(2000),@(2600)])
//            .showEqual(false)
            
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(NO);
            }])
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.showEqual(NO);
            }])
            .splitAreaEqual([PYSplitArea initPYSplitAreaWithBlock:^(PYSplitArea *splitArea) {
                splitArea.showEqual(NO);
            }])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *axisSpliteLine) {
                axisSpliteLine.showEqual(YES);
            }])
            
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.formatterEqual(@"{value}");
            }]);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue)
            .nameEqual(@"达成率")
//            .showEqual(false)
            .addDataArr(@[@(0),@(50),@(100),@(150),@(200)])
            
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(NO);
            }])
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.showEqual(NO);
            }])
            .splitAreaEqual([PYSplitArea initPYSplitAreaWithBlock:^(PYSplitArea *splitArea) {
                splitArea.showEqual(NO);
            }])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *axisSpliteLine) {
                axisSpliteLine.showEqual(NO);
            }])
            
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.formatterEqual(@"{value} %");
            }]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.barWidthEqual(@15);
            series.nameEqual(@"订单计划")
            .typeEqual(PYSeriesTypeBar)
            .dataEqual(yOrderPlanValues)//数据
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES);
                        label.positionEqual(PYPositionTop);
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(192, 212, 233, 1));
                }]);
            }]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.barWidthEqual(@15);
            series.nameEqual(@"订单实绩")
            .typeEqual(PYSeriesTypeBar)
            .dataEqual(yOrderactualValues)//数据
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES);
                        label.positionEqual(PYPositionTop);
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(186, 236, 183, 1));
                }]);
            }]);
        }])
        
        //
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.yAxisIndexEqual(@(1));
            series.nameEqual(@"达成率")
            .typeEqual(PYSeriesTypeLine)
            .addDataArr(yOrderfinishRateValues)//数据
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES)
//                        .formatterEqual(@"{c} %")
                        .formatterEqual(@"(function (params) {for (var i = 0, l = option.xAxis[0].data.length; i < l; i++) {if (option.xAxis[0].data[i] == params.name && params.value) {return params.value + '%';}}})")
                        .positionEqual(PYPositionTop);
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(246, 69, 64, 1));
                }]);
            }]);
        }]);
        //下面添加多余series用以在点击legend隐藏所有系列后。任然留着横线网格grid
        option.addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
//            series.nameEqual(@"test");
            series.typeEqual(PYSeriesTypeLine);
            NSNumber *OrderactualMax = [yOrderactualValues valueForKeyPath:@"@max.floatValue"];
            NSNumber *OrderPlanMax = [yOrderPlanValues valueForKeyPath:@"@max.floatValue"];
            series.dataEqual(@[MAX(OrderactualMax, OrderPlanMax)])//数据 取所有系列的最大值
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(NO);
                        label.positionEqual(PYPositionTop);
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(255, 255, 255, 0));
                }]);
            }]);
        }]);

    }];
    
    
}

@end
