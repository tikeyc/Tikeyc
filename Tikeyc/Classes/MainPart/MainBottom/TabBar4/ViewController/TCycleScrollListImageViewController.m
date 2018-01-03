//
//  TCycleScrollListImageViewController.m
//  Tikeyc
//
//  Created by ways on 2017/5/26.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TCycleScrollListImageViewController.h"

#import "TCycleScrollListImageView.h"
#import "LYCarrouselView.h"

@interface TCycleScrollListImageViewController ()


@property (nonatomic,strong)NSMutableArray *showCycleImages;
@property (nonatomic,strong)NSMutableArray *showCarrouselImages;

@property (strong, nonatomic) IBOutlet TCycleScrollListImageView *cycleScrollListImageView;
@property (strong, nonatomic) IBOutlet LYCarrouselView *carrouselView;

@end

@implementation TCycleScrollListImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initProperty];
    [self.cycleScrollListImageView startTimerToScrollImage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.cycleScrollListImageView dispatchSourceCancel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)initProperty {
    [self showCycleImages];
    [self showCarrouselImages];
}


- (NSMutableArray *)showCycleImages {
    if (_showCycleImages == nil) {
        _showCycleImages = [NSMutableArray array];
        for (int i = 1; i <= 15; i++) {
            [_showCycleImages addObject:[[@"cycle" stringByAppendingString:[@(i) stringValue]] stringByAppendingString:@".jpg"]];
        }
        self.cycleScrollListImageView.showImages = _showCycleImages;
    }
    return _showCycleImages;
}


- (NSMutableArray *)showCarrouselImages {
    if (_showCarrouselImages == nil) {
        _showCarrouselImages = [NSMutableArray array];
        for (int i = 1; i <= 15; i++) {
            NSString *imageName = [[@"cycle" stringByAppendingString:[@(i) stringValue]] stringByAppendingString:@".jpg"];
            [_showCarrouselImages addObject:[UIImage imageNamed:imageName]];
        }
        self.carrouselView.showImages = _showCarrouselImages;
//        [self.carrouselView addImage:[UIImage imageNamed:[[@"cycle" stringByAppendingString:[@(13) stringValue]]stringByAppendingString:@".jpg"]]];
    }
    return _showCarrouselImages;
}


@end








