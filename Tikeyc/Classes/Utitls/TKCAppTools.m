//
//  TKCAppTools.m
//  TSMWSChart
//
//  Created by ways on 16/6/1.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TKCAppTools.h"

////获取设备 IP 地址
#import <ifaddrs.h>
#import <arpa/inet.h>


@implementation TKCAppTools

#pragma mark 度转弧度
+ (float)huDuFromdu:(float)du
{
    return M_PI/(180/du);
}

#pragma mark 计算sin
+ (float)sin:(float)du
{
    return sinf([TKCAppTools huDuFromdu:du]);
}

#pragma mark 计算cos
+ (float)cos:(float)du
{
    return cosf([TKCAppTools huDuFromdu:du]);
}

/**
 拨打电话

 @param phoneNum        电话号码
 @param telephoningType 拨打类型 见TKCTelephoningType
 */
+ (void)userTelephoningNum:(NSString *)phoneNum type:(TKCTelephoningType)telephoningType{

    switch (telephoningType) {
        case TKCTelephoningTypeApplicationWebView:
        {
            phoneNum = [@"tel:" stringByAppendingString:phoneNum];
            //
            UIWebView *webView = [[UIWebView alloc] init];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNum]]];
            [[UIApplication sharedApplication].keyWindow addSubview:webView];
        }
            break;
        case TKCTelephoningTypeApplication:
        {
            phoneNum = [@"tel:" stringByAppendingString:phoneNum];
            //
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
        }
            break;
        case TKCTelephoningTypeApplicationTelprompt:
        {
            phoneNum = [@"telprompt://" stringByAppendingString:phoneNum];
            //
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
        }
            break;
            
        default:
            break;
    }

}


/**
 *  获取磁盘总空间大小
 *
 *  @return 磁盘总空间
 */
+ (CGFloat)diskOfAllSizeMBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"error: %@", error.localizedDescription);
#endif
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}


/**
 *  获取磁盘可用空间大小
 *
 *  @return 磁盘可用空间
 */
+ (CGFloat)diskOfFreeSizeMBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"error: %@", error.localizedDescription);
#endif
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemFreeSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}


/**
 *  获取指定路径下某个文件的大小
 *
 *  @param filePath filePath description
 *
 *  @return 获取文件大小
 */
+ (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) return 0;
    return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
}


/**
 *  获取文件夹下所有文件的大小
 *
 *  @param folderPath folderPath description
 *
 *  @return 获取文件夹下所有文件的大小
 */
+ (long long)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *filesEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folerSize = 0;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folerSize += [self fileSizeAtPath:filePath];
    }
    return folerSize;
}



/**
 *  获取字符串(或汉字)首字母
 *
 *  @param string string description
 *
 *  @return 字符串(或汉字)首字母
 */
