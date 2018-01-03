//
//  TBluetoothViewController.m
//  Tikeyc
//
//  Created by ways on 2017/7/20.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TBluetoothViewController.h"

#import "TBluetoothPeripheralViewController.h"
#import "TBluetoothCentralViewController.h"


@interface TBluetoothViewController ()
- (IBAction)openPeripheralAction:(UIButton *)sender;
- (IBAction)openCentralAction:(UIButton *)sender;

@end

@implementation TBluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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




- (IBAction)openPeripheralAction:(UIButton *)sender {
    [self.navigationController pushViewController:[[TBluetoothPeripheralViewController alloc] init] animated:YES];
}

- (IBAction)openCentralAction:(UIButton *)sender {
    [self.navigationController pushViewController:[[TBluetoothCentralViewController alloc] init] animated:YES];
}
@end













