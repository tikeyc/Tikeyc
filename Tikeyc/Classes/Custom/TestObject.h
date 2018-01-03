//
//  TestObject.h
//  Tikeyc
//
//  Created by ways on 2017/3/6.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

//
/**
 自定义泛型
 TestObject类有一个属性 type 这个属性类型是不确定的
 
 TestObject<NSString *> *test = [[TestObject alloc] init];
 test.type = @"type";
 `
 */
@interface TestObject<AnyObjectType> : NSObject

@property (nonatomic,strong) AnyObjectType type;


@property (nonatomic, strong) NSMutableArray<NSString *> * names;

@end
