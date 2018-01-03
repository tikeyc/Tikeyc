//
//  TLiveListTableViewController.m
//  Tikeyc
//
//  Created by ways on 16/9/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLiveListTableViewController.h"

#import "TNormalRefreshHead.h"
#import "TNormalRefreshFoot.h"
#import "TLiveListViewModel.h"

@interface TLiveListTableViewController ()


@property (nonatomic,strong)TLiveListViewModel *liveListViewModel;

@end

@implementation TLiveListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"映客直播列表";
    
    [self bindRACSignal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get

- (TLiveListViewModel *)liveListViewModel{
    if (!_liveListViewModel) {
        _liveListViewModel = [[TLiveListViewModel alloc] init];
    }
    return _liveListViewModel;
}

#pragma mark - bind RACSignal

- (void)bindRACSignal{
    self.tableView.dataSource = (id)self.liveListViewModel;
    self.tableView.delegate = (id)self.liveListViewModel;
    self.tableView.rowHeight = kScreenWidth + 50;
    //
    @weakify(self)
    [[RACObserve(self.liveListViewModel, liveListModels) skip:1] subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
            
        }];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            
        }];
        [self.tableView reloadData];
    }];
    
    
    [self initRefresh];
}

- (void)initRefresh{
    self.tableView.mj_header = [TNormalRefreshHead headerWithRefreshingBlock:^{
        [self.liveListViewModel.requestCommand execute:nil];
    }];
    //
    [self.tableView.mj_header beginRefreshing];
    
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
