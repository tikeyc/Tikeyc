//
//  TLivePlayerViewModel.h
//  Tikeyc
//
//  Created by ways on 16/9/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IJKMediaFramework/IJKMediaFramework.h>//此处报错请看https://github.com/Bilibili/ijkplayer目录下面的README.md文件Build iOS 制作IJKMediaFramework

@interface TLivePlayerViewModel : NSObject

- (instancetype)initWithPlayer:(id <IJKMediaPlayback>)player;

@end
