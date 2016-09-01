//
//  TMenuViewModel.h
//  Tikeyc
//
//  Created by ways on 16/8/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBaseViewController.h"

#import "TMenuLeftHeadView.h"
#import "TLeftMenuModel.h"
#import "TRightMenuModel.h"

static NSString *leftMenuTableViewCellIdentifier = @"TMenuLeftCell";
static NSString *rightMenuTableViewCellIdentifier = @"TMenuRightCell";

@interface TMenuViewModel : NSObject

- (instancetype)initMenuViewModelWitchTableViewCellIdentifier:(NSString *)tableViewCellIdentifier;


@property (nonatomic,strong)UITableView *currentTableView;
@property (nonatomic,strong)TMenuLeftHeadView *menuLeftHeadView;

@property (nonatomic,copy)NSString *tableViewCellIdentifier;


@property (nonatomic,strong)NSMutableArray *leftMenuModels;
@property (nonatomic,strong)NSMutableArray *rightMenuModels;


- (void)excuseToGetMenuData;//本来想使用RACSignal信号来实现，但为了以后的通用性就暂时不用了


@end
