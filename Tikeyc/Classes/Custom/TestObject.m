//
//  TestObject.m
//  Tikeyc
//
//  Created by ways on 2017/3/6.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject


- (instancetype)init
{
    self = [super init];
    if (self) {
        TestObject<NSString *> *test = [[TestObject alloc] init];
        test.type = @"type";
    }
    return self;
}

@end
