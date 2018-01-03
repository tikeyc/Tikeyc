//
//  TAppDelegateManager.h
//  Tikeyc
//
//  Created by ways on 16/8/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAppDelegateManager : NSObject

////////////////////////////////////////commen

/**解决iOS 8之后 横屏默认隐藏状态栏的问题，必须在didFinishLaunchingWithOptions中调用一次，一般第一次设置为NO
 *设置后通过此方法设置状态栏是否隐藏
 先在info.plist中add Row: Supported interface orientations
 *
 
 @param isHidden isHidden
 */
+ (void)setStatusBarHidden:(BOOL)isHidden;

+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 开启后台任务
 */
+ (void)openBackgroudTask;

/**
 进入后台后定时关闭APP，一般用于安全或隐私较高的APP
 */
+ (void)setNSTimerExitApp;


/**
 解决iOS11上因安全区域导致的UITableView或UIScrollView偏移的问题
 */
+ (void)dealWithiOS11SafeAreaIssue;

/**
 *远程推送的格式:这里我们要注意一定要有"mutable-content": "1",以及一定要有Alert的字段，否则可能会拦截通知失败。（苹果文档说的）
 *除此之外，我们还可以添加自定义字段，比如，图片地址，图片类型
 {
 "aps": {
 "alert": "This is some fancy message.",
 "badge": 1,
 "sound": "default",
 "mutable-content": "1",//
 "imageAbsoluteString": "http://xxx.jpg(png)",
 "category":"Category1",//与UNNotificationCategory创建的对象保持一致，否则无法显示该组策略按钮
 "fileMediaType":"png"//附件类型，便于做不同的界面及操作处理
 }
 }
 */
+ (void)registeRemoteNotification;

+ (void)registeLocalNotification;

+ (void)cancelLocalNotificationWithKey:(NSString *)key;

+ (void)registeLocalNotificationWithGif;

+ (void)registerVoipNotifications;

+ (NSString *)logDic:(NSDictionary *)dic;

/**
 添加应用图标的3DTouch功能
 */
+ (void)add3DTouchShortcutItems;

////////////////////////////////////////Extension

+ (void)gotoLuanchController;

+ (void)gotoLoginController;

+ (void)gotoMainController;

@end
