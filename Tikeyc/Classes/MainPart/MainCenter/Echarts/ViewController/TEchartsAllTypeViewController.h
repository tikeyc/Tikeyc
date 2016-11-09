//
//  TEchartsAllTypeViewController.h
//  Tikeyc
//
//  Created by ways on 2016/10/19.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TBaseViewController.h"

extern NSString *const basicAreaOption;
extern NSString *const stackedAreaOption;
extern NSString *const irregularLine2Option;

extern NSString *const timeLineOption;
extern NSString *const forceGuideOption;

extern NSString *const standardPieOption;
extern NSString *const nestedPieOption;

extern NSString *const basicChinaMapOption;
extern NSString *const basicChinaMapCityOption;
extern NSString *const basicWorldMapOption;
extern NSString *const showMapMarkLine;

@interface TEchartsAllTypeViewController : TBaseViewController


@property (nonatomic,assign)BOOL shouldNotLandscapeDevice;

//地图模式下
@property (nonatomic,copy)NSString *selectedPrivinceName;
@property (nonatomic,copy)NSString *selectedCityName;

@end
