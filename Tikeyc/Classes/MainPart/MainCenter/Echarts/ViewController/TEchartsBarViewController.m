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

@interface TEchartsBarViewController ()


@property (strong, nonatomic) IBOutlet PYEchartsView *echartsView;

@end

@implementation TEchartsBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Bar";
    
    
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


- (void)initSubViewProperty{
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
    
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis)
            .axisPointerEqual([PYAxisPointer initPYAxisPointerWithBlock:^(PYAxisPointer *axisPoint) {
                axisPoint.typeEqual(PYAxisPointerTypeShadow);
            }]);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"0-30天",@"30-60天",@">60天",@"长期在库率"]);
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@80);
        }])
//        .calculableEqual(YES)拖拽重计算
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory)
            .addDataArr(@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12]);
            axis.axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO);
            }]);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue);
            axis.splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *axisSpliteLine) {
                axisSpliteLine.showEqual(NO);
            }]);
            axis.axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.formatterEqual(@"{value} %");
            }]);
        }])
        
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.barWidthEqual(@15);
            series.stackEqual(@"广告")
            .nameEqual(@"0-30天")
            .typeEqual(PYSeriesTypeBar)
            .dataEqual(@[@120, @132, @101, @134, @90, @230, @210, @101, @134, @90, @230, @210])
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES);
                        label.positionEqual(@"inside");
                        label.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                            textStyle.colorEqual(PYRGBA(0, 0, 0, 1));
                            textStyle.fontSizeEqual(@9);
                        }]);
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(195, 212, 233, 1));
                }]);
            }]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.barWidthEqual(@15);
            series.stackEqual(@"广告")
            .nameEqual(@"30-60天")
            .typeEqual(PYSeriesTypeBar)
            .dataEqual(@[@220, @182, @191, @234, @290, @330, @310, @191, @234, @290, @330, @310])
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES);
                        label.positionEqual(@"inside");
                        label.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                            textStyle.colorEqual(PYRGBA(0, 0, 0, 1));
                            textStyle.fontSizeEqual(@9);
                        }]);
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(187, 235, 183, 1));
                }]);
            }]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.barWidthEqual(@15);
            series.stackEqual(@"广告")
            .nameEqual(@">60天")
            .typeEqual(PYSeriesTypeBar)
            .dataEqual(@[@150, @232, @201, @154, @190, @330, @410, @201, @154, @190, @330, @410])
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES);
                        label.positionEqual(@"inside");
                        label.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                            textStyle.colorEqual(PYRGBA(0, 0, 0, 1));
                            textStyle.fontSizeEqual(@9);
                        }]);
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(192, 139, 240, 1));
                }]);
            }]);
            series.markLineEqual([PYMarkLine initPYMarkLineWithBlock:^(PYMarkLine *markLine) {
//                markLine.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
//                    
//                }]);
                markLine.addDataArr(@[@{@"type" : @"average", @"name": @"平均值"}]);
            }]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.yAxisIndexEqual(@1);
            series.nameEqual(@"长期在库率")
            .typeEqual(PYSeriesTypeLine)
            .dataEqual(@[@320, @332, @301, @334, @390, @330, @320, @301, @334, @390, @330, @320])
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES);
                        label.positionEqual(PYPositionTop);
                        label.formatterEqual(@"(function (params) {for (var i = 0, l = option.xAxis[0].data.length; i < l; i++) {if (option.xAxis[0].data[i] == params.name && params.value) {return params.value + '%';}}})");
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(250, 13, 27, 1));
                }]);
            }]);
        }]);
        //下面添加多余series用以在点击legend隐藏所有系列后。任然留着横线网格grid
        option.addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
//            series.nameEqual(@"test");
            series.typeEqual(PYSeriesTypeLine)
            .dataEqual(@[@1000])//数据 取所有系列的最大值
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







