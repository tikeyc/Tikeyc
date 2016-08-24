//
//  TMenuRightTableViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/16.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMenuRightTableViewController.h"

#import "TMenuViewModel.h"

@interface TMenuRightTableViewController ()

@property (nonatomic,strong,nullable)TMenuViewModel *menuViewModel;


@end

@implementation TMenuRightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //
    [self initSubViews];
    //
    [self setSubViewProperty];
    //
    [self initBindViewModel];
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



#pragma mark - init

- (void)initSubViews{
    
}
- (void)setSubViewProperty{
    self.tableView.rowHeight = 80;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initBindViewModel{
    self.menuViewModel = [[TMenuViewModel alloc] initMenuViewModelWitchTableViewCellIdentifier:rightMenuTableViewCellIdentifier];
    
    self.tableView.dataSource = (id)self.menuViewModel;
    self.tableView.delegate = (id)self.menuViewModel;
}

@end
