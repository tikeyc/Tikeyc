//
//  TLiveListViewModel.h
//  Tikeyc
//
//  Created by ways on 16/9/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLiveListViewModel : NSObject


@property (nonatomic,strong)RACCommand *requestCommand;

@property (nonatomic,strong)NSMutableArray *liveListModels;

@end
