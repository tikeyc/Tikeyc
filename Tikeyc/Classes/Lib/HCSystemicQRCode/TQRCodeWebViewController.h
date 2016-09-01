//
//  TQRCodeWebViewController.h
//  Tikeyc
//
//  Created by ways on 16/8/31.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQRCodeWebViewController : UIViewController


- (instancetype)initWithURL:(NSURL *)webURL;


@property (nonatomic,strong)NSURL *webURL;


@end
