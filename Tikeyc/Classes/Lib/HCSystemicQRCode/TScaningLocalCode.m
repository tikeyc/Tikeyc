//
//  TScaningLocalCode.m
//  Tikeyc
//
//  Created by ways on 16/8/30.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TScaningLocalCode.h"

#import "SystemFunctions.h"

@implementation TScaningLocalCode


+ (NSMutableArray *)scanLocaImage:(UIImage *)image{
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    //2.从选中的图片中读取二维码数据
    //2.1创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    // 2.2利用探测器探测数据
    NSArray *feature = [detector featuresInImage:ciImage];
    
    // 2.3取出探测到的数据
    NSMutableArray *codeInfos = [NSMutableArray array];
    for (CIQRCodeFeature *result in feature) {
        NSString *urlStr = result.messageString;
        //二维码信息回传urlStr
        [codeInfos addObject:urlStr];
        //
        [SystemFunctions showInSafariWithURLMessage:urlStr Success:^(NSString *token) {
            
        } Failure:^(NSError *error) {
            
            [TAlertView showWithTitle:@"该信息无法跳转，详细信息为：" message:urlStr cancelButtonTitle:@"确定" otherButtonTitles:nil type:UIAlertControllerStyleAlert  andAction:^(NSInteger buttonIndex) {
                
            } andParentView:nil];
            
        }];
    }
    
    if (feature.count == 0) {
        [TAlertView showWithTitle:@"扫描结果" message:@"没有扫描到有效二维码" cancelButtonTitle:@"确定" otherButtonTitles:nil type:UIAlertControllerStyleAlert andAction:^(NSInteger buttonIndex) {
            
        } andParentView:nil];
    }
    
    return codeInfos;
}


@end
