//
//  TPLCGiftView.m
//  Tikeyc
//
//  Created by ways on 16/9/29.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TPLCGiftView.h"

@implementation TPLCGiftView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    NSLog(@"TPLCGiftView dealloc");
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _numVlaue = 1;
//        [self startGiftNumLabelAnimation];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _numVlaue = 1;
//    [self startGiftNumLabelAnimation];
    
}


#pragma mark - Animations

- (void)startGiftNumLabelAnimation{
    
    self.giftNumLabel.left = self.giftNumLabel.left - 40;
    
    self.giftNumLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    TWeakSelf(self)
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        weakself.giftNumLabel.left = weakself.giftNumLabel.left + 40;
        //
        weakself.giftNumLabel.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        weakself.giftNumLabel.text = [NSString stringWithFormat:@"x %ld",++_numVlaue];
        [weakself startGiftNumLabelAnimation];
    }];
    
}


@end







