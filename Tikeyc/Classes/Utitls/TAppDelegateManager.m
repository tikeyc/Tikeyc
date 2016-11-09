//
//  TAppDelegateManager.m
//  Tikeyc
//
//  Created by ways on 16/8/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TAppDelegateManager.h"

#import <UserNotifications/UserNotifications.h>

#import "TBaseNavigationViewController.h"

#import "TMainMenuViewController.h"

#import "TMainViewController.h"

#import "TLoginViewController.h"


@interface TAppDelegateManager ()

@end

@implementation TAppDelegateManager

////////////////////////////////////////commen////////////////////////////////////////
////////////////////////////////////////commen////////////////////////////////////////


/**解决iOS 8之后 横屏默认隐藏状态栏的问题，设置后通过此方法设置状态栏是否隐藏
 先在info.plist中add Row: Supported interface orientations
 *
 
 @param isHidden isHidden
 */
+ (void)setStatusBarHidden:(BOOL)isHidden{
//    Supported interface orientations
    
    [TApplication setStatusBarHidden:!isHidden withAnimation:UIStatusBarAnimationNone];
    [TApplication setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationNone];
    
}

+ (void)setNSTimerExitApp{
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    __block NSInteger timerRecord = 0;
    __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        timerRecord++;
        NSLog(@"timerRecord:%ld",(long)timerRecord);
        if (timerRecord >= 60*5) {
            [timer invalidate];
            exit(1);
        }
    }];
    
    [TNotificationCenter addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [timer invalidate];
        timer  = nil;
    }];
}



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
         "category":"Category1"//与UNNotificationCategory创建的对象保持一致，否则无法显示改组策略按钮
 
         }
 }
 */
+ (void)registeRemoteNotification{
    
    /*
     identifier：行为标识符，用于调用代理方法时识别是哪种行为。
     title：行为名称。
     UIUserNotificationActivationMode：即行为是否打开APP。
     authenticationRequired：是否需要解锁。
     destructive：这个决定按钮显示颜色，YES的话按钮会是红色。
     behavior：点击按钮文字输入，是否弹出键盘
     */
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"策略1行为1" options:UNNotificationActionOptionForeground];
    /*iOS9实现方法
     UIMutableUserNotificationAction * action1 = [[UIMutableUserNotificationAction alloc] init];
     action1.identifier = @"action1";
     action1.title=@"策略1行为1";
     action1.activationMode = UIUserNotificationActivationModeForeground;
     action1.destructive = YES;
     */
    
    UNTextInputNotificationAction *action2 = [UNTextInputNotificationAction actionWithIdentifier:@"action2" title:@"策略1行为2" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"textInputButtonTitle" textInputPlaceholder:@"textInputPlaceholder"];
    /*iOS9实现方法
     UIMutableUserNotificationAction * action2 = [[UIMutableUserNotificationAction alloc] init];
     action2.identifier = @"action2";
     action2.title=@"策略1行为2";
     action2.activationMode = UIUserNotificationActivationModeBackground;
     action2.authenticationRequired = NO;
     action2.destructive = NO;
     action2.behavior = UIUserNotificationActionBehaviorTextInput;//点击按钮文字输入，是否弹出键盘
     */
    
    /*UNNotificationCategory
     *UNNotificationCategoryOptionNone
     *UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
     *UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
     */
    UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"Category1" actions:@[action2,action1] intentIdentifiers:@[@"action1",@"action2"] options:UNNotificationCategoryOptionCustomDismissAction];
    //        UIMutableUserNotificationCategory * category1 = [[UIMutableUserNotificationCategory alloc] init];
    //        category1.identifier = @"Category1";
    //        [category1 setActions:@[action2,action1] forContext:(UIUserNotificationActionContextDefault)];
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"策略2行为1" options:UNNotificationActionOptionForeground];
    //        UIMutableUserNotificationAction * action3 = [[UIMutableUserNotificationAction alloc] init];
    //        action3.identifier = @"action3";
    //        action3.title=@"策略2行为1";
    //        action3.activationMode = UIUserNotificationActivationModeForeground;
    //        action3.destructive = YES;
    
    UNNotificationAction *action4 = [UNNotificationAction actionWithIdentifier:@"action4" title:@"策略2行为2" options:UNNotificationActionOptionForeground];
    //        UIMutableUserNotificationAction * action4 = [[UIMutableUserNotificationAction alloc] init];
    //        action4.identifier = @"action4";
    //        action4.title=@"策略2行为2";
    //        action4.activationMode = UIUserNotificationActivationModeBackground;
    //        action4.authenticationRequired = NO;
    //        action4.destructive = NO;
    
    UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"Category2" actions:@[action3,action4] intentIdentifiers:@[@"action3",@"action4"] options:UNNotificationCategoryOptionCustomDismissAction];
    //        UIMutableUserNotificationCategory * category2 = [[UIMutableUserNotificationCategory alloc] init];
    //        category2.identifier = @"Category2";
    //        [category2 setActions:@[action4,action3] forContext:(UIUserNotificationActionContextDefault)];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category1,category2,  nil]];
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"completionHandler：iOS10方法成功注册远程推送功能");
        }else NSLog(@"%@",error.localizedDescription);
        
    }];
    /*iOS9实现方法
     UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects: category1,category2, nil]];
     
     [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
     */
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = (id)TApplication.delegate;
}

