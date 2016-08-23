//
//  TMenuLeftCell.m
//  Tikeyc
//
//  Created by ways on 16/8/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMenuLeftCell.h"

@implementation TMenuLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setSubViewProperty];
}

#pragma mark - init

- (void)setSubViewProperty{
    self.backgroundColor = [UIColor clearColor];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
