//
//  TShowListImageCollectionViewController.h
//  LoveShare
//
//  Created by ways on 2017/5/10.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShowListImageVCBlock)(NSInteger currentIndex);//如果是-1表示缩小图片 

@interface TShowListImageCollectionViewController : UIViewController

@property (nonatomic,strong)UIImageView *animationImageView;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIPageControl *pageControl;

@property (nonatomic,assign)CGRect converFrame;
@property (nonatomic,strong)NSMutableArray *converFrames;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong)UIImage *currentImage;
@property (nonatomic,strong)NSArray *showImages;

@property (nonatomic,assign)BOOL is3DTouch;

@property (nonatomic,copy)ShowListImageVCBlock showListImageVCBlock;//如果是-1表示缩小图片

- (void)showListImageIs3DTouch:(BOOL)is3DTouch;

@end
