//
//  TSellThingsListCell.h
//  LoveShare
//
//  Created by ways on 2017/5/2.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TNinePlaceGridView.h"

static NSString *healthLifeListCellindextifier = @"healthLifeListCell";

@interface THealthLifeListCell : UITableViewCell


@property (strong, nonatomic) IBOutlet TNinePlaceGridView *ninePlaceGridView;


+ (instancetype)loadFromNib;

@end
