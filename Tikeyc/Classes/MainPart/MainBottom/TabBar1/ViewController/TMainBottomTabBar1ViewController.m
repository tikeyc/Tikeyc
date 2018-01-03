//
//  MainBottomTabBar1ViewController.m
//  Tikeyc
//
//  Created by ways on 2016/11/15.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainBottomTabBar1ViewController.h"

#import "TMainBottomJSOCViewController.h"
#import "TWordsToVoiceViewController.h"

@interface TMainBottomTabBar1ViewController ()

@end

@implementation TMainBottomTabBar1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = @"MainBottom";
    [self setChildViewControllers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)setChildViewControllers{
    for (int i = 0; i < 16; i++) {
        if (i == 0) {
            TMainBottomJSOCViewController *vc = [[TMainBottomJSOCViewController alloc] init];
            vc.title = [@"JSOC " stringByAppendingString:[@(i+1) stringValue]];
            [self addChildViewController:vc];
        } else if (i == 1) {
            TWordsToVoiceViewController *vc = [[TWordsToVoiceViewController alloc] init];
            vc.title = [@"Words-Voice " stringByAppendingString:[@(i+1) stringValue]];
            [self addChildViewController:vc];
        } else {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.title = [@"title " stringByAppendingString:[@(i+1) stringValue]];
            vc.view.backgroundColor = i%2 == 0 ? [UIColor orangeColor] : [UIColor redColor];
            [self addChildViewController:vc];
        }
        
    }
    
    TWeakSelf(self)
    [self setUpContentViewFrame:^(UIView *contentView) {
        contentView.frame = weakself.view.frame;
    }];
}


@end
















