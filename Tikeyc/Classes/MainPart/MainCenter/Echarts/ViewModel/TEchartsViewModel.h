//
//  TEchartsViewModel.h
//  Tikeyc
//
//  Created by ways on 2016/10/19.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TBaseViewModel.h"

#import "iOS-Echarts.h"

@interface TEchartsViewModel : TBaseViewModel


/**
 line bar 混合，addSuview在了ScrollView上，可以滑动
 
 @param result 数据
 
 @return option
 */
- (PYOption *)lineAndBarOption:(NSArray *)result;

/**
 line 叠加柱状图 混合
 
 @param result 数据
 
 @return option
 */
- (PYOption *)lineAndStackedBarOption:(NSArray *)result;

/**
 标准面积图
 
 @return option
 */
+ (PYOption *)basicAreaOption;

/**
 堆积面积图
 
 @return option
 */
+ (PYOption *)stackedAreaOption;

/**
 不等距折线图(下边有时间区域选择)
 
 @return option
 */
+ (PYOption *)irregularLine2Option;

/**
 柱状图(下边有时间轴选择)
 
 @return option
 */
+ (PYOption *)timeLineOption;


/**
 力导向图
 
 @return option
 */
+ (PYOption *)forceGuideOption;


/**
 标准饼图
 
 @return option
 */
+ (PYOption *)standardPieOption;


/**
 嵌套饼图(饼图和环形图)
 
 @return option
 */
+ (PYOption *)nestedPieOption;




@end













