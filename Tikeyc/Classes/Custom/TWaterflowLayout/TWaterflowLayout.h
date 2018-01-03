//
//  TWaterflowLayout.h
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath,CGFloat itemWidth);


@interface TWaterflowLayout : UICollectionViewFlowLayout

/** 列数 */
@property (nonatomic, assign) NSInteger columnNumber;
/** 行间距 */
@property (nonatomic, assign) CGFloat rowSpacing;
/** 列间距 */
@property (nonatomic, assign) CGFloat columnSpacing;

/**
 *  返回各个item高度方法 必须实现
 *
 *  @param block 设计计算item高度的block
 */
- (void)computeIndexCellHeightWithWidthBlock:(HeightBlock)block;
@end
