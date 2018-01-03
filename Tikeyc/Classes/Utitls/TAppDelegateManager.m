//
//  TAppDelegateManager.m
//  Tikeyc
//
//  Created by ways on 16/8/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TAppDelegateManager.h"

#import <UserNotifications/UserNotifications.h>

#import <PushKit/PushKit.h>

#import "TBaseNavigationViewController.h"

#import "TMainMenuViewController.h"

#import "TMainViewController.h"

#import "TLoginViewController.h"

#import "TLuanchViewController.h"

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

+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

+ (void)openBackgroudTask {
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
}

+ (void)setNSTimerExitApp{
    [self openBackgroudTask];
    
    __block NSInteger timerRecord = 0;
    __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        timerRecord++;
        NSLog(@"timerRecord:%ld",(long)timerRecord);
        if (timerRecord >= 60*5) {
            [timer invalidate];
            timer = nil;
            exit(1);
        }
    }];
    
    [TNotificationCenter addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [timer invalidate];
        timer  = nil;
    }];
}


/**
 解决iOS11上因安全区域导致的UITableView或UIScrollView偏移的问题
 */
+ (void)dealWithiOS11SafeAreaIssue{
    //解决iOS11，仅实现heightForHeaderInSection，没有实现viewForHeaderInSection方法时,section间距大的问题
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    
    //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    }
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
    if ([UIDevice systemVersion] >= 10.0) {
        
        UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"策略1行为1" options:UNNotificationActionOptionForeground];
        
        UNTextInputNotificationAction *action2 = [UNTextInputNotificationAction actionWithIdentifier:@"action2" title:@"策略1行为2" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"textInputButtonTitle" textInputPlaceholder:@"textInputPlaceholder"];
        
        
        /*UNNotificationCategory
         *UNNotificationCategoryOptionNone
         *UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
         *UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
         */
        UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"Category1" actions:@[action2,action1] intentIdentifiers:@[@"action1",@"action2"] options:UNNotificationCategoryOptionCustomDismissAction];
        
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"策略2行为1" options:UNNotificationActionOptionForeground];
        
        
        UNNotificationAction *action4 = [UNNotificationAction actionWithIdentifier:@"action4" title:@"策略2行为2" options:UNNotificationActionOptionForeground];
        
        
        UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"Category2" actions:@[action3,action4] intentIdentifiers:@[@"action3",@"action4"] options:UNNotificationCategoryOptionCustomDismissAction];
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category1,category2,  nil]];
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"completionHandler：iOS10方法成功注册远程推送功能");
            }else NSLog(@"%@",error.localizedDescription);
            
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        [UNUserNotificationCenter currentNotificationCenter].delegate = (id)TApplication.delegate;
        
    } else {/*iOS9-8实现方法*/
        
        /*iOS9实现方法*/
         UIMutableUserNotificationAction * action1 = [[UIMutableUserNotificationAction alloc] init];
         action1.identifier = @"action1";
         action1.title=@"策略1行为1";
         action1.activationMode = UIUserNotificationActivationModeForeground;
         action1.destructive = YES;
        /*iOS9实现方法*/
         UIMutableUserNotificationAction * action2 = [[UIMutableUserNotificationAction alloc] init];
         action2.identifier = @"action2";
         action2.title=@"策略1行为2";
         action2.activationMode = UIUserNotificationActivationModeBackground;
         action2.authenticationRequired = NO;
         action2.destructive = NO;
         action2.behavior = UIUserNotificationActionBehaviorTextInput;//点击按钮文字输入，是否弹出键盘
         ////
        UIMutableUserNotificationCategory * category1 = [[UIMutableUserNotificationCategory alloc] init];
        category1.identifier = @"Category1";
        [category1 setActions:@[action2,action1] forContext:(UIUserNotificationActionContextDefault)];
        ////、、、
        UIMutableUserNotificationAction * action3 = [[UIMutableUserNotificationAction alloc] init];
        action3.identifier = @"action3";
        action3.title=@"策略2行为1";
        action3.activationMode = UIUserNotificationActivationModeForeground;
        action3.destructive = YES;
        ////
        UIMutableUserNotificationAction * action4 = [[UIMutableUserNotificationAction alloc] init];
        action4.identifier = @"action4";
        action4.title=@"策略2行为2";
        action4.activationMode = UIUserNotificationActivationModeBackground;
        action4.authenticationRequired = NO;
        action4.destructive = NO;
        ////
        UIMutableUserNotificationCategory * category2 = [[UIMutableUserNotificationCategory alloc] init];
        category2.identifier = @"Category2";
        [category2 setActions:@[action4,action3] forContext:(UIUserNotificationActionContextDefault)];
        /*iOS9-8实现方法*/
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects: category1,category2, nil]];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }

}

