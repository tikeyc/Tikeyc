//
//  TNinePlaceGridView.h
//  LoveShare
//
//  Created by ways on 2017/5/10.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TShowListImageButton;
///////
static NSString *ninePlaceGridCollectionCellIdentifier = @"ninePlaceGridCollectionCell";

@interface TNinePlaceGridCollectionCell : UICollectionViewCell

@property (nonatomic,strong)TShowListImageButton *imageView;

@end

@interface TNinePlaceGridView : UIView


@property (nonatomic,strong)UICollectionView *collectionView;


@property (nonatomic,strong)NSArray *showImages;

@end
