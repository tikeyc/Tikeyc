//
//  YPWaterflowLayout.h
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPWaterflowLayout;

@protocol YPWaterflowLayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(YPWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (NSUInteger)columnCountInWaterflowLayout:(YPWaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(YPWaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(YPWaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(YPWaterflowLayout *)waterflowLayout;

@end

@interface YPWaterflowLayout : UICollectionViewLayout
@property (nonatomic, weak) id<YPWaterflowLayoutDelegate> delegate;
@end
