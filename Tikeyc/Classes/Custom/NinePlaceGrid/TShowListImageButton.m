//
//  TShowListImageButton.m
//  LoveShare
//
//  Created by ways on 2017/5/10.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TShowListImageButton.h"

#import "TNinePlaceGridView.h"

@interface TShowListImageButton ()

@property (nonatomic,strong)TShowListImageCollectionViewController *showListImageCollectionVC;

@end

@implementation TShowListImageButton


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setShowImages:(NSArray *)showImages {
    _showImages = showImages;
    
}

- (NSMutableArray *)converFrames {
    if (_myCollectionView == nil) {//对于一个item占据整个_myCollectionView的情况：如TCycleScrollListImageView的无限循环滑动
        return nil;
    }
    _converFrames = [NSMutableArray array];
    for (int i = 0; i < _showImages.count; i++) {
        
        TNinePlaceGridCollectionCell *cell = (TNinePlaceGridCollectionCell *)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        CGRect converFrame = [cell.imageView convertRect:cell.imageView.frame toView:self.window];
        [_converFrames addObject:NSStringFromCGRect(converFrame)];
    }
    return _converFrames;
}

#pragma mark - action

- (void)buttonClick:(UIButton *)button {
    [self showImageListToWindowIs3DTouch:NO];
    if (_showListImageVCBlock) {
        _showListImageVCBlock(-2);//如果是-2表示放大图片
    }
}

#pragma mark - show

- (void)showImageListToWindowIs3DTouch:(BOOL)is3DTouch {
    self.showListImageCollectionVC = [self showListImageCollectionVCIs3DTouch:is3DTouch];
    self.showListImageCollectionVC.view.frame = self.window.frame;
    [self.window addSubview:self.showListImageCollectionVC.view];
    [self.showListImageCollectionVC showListImageIs3DTouch:is3DTouch];
    
}


- (TShowListImageCollectionViewController *)showListImageCollectionVCIs3DTouch:(BOOL)is3DTouch {
    _showListImageCollectionVC = nil;
    _showListImageCollectionVC = [[TShowListImageCollectionViewController alloc] init];
    //在访问_showListImageCollectionVC.view之前设置好相关属性
    CGRect converFrame = [self convertRect:self.frame toView:self.window];
    _showListImageCollectionVC.currentIndex = self.tag;
    _showListImageCollectionVC.converFrame = converFrame;
    _showListImageCollectionVC.converFrames = self.converFrames;
    _showListImageCollectionVC.currentImage = self.currentImage;
    _showListImageCollectionVC.showImages = self.showImages;
    _showListImageCollectionVC.showListImageVCBlock = _showListImageVCBlock;
    _showListImageCollectionVC.is3DTouch = is3DTouch;
    return _showListImageCollectionVC;
}


@end













