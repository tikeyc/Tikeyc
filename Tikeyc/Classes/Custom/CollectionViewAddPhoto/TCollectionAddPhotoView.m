//
//  TCollectionAddPhotoView.m
//  LoveShare
//
//  Created by ways on 2017/4/28.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TCollectionAddPhotoView.h"

#import "TImageCropperViewController.h"
#import "TAddPhotoViewCell.h"
#import "UIImage+Rotation.h"

static NSString *itemIndentifier = @"TAddPhotoViewCell";

@interface TCollectionAddPhotoView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TImageCropperDelegate>

@property (nonatomic,strong)UIImagePickerController *pickerController;

@end

@implementation TCollectionAddPhotoView

+ (instancetype)loadFromNib {
    TCollectionAddPhotoView *view = [[[NSBundle mainBundle] loadNibNamed:@"TCollectionAddPhotoView" owner:self options:NULL] lastObject];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperty];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initProperty];
}

#pragma set 

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *collectionViewLayout = [TCollectionAddPhotoView getFlowLayout];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
    return _collectionView;
}

#pragma mark - init

- (void)initProperty {
    _selectedPhotos = [NSMutableArray array];
    UIImage *addImage = [UIImage imageNamed:@"上传照片_nor_50x50_"];
    [_selectedPhotos addObject:addImage];
    //
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.collectionView.scrollEnabled = NO;
    //
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //
    [self.collectionView registerNib:[UINib nibWithNibName:@"TAddPhotoViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:itemIndentifier];
    //
}

+ (UICollectionViewFlowLayout *)getFlowLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(TScreenWidth/4, 100);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    
    return layout;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TAddPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIndentifier forIndexPath:indexPath];
    
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == _selectedPhotos.count - 1) {
        
        cell.deleteButton.hidden = YES;
    } else {
        
        cell.deleteButton.hidden = NO;
    }
    
    cell.imageView.image = _selectedPhotos[indexPath.row];
    
    return cell;
}



#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    TAddPhotoViewCell *cell = (TAddPhotoViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.deleteButton.hidden) {
        NSLog(@"添加图片");
        
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
        
    } else {
        NSLog(@"放大查看图片");
    }
    
}

#pragma mark - Actions Mehtod

- (void)deleteButtonAction:(UIButton *)button {
    NSLog(@"删除图片");
    [self.selectedPhotos removeObjectAtIndex:button.tag];
    [self.collectionView reloadData];
}

//开始拍照
-(void)takePhotoOrSelectedPhotosAlbumWithType:(NSInteger)type
{
    UIImagePickerControllerSourceType sourceType;
    if (type == 1) {
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"模拟其中无法打开照相机,请在真机中使用");
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
    TWeakSelf(self)
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        portraitImg = [portraitImg imageByScalingToMaxSize];
        // 裁剪
        TImageCropperViewController *imgEditorVC = [[TImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake((TScreenWidth - 300)/2, (TScreenHeight - 300)/2, 300, 300) limitScaleRatio:3.0];
        imgEditorVC.delegate = (id)self;
        //    [self presentViewController:imgEditorVC animated:YES completion:^{
        // TO DO
        //    }];
        [self.viewController.navigationController pushViewController:imgEditorVC animated:YES];
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

#pragma mark - ORCImageCropperDelegate
- (void)imageCropper:(TImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [_selectedPhotos insertObject:editedImage atIndex:0];
    [self.collectionView reloadData];
    //    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    //        // TO DO
    //    }];
}

- (void)imageCropperDidCancel:(TImageCropperViewController *)cropperViewController {
    //    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    //    }];
}


@end