+ (NSString *)firstCharacterWithString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pingyin = [str capitalizedString];
    return [pingyin substringToIndex:1];
}





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
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array{
    if (array.count == 0) {
        return nil;
    }
    for (id obj in array) {
        if (![obj isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:indexedCollation.sectionTitles.count];
    //创建27个分组数组
    for (int i = 0; i < indexedCollation.sectionTitles.count; i++) {
        NSMutableArray *obj = [NSMutableArray array];
        [objects addObject:obj];
    }
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:objects.count];
    //按字母顺序进行分组
    NSInteger lastIndex = -1;
    for (int i = 0; i < array.count; i++) {
        NSInteger index = [indexedCollation sectionForObject:array[i] collationStringSelector:@selector(uppercaseString)];
        [[objects objectAtIndex:index] addObject:array[i]];
        lastIndex = index;
    }
    //去掉空数组
    for (int i = 0; i < objects.count; i++) {
        NSMutableArray *obj = objects[i];
        if (obj.count == 0) {
            [objects removeObject:obj];
        }
    }
    //获取索引字母
    for (NSMutableArray *obj in objects) {
        NSString *str = obj[0];
        NSString *key = [self firstCharacterWithString:str];
        [keys addObject:key];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:objects forKey:keys];
    return dic;
}



/**
 *  获取当前时间
 *
 *  @param format @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒" ...等
 *
 *  @return 当前时间
 */
+ (NSString *)currentDateWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}


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
                     currentTimeFormat:(NSString *)format2{
    //上次时间
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    dateFormatter1.dateFormat = format1;
    NSDate *lastDate = [dateFormatter1 dateFromString:lastTime];
    //当前时间
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    dateFormatter2.dateFormat = format2;
    NSDate *currentDate = [dateFormatter2 dateFromString:currentTime];
    return [TKCAppTools timeIntervalFromLastTime:lastDate ToCurrentTime:currentDate];
}
/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param currentTime 最近日期(需要和格式对应)
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime ToCurrentTime:(NSDate *)currentTime{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    //上次时间
    NSDate *lastDate = [lastTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:lastTime]];
    //当前时间
    NSDate *currentDate = [currentTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:currentTime]];
    //时间间隔
    NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];
    
    //秒、分、小时、天、月、年
    NSInteger minutes = intevalTime / 60;
    NSInteger hours = intevalTime / 60 / 60;
    NSInteger day = intevalTime / 60 / 60 / 24;
    NSInteger month = intevalTime / 60 / 60 / 24 / 30;
    NSInteger yers = intevalTime / 60 / 60 / 24 / 365;
    
    if (minutes <= 10) {
        return  @"刚刚";
    }else if (minutes < 60){
        return [NSString stringWithFormat: @"%ld分钟前",(long)minutes];
    }else if (hours < 24){
        return [NSString stringWithFormat: @"%ld小时前",(long)hours];
    }else if (day < 30){
        return [NSString stringWithFormat: @"%ld天前",(long)day];
    }else if (month < 12){
        NSDateFormatter * df =[[NSDateFormatter alloc]init];
        df.dateFormat = @"M月d日";
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }else if (yers >= 1){
        NSDateFormatter * df =[[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy年M月d日";
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }
    return @"";
}


/**
  判断身份证格式是否真确

 @param identityCard 身份证
 @return 身份证格式是否真确
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard {
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


/**
 *  判断手机号码格式是否正确
 *
 *  @param mobile 手机号
 *
 *  @return 手机号码格式是否正确
 */
+ (BOOL)valiMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}


/**
 *  判断邮箱格式是否正确 利用正则表达式验证
 *
 *  @param email 邮箱
 *
 *  @return 邮箱格式是否正确
 */
+ (BOOL)isAvailableEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



/**
 *  将十六进制颜色转换为 UIColor 对象
 *
 *  @param color 十六进制字符串  “0X” 打头  or  “#” 打头
 *
 *  @return 十六进制颜色转换为 UIColor 对象
 */
