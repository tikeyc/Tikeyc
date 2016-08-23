//
//  TMenuRightCell.m
//  Tikeyc
//
//  Created by ways on 16/8/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMenuRightCell.h"

@implementation TMenuRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSubViewProperty];
}

#pragma mark - init

- (void)setSubViewProperty{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_rightCell_background_320_110"]];
    //    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}



@end
