//
//  TLPCMessageListTableView.m
//  Tikeyc
//
//  Created by ways on 16/9/26.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLPCMessageListTableView.h"

#import "TLPCMessageView.h"

@interface TLPCMessageListTableView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TLPCMessageListTableView


- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    self.backgroundColor = [UIColor clearColor];
    self.tableFooterView = [UIView new];
    
    self.dataSource = self;
    self.delegate = self;
    
}

- (void)reloadData{
    [super reloadData];
    
    if (!self.isDragging) {
        [self scrollToBottom];
    }
    
}

#pragma mark - set

- (void)setMessageListModels:(NSMutableArray *)messageListModels{
    _messageListModels = messageListModels;
    
    //
//    [self reloadData];
}

- (CGFloat)getCellHeightWithMessageModel:(TPLCMessageModel *)messageModel{
    CGFloat height = 0;
    
    TLPCMessageView *messageView = [[TLPCMessageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
    messageView.messageModel = messageModel;
    
    height = messageView.messageLabel.bottom + 10;
    
    return height;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messageListModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self getCellHeightWithMessageModel:self.messageListModels[indexPath.row]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor redColor];
        //
        TLPCMessageView *messageView = [[TLPCMessageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 44)];
        messageView.tag = 111;
        [cell.contentView addSubview:messageView];
    }
    
    TLPCMessageView *messageView = (TLPCMessageView *)[cell.contentView viewWithTag:111];
    messageView.messageModel = self.messageListModels[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

@end










