//
//  TSelectListValueView.m
//  LoveShare
//
//  Created by ways on 2017/6/21.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TSelectListValueView.h"


@interface TSelectListValueView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TSelectListValueView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.hidden = YES;
    }
    
    return self;
}


#pragma mark - init

- (UITableView *)myTableView {
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        [self addSubview:_myTableView];
    }
    
    return _myTableView;
}

- (void)initSubView {
    
    [self myTableView];
    
}


- (void)setListValue:(NSArray *)listValue {
    _listValue = listValue;
    //
    NSUInteger count = _listValue.count;
    if (count > 6) {//不能太高
        count = 6;
    }
    self.height = 44*count;
    self.center = self.superview.center;
    self.myTableView.height = self.height;
    //
    [self.myTableView reloadData];
}


#pragma mark - show

- (void)selectListValueViewIsShow:(BOOL)isShow withListValue:(NSArray *)listValue{
    if (listValue != nil) {
        self.listValue = listValue;
    }
    self.hidden = !isShow;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listValue.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"valueCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = _listValue[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",_listValue[indexPath.row]);
    self.hidden = YES;
    if (self.selectedValueBlock) {
        self.selectedValueBlock(_listValue[indexPath.row]);
    }
}

@end





