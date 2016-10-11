//
//  AppDelegate.m
//  Tikeyc
//
//  Created by ways on 16/8/15.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    if (self.deviceInterfaceOrientationMask != UIInterfaceOrientationMaskLandscape) {
        self.deviceInterfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    }
    return self.deviceInterfaceOrientationMask;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.deviceInterfaceOrientationMask = UIInterfaceOrientationMaskPortrait;

    /*当然只会在需求：self.window第一次 不想 加载Main storyboard file base name的情况
     *不知道大家有没有范这么一个错误：在info.plist中Main storyboard file base name设置了storyboard，同时在AppDelegate self.window设置了rootViewController的情况
     *该情况就多余了，不必要的创建了storyboard。会出现这种情况-->创建Main storyboard file base name指定的storyboard，然后创建代码制定的rootViewController,销毁storyboard；
     *
     *根据不同需求这里我已经取消了info.plist中的Main storyboard file base name
     */
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [TAppDelegateManager gotoLoginController];
    
    [TAppDelegateManager registerNotification];
    
    /* APP未启动，点击推送消息的情况下 iOS10遗弃UIApplicationLaunchOptionsLocalNotificationKey，使用代理UNUserNotificationCenterDelegate方法didReceiveNotificationResponse:withCompletionHandler:获取本地推送
     */
    //    NSDictionary *localUserInfo = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    //    if (localUserInfo) {
    //        NSLog(@"localUserInfo:%@",localUserInfo);
    //        //APP未启动，点击推送消息
    //    }
    NSDictionary *remoteUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteUserInfo) {
        NSLog(@"remoteUserInfo:%@",remoteUserInfo);
        //APP未启动，点击推送消息，iOS10下还是跟以前一样在此获取
        [self application:application didReceiveRemoteNotification:remoteUserInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
            
        }];
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 网络监测
    [TServiceTool networkMonitoring];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Life Cycle
- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [TNotificationCenter removeObserver:self];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Tikeyc"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



#pragma mark - UIApplicationDelegate

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Regist fail%@",error);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"Device Token: %@", deviceTokenStr);
    //c9ff73c9fbbc2317db42f1cabe7322328cf36320adaf8072aaf72460a437ab78
    
    [TUserDefaults setObject:deviceTokenStr forKey:T_Device_Token];
}

//远程推送APP在前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    
    //    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"name"];
    NSString *messageStr = [NSString stringWithFormat:@"%@", userInfo];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    //
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge -= [userInfo[@"aps"][@"badge"] integerValue];
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"willPresentNotification:%@",notification.request.content.title);
    
    // 获取通知所带的数据
    //    NSString *notMess = [notification.request.content.userInfo objectForKey:@"aps"];
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
    //    NSString *notMess = [response.notification.request.content.userInfo objectForKey:@"aps"];
    NSLog(@"didReceiveNotificationResponse:%@",response.notification.request.content.title);
    //    response.notification.request.identifier
}




@end










