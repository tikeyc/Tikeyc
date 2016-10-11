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


+ (void)registerNotification{
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
    
    UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action2,action1] intentIdentifiers:@[@"action1",@"action2"] options:UNNotificationCategoryOptionCustomDismissAction];
    //        UIMutableUserNotificationCategory * category1 = [[UIMutableUserNotificationCategory alloc] init];
    //        category1.identifier = @"Category1";
    //        [category1 setActions:@[action2,action1] forContext:(UIUserNotificationActionContextDefault)];
    
    
    
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
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category1,category2,  nil]];
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"completionHandler：iOS10方法成功注册推送功能");
    }];
    /*iOS9实现方法
     UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects: category1,category2, nil]];
     
     [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
     */
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    [UNUserNotificationCenter currentNotificationCenter].delegate = (id)TApplication.delegate;
}



@end












