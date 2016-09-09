//
//  UIView+ViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)


- (UIViewController *)viewController{
    
    for (id next = self; next; next = [next nextResponder]) {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}


@end