+ (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


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
                            lineColor:(UIColor *)color{
    UIView *dashedLine = [[UIView alloc] initWithFrame:lineFrame];
    dashedLine.backgroundColor = [UIColor clearColor];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:dashedLine.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(dashedLine.frame) / 2, CGRectGetHeight(dashedLine.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(dashedLine.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:length], [NSNumber numberWithInt:spacing], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(dashedLine.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [dashedLine.layer addSublayer:shapeLayer];
    return dashedLine;
}


/**  通过图片Data数据第一个字节 来获取图片扩展名
 *
 *   假设这是一个网络获取的URL
 *   NSString *path = @"http://pic3.nipic.com/20090709/2893198_075124038_2.gif";
 *   判断是否为gif  此方法存在BUG
 *   NSString *extensionName = path.pathExtension;
 *   if ([extensionName.lowercaseString isEqualToString:@"gif"]) {
 *       是gif图片
 *   } else {
 *       不是gif图片
 *   }
 *  @param data  name description
 *
 *  @return string
 */
- (NSString *)contentTypeForImageData:(NSData *)data {
    
    //////////////下面方法无BUG
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

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
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}


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
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter;
    if (name.length != 0) {
        filter = [CIFilter filterWithName:name];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        if (![name isEqualToString:@"CIMedianFilter"]) {
            [filter setValue:@(radius) forKey:@"inputRadius"];
        }
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return resultImage;
    }else{
        return nil;
    }
}


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
                                   contrast:(CGFloat)contrast{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    [filter setValue:@(brightness) forKey:@"inputBrightness"];
    [filter setValue:@(contrast) forKey:@"inputContrast"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}



/**
 *  创建一张实时模糊效果 View (毛玻璃效果)
 *
 *  @param frame frame description
 *
 *  @return UIVisualEffectView
 */
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame NS_DEPRECATED(8_0, 8_0, 8_0, 8_0, "Avilable in iOS 8.0 and later"){
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    return effectView;
}


/**
 *  全屏截图
 *
 *  @return screen image
 */
+ (UIImage *)shotScreen{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContext(window.bounds.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 *  截取view生成一张图片
 *
 *  @param view view description
 *
 *  @return image
 */
+ (UIImage *)shotWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 设置圆形图片*/
+ (UIImage *)cutCircleImage:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    // 获取上下文
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    // 设置圆形
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextAddEllipseInRect(ctr, rect);
    // 裁剪
    CGContextClip(ctr);
    // 将图片画上去
    [image drawInRect:rect];
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImage;
}


/**
 *  把view设置成圆形
 *
 *  @param view 需要设置成圆形的view
 */
+ (void)setViewCornerCircleWithView:(UIView *)view{
    //
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:view.bounds.size.width/2];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}
/**
 *  把view设置圆角
 *
 *  @param view 需要设置成圆形的view
 *  @param rectCorner 需要设置的边rectCorner
 *  @param size 需要设置大小size
 */
+ (void)setCornerWithView:(UIView *)view byRoundingCorners:(UIRectCorner)rectCorner cornerRadii:(CGSize)size{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

/**
 *  截取view中某个区域生成一张图片
 *
 *  @param view  view description
 *  @param scope 需要截取的view中的某个区域frame
 *
 *  @return image
 */
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self shotWithView:view].CGImage, scope);
    UIGraphicsBeginImageContext(scope.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return image;
}


/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image image description
 *  @param size  size description
 *
 *  @return new image
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage *resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return resultImage;
}


/**
 *  压缩图片到指定文件大小
 *
 *  @param image image description
 *  @param size  size description
 *
 *  @return new image
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length/1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}


// 获取设备 IP 地址

/**
 *  获取设备 IP 地址
 *
 *  @return 设备 IP 地址
 */
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

/**
 *  判断字符串中是否含有空格
 *
 *  @param string string description
 *
 *  @return 字符串中是否含有空格
 */
- (BOOL)isHaveSpaceInString:(NSString *)string{
    NSRange _range = [string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

/**
 *  判断字符串中是否含有某个字符串
 *
 *  @param string1 判断对象字符串
 *  @param string2 判断条件字符串
 *
 *  @return 字符串中是否含有某个字符串
 */
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2{
    NSRange _range = [string2 rangeOfString:string1];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

/**
 *  判断字符串中是否含有中文
 *
 *  @param string string description
 *
 *  @return 字符串中是否含有中文
 */
+ (BOOL)isHaveChineseInString:(NSString *)string{
    for(NSInteger i = 0; i < [string length]; i++){
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}


/**
 *  判断字符串是否全部为数字
 *
 *  @param string string description
 *
 *  @return 字符串是否全部为数字
 */
+ (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
    /*
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([str rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        // 是数字
    } else
    {
        // 不是数字
    }*/
}


/**
 强制旋转设配的屏幕方向 使用此法（setValue：forKey：）目前为止上架不会被拒。但直接点语法设置上架会被拒
 
 *如果是第一次设置需要先设置一次正向
 *再设置希望的方向
 *不然存在BUG：当横着屏幕push进当前控制器时，第一次进来视图不会旋转至横屏状态。但当pop后再push进来视图却又可以旋转至横屏状态了
 
 @param deviceOrientation 旋转方向
 */
+ (void)constraintRotationDeviceWithUIDeviceOrientation:(UIDeviceOrientation)deviceOrientation{
    
    NSNumber *orientation = [NSNumber numberWithInt:deviceOrientation];
    [[UIDevice currentDevice] setValue:orientation forKey:@"orientation"];
}

/**
 数组排序
 
 @param dicArray 需要排序的数组
 @param key 按数组中的对象的那个属性来排序
 @param yesOrNo 升序还是降序
 @return 返回排序后的数组
 */
+ (NSMutableArray *) changeArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo{
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:yesOrNo];
    NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
    [dicArray sortUsingDescriptors:descriptors];
    return dicArray;
}


/**
 打开iPhone设置对应界面
 */
+ (void)openiPhomeSettingUI {
    // 打开设置->通用
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General"]];
    
    // 以下是设置其他界面
    /*
    prefs:root=General&path=About
    prefs:root=General&path=ACCESSIBILITY
    prefs:root=AIRPLANE_MODE
    prefs:root=General&path=AUTOLOCK
    prefs:root=General&path=USAGE/CELLULAR_USAGE
    prefs:root=Brightness
    prefs:root=Bluetooth
    prefs:root=General&path=DATE_AND_TIME
    prefs:root=FACETIME
    prefs:root=General
    prefs:root=General&path=Keyboard
    prefs:root=CASTLE
    prefs:root=CASTLE&path=STORAGE_AND_BACKUP
    prefs:root=General&path=INTERNATIONAL
    prefs:root=LOCATION_SERVICES
    prefs:root=ACCOUNT_SETTINGS
    prefs:root=MUSIC
    prefs:root=MUSIC&path=EQ
    prefs:root=MUSIC&path=VolumeLimit
    prefs:root=General&path=Network
    prefs:root=NIKE_PLUS_IPOD
    prefs:root=NOTES
    prefs:root=NOTIFICATIONS_ID
    prefs:root=Phone
    prefs:root=Photos
    prefs:root=General&path=ManagedConfigurationList
    prefs:root=General&path=Reset
    prefs:root=Sounds&path=Ringtone
    prefs:root=Safari
    prefs:root=General&path=Assistant
    prefs:root=Sounds
    prefs:root=General&path=SOFTWARE_UPDATE_LINK
    prefs:root=STORE
    prefs:root=TWITTER
    prefs:root=FACEBOOK
    prefs:root=General&path=USAGE prefs:root=VIDEO
    prefs:root=General&path=Network/VPN
    prefs:root=Wallpaper
    prefs:root=WIFI
    prefs:root=INTERNET_TETHERING
    prefs:root=Phone&path=Blocked
    prefs:root=DO_NOT_DISTURB
     */
}


/**
 textField需要设置的textField，index要设置的光标位置

 @param textField textField
 @param index 光标位置
 */
+ (void)cursorLocation:(UITextField *)textField index:(NSInteger)index
{
    NSRange range = NSMakeRange(index, 0);
    UITextPosition *start = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    [textField setSelectedTextRange:[textField textRangeFromPosition:start toPosition:end]];
}


/**
 去除webView底部黑色

 @param webView webView
 */
+ (void)clearBottomBlackImageViewWithWebView:(UIWebView *)webView {
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    
    for (UIView *v1 in [webView subviews])
    {
        if ([v1 isKindOfClass:[UIScrollView class]])
        {
            for (UIView *v2 in v1.subviews)
            {
                if ([v2 isKindOfClass:[UIImageView class]])
                {
                    v2.hidden = YES;
                }
            }
        }
    }
}


@end


/************************************SystemInfo************************************/

#include <arpa/inet.h>
#include <errno.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/sockio.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <unistd.h>
//#import "IPAddress.h"

@implementation SystemInfo

+ (NSString*)osVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char* machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString* platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString*)platformString
{
    NSString* platform = [self platform];
    
    if ([platform isEqualToString:@"iPhone1,1"])
        return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"])
        return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"])
        return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"])
        return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"])
        return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"])
        return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"])
        return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"])
        return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"])
        return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"])
        return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"])
        return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"])
        return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"])
        return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"])
        return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"])
        return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])
        return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])
        return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])
        return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])
        return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])
        return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])
        return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])
        return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])
        return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])
        return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])
        return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])
        return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])
        return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])
        return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])
        return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])
        return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])
        return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])
        return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])
        return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])
        return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])
        return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])
        return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])
        return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])
        return @"iPhone Simulator";
    
    return platform;
}

