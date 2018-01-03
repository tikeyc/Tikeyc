//
//  TUserAttentionCell.m
//  LoveShare
//
//  Created by ways on 2017/5/5.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TUserAttentionCell.h"

#import "TUserAttentionCollectionViewCell.h"

@interface TUserAttentionCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation TUserAttentionCell

+ (instancetype)loadFromNib {
    TUserAttentionCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:NULL] lastObject];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self initProperty];
}

#pragma mark - init

- (void)initProperty {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //
    self.collectionView.collectionViewLayout = [self getFlowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TUserAttentionCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:userAttentionCollectionViewCellIndentifier];
}


- (UICollectionViewFlowLayout *)getFlowLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(70, 100);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    return layout;
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TUserAttentionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userAttentionCollectionViewCellIndentifier forIndexPath:indexPath];
    
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

    
}

@end










