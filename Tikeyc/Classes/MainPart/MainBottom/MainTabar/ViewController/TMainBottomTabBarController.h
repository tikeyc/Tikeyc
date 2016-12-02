//
//  TMainBottomTabBarController.h
//  Tikeyc
//
//  Created by ways on 2016/11/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TBaseTabBarViewController.h"

#import "TMainBottomTabBarButton.h"

@interface TMainBottomTabBarController : TBaseTabBarViewController


@property (nonatomic,strong)NSMutableArray *tabBarItems;
@property (nonatomic,strong)TMainBottomTabBarButton *lastSelectedTabButton;
@property (nonatomic,strong)TMainBottomTabBarButton *lastLastSelectedTabButton;

//- (void)tabBarItemClick:(TMainBottomTabBarButton *)control;

@end
