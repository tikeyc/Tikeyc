//
//  TAlertView.h
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 按钮点击触发的回调 */
typedef void(^TAlertViewBlock)(NSInteger buttonIndex);

@interface TAlertView : UIView

/**
 *  总方法
 */
//+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles andAction:(TAlertViewBlock) block andParentView:(UIView *)view;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                 type:(UIAlertControllerStyle)alertControllerStyle
            andAction:(TAlertViewBlock) block
        andParentView:(UIView *)view;

@end
