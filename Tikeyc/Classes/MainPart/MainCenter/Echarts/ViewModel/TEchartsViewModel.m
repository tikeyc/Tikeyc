//
//  TEchartsViewModel.m
//  Tikeyc
//
//  Created by ways on 2016/10/19.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TEchartsViewModel.h"

#import "PYLinkStyle.h"
#import "PYNodeStyle.h"

#import "PYMapSeries.h"

@implementation TEchartsViewModel



/**
 line bar 混合，addSuview在了ScrollView上，可以滑动

 @param result 数据

 @return option
 */
- (PYOption *)lineAndBarOption:(NSArray *)result {
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
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.showEqual(YES)
            .triggerEqual(PYTooltipTriggerAxis)
            .axisPointerEqual([PYAxisPointer initPYAxisPointerWithBlock:^(PYAxisPointer *axisPoint) {
                axisPoint.showEqual(YES)
                .typeEqual(PYAxisPointerTypeCross)
                .lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.typeEqual(PYLineStyleTypeDashed)
                    .widthEqual(@1);
                }]);
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
            .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
                tooltip.triggerEqual(PYTooltipTriggerAxis)
                .showEqual(YES);
            }])
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
//        option.addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
//            //            series.nameEqual(@"test");
//            series.typeEqual(PYSeriesTypeLine);
//            NSNumber *OrderactualMax = [yOrderactualValues valueForKeyPath:@"@max.floatValue"];
//            NSNumber *OrderPlanMax = [yOrderPlanValues valueForKeyPath:@"@max.floatValue"];
//            series.dataEqual(@[MAX(OrderactualMax, OrderPlanMax)])//数据 取所有系列的最大值
//            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
//                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
//                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
//                        label.showEqual(NO);
//                        label.positionEqual(PYPositionTop);
//                    }]);
//                    itemStyleProp.colorEqual(PYRGBA(255, 255, 255, 0));
//                }]);
//            }]);
//            
//        }]);
        
    }];
    
}


/**
 line 叠加柱状图 混合
 
 @param result 数据
 
 @return option
 */
- (PYOption *)lineAndStackedBarOption:(NSArray *)result{
    
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
//        .dataZoomEqual([PYDataZoom initPYDataZoomWithBlock:^(PYDataZoom *dataZoom) {
//            dataZoom.showEqual(YES).startEqual(@20).endEqual(@70);
//            dataZoom.dataBackgroundColorEqual(PYRGBA(55, 55, 55, 1))
//            .realtimeEqual(YES);
//        }])
        .calculableEqual(YES)//拖拽重计算
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
            series.markPointEqual([PYMarkPoint initPYMarkPointWithBlock:^(PYMarkPoint *point) {
                point.addDataArr(@[@{@"type" : @"max", @"name": @"最大值"},
                                   @{@"type" : @"min", @"name": @"最小值"},
                                   @{@"value" : @(150), @"name": @"标记", @"xAxis":@(1), @"yAxis" : @(200)}
                                   ]);
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
//        option.addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
//            //            series.nameEqual(@"test");
//            series.typeEqual(PYSeriesTypeLine)
//            .dataEqual(@[@1000])//数据 取所有系列的最大值
//            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
//                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
//                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
//                        label.showEqual(NO);
//                        label.positionEqual(PYPositionTop);
//                    }]);
//                    itemStyleProp.colorEqual(PYRGBA(255, 255, 255, 0));
//                }]);
//            }]);
//        }]);
        
    }];

}

/**
 标准面积图

 @return option
 */
+ (PYOption *)basicAreaOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"某楼盘销售情况").subtextEqual(@"纯属虚构");
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@50);
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"意向",@"预购",@"成交"]);
        }])
        .dataZoomEqual([PYDataZoom initPYDataZoomWithBlock:^(PYDataZoom *dataZoom) {
            dataZoom.showEqual(YES).startEqual(@20).endEqual(@70);
            dataZoom.dataBackgroundColorEqual(PYRGBA(55, 55, 55, 1))
            .realtimeEqual(YES);
        }])
