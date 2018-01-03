//
//  UITableView+TStretchableTableHead.m
//  LoveShare
//
//  Created by ways on 2017/5/8.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "UITableView+TStretchableTableHead.h"
#import <objc/runtime.h>


#define headView_tag 9999999

@implementation UITableView (TStretchableTableHead)


- (void)dealloc
{
    [self removeObserverBlocks];
}

- (void)stretchHeaderWithView:(UIView *)headView
{
    UIView* emptyTableHeaderView = [[UIView alloc] initWithFrame:headView.frame];
    self.tableHeaderView = emptyTableHeaderView;
    
    headView.tag = headView_tag;
    [self addSubview:headView];
    
    @weakify(self)
    [self addObserverBlockForKeyPath:@"contentOffset" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        @strongify(self)
        [self scrollViewDidScroll:obj];
    }];
}

- (void)scrollViewDidScroll:(UITableView *)tableView
{
    if(tableView.contentOffset.y <= 0) {
        
        CGFloat offsetY = (tableView.contentOffset.y + tableView.contentInset.top) * -1;
        CGRect frame = CGRectMake((tableView.width - (tableView.width + offsetY))/2/*水平居中*/, offsetY * -1, tableView.width + offsetY, tableView.tableHeaderView.height + offsetY);
        
        for (UIView *subView in self.subviews) {
            if (subView.tag == headView_tag) {
                subView.frame = frame;
            }
        }
    }
}

- (void)resizeView
{
    for (UIView *subView in self.subviews) {
        if (subView.tag == headView_tag) {
            subView.frame = CGRectMake(0, 0, self.width, self.tableHeaderView.height);
        }
    }
    
}





@end
