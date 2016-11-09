//
//  NotificationViewController.m
//  MyNotificationExtension
//
//  Created by ways on 2016/10/19.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

#pragma mark - UNNotificationContentExtension

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
    
    //
    NSDictionary *dict =  notification.request.content.userInfo;
    // 这里可以把打印的所有东西拿出来
    NSLog(@"%@",dict);
    
    /****************************打印的信息是************
     *远程推送的格式:这里我们要注意一定要有"mutable-content": "1",以及一定要有Alert的字段，否则可能会拦截通知失败。（苹果文档说的）
     *除此之外，我们还可以添加自定义字段，比如，图片地址，图片类型
     {
     "aps": {
     "alert": "This is some fancy message.",
     "badge": 1,
     "sound": "default",
     "mutable-content": "1",//
     "imageAbsoluteString": "http://xxx.jpg(png)",
     "category":"Category1",//与UNNotificationCategory创建的对象保持一致，否则无法显示改组策略按钮
     "fileMediaType":"png"//附件类型，便于做不同的界面及操作处理
     }
     }
     *******************************************/
    
    
}


- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion{

    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {

        NSString* userSayStr = [(UNTextInputNotificationResponse *)response userText];
        NSLog(@"%@",userSayStr);

    }

}



- (UNNotificationContentExtensionMediaPlayPauseButtonType)mediaPlayPauseButtonType
{
    return UNNotificationContentExtensionMediaPlayPauseButtonTypeDefault;
}

- (CGRect)mediaPlayPauseButtonFrame
{
    return CGRectMake(100, 100, 100, 100);
}

- (UIColor *)mediaPlayPauseButtonTintColor{
    return [UIColor blueColor];
}

- (void)mediaPlay{
    NSLog(@"mediaPlay,开始播放");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.extensionContext mediaPlayingPaused];
    });
    
    
}
- (void)mediaPause{
    NSLog(@"mediaPause，暂停播放");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.extensionContext mediaPlayingStarted];
    });
    
    
}


- (void)mediaPlayingStarted{
    NSLog(@"主动调用开始的方法");
}
- (void)mediaPlayingPaused
{
    NSLog(@"主动调用暂停的方法");
    
}




//@property (nonatomic, readonly, assign) UNNotificationContentExtensionMediaPlayPauseButtonType mediaPlayPauseButtonType;
//
//// Implementing this method and returning a non-empty frame will make
//// the notification draw a button that allows the user to play and pause
//// media content embedded in the notification.
//@property (nonatomic, readonly, assign) CGRect mediaPlayPauseButtonFrame;
//
//// The tint color to use for the button.
//@property (nonatomic, readonly, copy) UIColor *mediaPlayPauseButtonTintColor;
//
//// Called when the user taps the play or pause button.
//- (void)mediaPlay;
//- (void)mediaPause;



@end