//        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
//            toolbox.showEqual(YES)
//            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
//                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
//                    mark.showEqual(YES);
//                }])
//                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
//                    dataView.showEqual(YES).readOnlyEqual(NO);
//                }])
//                .magicTypeEqual([PYToolboxFeatureMagicType initPYToolboxFeatureMagicTypeWithBlock:^(PYToolboxFeatureMagicType *magicType) {
//                    magicType.showEqual(YES).typeEqual(@[PYSeriesTypeLine, PYSeriesTypeBar, @"stack", @"tiled"]);
//                }])
//                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
//                    restore.showEqual(YES);
//                }]);
//            }]);
//        }])
        .calculableEqual(YES)
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory).boundaryGapEqual(@NO).addDataArr(@[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"]);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .nameEqual(@"成交")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(10),@(12),@(21),@(54),@(260),@(830),@(710)]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .nameEqual(@"预购")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(30),@(182),@(434),@(791),@(390),@(30),@(10)]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .nameEqual(@"意向")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(1320),@(1132),@(601),@(234),@(120),@(90),@(20)]);
        }]);
    }];
}


/**
 堆积面积图

 @return option
 */
+ (PYOption *)stackedAreaOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"邮件营销",@"联盟广告",@"视频广告",@"直接访问",@"搜索引擎"]);
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@50);
        }])
        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
            toolbox.showEqual(YES)
            .xEqual(@100).yEqual(@30)
            .itemGapEqual(@20)
            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
//                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
//                    mark.showEqual(YES);
//                }])
//                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
//                    dataView.showEqual(YES).readOnlyEqual(NO);
//                }])
                feature.magicTypeEqual([PYToolboxFeatureMagicType initPYToolboxFeatureMagicTypeWithBlock:^(PYToolboxFeatureMagicType *magicType) {
                    magicType.showEqual(YES).typeEqual(@[PYSeriesTypeLine, PYSeriesTypeBar, @"stack", @"tiled"]);
                }]);
                feature.dataZoomEqual([PYToolboxFeatureDataZoom initPYToolboxFeatureDataZoomWithBlock:^(PYToolboxFeatureDataZoom *dataZoom) {
                    dataZoom.showEqual(NO);
                }]);
//                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
//                    restore.showEqual(YES);
//                }]);
            }]);
        }])
        .calculableEqual(YES)
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory)
            .boundaryGapEqual(@NO).addDataArr(@[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"]);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.stackEqual(@"总量")
            .nameEqual(@"邮件营销")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(120),@(132),@(101),@(134),@(90),@(230),@(210)]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.stackEqual(@"总量")
            .nameEqual(@"联盟广告")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(220), @(182), @(191), @(234), @(290), @(330), @(310)]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.stackEqual(@"总量")
            .nameEqual(@"视频广告")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(150), @(232), @(201), @(153), @(190), @(330), @(410)]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.stackEqual(@"总量")
            .nameEqual(@"直接访问")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(320), @(332), @(301), @(334), @(390), @(330), @(320)]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.stackEqual(@"总量")
            .nameEqual(@"搜索引擎")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(820), @(932), @(901), @(934), @(1290), @(1330), @(1320)]);
        }]);
    }];
}



/**
 不等距折线图(下边有时间区域选择)

 @return option
 */
