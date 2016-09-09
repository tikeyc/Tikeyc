//
//  TAlertView.h
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline BOOL versionBigger9()
{
    float sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (sysVersion >= 9.0) {
        return YES;
    } else {
        return NO;
    }
}

/** 按钮点击触发的回调 */
typedef void(^TAlertViewBlock)(NSInteger buttonIndex);

@interface TAlertView : UIView

/**
 *  总方法
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                 type:(UIAlertControllerStyle)alertControllerStyle
        andParentView:(UIView *)view
            andAction:(TAlertViewBlock) block;

@end
