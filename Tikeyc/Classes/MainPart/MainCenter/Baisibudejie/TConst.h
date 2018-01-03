//
//  TConst.h
//  Tikeyc
//
//  Created by ways on 2017/5/12.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JYJExtensions.h"

/** tabBar的高度 */
UIKIT_EXTERN CGFloat const JYJTabBarH;

/** navigationBar的高度 */
UIKIT_EXTERN CGFloat const JYJNavigationBarH;

/** tabBar + navigationBar 的高度 */
UIKIT_EXTERN CGFloat const JYJTabBarAddNavBarH;

/** 首页标题的高度 */
UIKIT_EXTERN CGFloat const JYJTitilesViewH;

/** 精华-cell-间距 */
UIKIT_EXTERN CGFloat const JYJTopicCellMargin;
/** 精华-cell-文字内容的Y值 */
UIKIT_EXTERN CGFloat const JYJTopicCellTextY;
/** 精华-cell-底部工具条的高度 */
UIKIT_EXTERN CGFloat const JYJTopicCellBottomBarH;

/** 精华-cell-图片帖子的最大高度 */
UIKIT_EXTERN CGFloat const JYJTopicCellPictureMaxH;
/** 精华-cell-图片帖子一旦超过最大高度,就是用Break */
UIKIT_EXTERN CGFloat const JYJTopicCellPictureBreakH;

/** XMGUser模型-性别属性值 */
UIKIT_EXTERN NSString * const JYJGUserSexMale;
UIKIT_EXTERN NSString * const JYJGUserSexFemale;

/** 精华-cell-最热评论标题的高度 */
UIKIT_EXTERN CGFloat const JYJTopicCellTopCmtTitleH;

/** tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const JYJTabBarDidSelectNotification ;
/** tabBar被选中的通知 - 被选中的控制器的index key */
UIKIT_EXTERN NSString * const JYJSelectedControllerIndexKey;
/** tabBar被选中的通知 - 被选中的控制器 key */
UIKIT_EXTERN NSString * const JYJSelectedControllerKey;

/** 标签-间距 */
UIKIT_EXTERN CGFloat const JYJTagMargin;
/** 标签-高度 */
UIKIT_EXTERN CGFloat const JYJTagH;



/**
 *  弱引用
 */
#define JYJWeakSelf __weak typeof(self) weakSelf = self

#define JYJNoteCenter [NSNotificationCenter defaultCenter]
#define JYJUserDefaults [NSUserDefaults standardUserDefaults]

#define JYJScreenH [UIScreen mainScreen].bounds.size.height
#define JYJScreenW [UIScreen mainScreen].bounds.size.width
#define JYJScreenBounds [UIScreen mainScreen].bounds
#define JYJKeyWindow [UIApplication sharedApplication].keyWindow
#define JYJRootTabBarController (UITabBarController *)JYJKeyWindow.rootViewController


/**
 沙盒路径
 */
#define JYJCaches [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


// 随机色
#define JYJRandomColor JYJColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 设置颜色
#define JYJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define JYJColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
//保单显示文字颜色
#define The_Prompt_Color_Nine [[UIColor alloc]initWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
#define The_Prompt_Color_Six [[UIColor alloc]initWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]
#define The_Prompt_Color_Three [[UIColor alloc]initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]

#define The_MainColor JYJColor(58, 149, 252)
#define JYJGlobalBg JYJColor(223, 223, 223)

#define JYJTagBg JYJColor(74, 139, 209)

#define JYJTagFont [UIFont systemFontOfSize:14]

// 自定义log
#ifdef DEBUG

#define JYJLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#define JYJLogFunc NSLog(@"%s %d", __func__, __LINE__)

#else

#define JYJLog(...)

#define JYJLogFunc

#endif


@interface TConst : NSObject




@end
