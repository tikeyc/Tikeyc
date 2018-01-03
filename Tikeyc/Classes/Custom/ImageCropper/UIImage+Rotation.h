//
//  UIImage+Rotation.h
//  CATHAY
//
//  Created by tikeyc on 15/10/12.
//  Copyright © 2015年 vizz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotation)

@property (nonatomic,copy)NSString *isRotation;

- (UIImage *)fixOrientation;

- (UIImage *)imageRotation;

- (UIImage *)orientationLeft;

- (UIImage *)imageByScalingToMaxSize;

@end
