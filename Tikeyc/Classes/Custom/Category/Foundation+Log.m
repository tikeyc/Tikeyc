//
//  Foundation+Log.m
//  Tikeyc
//
//  Created by ways on 2016/11/8.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>


@implementation NSDictionary (Log)


- (NSString *)descriptionWithLocale:(id)locale
{
    // 遍历数组中的所有内容，将内容拼接成一个新的字符串返回
    NSMutableString *strM = [NSMutableString string];
    
    [strM appendString:@"{\n"];
    
    // 遍历字典的所有键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        // 在拼接字符串时，会调用obj的description方法
        [strM appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [strM appendString:@"}"];
    
    // 查出最后一个,的范围
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [strM deleteCharactersInRange:range];
    }
    
    return strM;
}


@end





@implementation NSArray (Log)


- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString string];
    
    [strM appendString:@"[\n"];
    
    // 遍历数组的所有元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"%@,\n", obj];
    }];
    
    [strM appendString:@"]"];
    
    // 查出最后一个,的范围
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [strM deleteCharactersInRange:range];
    }
    
    return strM;
}



@end