//获取系统当前时间
+ (NSString*)systemTimeInfo
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateString;
}

+ (NSString*)appVersion
{
    NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@", version];
}

+ (BOOL)is_iPhone_5
{
    if ([UIScreen mainScreen].bounds.size.height == 568.0f) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark -
#pragma mark jailbreaker

static const char* __jb_app = NULL;

#if 0
+ (BOOL)isJailBroken
{
    static const char* __jb_apps[] = {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    __jb_app = NULL;
    
    // method 1
    for (int i = 0; __jb_apps[i]; ++i) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]]) {
            __jb_app = __jb_apps[i];
            return YES;
        }
    }
    
    // method 2
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"]) {
        return YES;
    }
    
    // method 3
    if (0 == system("ls")) {
        return YES;
    }
    
    return NO;
}
#endif

+ (NSString*)jailBreaker
{
    if (__jb_app) {
        return [NSString stringWithUTF8String:__jb_app];
    }
    else {
        return @"";
    }
}

//+ (NSString *)localIPAddress
//{
//    InitAddresses();
//
//    GetIPAddresses();
//
//    GetHWAddresses();
//
//    return [NSString stringWithFormat:@"%s", ip_names[1]];
//}

+ (NSString*)getCarrierName
{
    CTTelephonyNetworkInfo* telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = [telephonyInfo subscriberCellularProvider];
    return [carrier carrierName];
}

