//
//  TShowListImageButton.h
//  LoveShare
//
//  Created by ways on 2017/5/10.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TShowListImageCollectionViewController.h"

@interface TShowListImageButton : UIButton

@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)NSMutableArray *converFrames;
@property (nonatomic,strong)NSArray *showImages;

@property (nonatomic,copy)ShowListImageVCBlock showListImageVCBlock;//如果是-1表示缩小图片 

- (TShowListImageCollectionViewController *)showListImageCollectionVCIs3DTouch:(BOOL)is3DTouch;

- (void)showImageListToWindowIs3DTouch:(BOOL)is3DTouch;

@end
