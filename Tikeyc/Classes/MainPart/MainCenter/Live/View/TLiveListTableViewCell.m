//
//  TLiveListTableViewCell.m
//  Tikeyc
//
//  Created by ways on 16/9/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLiveListTableViewCell.h"

#import "UIImageView+WebCache.h"

@implementation TLiveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - set

- (void)setLiveListModel:(TLiveListModel *)liveListModel{
    _liveListModel = liveListModel;
    
    [self.headImgView setImageWithURL:[NSURL URLWithString:_liveListModel.creator[@"portrait"]] placeholder:nil];
    //
    [self.ShowImgView setImageWithURL:[NSURL URLWithString:_liveListModel.creator[@"portrait"]] placeholder:nil];
    //
    self.nickNameLabel.text = _liveListModel.creator[@"nick"];
    //
    NSString *str = [NSString stringWithFormat:@"%@ 在看",_liveListModel.online_users];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:str];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor orangeColor] } range:NSMakeRange(0, attribute.length-2)];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor] } range:NSMakeRange(attribute.length-2, 2)];
    self.onlineLabel.attributedText = attribute;
    //
    if (![_liveListModel.city isEqualToString:@""]) {
        self.locationLabel.text = _liveListModel.city;
    }else{
        self.locationLabel.text = @"在WC?";
    }
}


@end
