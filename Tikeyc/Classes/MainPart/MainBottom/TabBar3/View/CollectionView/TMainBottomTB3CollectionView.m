//
//  TMainBottomTB3CollectionView.m
//  Tikeyc
//
//  Created by ways on 2016/12/2.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainBottomTB3CollectionView.h"

#import "TMainBottomTB3CollectionViewCell.h"
#import "TMainBottomTB3CollectionViewLayout.h"

#import "UIImageView+WebCache.h"

#import "TLivePlayerViewController.h"

@interface TMainBottomTB3CollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSArray *heightArr;

@end

@implementation TMainBottomTB3CollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initProperty];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initProperty];
}


#pragma mark - init

- (void)initProperty{
    //
    self.dataSource = (id)self;
    self.delegate = (id)self;
    //
    TMainBottomTB3CollectionViewLayout *collectionViewLayout = [[TMainBottomTB3CollectionViewLayout alloc] init];
    [collectionViewLayout computeIndexCellHeightWithWidthBlock:^CGFloat(NSIndexPath *indexPath,CGFloat itemWidth) {
        
        CGFloat height = [self.heightArr[indexPath.item] floatValue];
        return height;
    }];
    self.collectionViewLayout = collectionViewLayout;
    
}

- (NSArray *)heightArr{
    if(!_heightArr && self.liveListModels.count > 0){
        //随机生成高度
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < self.liveListModels.count; i++) {
            [arr addObject:@(arc4random()%100+120)];
        }
        _heightArr = [arr copy];
    }
    return _heightArr;
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.liveListModels.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"TMainBottomTB3CollectionViewCell";
    
    TMainBottomTB3CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    TLiveListModel *liveListModel = self.liveListModels[indexPath.item];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",liveListModel.creator[@"portrait"]]]];
    
    
    return cell;
}

#pragma mark - 

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGSize size = CGSizeMake(100, 100);
//    return size;
//}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
    
    TLivePlayerViewController *livePlayerVC = [[TLivePlayerViewController alloc] init];
    
    livePlayerVC.liveListModel = self.liveListModels[indexPath.row];
    
    [self.viewController.navigationController pushViewController:livePlayerVC animated:YES];
}

@end










