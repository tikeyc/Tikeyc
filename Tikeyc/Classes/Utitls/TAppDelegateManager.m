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

#import "TLoginViewController.h"

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

@end
