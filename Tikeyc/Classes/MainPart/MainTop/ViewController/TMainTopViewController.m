//
//  TMainTopViewController.m
//  Tikeyc
//
//  Created by ways on 16/9/6.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainTopViewController.h"

#import "TNormalRefreshHead.h"
#import "TNormalRefreshFoot.h"

#import "TMainTopViewModel.h"

@interface TMainTopViewController ()

@property (nonatomic,strong)TMainTopViewModel *mainTopViewModel;

@end

@implementation TMainTopViewController

- (void)setNavigationProperty{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor purpleColor]] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *image = [UIImage imageNamed:@"main_top_title"];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:image];
    titleView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.navigationItem.titleView = titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    [self setNavigationProperty];
    //
    [self setProperty];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [TNotificationCenter postNotificationName:TNotificationName_Set_menuPanEnable object:@(true)];
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

- (void)setProperty{
    self.title = @"top View";
    //
    UIScrollView *scrollView = (UIScrollView*)self.view;//in storyboard set self.view = scrollView
    scrollView.delegate = (id)self.mainTopViewModel;
    scrollView.contentSize = CGSizeMake(0, scrollView.height+ 100);
    //
//    scrollView.mj_header = [TNormalRefreshHead headerWithRefreshingBlock:^{
//        NSLog(@"headerWithRefreshingBlock:%lf",scrollView.contentOffset.y);
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [scrollView.mj_header endRefreshingWithCompletionBlock:^{
//                NSLog(@"endRefreshingWithCompletionBlock");
//            }];
//        });
//        
//    }];
    //
//            TNormalRefreshFoot *refreshFooter = [TNormalRefreshFoot footerWithRefreshingBlock:^{
//                 NSLog(@"footerWithRefreshingBlock");
//            }];
//            scrollView.mj_footer = refreshFooter;
    
    
    //
//    [self getQuadCurveLayer];
}

#pragma mark - bind RACSignal

- (void)initRACSignal{
    
}

#pragma mark - set

- (TMainTopViewModel *)mainTopViewModel{
    if (!_mainTopViewModel) {
        _mainTopViewModel = [[TMainTopViewModel alloc] init];
    }
    return _mainTopViewModel;
}



@end





