//
//  MainBottomTabBar3ViewController.m
//  Tikeyc
//
//  Created by ways on 2016/12/2.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainBottomTabBar3ViewController.h"

#import "TMainBottomTB3CollectionView.h"

#import "TLiveListViewModel.h"

@interface TMainBottomTabBar3ViewController ()



@property (strong, nonatomic) IBOutlet TMainBottomTB3CollectionView *collectionView;
- (IBAction)rightItemfinishButtonAction:(UIBarButtonItem *)sender;



@property (nonatomic,strong)TLiveListViewModel *liveListViewModel;

@end

@implementation TMainBottomTabBar3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //测试用 为了方便所以就直接使用TLiveListViewModel了
    [self.liveListViewModel.requestCommand execute:nil];
    @weakify(self)
    [[RACObserve(self.liveListViewModel, liveListModels) skip:1] subscribeNext:^(id x) {
        @strongify(self)
        self.collectionView.liveListModels = self.liveListViewModel.liveListModels;
        [self.collectionView reloadData];
        
    }];
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


#pragma mark - get



- (TLiveListViewModel *)liveListViewModel{
    if (!_liveListViewModel) {
        _liveListViewModel = [[TLiveListViewModel alloc] init];
    }
    return _liveListViewModel;
}

#pragma mark - Actions Method

- (IBAction)rightItemfinishButtonAction:(UIBarButtonItem *)sender {
    
    
}

@end
