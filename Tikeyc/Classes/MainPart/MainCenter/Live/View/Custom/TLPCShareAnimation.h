//
//  TLPCShareAnimation.h
//  Tikeyc
//
//  Created by ways on 16/9/29.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLPCShareAnimation : UIButton{
    
    NSMutableArray *_shareImgViews;
    UIImageView *_shareImgView;
    
    CAKeyframeAnimation *_animation;
    NSInteger _startNum;
    NSInteger _stopNum;
    
    BOOL _isAnimation;
}

- (void)startShareAnimation;
- (void)stopShareAnimation;

@end
