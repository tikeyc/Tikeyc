//
//  TCycleScrollListImageView.m
//  Tikeyc
//
//  Created by ways on 2017/5/26.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TCycleScrollListImageView.h"

#import "TShowListImageCollectionViewController.h"
#import "TShowListImageButton.h"

///////
static NSString *cycleImageListCollectionCellIdentifier = @"cycleImageListCollectionCell";

@interface TCycleImageListCollectionCell : UICollectionViewCell

@property (nullable,nonatomic,strong)TShowListImageButton *imageView;

@end

@interface TCycleImageListCollectionCell ()

@end

@implementation TCycleImageListCollectionCell

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[TShowListImageButton alloc] init];
//        _imageView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
    return self;
}
@end
///////



@interface TCycleScrollListImageView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)dispatch_source_t timer;

@end

@implementation TCycleScrollListImageView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        [self initProperty];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initProperty];
}

#pragma mark - init

- (void)initProperty {
    self.dataSource = self;
    self.delegate = self;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    [self setFlowLayout];
    //
    [self registerClass:[TCycleImageListCollectionCell class] forCellWithReuseIdentifier:cycleImageListCollectionCellIdentifier];
    
}

- (void)setFlowLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing =0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = self.size;
    self.collectionViewLayout = layout;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        @weakify(self)
        [[_pageControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIPageControl * _Nullable x) {
            @strongify(self)
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:x.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            self.currentIndex = x.currentPage;
        }];
        [self.superview addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@(self.bottom - 40));
        }];
    }
    return _pageControl;
}

/**原理：
 比如显示的是 1 2 3
 则 3 （1 2 3） 1
 当显示（1 2 3）中1的时候右滑动到3感觉是显示（1 2 3）中的最后一个，然后马上无动画滑动到（1 2 3）中的3
 当显示（1 2 3）中3的时候左滑动到1感觉是显示（1 2 3）中的第一个，然后马上无动画滑动到（1 2 3）中的1
 */
- (void)setShowImages:(NSMutableArray *)showImages {
    _showImages = showImages;
    
    if (_showImages.count == 0) {
        return;
    }
    //
    self.pageControl.numberOfPages = _showImages.count;
    //
    _cycleShowImages = [NSMutableArray arrayWithArray:_showImages];
    [_cycleShowImages insertObject:[_showImages lastObject] atIndex:0];
    [_cycleShowImages addObject:[_showImages firstObject]];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = self.size;
    [self reloadData];
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    //
    [self startTimerToScrollImage];
}


- (void)startTimerToScrollImage {
    [self dispatchSourceCancel];
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"%ld",(long)self.currentIndex);
        ++self.currentIndex;
        if (self.currentIndex >= self.cycleShowImages.count) {
            self.currentIndex = self.cycleShowImages.count - 1;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        });
        
    });
    dispatch_resume(_timer);

}

- (void)dispatchSourceCancel {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cycleShowImages.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TCycleImageListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cycleImageListCollectionCellIdentifier forIndexPath:indexPath];
    
    [cell.imageView setImage:[UIImage imageNamed:_cycleShowImages[indexPath.row]] forState:UIControlStateNormal];
    if (indexPath.row == 0 || indexPath.row == _cycleShowImages.count - 1) {
        //过度图片禁止点击，防止快速操作
        cell.imageView.userInteractionEnabled = NO;
    } else {
        cell.imageView.userInteractionEnabled = YES;
    }
    NSInteger tag = indexPath.row - 1;//放大浏览后不再无限滑动
    cell.imageView.tag = tag;
//    cell.imageView.myCollectionView = collectionView;//此无限循环滑动无需设置
    cell.imageView.showImages = self.showImages;
    @weakify(self)
    cell.imageView.showListImageVCBlock = ^(NSInteger currentIndex) {
        @strongify(self)
        if (currentIndex == -1) {//如果是-1表示缩小图片
            [self performSelector:@selector(startTimerToScrollImage) withObject:nil afterDelay:1.0];
        } else if (currentIndex == -2) {//如果是-2表示放大图片
            [self dispatchSourceCancel];
        } else {//其他情况是在滑动图片
            
            self.pageControl.currentPage = currentIndex;
            ++currentIndex;
            self.currentIndex = currentIndex;
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        
    };
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


/**原理：
 比如显示的是 1 2 3
 则 3 （1 2 3） 1
 当显示（1 2 3）中1的时候右滑动到3感觉是显示（1 2 3）中的最后一个，然后马上无动画滑动到（1 2 3）中的3
 当显示（1 2 3）中3的时候左滑动到1感觉是显示（1 2 3）中的第一个，然后马上无动画滑动到（1 2 3）中的1
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *visibleCells = [collectionView visibleCells];
    if (visibleCells.count == 0) {
        return;
    }
    NSIndexPath *currentIndexPath = [collectionView indexPathForCell:[visibleCells firstObject]];
    NSLog(@"indexPath.row:%ld---currentIndexPath.row:%ld",(long)indexPath.row,(long)currentIndexPath.row);
    self.currentIndex = currentIndexPath.row;
    if (currentIndexPath.row == 0) {
        //当显示（1 2 3）中1的时候右滑动到3感觉是显示（1 2 3）中的最后一个，然后马上无动画滑动到（1 2 3）中的3
        self.currentIndex = _cycleShowImages.count - 2;
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else if (currentIndexPath.row == _cycleShowImages.count - 1){
        //当显示（1 2 3）中3的时候左滑动到1感觉是显示（1 2 3）中的第一个，然后马上无动画滑动到（1 2 3）中的1
        self.currentIndex = 1;
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
    }
    self.pageControl.currentPage = self.currentIndex - 1;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSet_X = scrollView.contentOffset.y;
    
    
}

@end