+ (PYOption *)irregularLine2Option {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"时间坐标折线图")
            .subtextEqual(@"dataZoom支持");
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@50).y2Equal(@80);
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@"(function(params){var date = new Date(params.value[0]);data = date.getFullYear() + \'-\' + (date.getMonth() + 1) + \'-\' + date.getDate() + \' \' + date.getHours() + \':\' + date.getMinutes(); return data + \'<br/>\' + params.value[1] + \',\' + params.value[2]})");
        }])
        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
            toolbox.showEqual(NO)
            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
                    mark.showEqual(YES);
                }])
                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
                    dataView.showEqual(YES).readOnlyEqual(NO);
                }])
                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
                    restore.showEqual(YES);
                }]);
            }]);
        }])
        .dataZoomEqual([PYDataZoom initPYDataZoomWithBlock:^(PYDataZoom *dataZoom) {
            dataZoom.showEqual(YES).startEqual(@20).endEqual(@70);
            dataZoom.dataBackgroundColorEqual(PYRGBA(55, 55, 55, 1))
            .realtimeEqual(YES);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"series1"]);
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeTime)
            .splitNumberEqual(@10);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.symbolSizeEqual(@"(function(value) {return Math.round(value[2]/100) + 2;})").showAllSymbolEqual(YES).nameEqual(@"series1").typeEqual(PYSeriesTypeLine).dataEqual(@"(function () {var d = [];var len = 0;var now = new Date();var value;while (len++ < 200) {d.push([new Date(2014, 9, 1, 0, len * 10000),(Math.random()*30).toFixed(2) - 0,(Math.random()*100).toFixed(2) - 0]);}return d;})()");
        }]);
    }];
}


/**
 柱状图(下边有时间轴选择)
 
 @return option
 */
