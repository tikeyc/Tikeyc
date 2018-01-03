//
//  TSellThingsListCell.m
//  LoveShare
//
//  Created by ways on 2017/5/2.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "THealthLifeListCell.h"

@interface THealthLifeListCell ()
- (IBAction)sendIMButtonAction:(UIButton *)sender;

@end

@implementation THealthLifeListCell


+ (instancetype)loadFromNib {
    THealthLifeListCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:NULL] lastObject];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.ninePlaceGridView.showImages = @[@"beauty.jpg",@"beauty1.jpg",@"beauty.jpg",@"beauty1.jpg",@"live_icon.jpg"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sendIMButtonAction:(UIButton *)sender {
    
}
@end
