//
//  TSelectQRCodeTypeViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/30.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TSelectQRCodeTypeViewController.h"

#import "TCreatingRQCodeViewController.h"
#import "HCHeader.h"

@interface TSelectQRCodeTypeViewController ()

@property (strong, nonatomic) IBOutlet UIButton *scaningButton;

@property (strong, nonatomic) IBOutlet UIButton *creatButton;


@end

@implementation TSelectQRCodeTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBindRACSignal];
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

#pragma mark - signal

- (void)setBindRACSignal{
    TWeakSelf(self)
    [[self.scaningButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        HCScanQRViewController *scanQRVC = [[HCScanQRViewController alloc] init];
        scanQRVC.showQRCodeInfo = YES;
        [scanQRVC successfulGetQRCodeInfo:^(NSString *scanQRCodeInfo) {
            NSLog(@"扫描结果：%@",scanQRCodeInfo);
        }];
        [weakself.navigationController pushViewController:scanQRVC animated:YES];
    }];
    
    
    [[self.creatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    
}

@end








