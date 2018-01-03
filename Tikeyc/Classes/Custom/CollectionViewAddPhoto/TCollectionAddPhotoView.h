//
//  TCollectionAddPhotoView.h
//  LoveShare
//
//  Created by ways on 2017/4/28.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCollectionAddPhotoView : UIView


@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;


+ (instancetype)loadFromNib;

@end