+ (PYOption *)timeLineOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.timelineEqual([PYTimeline initPYTimelineWithBlock:^(PYTimeline *timeline) {
            timeline.addDataArr(@[@"2002-01-01",@"2003-01-01",@"2004-01-01",@"2005-01-01",@"2006-01-01",
                                  @"2007-01-01",@"2008-01-01",@"2009-01-01",@"2010-01-01",@"2011-01-01"])
            .labelEqual([PYTimelineLabel initPYTimelineLabelWithBlock:^(PYTimelineLabel *timelineLabel) {
                timelineLabel.formatterEqual(@"(function(s) {return s.slice(0, 4);})");
            }])
            .autoPlayEqual(YES)
            .playIntervalEqual(@1000);
        }])
        

        
        //option1
        .addOptions([PYOption initPYOptionWithBlock:^(PYOption *option) {
            option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
                title.textEqual(@"2002全国装逼指标");
//                .subtextEqual(@"数据来自国家装逼统计局");
            }])
            .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
                tooltip.triggerEqual(PYTooltipTriggerAxis);
            }])
            .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
                legend.xEqual(@200)
                .dataEqual(@[@"装逼异界",@"装逼金融街",@"装逼地产",@"装逼产业"]);
            }])
            .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
                toolbox.showEqual(YES)
                .xEqual(@200).yEqual(@30)
                .itemGapEqual(@20)
                .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
                    //                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
                    //                    mark.showEqual(YES);
                    //                }])
                    //                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
                    //                    dataView.showEqual(YES).readOnlyEqual(NO);
                    //                }])
                    feature.magicTypeEqual([PYToolboxFeatureMagicType initPYToolboxFeatureMagicTypeWithBlock:^(PYToolboxFeatureMagicType *magicType) {
                        magicType.showEqual(YES).typeEqual(@[PYSeriesTypeLine, PYSeriesTypeBar]);//, @"stack", @"tiled"
                    }]);
                    feature.dataZoomEqual([PYToolboxFeatureDataZoom initPYToolboxFeatureDataZoomWithBlock:^(PYToolboxFeatureDataZoom *dataZoom) {
                        dataZoom.showEqual(NO);
                    }]);
                    //                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
                    //                    restore.showEqual(YES);
                    //                }]);
                }]);
            }])
            .calculableEqual(YES)
            .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
                grid.yEqual(@80).y2Equal(@100);
            }])
            .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
                axis.typeEqual(PYAxisTypeCategory)
                .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                    axisLabel.intervalEqual(@0);
                }])
                .addDataArr(@[@1,@2,@3,@4,@5,@6,@7]);
            }])
            .addYAxisArr(
             @[[PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
                axis.typeEqual(PYAxisTypeValue)
                .nameEqual(@"装逼异界（装逼程度）");
            }],
               [PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
                axis.typeEqual(PYAxisTypeValue)
                .nameEqual(@"其他（装逼程度）");
            }]])
            .addSeriesArr(@[[PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.nameEqual(@"装逼异界")
                .typeEqual(PYSeriesTypeBar)
                .markLineEqual([PYMarkLine initPYMarkLineWithBlock:^(PYMarkLine *markLine) {
                    markLine.symbolEqual(@[PYSymbolArrow,PYSymbolNone])
//                    .symbolSizeEqual(@[@4,@2])
                    .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                        itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                            itemStyleProp.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                                lineStyle.colorEqual(@"orange");
                            }])
                            .barBorderColorEqual(@"orange")
                            .labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                                label.positionEqual(PYPositionLeft)
                                .formatterEqual(@"(function(params){return Math.round(params.value);})")
                                .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                                    textStyle.colorEqual(@"orange");
                                }]);
                            }]);
                        }]);
                    }])
                    .addDataArr(@[@{@"type":@"average",@"name":@"平均值"}]);
                }]);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(2000 + 1))];
                }
                series.addDataArr(datas);
            }],
                            [PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.nameEqual(@"装逼金融街");
                series.yAxisIndexEqual(@1)
                .typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(2000 + 1))];
                }
                series.addDataArr(datas);
            }],
                            [PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.nameEqual(@"装逼地产");
                series.yAxisIndexEqual(@1)
                .typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(2000 + 1))];
                }
                series.addDataArr(datas);
            }],
                            [PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.nameEqual(@"装逼产业");
                series.yAxisIndexEqual(@1)
                .typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(2000 + 1))];
                }
                series.addDataArr(datas);
            }]]);
            
        }])
        //option2
        .addOptions([PYOption initPYOptionWithBlock:^(PYOption *option) {
            option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
                title.textEqual(@"(2003全国装逼指标)");
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
                
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
                
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
                
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
                
            }]);
        }])
        //option3
        .addOptions([PYOption initPYOptionWithBlock:^(PYOption *option) {
            option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
                title.textEqual(@"2004全国装逼指标");
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }]);
        }])
        //option4
        .addOptions([PYOption initPYOptionWithBlock:^(PYOption *option) {
            option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
                title.textEqual(@"2005全国装逼指标");
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }]);
        }])
        //option5
        .addOptions([PYOption initPYOptionWithBlock:^(PYOption *option) {
            option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
                title.textEqual(@"2006全国装逼指标");
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }]);
            
        }])
        //option6
        .addOptions([PYOption initPYOptionWithBlock:^(PYOption *option) {
            option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
                title.textEqual(@"2007全国装逼指标");
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }]);
        }])
        //option7
        .addOptions([PYOption initPYOptionWithBlock:^(PYOption *option) {
            option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
                title.textEqual(@"2008全国装逼指标");
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }]);
        }])
        //option8
        .addOptions([PYOption initPYOptionWithBlock:^(PYOption *option) {
            option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
                title.textEqual(@"2009全国装逼指标");
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }]);
        }])
        //option9
        .addOptions([PYOption initPYOptionWithBlock:^(PYOption *option) {
            option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
                title.textEqual(@"2010全国装逼指标");
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }]);
        }])
        //option10
        .addOptions([PYOption initPYOptionWithBlock:^(PYOption *option) {
            option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
                title.textEqual(@"2011全国装逼指标");
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }])
            .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
                series.typeEqual(PYSeriesTypeBar);
                NSMutableArray *datas = [NSMutableArray array];
                for (int i = 0; i < 7; i++) {
                    [datas addObject:@(arc4random()%(1000 + 1))];
                }
                series.addDataArr(datas);
            }]);
        }]);
    }];
}


