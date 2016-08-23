//
//  TMenuViewModel.h
//  Tikeyc
//
//  Created by ways on 16/8/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "TMenuLeftHeadView.h"


static NSString *leftMenuTableViewCellIdentifier = @"TMenuLeftCell";
static NSString *rightMenuTableViewCellIdentifier = @"TMenuRightCell";

@interface TMenuViewModel : NSObject


@property (nonatomic,strong)TMenuLeftHeadView *menuLeftHeadView;

@property (nonatomic,copy)NSString *tableViewCellIdentifier;

- (instancetype)initMenuViewModelWitchTableViewCellIdentifier:(NSString *)tableViewCellIdentifier;

@end
