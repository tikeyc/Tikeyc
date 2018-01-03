//
//  ORCImageCropperViewController.h
//  ORC
//
//  Created by tikeyc on 16/1/20.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TBaseViewController.h"

@class TImageCropperViewController;

@protocol TImageCropperDelegate <NSObject>

- (void)imageCropper:(TImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(TImageCropperViewController *)cropperViewController;

@end

@interface TImageCropperViewController : TBaseViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<TImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