/**
 力导向图
 
 @return option
 */
+ (PYOption *)forceGuideOption{
    NSString *legend1 = @"情人",*legend2 = @"小三";
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"").xEqual(@50).yEqual(@20);
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@"{a} : {b}");
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[legend1,legend2]);
        }])
//        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
//            grid.xEqual(@40).x2Equal(@50);
//        }])
        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
            toolbox.showEqual(YES)
            .xEqual(@100).yEqual(@30)
            .itemGapEqual(@20)
            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
                //                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
                //                    mark.showEqual(YES);
                //                }])
                //                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
                //                    dataView.showEqual(YES).readOnlyEqual(NO);
                //                }])
                feature.magicTypeEqual([PYToolboxFeatureMagicType initPYToolboxFeatureMagicTypeWithBlock:^(PYToolboxFeatureMagicType *magicType) {
                    magicType.showEqual(YES).typeEqual(@[PYSeriesTypeForce, PYSeriesTypeChord]);
                }]);
                feature.dataZoomEqual([PYToolboxFeatureDataZoom initPYToolboxFeatureDataZoomWithBlock:^(PYToolboxFeatureDataZoom *dataZoom) {
                    dataZoom.showEqual(NO);
                }]);
                //                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
                //                    restore.showEqual(YES);
                //                }]);
            }]);
        }])
//        .calculableEqual(YES)
//        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
//            axis.typeEqual(PYAxisTypeCategory)
//            .boundaryGapEqual(@NO).addDataArr(@[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"]);
//        }])
//        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
//            axis.typeEqual(PYAxisTypeValue);
//        }])
        .addSeries([PYForceSeries initPYForceSeriesWithBlock:^(PYForceSeries *series) {
            series.typeEqual(PYSeriesTypeForce)
            .nameEqual(@"人物关系");
            series.addCategoriesArr(@[[PYCategories initPYCategoriesWithBlock:^(PYCategories *categories) {
                categories.nameEqual(@"人物");//不设置 表示不能通过点击legend隐藏
                categories.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.colorEqual(PYRGBA(62, 140, 226, 1));//蓝色节点
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(YES)
                            .positionEqual(PYPositionCenter)
                            .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                                textStyle.colorEqual(PYRGBA(0, 0, 0, 1));
                            }]);
                        }]);
                    }]);
                }]);
                
            }],[PYCategories initPYCategoriesWithBlock:^(PYCategories *categories) {
                categories.nameEqual(legend1);//与legend对应
                categories.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.colorEqual(PYRGBA(219, 81, 73, 1));//红色节点
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(YES)
                            .positionEqual(PYPositionTop)
                            .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                                textStyle.colorEqual(PYRGBA(0, 0, 0, 1));
                            }]);
                        }]);
                    }]);
                }]);
            }],[PYCategories initPYCategoriesWithBlock:^(PYCategories *categories) {
                categories.nameEqual(legend2);//与legend对应
                categories.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.colorEqual(PYRGBA(35, 159, 96, 1));//绿色节点
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(YES)
                            .positionEqual(PYPositionTop)
                            .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                                textStyle.colorEqual(PYRGBA(0, 0, 0, 1));
                            }]);
                        }]);
                    }]);
                    
                }]);
            }]]);
            series.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES)
                        .positionEqual(PYPositionTop)
                        .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                            textStyle.colorEqual(PYRGBA(0, 0, 0, 1));//不起作用，在上面的PYCategories设置才起作用
                        }]);
                    }]);
                    itemStyleProp.nodeStyleEqual([PYNodeStyle initPYNodeStyleWithBlock:^(PYNodeStyle *nodeStyle) {
//                        nodeStyle.brushType
                    }]);
                    itemStyleProp.linkStyleEqual([PYLinkStyle initPYLinkStyleWithBlock:^(PYLinkStyle *linkStyle) {
                        linkStyle.typeEqual(PYLinkStyleTypeCurve);
                    }]);
                    
                }]);
