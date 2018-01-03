//
//  NotificationService.m
//  MyNotificationService
//
//  Created by ways on 2016/10/19.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#define DDLOG(...) printf("%s\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#import "NotificationService.h"
#import <UserNotifications/UserNotifications.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    // copy发来的通知，开始做一些处理
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    
    // 重写一些东西
    self.bestAttemptContent.title = @"标题";
    self.bestAttemptContent.subtitle = @"子标题";
    self.bestAttemptContent.body = @"come form tikeyc";
    
    // 附件 imageAbsoluteString：value由推送时设置的值决定
    NSDictionary *dict =  self.bestAttemptContent.userInfo;
    NSDictionary *notiDict = dict[@"aps"];
    NSString *imgUrl = [NSString stringWithFormat:@"%@",notiDict[@"imageAbsoluteString"]];
    
    // 这里添加一些点击事件，可以在收到通知的时候，添加，也可以在拦截通知的这个扩展中添加
    
    self.bestAttemptContent.categoryIdentifier = @"Category1";
    
    
    
    
    if (!imgUrl.length) {
        
        self.contentHandler(self.bestAttemptContent);
        
    }
    
    
    //withType:@"png" 这里是写死了。该类型应该在推送消息的字典中带上如:
    /**
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
     */
    [self loadAttachmentForUrlString:imgUrl withType:@"audio" completionHandle:^(UNNotificationAttachment *attach) {
        
        if (attach) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
        }
        self.contentHandler(self.bestAttemptContent);
        
    }];    
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

#pragma mark -

- (void)loadAttachmentForUrlString:(NSString *)urlStr
                          withType:(NSString *)type
                  completionHandle:(void(^)(UNNotificationAttachment *attach))completionHandler{
    
    
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlStr];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", error.localizedDescription);
                    } else {
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
                        [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
                        
                        NSError *attachmentError = nil;
                        attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
                        if (attachmentError) {
                            NSLog(@"%@", attachmentError.localizedDescription);
                        }
                    }
                    
                    completionHandler(attachment);
                    
                    
                }] resume];
    
    
    
}

//类型最好在服务器设置好赋值到推送消息的aps中
- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    
    
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    
    return [@"." stringByAppendingString:ext];
}


@end
