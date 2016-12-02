//
//  TMainViewModel.m
//  Tikeyc
//
//  Created by ways on 16/9/6.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainViewModel.h"

#import "TMainViewController.h"

@interface TMainViewModel ()

//weak避免循环引用,导致无法释放的问题，因为在TMainMenuViewController.view调用了addSubview:TMainViewController.view
@property (nonatomic,weak)TMainViewController *mainViewController;

@end

@implementation TMainViewModel

- (void)dealloc
{
#warning 存在内存无法释放的问题，待研究RACObserve(scrollView, contentOffset) 已使用系统方法实现
    for (UIScrollView *scrollView in _scrollViewArrays) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            [scrollView removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
    NSLog(@"TMainViewModel dealloc");
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

#pragma mark - set



#pragma mark - init RACSignal



#pragma mark -

- (void)creatTopCenterBottomViewControllerToAddViewController:(TMainViewController *)mainViewController{
    self.mainViewController = mainViewController;
    if (mainViewController.childViewControllers.count < 2 || mainViewController.childViewControllers.count > 3) {
        [TAlertView showWithTitle:@"提示" message:@"超出设置，请设置至少2个最多3个控制器，上中下,上中" cancelButtonTitle:@"确定" otherButtonTitles:nil type:UIAlertControllerStyleAlert andParentView:nil andAction:^(NSInteger buttonIndex) {
        }];
        return;
    }
    
    _scrollViewArrays = [NSMutableArray array];
    for (int i = 0; i < mainViewController.childViewControllers.count; i++) {
        //        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.height*(i-1), self.view.width, self.view.height)];

        UIScrollView *scrollView;
        UIViewController *vc = mainViewController.childViewControllers[i];
        if ([vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navc = mainViewController.childViewControllers[i];
            navc.view.frame = CGRectMake(0, mainViewController.view.height*(i-1), mainViewController.view.width, mainViewController.view.height);
            UIViewController *vc = navc.topViewController;
            scrollView = (UIScrollView*)vc.view;//in storyboard set self.view = scrollView
            [mainViewController.view addSubview:navc.view];
        }else{
            vc.view.frame = CGRectMake(0, mainViewController.view.height*(i-1), mainViewController.view.width, mainViewController.view.height - kAppStatusBarHeight - kAppNavigationBarHeight);
            scrollView = (UIScrollView*)vc.view;//in storyboard set self.view = scrollView
            [mainViewController.view addSubview:scrollView];
        }
        if (scrollView) {
            scrollView.tag = i;
            [_scrollViewArrays addObject:scrollView];
        }
        ///////////////////////////////////////scrollView contentOffset
        if (![scrollView isKindOfClass:[UIScrollView class]]) {
            return;
        }

        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        //skip跳过前3次信号
//        TWeakSelf(self)
//        @weakify(self)
        /*[[RACObserve(scrollView, contentOffset) skip:3] subscribeNext:^(id x) {
            @strongify(self)
            CGFloat y_offSet = [x CGPointValue].y;
            if (y_offSet == 0) {
                NSLog(@"y_offSet is 0");
                //return;//return后出现内存无法释放的问题
            }else{

                return;
                NSLog(@"%f",y_offSet);
                //            NSLog(@"%@",scrollView);

                UIScrollView *scrollView1 = self.scrollViewArrays[0];
                UIScrollView *scrollView2 = self.scrollViewArrays[1];
                UIScrollView *scrollView3 = self.scrollViewArrays[2];
                if (!scrollView1 || !scrollView2 || !scrollView3) {
                    NSLog(@"scrollView nil %@",self.scrollViewArrays);
                }
                
                /////////////////////////////////逐渐显示和隐藏topVC(即调节当前控制器的NavigationBar的alpha值)
                CGFloat goOffset = 110.0;
                CGFloat alphaValue = 1;
                if (y_offSet < -goOffset) {
                    
                    if (scrollView.tag == TMainVCChildVCIndexValueCenter || scrollView.tag == TMainVCChildVCIndexValueBottom) {

                        if (y_offSet < -goOffset) {
                            
                            ((TNormalRefreshHead*)scrollView.mj_header).titleLabel.text = @"不行了！敢不敢再拉一下";
                            [((TNormalRefreshHead*)scrollView.mj_header).titleLabel sizeToFit];
                            alphaValue = 1 - (ABS(y_offSet) - goOffset)/50.0;
                        }else{
                            
                            alphaValue = 1.0;
                        }
                        
                    }
                }else{
                    
                    alphaValue = 1.0;
                }
                if (scrollView.tag == TMainVCChildVCIndexValueCenter) {
                    
                    if ([mainViewController isKindOfClass:[UINavigationController class]]) {
                        
                        ((UINavigationController *)mainViewController).navigationBar.alpha = alphaValue;
                    }else{
                        
                        mainViewController.navigationController.navigationBar.alpha = alphaValue;
                    }
                    
                }else if (scrollView.tag == TMainVCChildVCIndexValueBottom){
                    
                    if ([scrollView.viewController isKindOfClass:[UINavigationController class]]) {
                        
                        ((UINavigationController *)scrollView.viewController).navigationBar.alpha = alphaValue;
                    }else{
                        
                        scrollView.viewController.navigationController.navigationBar.alpha = alphaValue;
                    }
                }
                ////////////////////////////////////动画滑动显示topVC 或 bottomVC
                if (y_offSet < ScrollDown_toShow_topVC_OffsetValue) {
                    
                    NSLog(@"should show top View");
                    
                    if (scrollView.tag == TMainVCChildVCIndexValueTop) {
                        
                    }else if (scrollView.tag == TMainVCChildVCIndexValueCenter){//show top

                        mainViewController.selectedViewController = mainViewController.childViewControllers[TMainVCChildVCIndexValueTop];//self.mainTopNAVC;
                        mainViewController.selectedIndex = 0;
//                        [self.mainBottomNAVC setNavigationBarHidden:YES animated:NO];
                        [mainViewController.navigationController setNavigationBarHidden:YES animated:NO];
                        
                        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            //                        scrollView1.top = 0;
                            //                        scrollView2.top = scrollView1.bottom;
                            //                        scrollView3.top = scrollView2.bottom;
                            mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.top = 0;
                            scrollView2.top = mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.bottom;
                            mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top = scrollView2.bottom;
                        } completion:^(BOOL finished) {
                            
                        }];
                        
                    }else if (scrollView.tag == TMainVCChildVCIndexValueBottom){//show center

                        mainViewController.selectedViewController = mainViewController;
                        mainViewController.selectedIndex = 1;
//                        [mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom] setNavigationBarHidden:YES animated:NO];
                        
                        mainViewController.navigationController.navigationBar.alpha = 1.0;
                        [mainViewController.navigationController setNavigationBarHidden:NO animated:NO];
                        
                        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            //                        scrollView2.top = 0;
                            //                        scrollView1.bottom = scrollView2.top;
                            //                        scrollView3.top = scrollView2.bottom;
                            scrollView2.top = 0;
                            mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.bottom = scrollView2.top;
                            mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top = scrollView2.bottom;
                        } completion:^(BOOL finished) {
                            
                        }];
                        
                    }
                    
                }else if (y_offSet - ((scrollView.contentSize.height - scrollView.height) < 0 ? 0 : (scrollView.contentSize.height - scrollView.height))  > ScrollUp_toShow_bottomVC_OffsetValue){
                    
                    NSLog(@"should show bottom View:%f",y_offSet - (scrollView.contentSize.height - scrollView.height));

                    if (scrollView.tag == TMainVCChildVCIndexValueTop) {//show center
                        mainViewController.selectedViewController = mainViewController;
                        mainViewController.selectedIndex = 1;
                        [mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom] setNavigationBarHidden:YES animated:NO];
                        
                        mainViewController.navigationController.navigationBar.alpha = 1.0;
                        [mainViewController.navigationController setNavigationBarHidden:NO animated:NO];
                        
                        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            //                        scrollView2.top = 0;
                            //                        scrollView1.bottom = scrollView2.top;
                            //                        scrollView3.top = scrollView2.bottom;
                            scrollView2.top = 0;
                            mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.bottom = scrollView2.top;
                            mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top = scrollView2.bottom;
                        } completion:^(BOOL finished) {
                            
                        }];
                        
                    }else if (scrollView.tag == TMainVCChildVCIndexValueCenter){//show bottom
                        mainViewController.selectedViewController = mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom];
                        mainViewController.selectedIndex = 2;
                        [mainViewController.navigationController setNavigationBarHidden:YES animated:NO];
                        
                        [mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom] navigationBar].alpha = 1.0;
                        [mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom] setNavigationBarHidden:NO animated:NO];
                        
                        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            //                        scrollView3.top = 0;
                            //                        scrollView2.bottom = scrollView3.top;
                            //                        scrollView1.bottom = scrollView2.top;
                            
                            mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top = 0;
                            scrollView2.bottom = scrollView3.top;//_mainBottomNAVC.view.top;
                            mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.bottom = scrollView2.top;
                        } completion:^(BOOL finished) {
                            
                        }];
                        
                    }else if (scrollView.tag == TMainVCChildVCIndexValueBottom){
                        
                    }
                    
                    
                }

            }
            
        }];*/
        
    }
    
    
    if (_scrollViewArrays.count > 1) {
        
        NSLog(@"animateWithDuration 0");
        __block UIScrollView *scrollView2 = _scrollViewArrays[1];
//        TWeakSelf(self)
        [UIView animateWithDuration:0 animations:^{
            
            mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top = 0;
            scrollView2.bottom = mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top;
            mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.bottom = scrollView2.top;
        } completion:^(BOOL finished) {
            
            mainViewController.selectedViewController = mainViewController;
            mainViewController.selectedIndex = 1;
            
            scrollView2.top = 0;
            mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.bottom = scrollView2.top;
            mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top = scrollView2.bottom;
        }];
    }
    
}

#pragma mark - observe

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    if (![object isKindOfClass:[UIScrollView class]]) {
        return;
    }
    id nsPoint = change[NSKeyValueChangeNewKey];
    CGFloat y_offSet = [nsPoint CGPointValue].y;
    if (y_offSet == 0) {
        NSLog(@"y_offSet is 0");
        
    }else{
        TMainViewController *mainViewController = self.mainViewController;
        UIScrollView *scrollView = object;
        
        NSLog(@"%f",y_offSet);
        //            NSLog(@"%@",scrollView);
        
        UIScrollView *scrollView1 = self.scrollViewArrays[0];
        UIScrollView *scrollView2 = self.scrollViewArrays[1];
        UIScrollView *scrollView3 = self.scrollViewArrays[2];
        if (!scrollView1 || !scrollView2 || !scrollView3) {
            NSLog(@"scrollView nil %@",self.scrollViewArrays);
        }
        
        /////////////////////////////////逐渐显示和隐藏topVC(即调节当前控制器的NavigationBar的alpha值)
        CGFloat goOffset = 110.0;
        CGFloat alphaValue = 1.0;
        if (y_offSet < -goOffset) {
            
            if (scrollView.tag == TMainVCChildVCIndexValueCenter || scrollView.tag == TMainVCChildVCIndexValueBottom) {
                
                if (y_offSet < -goOffset) {
                    
                    ((TNormalRefreshHead*)scrollView.mj_header).titleLabel.text = @"不行了！敢不敢再拉一下";
                    [((TNormalRefreshHead*)scrollView.mj_header).titleLabel sizeToFit];
                    alphaValue = 1 - (ABS(y_offSet) - goOffset)/50.0;
                }else{
                    
                    alphaValue = 1.0;
                }
                
            }
        }else{
            
            alphaValue = 1.0;
        }
        if (scrollView.tag == TMainVCChildVCIndexValueCenter) {
            
            if ([mainViewController isKindOfClass:[UINavigationController class]]) {
                
                ((UINavigationController *)mainViewController).navigationBar.alpha = alphaValue;
            }else{
                
                mainViewController.navigationController.navigationBar.alpha = alphaValue;
            }
            
        }else if (scrollView.tag == TMainVCChildVCIndexValueBottom){
            
            if ([scrollView.viewController isKindOfClass:[UINavigationController class]]) {
                
                ((UINavigationController *)scrollView.viewController).navigationBar.alpha = alphaValue;
                [((UINavigationController *)scrollView.viewController) setNavigationBarHidden:YES animated:YES];//因bottom下添加UITabBarController 所以隐藏
            }else{
                
                scrollView.viewController.navigationController.navigationBar.alpha = alphaValue;
                [scrollView.viewController.navigationController setNavigationBarHidden:YES animated:YES];//因bottom下添加UITabBarController 所以隐藏
            }
        }
        ////////////////////////////////////动画滑动显示topVC 或 bottomVC
        if (y_offSet < ScrollDown_toShow_topVC_OffsetValue) {
            
            NSLog(@"should show top View");
            
            if (scrollView.tag == TMainVCChildVCIndexValueTop) {
                
            }else if (scrollView.tag == TMainVCChildVCIndexValueCenter){//show top
                
                mainViewController.selectedViewController = mainViewController.childViewControllers[TMainVCChildVCIndexValueTop];//self.mainTopNAVC;
                mainViewController.selectedIndex = 0;
                //                        [self.mainBottomNAVC setNavigationBarHidden:YES animated:NO];
                [mainViewController.navigationController setNavigationBarHidden:YES animated:NO];
                
                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    //                        scrollView1.top = 0;
                    //                        scrollView2.top = scrollView1.bottom;
                    //                        scrollView3.top = scrollView2.bottom;
                    mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.top = 0;
                    scrollView2.top = mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.bottom;
                    mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top = scrollView2.bottom;
                } completion:^(BOOL finished) {
                    [mainViewController.mainMenuViewController removePanGestureRecognizerTarget:YES];
                }];
                
            }else if (scrollView.tag == TMainVCChildVCIndexValueBottom){//show center
                
                mainViewController.selectedViewController = mainViewController;
                mainViewController.selectedIndex = 1;
                //                        [mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom] setNavigationBarHidden:YES animated:NO];
                
                mainViewController.navigationController.navigationBar.alpha = 1.0;
                [mainViewController.navigationController setNavigationBarHidden:NO animated:NO];
                
                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    //                        scrollView2.top = 0;
                    //                        scrollView1.bottom = scrollView2.top;
                    //                        scrollView3.top = scrollView2.bottom;
                    scrollView2.top = 0;
                    mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.bottom = scrollView2.top;
                    mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top = scrollView2.bottom;
                } completion:^(BOOL finished) {
                    [mainViewController.mainMenuViewController removePanGestureRecognizerTarget:NO];
                }];
                
            }
            
        }else if (y_offSet - ((scrollView.contentSize.height - scrollView.height) < 0 ? 0 : (scrollView.contentSize.height - scrollView.height))  > ScrollUp_toShow_bottomVC_OffsetValue){
            
            NSLog(@"should show bottom View:%f",y_offSet - (scrollView.contentSize.height - scrollView.height));
            
            if (scrollView.tag == TMainVCChildVCIndexValueTop) {//show center
                mainViewController.selectedViewController = mainViewController;
                mainViewController.selectedIndex = 1;
                [mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom] setNavigationBarHidden:YES animated:NO];
                
                mainViewController.navigationController.navigationBar.alpha = 1.0;
                [mainViewController.navigationController setNavigationBarHidden:NO animated:NO];
                
                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    //                        scrollView2.top = 0;
                    //                        scrollView1.bottom = scrollView2.top;
                    //                        scrollView3.top = scrollView2.bottom;
                    scrollView2.top = 0;
                    mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.bottom = scrollView2.top;
                    mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top = scrollView2.bottom;
                } completion:^(BOOL finished) {
                    [mainViewController.mainMenuViewController removePanGestureRecognizerTarget:NO];
                }];
                
            }else if (scrollView.tag == TMainVCChildVCIndexValueCenter){//show bottom
                mainViewController.selectedViewController = mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom];
                mainViewController.selectedIndex = 2;
                [mainViewController.navigationController setNavigationBarHidden:YES animated:NO];
                
                [mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom] navigationBar].alpha = 1.0;
                [mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom] setNavigationBarHidden:YES animated:YES];//因bottom下添加UITabBarController 所以隐藏
                
                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    //                        scrollView3.top = 0;
                    //                        scrollView2.bottom = scrollView3.top;
                    //                        scrollView1.bottom = scrollView2.top;
                    
                    mainViewController.childViewControllers[TMainVCChildVCIndexValueBottom].view.top = 0;
                    scrollView2.bottom = scrollView3.top;//_mainBottomNAVC.view.top;
                    mainViewController.childViewControllers[TMainVCChildVCIndexValueTop].view.bottom = scrollView2.top;
                } completion:^(BOOL finished) {
                    [mainViewController.mainMenuViewController removePanGestureRecognizerTarget:YES];
                }];
                
            }else if (scrollView.tag == TMainVCChildVCIndexValueBottom){
                
            }
            
            
        }
        
    }
    
}

@end







