//
//  TodayViewController.m
//  widget
//
//  Created by ways on 2017/12/29.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)button2ClickAction:(UIButton *)sender;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
#endif

    
}

-(void)viewWillAppear:(BOOL)animated{
    //网络请求图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageDate = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://7xi8d6.com1.z0.glb.clouddn.com/20171219115747_tH0TN5_Screenshot.jpeg"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageDate];
            self.imageView.image = image;
        });
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

//展开和收缩效果设置
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    switch (activeDisplayMode) {
        case NCWidgetDisplayModeCompact:
            self.preferredContentSize = CGSizeMake(maxSize.width,300);
            //ios10以后，widget的关闭时高度为固定值，设置没效果。
            break;
        case NCWidgetDisplayModeExpanded:
            self.preferredContentSize = CGSizeMake(maxSize.width,400);
            break;
        default:
            break;
    }
}
#endif

//设置widget的edgeInsets
-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (IBAction)button2ClickAction:(UIButton *)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"tikeycWidget://action=all"] completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"openURL success");
        }
    }];
}
@end












