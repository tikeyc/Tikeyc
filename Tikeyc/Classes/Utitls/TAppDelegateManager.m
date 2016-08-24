//
//  TAppDelegateManager.m
//  Tikeyc
//
//  Created by ways on 16/8/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TAppDelegateManager.h"

#import "TBaseNavigationViewController.h"

#import "TMainMenuViewController.h"

#import "TMainViewController.h"

@implementation TAppDelegateManager


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
}

@end
