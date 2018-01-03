//
//  TCycleScrollListImageView.h
//  Tikeyc
//
//  Created by ways on 2017/5/26.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCycleScrollListImageView : UICollectionView


@property (nonatomic,strong)NSMutableArray *showImages;
@property (nonatomic,strong)NSMutableArray *cycleShowImages;

- (void)startTimerToScrollImage;
- (void)dispatchSourceCancel;

@end
