//
//  TWaterflowLayout.m
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TWaterflowLayout.h"


@interface TWaterflowLayout ()

/**用来记录每一列的最大y值*/
@property (nonatomic, strong) NSMutableDictionary *maxYDic;
/** 存放所有item的attrubutes属性*/
@property (nonatomic, strong) NSMutableArray *attributesArray;
/** 计算每个item高度的block，必须实现*/
@property (nonatomic, copy) HeightBlock heightBlock;

@end

@implementation TWaterflowLayout

#pragma mark - init


- (instancetype)init
{
    self = [super init];
    if (self) {
        //对默认属性进行设置
        self.columnNumber = 3;
        self.rowSpacing = 10.0f;
        self.columnSpacing = 10.0f;
        //
        self.sectionInset = UIEdgeInsetsMake(20, 10, 10, 20);
    }
    return self;
}

- (NSMutableDictionary *)maxYDic {
    if (!_maxYDic) {
        _maxYDic = [[NSMutableDictionary alloc] init];
    }
    return _maxYDic;
}

- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

#pragma mark -

/**
 *  设置计算高度block方法
 *
 *  @param block 计算item高度的block
 */
- (void)computeIndexCellHeightWithWidthBlock:(HeightBlock)block{
    if (self.heightBlock != block) {
        self.heightBlock = block;
    }
}

#pragma mark -

/*  准备好布局时调用
 */
- (void)prepareLayout{
    [super prepareLayout];
    
    //初始化字典，有几列就有几个键值对，key为列，value为列的最大y值，初始值为上内边距
    for (int i = 0; i < self.columnNumber; i++) {
        self.maxYDic[@(i)] = @(self.sectionInset.top + self.headerReferenceSize.height);
    }
    
    //根据collectionView获取总共有多少个item
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    [self.attributesArray removeAllObjects];
    //为每一个item创建一个attributes并存入数组
    if (self.headerReferenceSize.height > 0) {//头部视图
        UICollectionViewLayoutAttributes *attributesHead = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        attributesHead.frame = CGRectMake(0, 0, TScreenWidth, self.headerReferenceSize.height);
        [self.attributesArray addObject:attributesHead];
    }
    
    for (int i = 0; i < itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}


/*  设置可滚动区域范围
 */
- (CGSize)collectionViewContentSize{
    [super collectionViewContentSize];
    
    NSLog(@"collectionViewContentSize");
    
    __block NSNumber *maxIndex = @0;
    //遍历字典，找出最长的那一列
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxYDic[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = key;
        }
    }];
    
    //collectionView的contentSize.height就等于最长列的最大y值+下内边距
    return CGSizeMake(0, [self.maxYDic[maxIndex] floatValue] + self.sectionInset.bottom);
}

/*  返回视图框内item的属性，可以直接返回所有item属性
 */
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    [super layoutAttributesForElementsInRect:rect];
    
    return self.attributesArray;
}

/*  计算indexPath下item的属性的方法
 *
 *  @return item的属性
 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    [super layoutAttributesForItemAtIndexPath:indexPath];
    
    //根据indexPath获取item的attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //获取collectionView的宽度
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    //item的宽度 = (collectionView的宽度 - 内边距与列间距) / 列数
    CGFloat itemWidth = (collectionViewWidth - self.sectionInset.left - self.sectionInset.right - (self.columnNumber - 1) * self.columnSpacing) / self.columnNumber;
    
    CGFloat itemHeight = 0;
    //获取item的高度，由外界计算得到
    if (self.heightBlock) itemHeight = self.heightBlock(indexPath, itemWidth);
    
    
    //找出最短的那一列
    __block NSNumber *minIndex = @0;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxYDic[minIndex] floatValue] > obj.floatValue) {
            minIndex = key;
        }
    }];
    
    /*方法一
     *此法的效果是设置每个item的frame时会在当前已加载的所有item中的最底部 中 取最短的列的Y值 作为当前要加载的item的Y值，
     *会出现不是按顺序排放item的情况即出现 0 1 2
     *                               4 3 5
     *                               7 8 6
     */
    //根据最短列的列数计算item的x值
    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * minIndex.integerValue;
    
    
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = [self.maxYDic[minIndex] floatValue] + self.rowSpacing;
    
    
    //设置attributes的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    //更新字典中的最大y值
    self.maxYDic[minIndex] = @(CGRectGetMaxY(attributes.frame));
    
    
    /*方法二
     *此法按顺序排放item,但会出现这种情况 即：
     *9 或 10
     *9    10表示该item较长表示同一个item
     *                              0  1  2
     *                              3  4  5
     *                              6  7  8
     *                              9  10 11
     *                              9  10 14
     *                              12 13
     *                              15
     *看过效果后我个人觉得还是使用 方法一 较为合适
     
     //根据最短列的列数计算item的x值
     CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * (indexPath.item%self.columnNumber);
     //item的y值 = 上一行中与之同列的y值 + 行间距。 indexPath.item%self.columnNumber ：表示第几列
     CGFloat itemY = [self.maxYDic[@(indexPath.item%self.columnNumber)] floatValue] + self.rowSpacing;
     
     //设置attributes的frame
     attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
     //更新字典中的y值  self.maxYDic最多有self.columnNumber个key-value
     self.maxYDic[@(indexPath.item%self.columnNumber)] = @(CGRectGetMaxY(attributes.frame));
     */
    return attributes;
}

@end








































