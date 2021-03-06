//
//  CommenHeader.h
//  TSMWSChart
//
//  Created by ways on 16/5/27.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#ifndef CommenDefine_h
#define CommenDefine_h

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DeBugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog(...) NSLog(__VA_ARGS__);//printf([[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#define MyNSLog(FORMAT, ...) fprintf(stderr,"[%s]:[line %d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(...)
#define DeBugLog(...)
#define NSLog(...)
#define MyNSLog(FORMAT, ...) nil
#endif


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** RGB颜色 */
#define TColor_RGB(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
#define TColor_RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define TColor_RGBA_256(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0]
/** 随机色 */
#define TRandomColor_RGB TColor_RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define TRandomColor_RGBA TColor_RGBA_256(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

/** 字体 */

#define TSystemFontSize(size) [UIFont systemFontOfSize:size]

/** 弧度制转为角度制 */
#define TAngle2Radian(angle) ((angle) / 180.0 * M_PI)

/** 屏幕 */
#define TScreen [UIScreen mainScreen]
/** 屏幕宽度 */
#define TScreenWidth [UIScreen mainScreen].bounds.size.width
/** 屏幕高度 */
#define TScreenHeight [UIScreen mainScreen].bounds.size.height
/** 屏幕bounds */
#define TScreenBounds [UIScreen mainScreen].bounds
/** 屏幕伸缩度（Retina时值为2,非Retina值为1）*/
#define TScreenScale [UIScreen mainScreen].scale
/*
Item            Normal Height    iPhone X Height
UINavigationBar      64         88 (96 large title)
UIStatusBar          20                 44
UITabBar             49                 83
 */
/** 系统状态栏高度: iPhone X的高度是44，其他情况是20*/
#define kAppStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
/** 系统导航栏高度 */
#define kAppNavigationBarHeight 44
/** iPhone X Height: 88 = 44 + 44; [large title: 96 = 44 + (44 + 8); ]*/
#define kAppNavigationBarLargeTitleHeight 44 + 8
/** 系统tabbar高度 */
#define kAppTabBarHeight 49

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define TApplication [UIApplication sharedApplication]
#define TApplicationDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)
#define TFileManager [NSFileManager defaultManager]
#define TDevice [UIDevice currentDevice]

#define TStoryboardWithName(storyboardName) [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]]

////////////////////////////////////////////////////////////////////////////////////////////////////
//#define WEAKSELF __weak typeof(self) weakSelf = self;
#define TWeakSelf(type)  __weak typeof(type) weak##type = type;//#的意思是紧跟着它的后面的标识符添加一个双引号""

#endif /* CommenDefine_h */