+ (void)registeLocalNotification{
    // 1.创建通知内容
    UNMutableNotificationContent *content1 = [[UNMutableNotificationContent alloc] init];
    content1.title = @"本地推送测试";
    content1.subtitle = @"本地推送测试";
    content1.body = @"come from tikeyc";
    content1.badge = @1;
    // 2.设置通知附件内容
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"live_icon" ofType:@"jpg"];
    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error) {
        NSLog(@"attachment error %@", error);
    }
    content1.attachments = @[att];
    content1.launchImageName = @"live_icon";//下拉通知栏放大content.launchImageName
    // 3.设置声音
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content1.sound = sound;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////触发模式
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // 4.触发模式
    /*触发模式1*/
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    
    /*触发模式2*/
    UNTimeIntervalNotificationTrigger *trigger2 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    /*触发模式3*/
    // 周一早上 8：00 上班
    NSDateComponents *components = [[NSDateComponents alloc] init];
    // 注意，weekday是从周日开始的，如果想设置为从周一开始，大家可以自己想想~
    components.weekday = 2;
    components.hour = 8;
    UNCalendarNotificationTrigger *trigger3 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    
    /*触发模式4 这个方法一般要先#import<CoreLocation/CoreLocation.h>*/
    
    /*这个触发条件一般在
     //1、如果用户进入或者走出某个区域会调用下面两个方法
     - (void)locationManager:(CLLocationManager *)manager
     didEnterRegion:(CLRegion *)region
     - (void)locationManager:(CLLocationManager *)manager
     didExitRegion:(CLRegion *)region代理方法反馈相关信息
     */
    
    CLRegion *region = [[CLRegion alloc] init];
    CLCircularRegion *circlarRegin = [[CLCircularRegion alloc] init];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////触发模式
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*一定要为它设置identifier, 在后面的查找，更新， 删除通知，这个标识是可以用来区分这个通知与其他通知
     把request加到UNUserNotificationCenter， 并设置触发器，等待触发
     如果另一个request具有和之前request相同的标识，不同的内容， 可以达到更新通知的目的
     */
    NSString *identifier1 = @"identifier1";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier1 content:content1 trigger:trigger1];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"completionHandler：iOS10方法成功注册本地推送功能");
        }else NSLog(@"%@",error.localizedDescription);
    }];
}

+ (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


////////////////////////////////////////Extension////////////////////////////////////////
////////////////////////////////////////Extension////////////////////////////////////////

+ (void)gotoLoginController{
    TLoginViewController *login = [[TLoginViewController alloc] init];
    TApplication.delegate.window.rootViewController = login;
}


+ (void)gotoMainController{
    UIStoryboard *centerStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TMainViewController *center = [centerStoryboard instantiateInitialViewController];
    TBaseNavigationViewController *centerNav = [[TBaseNavigationViewController alloc] initWithRootViewController:center];
    
    UIStoryboard *leftStoryboard = [UIStoryboard storyboardWithName:@"LeftView" bundle:[NSBundle mainBundle]];
    UIViewController *left = [leftStoryboard instantiateInitialViewController];
    
    UIStoryboard *rightStoryboard = [UIStoryboard storyboardWithName:@"RightView" bundle:[NSBundle mainBundle]];
    UIViewController *right = [rightStoryboard instantiateInitialViewController];
    
    TMainMenuViewController *mainMenu = [[TMainMenuViewController alloc] initMainMenuWithCenterViewController:centerNav
                                                                                           leftViewController:left
                                                                                          rightViewController:right];
    mainMenu.showLeftBarButtonItem = YES;
    mainMenu.showRighBarButtonItem = YES;
    TApplication.delegate.window.rootViewController = mainMenu;//[[TBaseNavigationViewController alloc] initWithRootViewController:mainMenu]
    
    //animation
    TApplication.delegate.window.transform = CGAffineTransformScale(TApplication.delegate.window.transform, 0.3, 0.3);
    [UIView animateWithDuration:0.5 animations:^{
        TApplication.delegate.window.transform = CGAffineTransformIdentity;
    }];
    [UIView transitionWithView:TApplication.delegate.window duration:0.05 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
    } completion:^(BOOL finished) {
        [UIView transitionWithView:TApplication.delegate.window duration:0.15 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
        } completion:^(BOOL finished) {
            [UIView transitionWithView:TApplication.delegate.window duration:0.2 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
    
}




@end












