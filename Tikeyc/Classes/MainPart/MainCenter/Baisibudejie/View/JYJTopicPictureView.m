//
//  JYJTopicPictureView.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/23.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTopicPictureView.h"
#import "UIImageView+WebCache.h"
#import "JYJTopic.h"
#import "JYJProgressView.h"
#import "JYJShowPictureViewController.h"

#import "SDWebImageDownloader.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface JYJTopicPictureView ()
/** 图片 */
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
@property (weak, nonatomic) IBOutlet JYJProgressView *progressView;

@end

@implementation JYJTopicPictureView

+ (instancetype)pictureView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.seeBigButton.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingNone;
    // 给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)setTopic:(JYJTopic *)topic {
    _topic = topic;
    
    // 判断是否为gif
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    // 设置图片
    self.imageView.animatedImage = nil;
    self.imageView.image = nil;
    TWeakSelf(self)
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:topic.large_image]
                                                options:0
                                               progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                   topic.pictureProgress = 1.0 * receivedSize / expectedSize;
                                                   dispatch_async_on_main_queue(^{
                                                       weakself.progressView.hidden = NO;
                                                       [weakself.progressView setProgress:topic.pictureProgress animated:YES];
                                                   });

                                               }
                                              completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                  weakself.progressView.hidden = YES;
                                                  if (weakself.gifView.hidden) {
                                                      weakself.imageView.image = image;
                                                  } else {
                                                      FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                                                      weakself.imageView.animatedImage = animatedImage;
                                                  }
                                                  
                                                  // 如果大图片，才需要进行绘图处理
                                                  if (topic.isBigPicture == NO) return;
                                                  
                                                  // 开启图形上下文
                                                  UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);
                                                  
                                                  // 将下载完的image对象绘制到图形上下文
                                                  CGFloat width = topic.pictureF.size.width;
                                                  CGFloat height = width * image.size.height / image.size.width;
                                                  [image drawInRect:CGRectMake(0, 0, width, height)];
                                                  
                                                  //获得图片
                                                  weakself.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                                                  
                                                  // 结束图形上下文
                                                  UIGraphicsEndImageContext();
                                              }];
    /*
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:topic.pictureProgress animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        // 如果大图片，才需要进行绘图处理
        if (topic.isBigPicture == NO) return;
        
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);
        
        // 将下载完的image对象绘制到图形上下文
        CGFloat width = topic.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        //获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束图形上下文
        UIGraphicsEndImageContext();
        
    }];*/
    
    
    
    //判断是否显示"点击查看全图"
    if (topic.isBigPicture) { // 大图
        self.seeBigButton.hidden = NO;
    } else { // 非大图
        self.seeBigButton.hidden = YES;
    }
}

- (void)showPicture {
    if (_topic.type == JYJTopicTypePicture && self.gifView.hidden) {
        JYJShowPictureViewController *showPicture = [[JYJShowPictureViewController alloc] init];
        showPicture.topic = self.topic;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
    }
    
}


@end
