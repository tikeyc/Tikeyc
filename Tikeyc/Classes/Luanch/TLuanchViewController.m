//
//  TLuanchViewController.m
//  Tikeyc
//
//  Created by ways on 2017/5/4.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TLuanchViewController.h"

#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

///////
static NSString *luanchCollectionCellIdentifier = @"luanchCollectionCell";

@interface TLuanchCollectionCell : UICollectionViewCell

@property (nonatomic,strong)FLAnimatedImageView *imageView;

@end

@implementation TLuanchCollectionCell

- (void)prepareForReuse {
    [super prepareForReuse];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[FLAnimatedImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
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

@interface TLuanchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)goButtonAction:(UIButton *)sender;
- (IBAction)pageControllClickAction:(UIPageControl *)sender;

@end

@implementation TLuanchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//    NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"circle" ofType:@"gif"];
//    NSData *data = [NSData dataWithContentsOfFile:imageFile];
//    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
//    self.gifImageView.animatedImage = animatedImage;
    
    
    [self initProperty];
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

#pragma mark - init

- (void)initProperty {
    self.collectionView.pagingEnabled = YES;
    //
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(TScreenWidth, TScreenHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    [self.collectionView registerClass:[TLuanchCollectionCell class] forCellWithReuseIdentifier:luanchCollectionCellIdentifier];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TLuanchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:luanchCollectionCellIdentifier forIndexPath:indexPath];
    
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:[@"circle" stringByAppendingString:[@(indexPath.row) stringValue]] ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:imageFile];
    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
    cell.imageView.animatedImage = animatedImage;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSet_x = scrollView.contentOffset.x;
    NSInteger index = offSet_x/TScreenWidth;
    self.pageControl.currentPage = index;
}

#pragma mark - actions

- (IBAction)goButtonAction:(UIButton *)sender {
    [TAppDelegateManager gotoLoginController];
}

- (IBAction)pageControllClickAction:(UIPageControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.currentPage inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

@end









