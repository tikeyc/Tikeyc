//
//  TShowListImageCollectionViewController.m
//  LoveShare
//
//  Created by ways on 2017/5/10.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TShowListImageCollectionViewController.h"

#import "UIView+Extension.h"

///////
static NSString *imageListCollectionCellIdentifier = @"imageListCollectionCell";

@interface TImageListCollectionCell : UICollectionViewCell

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nullable,nonatomic,strong)UIImageView *imageView;

@end

@interface TImageListCollectionCell ()<UIScrollViewDelegate>

@end

@implementation TImageListCollectionCell

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0;
        [_scrollView setZoomScale:1.0];
        [self.contentView addSubview:_scrollView];
        _scrollView.frame = CGRectMake(0, 0, TScreenWidth, TScreenHeight);
//        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@0);
//            make.top.equalTo(@0);
//            make.right.equalTo(@0);
//            make.bottom.equalTo(@0);
//        }];
        //
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_imageView];
        _imageView.frame = CGRectMake(0, 0, TScreenWidth, TScreenHeight);
//        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@0);
//            make.top.equalTo(@0);
//            make.right.equalTo(@0);
//            make.bottom.equalTo(@0);
//        }];
        //
        @weakify(self)
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(UILongPressGestureRecognizer  *_Nonnull sender) {
            @strongify(self)
            if (sender.state == UIGestureRecognizerStateBegan) {
//                UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
            
        }];
        longPress.minimumPressDuration = 1.0;
        [_imageView addGestureRecognizer:longPress];
    }
    return self;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
//    } else {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
//    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    
}

@end
///////

@interface TShowListImageCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

//用于还原上次放大的图片
@property (nonatomic, strong)TImageListCollectionCell *lastImageListCollectionCell;

@end

@implementation TShowListImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.view.backgroundColor = [UIColor blackColor];
    [self initProperty];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    if (_is3DTouch) {
        self.collectionView.hidden = NO;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showListImageIs3DTouch:(BOOL)is3DTouch {

    if (is3DTouch) {
        NSLog(@"showListImageIs3DTouch");
        _is3DTouch = is3DTouch;
        self.animationImageView.frame = CGRectMake(0, 0 - (20 + kAppNavigationBarHeight), self.view.frame.size.width, self.view.frame.size.height);
        self.animationImageView.hidden = YES;
        self.collectionView.hidden = YES;//在viewDidAppear中显示，
        //[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];在viewDidAppear中移动，不然轻度按压时滑到制定位置，这是BUG？
    } else {
        self.collectionView.hidden = YES;
        self.pageControl.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.animationImageView.frame = self.view.window.frame;
        } completion:^(BOOL finished) {
            self.animationImageView.hidden = YES;
            self.collectionView.hidden = NO;
            self.pageControl.hidden = NO;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }];
    }
    
    
}

- (void)hiddenListImage {
    if (_showListImageVCBlock) {
        _showListImageVCBlock(-1);//如果是-1表示缩小图片
    }
    
    self.animationImageView.image = [UIImage imageNamed:_showImages[_currentIndex]];
    self.animationImageView.hidden = NO;
    self.collectionView.hidden = YES;
    self.pageControl.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        NSString *converFrameString;
        if (self.converFrames) {
            converFrameString = [self.converFrames objectAtIndex:self.currentIndex];
        }else converFrameString = NSStringFromCGRect(self.converFrame);
        self.animationImageView.frame = CGRectFromString(converFrameString);//self.converFrame;
    } completion:^(BOOL finished) {
        [self.animationImageView removeFromSuperview];
        self.animationImageView = nil;
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
        [self.view removeFromSuperview];
        self.view = nil;
    }];
    
}

#pragma mark - init

- (void)setShowImages:(NSArray *)showImages {
    _showImages = showImages;
    
    self.pageControl.numberOfPages = _showImages.count;
    self.pageControl.currentPage = self.currentIndex;
}

- (void)initProperty {
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self collectionView];
    [self animationImageView];
    [self pageControl];
}


- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(TScreenWidth, TScreenHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        //
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor blackColor];
        [self.collectionView registerClass:[TImageListCollectionCell class] forCellWithReuseIdentifier:imageListCollectionCellIdentifier];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
    return _collectionView;
}


- (UIImageView *)animationImageView {
    if (_animationImageView == nil) {
        _animationImageView = [[UIImageView alloc] initWithImage:self.currentImage];
        if (_is3DTouch) {
            _animationImageView.backgroundColor = [UIColor blackColor];
        }
        _animationImageView.contentMode = UIViewContentModeScaleAspectFit;
        _animationImageView.frame = self.converFrame;
        [self.view addSubview:_animationImageView];
    }
    return _animationImageView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        @weakify(self)
        [[_pageControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIPageControl * _Nullable x) {
            @strongify(self)
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:x.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            self.currentIndex = x.currentPage;
        }];
        [self.view addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@(-80));
        }];
    }
    return _pageControl;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.showImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TImageListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageListCollectionCellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:_showImages[indexPath.row]];
    [cell.imageView addTarget:self action:@selector(hiddenListImage)];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self hiddenListImage];
    if (_showListImageVCBlock) {
        _showListImageVCBlock(-1);//如果是-1表示缩小图片
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *visibleCells = [collectionView visibleCells];
    if (visibleCells.count == 0) {
        return;
    }
    TImageListCollectionCell *imageListCollectionCell = (TImageListCollectionCell *)[visibleCells firstObject];
    if (self.lastImageListCollectionCell != nil && self.lastImageListCollectionCell.scrollView.zoomScale != 1.0) {
        [self.lastImageListCollectionCell.scrollView setZoomScale:1.0];
    }
    self.lastImageListCollectionCell = imageListCollectionCell;
    NSIndexPath *currentIndexPath = [collectionView indexPathForCell:imageListCollectionCell];
    if (_showListImageVCBlock) {
        _showListImageVCBlock(currentIndexPath.row);
    }
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/TScreenWidth;
    self.currentIndex = index;
    self.pageControl.currentPage = index;
    
}




@end
