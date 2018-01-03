//
//  TUserAttentionCell.h
//  LoveShare
//
//  Created by ways on 2017/5/5.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *userAttentionCellIdentifier = @"userAttentionCell";

@interface TUserAttentionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


+ (instancetype)loadFromNib;

@end