//                .emphasisEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
//                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
//                        label.showEqual(YES);
//                    }]);
//                    itemStyleProp.nodeStyleEqual([PYNodeStyle initPYNodeStyleWithBlock:^(PYNodeStyle *nodeStyle) {
//                        //                        nodeStyle.brushType
//                    }]);
//                    itemStyleProp.linkStyleEqual([PYLinkStyle initPYLinkStyleWithBlock:^(PYLinkStyle *linkStyle) {
//                        linkStyle.typeEqual(PYLineStyleTypeCurve);
//                    }]);
//                }]);
            }]);
            series.draggableEqual(NO);
            series.useWorkerEqual(NO);
            series.minRadiusEqual(@15);
            series.maxRadiusEqual(@25);
            series.gravityEqual(@1.1);
            series.scalingEqual(@1.1);
//            series.roamEqual(PYForceSeriesRoamMove);
            //
            NSMutableArray *nodes = [NSMutableArray array];
            NSMutableArray *nodeLinks = [NSMutableArray array];
            for (int i = 0; i < 20; i++) {
                PYForceNodes *forceNodes = [PYForceNodes initPYForceNodesWithBlock:^(PYForceNodes *nodes) {
                    NSNumber *categoryValue = 0;
                    if (i == 0) {
                        categoryValue = @0;//人物
                    }else if (i > 0 && i < 5){
                        categoryValue = @1;//情人
                    }else if (i >= 5){
                        categoryValue = @2;//小三
                    }
                    nodes.categoryEqual(categoryValue)//与series的categorys对应
                    .nameEqual([NSString stringWithFormat:@"%ld 号",(long)i]);
                    nodes.draggableEqual(YES);//很重要，节点是否可以拖拽
                }];
                [nodes addObject:forceNodes];
                
                if (i > 0) {
                    PYLinks *links = [PYLinks initPYLinksWithBlock:^(PYLinks *links) {
                        NSString *target;
                        if (i > 0 && i < 6) {
                            target = @"0 号";
                            links.weightEqual(@10);//所有节点大小权重（比）
                        }else if (i >= 6 && i < 7){
                            target = @"2 号";
                            links.weightEqual(@8);
                        }else if (i >= 7 && i < 8){
                            target = @"6 号";
                            links.weightEqual(@6);
                        }else if (i >= 8 && i < 10){
                            target = @"5 号";
                            links.weightEqual(@4);
                        }else if (i >= 10 && i < 15){
                            target = @"4 号";
                            links.weightEqual(@2);
                        }else if (i >= 15 && i < 20){
                            target = @"9 号";
                            links.weightEqual(@1);
                        }
                        links.sourceEqual([NSString stringWithFormat:@"%ld 号",(long)i])//当前节点
                        .targetEqual(target);//当前节点的上一节点
                        
                    }];
                    [nodeLinks addObject:links];
                }
                
            }
            series.nodesEqual(nodes);
            
            series.linksEqual(nodeLinks);
            
        }]);
    
    }];
}

/**
 标准饼图
 
 @return option
 */
+ (PYOption *)standardPieOption{
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"某站点用户访问来源")
            .subtextEqual(@"纯属虚构")
            .xEqual(PYPositionCenter);
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@"{a} <br/>{b} : {c} ({d}%)");
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.orientEqual(PYOrientVertical)
            .xEqual(PYPositionLeft).yEqual(@50)
            .dataEqual(@[@"邮件营销",@"联盟广告",@"视频广告",@"直接访问",@"搜索引擎"]);
        }])
        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
            toolbox.showEqual(YES).yEqual(@50)
            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
