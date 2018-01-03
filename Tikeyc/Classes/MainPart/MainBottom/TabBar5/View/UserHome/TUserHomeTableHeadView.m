//
//  TUserHomeTableHeadView.m
//  LoveShare
//
//  Created by ways on 2017/4/14.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TUserHomeTableHeadView.h"

#import "UIImage+Rotation.h"

@interface TUserHomeTableHeadView ()<UIImagePickerControllerDelegate>

@property (nonatomic,strong)UIImagePickerController *pickerController;

- (IBAction)userIconButtonAction:(UIButton *)sender;


@end

@implementation TUserHomeTableHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [TAlertView showWithTitle:nil message:@"跟换背景图片" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] type:UIAlertControllerStyleActionSheet andParentView:nil andAction:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            TWeakSelf(self)
            [TAlertView showWithTitle:nil
                              message:nil
                    cancelButtonTitle:@"取消"
                    otherButtonTitles:@[@"拍照",@"相册"]
                                 type:UIAlertControllerStyleActionSheet
                        andParentView:nil
                            andAction:^(NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    NSLog(@"取消");
                                } else if (buttonIndex == 1) {
                                    NSLog(@"拍照");
                                    [weakself takePhotoOrSelectedPhotosAlbumWithType:1];
                                } else if (buttonIndex == 2) {
                                    NSLog(@"相册");
                                    [weakself takePhotoOrSelectedPhotosAlbumWithType:2];
                                }
                            }];

        }
    }];
}

- (IBAction)userIconButtonAction:(UIButton *)sender {
    
}


//开始拍照
-(void)takePhotoOrSelectedPhotosAlbumWithType:(NSInteger)type
{
    UIImagePickerControllerSourceType sourceType;
    if (type == 1) {
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
            return;
        }
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
            NSLog(@"模拟失败");
            return;
        }
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.delegate = (id)self;
    }
    _pickerController.sourceType = sourceType;
    if (type == 1) {
        _pickerController.showsCameraControls = YES;
    }
    //
    [self.viewController presentViewController:_pickerController animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSLog(@"选择照片...");
    UIImage *original;
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if ([type isEqualToString:(NSString*)kUTTypeImage] && picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        //获取照片的原图
        original = [info objectForKey:UIImagePickerControllerOriginalImage];
        //        如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(original, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else if ([type isEqualToString:(NSString*)kUTTypeImage] && picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        //获取照片的原图
        original = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    // //////////////
    @weakify(self)
    [picker dismissViewControllerAnimated:YES completion:^() {
        @strongify(self)
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        portraitImg = [portraitImg imageByScalingToMaxSize];
        self.bgImageView.image = portraitImg;
        
    }];
    
    
}


//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"saved..");
    
}


@end
