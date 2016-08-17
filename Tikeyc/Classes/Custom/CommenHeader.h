//
//  CommenHeader.h
//  TSMWSChart
//
//  Created by ways on 16/5/27.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#ifndef CommenHeader_h
#define CommenHeader_h


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DeBugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog(...) NSLog(__VA_ARGS__);
#define MyNSLog(FORMAT, ...) fprintf(stderr,"[%s]:[line %d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(...)
#define DeBugLog(...)
#define NSLog(...)
#define MyNSLog(FORMAT, ...) nil
#endif

#endif /* CommenHeader_h */
