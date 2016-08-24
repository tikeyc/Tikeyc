//
//  TMainViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainViewController.h"


@interface TMainViewController ()

@end

@implementation TMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"main_title"];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:image];
    titleView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.navigationItem.titleView = titleView;

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.mainMenuViewController removePanGestureRecognizerTarget:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.mainMenuViewController removePanGestureRecognizerTarget:YES];
    
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



@end









