//
//  TAlertView.m
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TAlertView.h"

@interface UIView (TSearchVcExtend)

- (UIViewController *)viewController;

@end

@implementation UIView (TSearchVcExtend)

- (UIViewController*)viewController {
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end


@interface TAlertView () <UIAlertViewDelegate>

/** 按钮点击触发的回调 */
@property (nonatomic, copy) TAlertViewBlock block;

@end

@implementation TAlertView

#pragma mark - Life Cycle -
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.1];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.frame = newSuperview.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 公有方法 -

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                 type:(UIAlertControllerStyle)alertControllerStyle//UIAlertControllerStyleAlert UIAlertControllerStyleActionSheet
        andParentView:(UIView *)view
            andAction:(TAlertViewBlock) block
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertControllerStyle];
    __block TAlertView *alert = [[TAlertView alloc] init];
    alert.block = block;
    
    if (cancelButtonTitle) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            if (alert.block) {
                alert.block(0);
            }
            
        }];
        [alertVc addAction:action];
    }
    
    for (int i=0; i < otherButtonTitles.count; i++) {
        NSString *otherTitle = otherButtonTitles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            if (cancelButtonTitle) {
                if (alert.block) {
                    alert.block(i+1);
                }
            } else {
                if (alert.block) {
                    alert.block(i);
                }
            }
        }];
        [alertVc addAction:action];
    }
    
    if (view == nil) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window.rootViewController presentViewController:alertVc animated:YES completion:nil];
    } else {
        [[view viewController] presentViewController:alertVc animated:YES completion:nil];
    }
}


@end
