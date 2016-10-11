//
//  TLiveHomeViewController.m
//  Tikeyc
//
//  Created by ways on 16/9/21.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLiveHomeViewController.h"

#import "TLiveListTableViewController.h"
#import "TLiveViewController.h"

@interface TLiveHomeViewController ()


- (IBAction)playLiveAction:(UIButton *)sender;

- (IBAction)livingAction:(UIButton *)sender;


@end

@implementation TLiveHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"直播研究";
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

- (IBAction)playLiveAction:(UIButton *)sender {
    TLiveListTableViewController *liveListVC = [[TLiveListTableViewController alloc] init];
    [self.navigationController pushViewController:liveListVC animated:YES];
}

- (IBAction)livingAction:(UIButton *)sender {
    TLiveViewController *liveVC = [[TLiveViewController alloc] init];
    [self.navigationController pushViewController:liveVC animated:YES];
}


@end
