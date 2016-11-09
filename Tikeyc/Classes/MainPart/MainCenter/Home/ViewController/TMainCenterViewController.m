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

#import "TNormalRefreshHead.h"
#import "TNormalRefreshFoot.h"

#import "TPopMenuPathIconView.h"

#import "TPickerView.h"

@interface TMainCenterViewController ()

@property (nonatomic,strong)TPopMenuPathIconView *popMenuPathIconView;

@end

@implementation TMainCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self setSubViewProperty];
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
    scrollView.mj_header = [TNormalRefreshHead headerWithRefreshingBlock:^{

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
}

- (TPopMenuPathIconView *)popMenuPathIconView{
    if (!_popMenuPathIconView) {
        //
        _popMenuPathIconView = [[TPopMenuPathIconView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)
                                                                 direction:TPopMenuPathIconAnimationDirectionTop icons:@[@"main_center_menu_animation_icon1",@"main_center_menu_animation_icon2",@"main_center_menu_animation_icon3",@"main_center_menu_animation_icon4",@"main_center_menu_animation_icon5"]
                                                                    titles:@[@"直播",@"图表Echarts",@"test3",@"test4",@"test5"]
                                                                 clickIcon:^(NSInteger index) {
                                                                     NSLog(@"click index:%ld",(long)index);
                                                                     
                                                                     switch (index) {
                                                                         case 0:
                                                                         {
                                                                             TLiveHomeViewController *liveHomeVC = [[TLiveHomeViewController alloc] init];
                                                                             [self.navigationController pushViewController:liveHomeVC animated:YES];
                                                                         }
                                                                             break;
                                                                         case 1:
                                                                         {
                                                                             TEchartsTypeListController *chartsTypeVC = [[TEchartsTypeListController alloc] init];
                                                                             [self.navigationController pushViewController:chartsTypeVC animated:YES];
                                                                         }
                                                                             break;
                                                                         case 2:
                                                                         {
                                                                             
                                                                         }
                                                                             break;
                                                                             
                                                                             
                                                                         default:
                                                                             break;
                                                                     }
                                                                     
                                                                 }];
    }
    return _popMenuPathIconView;
}

#pragma mark - bind RACSignal

- (void)initRACSignal{
    
}

@end