//                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
//                    mark.showEqual(YES);
//                }])
//                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
//                    dataView.showEqual(YES).readOnlyEqual(NO);
//                }])
                feature.magicTypeEqual([PYToolboxFeatureMagicType initPYToolboxFeatureMagicTypeWithBlock:^(PYToolboxFeatureMagicType *magicType) {
                    magicType.showEqual(YES).typeEqual(@[PYSeriesTypePie, PYSeriesTypeFunnel]).optionEqual(@{@"funnel":@{@"x":@"25%",@"width":@"50%",@"funnelAlign":PYPositionLeft,@"max":@(1548)}});
                    
                }]);
//                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
//                    restore.showEqual(YES);
//                }]);
            }]);
        }])
        .addSeries([PYPieSeries initPYPieSeriesWithBlock:^(PYPieSeries *series) {
            series.radiusEqual(@"55%")
            .centerEqual(@[@"50%",@"60%"])
            .nameEqual(@"访问来源")
            .typeEqual(PYSeriesTypePie)
            .dataEqual(@[@{@"value":@(335),@"name":@"直接访问"},@{@"value":@(310),@"name":@"邮件营销"},@{@"value":@(234),@"name":@"联盟广告"},@{@"value":@(135),@"name":@"视频广告"},@{@"value":@(1548),@"name":@"搜索引擎"}]);
        }]);
    }];
}


/**
  嵌套饼图(饼图和环形图)
 
 @return option
 */
+ (PYOption *)nestedPieOption{
    
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@"{a} <br/>{b} : {c} ({d}%)");
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.orientEqual(PYOrientVertical)
            .xEqual(PYPositionLeft)
            .dataEqual(@[@"直达",@"营销广告",@"百度",@"谷歌",@"必应",/*@"其他",*/@"邮件营销",@"联盟广告",@"视频广告",/*@"直接访问",*/@"搜索引擎"]);
        }])
//        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
//            toolbox.showEqual(YES)
//            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
////                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
////                    mark.showEqual(YES);
////                }])
////                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
////                    dataView.showEqual(YES).readOnlyEqual(NO);
////                }])
//                feature.magicTypeEqual([PYToolboxFeatureMagicType initPYToolboxFeatureMagicTypeWithBlock:^(PYToolboxFeatureMagicType *magicType) {
//                    magicType.showEqual(YES).typeEqual(@[PYSeriesTypePie, PYSeriesTypeFunnel]);
//                    
//                }]);
////                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
////                    restore.showEqual(YES);
////                }]);
//            }]);
//        }])
        .calculableEqual(YES)
        .addSeries([PYPieSeries initPYPieSeriesWithBlock:^(PYPieSeries *series) {
            series.selectedModeEqual(@"single")
            .radiusEqual(@[@"0",@(30)])
            .nameEqual(@"访问来源")
            .typeEqual(PYSeriesTypePie)
            .dataEqual(@[@{@"value":@(335),@"name":@"直达"},@{@"value":@(679),@"name":@"营销广告"},@{@"value":@(1548),@"name":@"搜索引擎",@"selected":@"true"}])//@"selected":@"true" 默认选中设置
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp){
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.positionEqual(@"inner");
                    }])
                    .labelLineEqual([PYLabelLine initPYLabelLineWithBlock:^(PYLabelLine *labelLine) {
                        labelLine.showEqual(NO);
                    }]);
                }]);
            }]);
        }])
        .addSeries([PYPieSeries initPYPieSeriesWithBlock:^(PYPieSeries *series) {
            series.radiusEqual(@[@(50),@(100)])
            .nameEqual(@"访问来源")
            .typeEqual(PYSeriesTypePie)
            .dataEqual(@[@{@"value":@(335),@"name":@"直达"},@{@"value":@(310),@"name":@"邮件营销"},@{@"value":@(234),@"name":@"联盟广告"},@{@"value":@(135),@"name":@"视频广告"},@{@"value":@(1048),@"name":@"百度"},@{@"value":@(1048),@"name":@"谷歌"},@{@"value":@(1048),@"name":@"必应"},@{@"value":@(1048),@"name":@"其它"}]);
        }]);
    }];
    
}





@end



















