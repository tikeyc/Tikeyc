//
//  JYJTopicCell.h
//  JYJ不得姐
//
//  Created by JYJ on 16/5/21.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYJTopic;
@interface JYJTopicCell : UITableViewCell
/** 模型数据 */
@property (nonatomic, strong) JYJTopic *topic;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, assign) BOOL isHome;

+ (instancetype)cell;
@end