//+ (NSString*)uuidSolution
//{
//    NSUUID* uuid = [[UIDevice currentDevice] identifierForVendor];
//    NSString* uuidString = [uuid UUIDString];
//    uuidString = [SFHFKeychainUtils getPasswordForUsername:kKeyChainUUIDKey andServiceName:kKeyChainGroupKey error:nil];
//
//    if (!uuidString) {
//        uuidString = [self uuidString];
//        [SFHFKeychainUtils storeUsername:kKeyChainUUIDKey andPassword:uuidString forServiceName:kKeyChainGroupKey updateExisting:NO error:nil];
//    }
//    return uuidString;
//}
//
//+ (NSString*)uuidString
//{
//    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
//    CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
//    NSString* uuidstring = (__bridge NSString*)(stringRef);
//    CFRelease(uuidRef);
//    return uuidstring;
//}

@end


/************************************Runtime************************************/


#import <objc/runtime.h>

@implementation TRuntimeHelper

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSArray*)extractPropertyNamesFromOjbect:(NSObject*)object
{
    NSMutableArray* propertyNames = [NSMutableArray array];
    
    unsigned int outCount;
    objc_property_t* properties = class_copyPropertyList([object class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        [propertyNames addObject:[NSString stringWithUTF8String:property_getName(property)]];
    }
    
    free(properties);
    
    return [propertyNames copy];
}

- (NSArray*)extractValuesFromObject:(NSObject*)object forPropertiesWithClass:(NSString*)className
{
    NSArray* propertyNames = [self extractPropertyNamesFromOjbect:object];
    NSMutableArray* propertyValues = [NSMutableArray array];
    
    for (NSString* property in propertyNames) {
        id value = [object valueForKey:property];
        
        if ([value isKindOfClass:(NSClassFromString(className))]) {
            [propertyValues addObject:value];
        }
    }
    return [propertyValues copy];
}

- (NSArray*)extractValuesFromObject:(NSObject*)object forPropertiesWithProtocol:(NSString*)protocolName
{
    NSArray* propertyNames = [self extractPropertyNamesFromOjbect:object];
    NSMutableArray* propertyValues = [NSMutableArray array];
    
    for (NSString* property in propertyNames) {
        id value = [object valueForKey:property];
        
        if ([value conformsToProtocol:(NSProtocolFromString(protocolName))]) {
            [propertyValues addObject:value];
        }
    }
    return [propertyValues copy];
}

@end