+ (void)registeLocalNotification{
    
    if ([UIDevice systemVersion] >= 10.0) {
        // 1.创建通知内容
        UNMutableNotificationContent *content1 = [[UNMutableNotificationContent alloc] init];
        content1.title = @"本地推送测试";
        content1.subtitle = @"本地推送测试";
        content1.body = @"come from tikeyc";
        content1.badge = @1;
        // 2.设置通知附件内容
        NSError *error = nil;
        //    NSString *path = [[NSBundle mainBundle] pathForResource:@"live_icon" ofType:@"jpg"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"giveyour" ofType:@"mp3"];
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
        
    } else {//iOS9-8本地文字推送
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        // 设置触发通知的时间
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:[NSDate date].timeIntervalSinceNow];
        NSLog(@"fireDate=%@",fireDate);
        
        notification.fireDate = fireDate;
        // 时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复的间隔
        notification.repeatInterval = kCFCalendarUnitSecond;
        
        // 通知内容
        notification.alertBody =  @"该起床了...";
        notification.applicationIconBadgeNumber = 1;
        // 通知被触发时播放的声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 通知参数
        NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
        notification.userInfo = userDict;
        
        // ios8后，需要添加这个注册，才能得到授权
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            // 通知重复提示的单位，可以是天、周、月
            notification.repeatInterval = 0;//NSCalendarUnitDay; 0 means don't repeat
        } else {
            // 通知重复提示的单位，可以是天、周、月
            notification.repeatInterval = 0;//NSDayCalendarUnit; 0 means don't repeat
        }
        
        // 执行通知注册
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
    }
    
}

/**
 取消某个本地推送通知

 @param key key description
 */
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}

+ (void)registeLocalNotificationWithGif{
    if ([UIDevice systemVersion] >= 10.0) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://ww3.sinaimg.cn/large/006y8lVagw1faknzht671g30b408c1l2.gif"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                //缓存到tmp文件夹
                NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/%@att.%@",@([NSDate date].timeIntervalSince1970),@"gif"]];
                NSError *err = nil;
                [data writeToFile:path atomically:YES];
                UNNotificationAttachment *gif_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment" URL:[NSURL fileURLWithPath:path] options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:[NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)]} error:&err];
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.title = @"\"Fly to the moon\"";
                content.subtitle = @"by Neo";
                content.body = @"the wonderful song with you~";
                content.badge = @0;
                NSError *error = nil;
                if (gif_attachment) {
                    content.attachments = @[gif_attachment];
                }
                if (error) {
                    NSLog(@"%@", error);
                }
                //设置为@""以后，进入app将没有启动页
                content.launchImageName = @"";
                UNNotificationSound *sound = [UNNotificationSound defaultSound];
                content.sound = sound;
                UNTimeIntervalNotificationTrigger *time_trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
                NSString *requestIdentifer = @"time interval request";
                content.categoryIdentifier = @"seeCategory1";
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:time_trigger];
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    NSLog(@"%@",error);
                }];
            }
        }];
        [task resume];
        
    } else {//iOS9-8无Gif推送功能
        
    }
    
}

+ (void)registerVoipNotifications {
    
    PKPushRegistry * voipRegistry = [[PKPushRegistry alloc]initWithQueue:dispatch_get_main_queue()];
    
    voipRegistry.delegate = (id)TApplication.delegate;
    voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    UIUserNotificationType types = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    
    UIUserNotificationSettings * notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication]registerUserNotificationSettings:notificationSettings];
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

/**
 添加应用图标的3DTouch功能
 */
+ (void)add3DTouchShortcutItems {
    // 创建标签的ICON图标。
    //UIApplicationShortcutIcon *shortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutIcon *shortcutIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"main_top_title"];
    // 创建一个标签，并配置相关属性。
    NSString *shortcutItemType = @"我们可以监听该项的值来判断用户是从哪一个标签进入App的，该字段的值可以为空";
    UIApplicationShortcutItem *shortcutItem = [[UIApplicationShortcutItem alloc] initWithType:shortcutItemType localizedTitle:@"动态代码添加" localizedSubtitle:@"subTitle" icon:shortcutIcon userInfo:nil];
    // 将标签添加进Application的shortcutItems中。
    [UIApplication sharedApplication].shortcutItems = @[shortcutItem];
}

////////////////////////////////////////Extension////////////////////////////////////////
////////////////////////////////////////Extension////////////////////////////////////////


+ (void)gotoLuanchController{
    TLuanchViewController *luanch = [[TLuanchViewController alloc] init];
    TApplication.delegate.window.rootViewController = luanch;
}

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












