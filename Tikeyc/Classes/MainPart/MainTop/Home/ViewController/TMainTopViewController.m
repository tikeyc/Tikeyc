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
#import "ZYQSphereView.h"

@interface TMainTopViewController ()

@property (nonatomic,strong)ZYQSphereView *sphereView;

@property (nonatomic,strong)TMainTopViewModel *mainTopViewModel;

@end

@implementation TMainTopViewController

- (void)setNavigationProperty{
    TsetNavigationBarBackgroundImage_withImage([UIImage imageWithColor:[UIColor purpleColor]])
    
    TsetNavigationItem_titleView_withImgName(@"main_top_title")
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
    
    
    [self.sphereView timerStart];
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

- (ZYQSphereView *)sphereView {
    if (_sphereView == nil) {
        _sphereView = [[ZYQSphereView alloc] initWithFrame:CGRectMake(10, 60, 300, 300)];
        _sphereView.center=CGPointMake(self.view.center.x, self.view.center.y-30);
        NSMutableArray *views = [[NSMutableArray alloc] init];
        for (int i = 0; i < 50; i++) {
            UIButton *subV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            subV.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100. green:arc4random_uniform(100)/100. blue:arc4random_uniform(100)/100. alpha:1];
            [subV setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
            subV.layer.masksToBounds = YES;
            subV.layer.cornerRadius = 3;
            [subV addTarget:self action:@selector(subVClick:) forControlEvents:UIControlEventTouchUpInside];
            [views addObject:subV];
        }
        
        [_sphereView setItems:views];
        _sphereView.speed = 3;
        _sphereView.miniScallValue = 0.5;
        _sphereView.isPanTimerStart = YES;
        
        
        [self.view addSubview:_sphereView];
    }
    return _sphereView;
}

-(void)subVClick:(UIButton*)sender{
    NSLog(@"%@",sender.titleLabel.text);
    
    BOOL isStart = [_sphereView isTimerStart];
    
    [_sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.transform = CGAffineTransformMakeScale(1, 1);
            if (isStart) {
                [_sphereView timerStart];
            }
        }];
    }];
}


@end





