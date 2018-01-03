//
//  TNinePlaceGridView.m
//  LoveShare
//
//  Created by ways on 2017/5/10.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TNinePlaceGridView.h"

#import "TShowListImageButton.h"

#define item_x_gap 5

@interface TNinePlaceGridCollectionCell ()


@end

@implementation TNinePlaceGridCollectionCell

- (void)prepareForReuse {
    [super prepareForReuse];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[TShowListImageButton alloc] init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
    return self;
}


@end
///////


@interface TNinePlaceGridView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerPreviewingDelegate>


@property (nonatomic,assign)CGFloat itemWith;

@end

@implementation TNinePlaceGridView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self initSubView];
//        [self initProperty];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self initSubView];
//    [self initProperty];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self initSubView];
    [self initProperty];

}


#pragma mark - init

- (void)initSubView {
    [self collectionView];
}

- (void)initProperty {
    //test
//    self.showImages = @[@"beauty.jpg",@"beauty1.jpg",@"beauty.jpg",@"glenceLuanch.jpg",@"live_icon.jpg"];
}


- (CGFloat)itemWith {
    _itemWith = (self.width - item_x_gap*3)/3;
    return _itemWith;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(self.itemWith, self.itemWith);
        layout.minimumLineSpacing = item_x_gap;
        layout.minimumInteritemSpacing = item_x_gap;
        //
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[TNinePlaceGridCollectionCell class] forCellWithReuseIdentifier:ninePlaceGridCollectionCellIdentifier];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}





#pragma mark - set

- (void)setShowImages:(NSArray *)showImages {
    _showImages = showImages;
    /*如果需要自适应屏幕宽度的item打开此部分代码
    NSInteger rowNum = _showImages.count/3;
    if (_showImages.count%3 == 0) {
        
    } else {
        ++rowNum;
    }
    CGFloat height = rowNum * (self.itemWith + item_x_gap);
    self.height = height;
    self.collectionView.height = height;
    self.collectionView.width = self.width;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(self.itemWith, self.itemWith);*/
    [self.collectionView  reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _showImages.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TNinePlaceGridCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ninePlaceGridCollectionCellIdentifier forIndexPath:indexPath];
    
    [cell.imageView setImage:[UIImage imageNamed:_showImages[indexPath.row]] forState:UIControlStateNormal];
    cell.imageView.tag = indexPath.row;
    cell.imageView.myCollectionView = collectionView;
    cell.imageView.showImages = self.showImages;
    
    //
    if ([self.viewController respondsToSelector:@selector(registerForPreviewingWithDelegate:sourceView:)]) {
        [self.viewController registerForPreviewingWithDelegate:self sourceView:cell.imageView];
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    
}


#pragma mark - UIViewControllerPreviewingDelegate

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
    TShowListImageButton *showListImageButton = (TShowListImageButton *)previewingContext.sourceView;
    TShowListImageCollectionViewController *vc = [showListImageButton showListImageCollectionVCIs3DTouch:YES];
    [vc showListImageIs3DTouch:YES];
    return vc;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {
    NSLog(@"commitViewController");
    TShowListImageButton *showListImageButton = (TShowListImageButton *)previewingContext.sourceView;
    [showListImageButton showImageListToWindowIs3DTouch:YES];
}

@end











