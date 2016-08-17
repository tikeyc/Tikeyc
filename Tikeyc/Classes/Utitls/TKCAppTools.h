//
//  TKCAppTools.h
//  TSMWSChart
//
//  Created by ways on 16/6/1.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>



@interface TKCAppTools : NSObject

/**
 *  获取磁盘总空间大小
 *
 *  @return 磁盘总空间
 */
+ (CGFloat)diskOfAllSizeMBytes;

/**
 *  获取磁盘可用空间大小
 *
 *  @return 磁盘可用空间
 */
+ (CGFloat)diskOfFreeSizeMBytes;


/**
 *  获取指定路径下某个文件的大小
 *
 *  @param filePath filePath description
 *
 *  @return 获取文件大小
 */
+ (long long)fileSizeAtPath:(NSString *)filePath;

/**
 *  获取文件夹下所有文件的大小
 *
 *  @param folderPath folderPath description
 *
 *  @return 获取文件夹下所有文件的大小
 */
+ (long long)folderSizeAtPath:(NSString *)folderPath;


/**
 *  获取字符串(或汉字)首字母
 *
 *  @param string string description
 *
 *  @return 字符串(或汉字)首字母
 */
+ (NSString *)firstCharacterWithString:(NSString *)string;


/**
 *  将字符串数组按照元素首字母顺序进行排序分组
 *  NSArray *arr = @[@"guangzhou", @"shanghai", @"北京", @"henan", @"hainan"];
 *  NSDictionary *dic = [Utilities dictionaryOrderByCharacterWithOriginalArray:arr];
 *  NSLog(@"\n\ndic: %@", dic);
 *
 *  @param array 字符串数组
 *
 *  @return 将字符串数组按照元素首字母顺序进行排序分组
 */
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array;


/**
 *  获取当前时间
 *
 *  @param format @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒" ...等
 *
 *  @return 当前时间
 */
+ (NSString *)currentDateWithFormat:(NSString *)format;


/**
 *  计算上次日期距离现在多久
 *  NSLog(@"\n\nresult: %@", [TKCAppTools timeIntervalFromLastTime:@"2016年06月01日 15:50"
 *  lastTimeFormat:@"yyyy年MM月dd日 HH:mm"
 *  ToCurrentTime:@"2015/12/08 16:12"
 *  currentTimeFormat:@"yyyy/MM/dd HH:mm"]);
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *  @param currentTime 最近日期(需要和格式对应)
 *  @param format2     最近日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     currentTimeFormat:(NSString *)format2;


/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param currentTime 最近日期(需要和格式对应)
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime ToCurrentTime:(NSDate *)currentTime;

/**
 *  判断手机号码格式是否正确
 *
 *  @param mobile 手机号
 *
 *  @return 手机号码格式是否正确
 */
+ (BOOL)valiMobile:(NSString *)mobile;

/**
 *  判断邮箱格式是否正确 利用正则表达式验证
 *
 *  @param email 邮箱
 *
 *  @return 邮箱格式是否正确
 */
+ (BOOL)isAvailableEmail:(NSString *)email;


/**
 *  将十六进制颜色转换为 UIColor 对象
 *
 *  @param color 十六进制字符串  “0X” 打头  or  “#” 打头
 *
 *  @return 十六进制颜色转换为 UIColor 对象
 */
+ (UIColor *)colorWithHexString:(NSString *)color;


/**
 *  绘制虚线
 *
 *  @param lineFrame 虚线的 frame
 *  @param length    虚线中短线的宽度
 *  @param spacing   虚线中短线之间的间距
 *  @param color     虚线中短线的颜色
 *
 *  @return 虚线View
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color;



/**  对图片进行滤镜处理
 *   怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
 *   黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
 *   色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
 *   岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
 *   CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
 *
 *  @param image image description
 *  @param name  name description
 *
 *  @return image
 */
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;




/**
 *  对图片进行模糊处理
 *  CIGaussianBlur ---> 高斯模糊
 *  CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
 *  CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
 *  CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
 *  CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
 
 *
 *  @param image  image description
 *  @param name   name description
 *  @param radius radius description
 *
 *  @return image
 */
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;


