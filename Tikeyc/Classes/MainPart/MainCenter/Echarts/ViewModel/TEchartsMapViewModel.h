//
//  TEchartsMapViewModel.h
//  Tikeyc
//
//  Created by ways on 2016/11/3.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TBaseViewModel.h"

#import "iOS-Echarts.h"

@interface TEchartsMapViewModel : TBaseViewModel

/**
 中国基础地图
 
 @return option
 */
+ (PYOption *)basicChinaMapOption;

/**
 中国基础地图(城市)
 
 @return option
 */
+ (PYOption *)basicChinaMapCityOptionWithPrivinceName:(NSString *)selectedProvince selectedCityName:(NSString *)selectedCityName;

/**
 中国基础地图某一个省份 的Series
 
 @return Series
 */
+ (PYSeries *)basicChinaPrivinceMapSeriesWithPrivinceName:(NSString *)selectedProvince;

/**
 中国基础地图某一个城市 的Series
 
 @return Series
 */
+ (PYSeries *)basicChinaPrivinceMapSeriesWithPrivinceName:(NSString *)selectedProvince selectedCityName:(NSString *)selectedCityName;


/**
 世界基础地图
 
 @return option
 */
+ (PYOption *)basicWorldMapOption;


/**
 地图标线(模拟迁徙)
 
 @return option
 */
+ (PYOption *)showMapMarkLine;

@end
