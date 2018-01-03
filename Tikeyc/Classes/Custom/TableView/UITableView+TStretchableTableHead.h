//
//  UITableView+TStretchableTableHead.h
//  LoveShare
//
//  Created by ways on 2017/5/8.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (TStretchableTableHead)

/**
 在需要的tableView上初始化该滑动放大头视图
 
 @param headView headView
 */
- (void)stretchHeaderWithView:(UIView *)headView;

/**
 重置
 */
- (void)resizeView;

@end
