//
//  TLivePlayerViewModel.h
//  Tikeyc
//
//  Created by ways on 16/9/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>


/**因gitHub无法上传较大文件，因此未上传 IJKMediaFramework
 //此处报错请看https://github.com/Bilibili/ijkplayer目录下面的README.md文件Build iOS 制作IJKMediaFramework
 或直接到https://git.oschina.net/tikeyc/Tikeyc下载完整部分
 */
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface TLivePlayerViewModel : NSObject

- (instancetype)initWithPlayer:(id <IJKMediaPlayback>)player;

@end
