//
//  TBaseViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/15.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TBaseViewController.h"

@interface TBaseViewController ()






@end

@implementation TBaseViewController

- (void)dealloc
{
    [SVProgressHUD dismiss];
    [TNotificationCenter removeObserver:self];
    [self removeObserverBlocks];
    NSLog(@"%@ 成功销毁了，无内存泄漏",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.customSupportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;//默认只能竖屏
    
    if (self.presentingViewController) {
        [self initPresentBackButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 实现了3DTocuh的控制器，预览效果时上滑出现的按钮列表

 @return 按钮列表
 */
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你点了-删除" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"置顶" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你点了-置顶" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"啥也不干" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"真的啥也不干？" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
    NSArray *actions = @[action1,action2,action3];
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return actions;
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}

//是否旋转
-(BOOL)shouldAutorotate{
    return YES;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.customSupportedInterfaceOrientations;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    [self initPresentBackButton];
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}


- (void)initPresentBackButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"common_back_barItem_button"] forState:UIControlStateNormal];
    //            @weakify(self);
    TWeakSelf(self)
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //                @strongify(self);
        [weakself dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self.view endEditing:YES];
}

@end
