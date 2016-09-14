//
//  TMainTopViewModel.m
//  Tikeyc
//
//  Created by ways on 16/9/13.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainTopViewModel.h"

@interface TMainTopViewModel ()<UIScrollViewDelegate>

{
    CAShapeLayer *_scrollShapeLayer;
}


@end

@implementation TMainTopViewModel


- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y_Offset = scrollView.contentOffset.y;
    
    if (y_Offset < 0) {
        
        if (!_scrollShapeLayer) {
            _scrollShapeLayer = [CAShapeLayer layer];
            _scrollShapeLayer.lineWidth = 0;
            _scrollShapeLayer.strokeColor = [UIColor purpleColor].CGColor;
            _scrollShapeLayer.fillColor = [UIColor purpleColor].CGColor;
            [scrollView.viewController.navigationController.navigationBar.layer addSublayer:_scrollShapeLayer];
        }
        UIBezierPath *scrollBezierPath = [UIBezierPath bezierPath];
        [scrollBezierPath moveToPoint:CGPointMake(0, kAppNavigationBarHeight)];
        [scrollBezierPath addQuadCurveToPoint:CGPointMake(TScreenWidth, kAppNavigationBarHeight) controlPoint:CGPointMake(TScreenWidth/2, ABS(y_Offset)*2 + kAppNavigationBarHeight)];
        _scrollShapeLayer.path = scrollBezierPath.CGPath;
        
    }else{
        _scrollShapeLayer.path = nil;
    }
}

@end












