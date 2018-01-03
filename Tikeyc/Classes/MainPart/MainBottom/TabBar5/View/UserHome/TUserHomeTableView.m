//
//  TUserHomeTableView.m
//  LoveShare
//
//  Created by ways on 2017/4/14.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TUserHomeTableView.h"

#import "TUserHomeTableHeadView.h"
#import "UITableView+TStretchableTableHead.h"

#import "TUserAttentionCell.h"


@interface TUserHomeTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)NSArray *cellListTitles;
@property (nonatomic,copy)NSArray *cellListImageNames;

@end

@implementation TUserHomeTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initProperty];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initProperty];
}


#pragma mark - init

- (void)initProperty {
    self.dataSource = self;
    self.delegate = self;
    
    [self setTableHeaderView];
    UIView *view = [UIView new];
    view.height = 100;
    self.tableFooterView = view;
    
    _cellListTitles = @[@"我的关注",@"发布记录",@"消息中心",@"邀请朋友",@"我的资料",@"修改密码",@"退出登录"];
    _cellListImageNames = @[@"user_home_attention",@"user_home_history",@"user_home_news",@"user_home_friends",@"user_home_information",@"user_home_password",@"user_home_logout",];
}


- (void)setTableHeaderView {
    TUserHomeTableHeadView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TUserHomeTableHeadView" owner:nil options:NULL] lastObject];
    headerView.width = TScreenWidth;
    [self stretchHeaderWithView:headerView];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cellListTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        TUserAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:userAttentionCellIdentifier];
        if (cell == nil) {
            cell = [TUserAttentionCell loadFromNib];
        }
        return cell;
    }
    
    static NSString *indentfier = @"userHomeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentfier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentfier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TUserHomeCell" owner:nil options:NULL] lastObject];
    }
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:111];
    UIImageView *messageTip = (UIImageView *)[cell.contentView viewWithTag:222];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:333];
    titleLabel.text = _cellListTitles[indexPath.section];
    if ( indexPath.section == 2 && [self.viewController.navigationController.tabBarItem.badgeValue integerValue] > 0) {
        messageTip.hidden = NO;
    } else {
        messageTip.hidden = YES;
    }
    imageView.image = [UIImage imageNamed:_cellListImageNames[indexPath.section]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%@",_cellListTitles[indexPath.row]);
    
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
                
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
            
        }
            break;
        case 6:
        {
            [TAlertView showWithTitle:@"提示" message:@"确定退出登录?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] type:UIAlertControllerStyleAlert andParentView:self andAction:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                    [TAppDelegateManager gotoLoginController];
                }
            }];
            
        }
            break;
            
        default:
            break;
    }
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y <= 0) {
//        [self.viewController.tabBarController.tabBar setHidden:NO];
//        self.height = TScreenHeight - kAppTabBarHeight;
//    } else {
//        [self.viewController.tabBarController.tabBar setHidden:YES];
//        self.height = TScreenHeight;
//    }
//    
//}

@end




