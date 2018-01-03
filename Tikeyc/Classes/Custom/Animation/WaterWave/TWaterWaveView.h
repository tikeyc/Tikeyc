//
//  TWaterWaveView.h
//  Tikeyc
//
//  Created by ways on 2016/12/9.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@interface TWaterWaveView : UIView

+ (instancetype)loadingView;

- (void)startLoading;

- (void)stopLoading;

@end
NS_ASSUME_NONNULL_END
