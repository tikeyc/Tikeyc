//
//  TSellThingsListTableView.m
//  LoveShare
//
//  Created by ways on 2017/5/2.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "THealthLifeListTableView.h"

#import "THealthLifeListCell.h"

@interface THealthLifeListTableView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation THealthLifeListTableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initProperty];
}


#pragma mark - init

- (void)initProperty {
    self.dataSource = self;
    self.delegate = self;
    
    self.tableFooterView = [UIView  new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THealthLifeListCell *cell = [tableView dequeueReusableCellWithIdentifier:healthLifeListCellindextifier];
    if (cell == nil) {
        cell = [THealthLifeListCell loadFromNib];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


@end
