//
//  TMainCenterViewController.m
//  Tikeyc
//
//  Created by ways on 16/9/6.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainCenterViewController.h"

#import "TLiveHomeViewController.h"
#import "TEchartsTypeListController.h"
#import "JYJEssenceViewController.h"
#import "TBluetoothViewController.h"
#import "TARViewController.h"

#import "TCoreMLViewController.h"
#import "TDragDropViewController.h"
#import "TSocketViewController.h"

#import "TNormalRefreshHead.h"
#import "TNormalRefreshFoot.h"

#import "TPopMenuPathIconView.h"

#import "TWaterWaveView.h"

@interface TMainCenterViewController ()

@property (nonatomic,strong)TPopMenuPathIconView *popMenuPathIconView;
@property (nonatomic,strong)TPopMenuPathIconView *popMenuPathIconView1;
@property (nonatomic,strong)TWaterWaveView *waterWaveView;

@end

@implementation TMainCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSubViewProperty];
    
//    [self startTime];
    
}


- (void)startTime{
    __block UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 200, 21)];
    [self.view addSubview:label];
    __block int timeout = 60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //定时结束后的UI处理
            });
        }else{
//            NSLog(@"时间 = %d",timeout);
            NSString *strTime = [NSString stringWithFormat:@"发送验证码(%dS)",timeout];
//            NSLog(@"strTime = %@",strTime);
            dispatch_async(dispatch_get_main_queue(), ^{
                //定时过程中的UI处理9
                label.text = strTime;
                
            });
            
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TNotificationCenter postNotificationName:TNotificationName_Set_menuPanEnable object:@(false)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - init

- (void)setSubViewProperty{
    UIScrollView *scrollView = (UIScrollView*)self.view;//in storyboard set self.view = scrollView
//    scrollView.contentSize = CGSizeMake(0, scrollView.height + 100);
//    scrollView.delegate = self;
    //
    @weakify(self)
    scrollView.mj_header = [TNormalRefreshHead headerWithRefreshingBlock:^{
        @strongify(self)

        if (self.view.top == 0) {//在下滑到即将显示topVC时会动画快速显示topVC,此时不应该刷新数据
            NSLog(@"headerWithRefreshingBlock");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [scrollView.mj_header endRefreshingWithCompletionBlock:^{
                    NSLog(@"endRefreshingWithCompletionBlock");
                }];
            });
        }else{
            [scrollView.mj_header endRefreshingWithCompletionBlock:^{
                
            }];
        }
        
        
    }];
    
    //
    //        TNormalRefreshFoot *refreshFooter = [TNormalRefreshFoot footerWithRefreshingBlock:^{
    //             NSLog(@"footerWithRefreshingBlock");
    //        }];
    //        scrollView.mj_footer = refreshFooter;
    
    [self.view addSubview:self.popMenuPathIconView];
    [self.view addSubview:self.popMenuPathIconView1];
    [self.view addSubview:self.waterWaveView];
    [self.waterWaveView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(@(self.popMenuPathIconView.bottom + 20));
        make.left.equalTo(@((self.view.width - self.waterWaveView.width)/2));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [_waterWaveView startLoading];
    });
}

- (TPopMenuPathIconView *)popMenuPathIconView{
    if (!_popMenuPathIconView) {
        //
        @weakify(self)
        _popMenuPathIconView = [[TPopMenuPathIconView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 250)
                                                                 direction:TPopMenuPathIconAnimationDirectionTop icons:@[@"main_center_menu_animation_icon1",@"main_center_menu_animation_icon2",@"main_center_menu_animation_icon3",@"main_center_menu_animation_icon4",@"main_center_menu_animation_icon5"]
                                                                    titles:@[@"直播",@"图表Echarts",@"百思不得姐",@"蓝牙",@"ARKit"]
                                                                 clickIcon:^UIViewController *(NSInteger index, BOOL is3DTouch) {
                                                                     NSLog(@"click index:%ld",(long)index);
                                                                     @strongify(self)
                                                                     UIViewController *vc = [self popMenuPathIconViewClickAtIndex:index is3DTouch:is3DTouch];
                                                                     if (is3DTouch) {
                                                                         return vc;
                                                                     } else {
                                                                         return nil;
                                                                     }
                                                                 }];
    }
    return _popMenuPathIconView;
}

