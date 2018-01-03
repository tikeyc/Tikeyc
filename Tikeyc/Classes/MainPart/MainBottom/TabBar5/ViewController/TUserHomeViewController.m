//
//  TUserInforViewController.m
//  LoveShare
//
//  Created by ways on 2017/4/11.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TUserHomeViewController.h"

#import "TUserHomeTableView.h"

@interface TUserHomeViewController ()

//@property (strong, nonatomic) IBOutlet TUserHomeTableView *userHomeTableView;

@end

@implementation TUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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

- (void)initProperty {
    
}

@end






