//
//  TPLCGiftView.h
//  Tikeyc
//
//  Created by ways on 16/9/29.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPLCGiftView : UIView{
    
    NSInteger _numVlaue;
    
}


@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImgView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *giftImgView;
@property (strong, nonatomic) IBOutlet UILabel *giftNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *giftNumLabel;


- (void)startGiftNumLabelAnimation;

@end