- (TPopMenuPathIconView *)popMenuPathIconView1{
    if (!_popMenuPathIconView1) {
        //
        @weakify(self)
        _popMenuPathIconView1 = [[TPopMenuPathIconView alloc] initWithFrame:CGRectMake(0, 320, self.view.width, 250)
                                                                 direction:TPopMenuPathIconAnimationDirectionBottom icons:@[@"main_center_menu_animation_coreML",@"main_center_menu_animation_drag",@"main_center_menu_animation_socket",@"coreML",@"coreML"]
                                                                    titles:@[@"CoreML",@"Drag-Drop",@"Socket",@"test4",@"test5"]
                                                                 clickIcon:^UIViewController *(NSInteger index, BOOL is3DTouch) {
                                                                     NSLog(@"click index:%ld",(long)index);
                                                                     @strongify(self)
                                                                     UIViewController *vc = [self popMenuPathIconView1ClickAtIndex:index is3DTouch:is3DTouch];
                                                                     if (is3DTouch) {
                                                                         return vc;
                                                                     } else {
                                                                         return nil;
                                                                     }
                                                                 }];
    }
    return _popMenuPathIconView1;
}

- (TWaterWaveView *)waterWaveView{
    
    if (!_waterWaveView) {
        
        _waterWaveView = [TWaterWaveView loadingView];
    }
    
    return _waterWaveView;
}

#pragma mark - bind RACSignal

- (void)initRACSignal{
    
}



#pragma mark - 

- (UIViewController *)popMenuPathIconViewClickAtIndex:(NSInteger)index is3DTouch:(BOOL)is3DTouch{
    switch (index) {
        case 0:
        {
            TLiveHomeViewController *liveHomeVC = [[TLiveHomeViewController alloc] init];
            if (is3DTouch) return liveHomeVC;
            [self.navigationController pushViewController:liveHomeVC animated:YES];
        }
            break;
        case 1:
        {
            TEchartsTypeListController *chartsTypeVC = [[TEchartsTypeListController alloc] init];
            if (is3DTouch) return chartsTypeVC;
            [self.navigationController pushViewController:chartsTypeVC animated:YES];
        }
            break;
        case 2:
        {
            JYJEssenceViewController *carVC = [[JYJEssenceViewController alloc] init];
            if (is3DTouch) return carVC;
            [self.navigationController pushViewController:carVC animated:YES];
        }
            break;
        case 3: {
            
            TBluetoothViewController *bluetoothVC = [[TBluetoothViewController alloc] init];
            if (is3DTouch) return bluetoothVC;
            [self.navigationController pushViewController:bluetoothVC animated:YES];
            break;
        }
        case 4: {
            if (@available(iOS 11, *)) {
                TARViewController *arVC = [[TARViewController alloc] init];
                if (is3DTouch) return arVC;
                [self presentViewController:arVC animated:YES completion:NULL];
            } else {
                [SVProgressHUD showErrorWithStatus:@"支持iPhone SE iPhone6s、iOS11及以上的设备"];
                return nil;
            }
            break;
        }
            
        default:
            return nil;
            break;
    }
    return nil;
}

- (UIViewController *)popMenuPathIconView1ClickAtIndex:(NSInteger)index is3DTouch:(BOOL)is3DTouch{
    switch (index) {
        case 0:
        {
            if (@available(iOS 11, *)) {
                TCoreMLViewController *coreMLVC = [[TCoreMLViewController alloc] init];
                if (is3DTouch) return coreMLVC;
                [self.navigationController pushViewController:coreMLVC animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"需要iOS11及以上的设备"];
                return nil;
            }
        }
            break;
        case 1:
        {
            if (@available(iOS 11, *)) {
                TDragDropViewController *dragDropVC = [[TDragDropViewController alloc] init];
                if (is3DTouch) return dragDropVC;
                [self.navigationController pushViewController:dragDropVC animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"需要iOS11及以上的设备"];
                return nil;
            }
        }
            break;
        case 2:
        {
            TSocketViewController *socketVC = [[TSocketViewController alloc] init];
            if (is3DTouch) return socketVC;
            [self.navigationController pushViewController:socketVC animated:YES];
        }
            break;
        case 3: {
            
            return nil;
            break;
        }
        case 4: {
            return nil;
            break;
        }
            
        default:
            return nil;
            break;
    }
    return nil;
}


@end











