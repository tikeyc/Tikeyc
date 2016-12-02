//
//  TMainBottomTBCollectionViewCell.m
//  Tikeyc
//
//  Created by ways on 2016/12/2.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainBottomTB3CollectionViewCell.h"

@implementation TMainBottomTB3CollectionViewCell


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperty];
    }
    return self;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initProperty];
}

- (void)initProperty{
    self.contentView.backgroundColor = [UIColor orangeColor];
//    [self performSelector:@selector(test) withObject:nil afterDelay:0.2];
}

- (void)test{
//    [TKCAppTools setCornerWithView:self byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
}

@end
