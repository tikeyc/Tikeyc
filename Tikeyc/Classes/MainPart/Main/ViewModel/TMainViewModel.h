//
//  TMainViewModel.h
//  Tikeyc
//
//  Created by ways on 16/9/6.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TNormalRefreshHead.h"


#define ScrollDown_toShow_topVC_OffsetValue - 140
#define ScrollUp_toShow_bottomVC_OffsetValue 80

typedef enum : NSUInteger {
    TMainVCChildVCIndexValueTop = 0,
    TMainVCChildVCIndexValueCenter,
    TMainVCChildVCIndexValueBottom,
} TMainVCChildVCIndexValue;

@class TMainViewController;

@interface TMainViewModel : NSObject

@property (nonatomic,strong)NSMutableArray *scrollViewArrays;

/*TMainViewController.view添加了topVC centerVC bottomVC的结构
 *selectedIndex表示当前显示的索引
 */
//@property (nonatomic,assign)NSInteger selectedIndex;
//@property (nonatomic,strong)UIViewController *selectedViewController;

- (void)creatTopCenterBottomViewControllerToAddViewController:(TMainViewController *)viewController;

@end
