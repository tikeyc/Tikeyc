//
//  TUICollectionViewMove.h
//  Tikeyc
//
//  Created by ways on 2016/12/6.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TUICollectionViewMove : UICollectionView

@property (nonatomic,assign)BOOL isBegin;


- (void)starShakeCell:(UICollectionViewCell*)cell;
- (void)stopShakeCell:(UICollectionViewCell*)cell;

@end
