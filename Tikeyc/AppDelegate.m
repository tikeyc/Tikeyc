//
//  AppDelegate.m
//  Tikeyc
//
//  Created by ways on 16/8/15.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "AppDelegate.h"

#import "TBaseNavigationViewController.h"

#import "TMainMenuViewController.h"
#import "TMenuCenterViewController.h"
#import "TMenuLeftTableViewController.h"
#import "TMenuRightTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIStoryboard *centerStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TMenuCenterViewController *center = [centerStoryboard instantiateInitialViewController];
    UIStoryboard *leftStoryboard = [UIStoryboard storyboardWithName:@"LeftView" bundle:[NSBundle mainBundle]];
    TMenuLeftTableViewController *left = [leftStoryboard instantiateInitialViewController];
    UIStoryboard *rightStoryboard = [UIStoryboard storyboardWithName:@"RightView" bundle:[NSBundle mainBundle]];
    TMenuRightTableViewController *right = [rightStoryboard instantiateInitialViewController];
    
    TMainMenuViewController *mainMenu = [[TMainMenuViewController alloc] initMainMenuWithCenterViewController:center
                                                                                           leftViewController:left
                                                                                          rightViewController:right];
    mainMenu.showLeftBarButtonItem = YES;
    mainMenu.showRighBarButtonItem = YES;
    self.window.rootViewController = [[TBaseNavigationViewController alloc] initWithRootViewController:mainMenu];
    
    
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
    [self networkMonitoring];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - 网络监测
- (void)networkMonitoring
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI状态");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [TAlertView showWithTitle:@"提示" message:@"正在使用移动数据流量" cancelButtonTitle:@"知道了" otherButtonTitles:nil andAction:^(NSInteger buttonIndex) {
                    NSLog(@"%ld",(long)buttonIndex);
                } andParentView:self.window];
                
                YYReachability *reach = [YYReachability reachability];
                YYReachabilityWWANStatus wwanStatus = reach.wwanStatus;
                switch (wwanStatus) {
                    case YYReachabilityWWANStatusNone:
                    {
                        NSLog(@"蜂窝网络");
                        break;
                    }
                    case YYReachabilityWWANStatus2G:
                    {
                        NSLog(@"2G");
                        break;
                    }
                    case YYReachabilityWWANStatus3G:
                    {
                        NSLog(@"3G");
                        break;
                    }
                    case YYReachabilityWWANStatus4G:
                    {
                        NSLog(@"4G");
                        break;
                    }
                    default:
                        break;
                }
                
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
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

@end










