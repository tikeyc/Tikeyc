//
//  TNotificationDefine.h
//  Tikeyc
//
//  Created by ways on 16/8/17.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#ifndef TNotificationDefine_h
#define TNotificationDefine_h


#define TNotificationCenter [NSNotificationCenter defaultCenter]

/*在TMainViewController中添加的top center bottom 控制器，当处于top和bottom中时滑动显示menu点击后push，左右滑动手势将禁止（返回跟控制器后打开），使用的是当前centerSelectedVC显示的NAV去push的
 *因此viwWillAppear和viewWillDisappear方法只会在当前显示的中间控制器中调用。如处于top滑动menu点击push，将调用【top.nav push:next】
 *而左右滑动手势在TMainViewController访问，在top和bottom中较难访问(需要设置多个属性传递)
 *当top center bottom的viewControllers.count >= 2是左右滑动禁止，返回根控制器时打开
 *综上所述所以使用通知
 
 *
 *直接使用[self.mainMenuViewController removePanGestureRecognizerTarget:NO];有bug
 *因为是在viewWillAppear和viewWillDisappear中判断menu滑动显示menu手势，先滑动后使用的是系统滑动返回手势，显示一点点上一层级的控制器才判断和设置menu_pan的enable。
 *需要毫秒级的时间差来过度，不然偶尔会出现始终可以滑动显示menu
 */
#define TNotificationName_Set_menuPanEnable @"TNotificationName_Set_menuPanEnable"


#endif /* TNotificationDefine_h */