/**
 *  调整图片饱和度, 亮度, 对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度: -1.0 ~ 1.0
 *  @param contrast   对比度
 *
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;


/**
 *  创建一张实时模糊效果 View (毛玻璃效果)
 *
 *  @param frame frame description
 *
 *  @return UIVisualEffectView
 */
// NS_DEPRECATED(8_0, 8_0, 8_0, 8_0, "Avilable in iOS 8.0 and later")
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame __deprecated_msg("Avilable in iOS 8.0 and later");


/**
 *  全屏截图
 *
 *  @return screen image
 */
+ (UIImage *)shotScreen;


/**
 *  截取view生成一张图片
 *
 *  @param view view description
 *
 *  @return image
 */
+ (UIImage *)shotWithView:(UIView *)view;


/**
 *  截取view中某个区域生成一张图片
 *
 *  @param view  view description
 *  @param scope 需要截取的view中的某个区域frame
 *
 *  @return image
 */
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;


/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image image description
 *  @param size  size description
 *
 *  @return new image
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

/**
 *  压缩图片到指定文件大小
 *
 *  @param image image description
 *  @param size  size description
 *
 *  @return new image
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;



// 获取设备 IP 地址

/**
 *  获取设备 IP 地址
 *
 *  @return 设备 IP 地址
 */
+ (NSString *)getIPAddress;


/**
 *  判断字符串中是否含有空格
 *
 *  @param string string description
 *
 *  @return 字符串中是否含有空格
 */
- (BOOL)isHaveSpaceInString:(NSString *)string;

/**
 *  判断字符串中是否含有某个字符串
 *
 *  @param string1 判断对象字符串
 *  @param string2 判断条件字符串
 *
 *  @return 字符串中是否含有某个字符串
 */
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2;

/**
 *  判断字符串中是否含有中文
 *
 *  @param string string description
 *
 *  @return 字符串中是否含有中文
 */
+ (BOOL)isHaveChineseInString:(NSString *)string;


/**
 *  判断字符串是否全部为数字
 *
 *  @param string string description
 *
 *  @return 字符串是否全部为数字
 */
+ (BOOL)isAllNum:(NSString *)string;


@end



/************************************SystemInfo************************************/


#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"10.0"] != NSOrderedAscending)
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define IOS6_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending)
#define IOS5_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending)
#define IOS4_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending)
#define IOS3_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE_5 [SNSystemInfo is_iPhone_5];

@interface SystemInfo : NSObject

/*系统版本*/
+ (NSString*)osVersion;

/*硬件版本*/
+ (NSString*)platform;

/*硬件版本名称*/
+ (NSString*)platformString;

/*系统当前时间 格式：yyyy-MM-dd HH:mm:ss*/
+ (NSString*)systemTimeInfo;

/*软件版本*/
+ (NSString*)appVersion;

/*是否是iPhone5*/
+ (BOOL)is_iPhone_5;

/*是否越狱*/
//+ (BOOL)isJailBroken;

/*越狱版本*/
+ (NSString*)jailBreaker;

/*本地ip*/
//+ (NSString *)localIPAddress;

/** 获取运营商 */
+ (NSString*)getCarrierName;

/** UUID解决方案 */
//+ (NSString*)uuidSolution;



@end


/************************************Runtime************************************/

@interface TRuntimeHelper : NSObject

+ (instancetype)shareInstance;

/**
 *  提取对象的全部属性名
 */
- (NSArray*)extractPropertyNamesFromOjbect:(NSObject*)object;

/**
 *  提取对象的指定类名的全部属性值
 */
- (NSArray*)extractValuesFromObject:(NSObject*)object forPropertiesWithClass:(NSString*)className;

/**
 *  提取对象的指定协议的全部属性值
 */
- (NSArray*)extractValuesFromObject:(NSObject*)object forPropertiesWithProtocol:(NSString*)protocolName;

@end









