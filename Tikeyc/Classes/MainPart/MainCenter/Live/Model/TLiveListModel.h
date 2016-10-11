//
//  TLiveListModel.h
//  Tikeyc
//
//  Created by ways on 16/9/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 {
 "creator": {
 "id": 3707220,
 "level": 82,
 "nick": "小莲莲不是胖是旺夫💕",
 "portrait": "MTQ3MjMxNDQwNDI2MyM5NDAjanBn.jpg"
 },
 "id": "1474515498062202",
 "name": "",
 "city": "丽水市",
 "share_addr": "http://mlive7.inke.cn/share/live.html?uid=3707220&liveid=1474515498062202&ctime=1474515498",
 "stream_addr": "http://pull99.a8.com/live/1474515498062202.flv",
 "version": 0,
 "slot": 1,
 "optimal": 0,
 "online_users": 18345,
 "group": 0,
 "link": 0,
 "multi": 0,
 "rotate": 0
 },
 */

@interface TLiveListModel : NSObject

/** 播放流地址 */
@property(nonatomic,copy)NSString * stream_addr;
/** 在线人数 */
@property(nonatomic,copy)NSString * online_users;
/** 详情 */
@property(nonatomic,strong)NSDictionary * creator;
/** city */
@property(nonatomic,copy)NSString * city;
/** id */
@property(nonatomic,copy)NSString * id;

@end
