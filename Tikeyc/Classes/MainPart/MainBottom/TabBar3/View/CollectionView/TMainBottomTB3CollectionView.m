//
//  TMainBottomTB3CollectionView.m
//  Tikeyc
//
//  Created by ways on 2016/12/2.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainBottomTB3CollectionView.h"

#import "TMainBottomTB3CollectionViewCell.h"
#import "TMainBottomTB3CollectionViewLayout.h"

#import "UIImageView+WebCache.h"

#import "TLivePlayerViewController.h"


@interface TMainBottomTB3CollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    NSIndexPath *_originalIndexPath;
    NSIndexPath *_moveIndexPath;
    UIView *_snapshotView;
}

@property (nonatomic,strong)NSArray *heightArr;


@end

@implementation TMainBottomTB3CollectionView




//////////////////

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initProperty];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initProperty];
}


#pragma mark - init

- (void)initProperty{
    //
    self.dataSource = (id)self;
    self.delegate = (id)self;
    //
    /**/
    TMainBottomTB3CollectionViewLayout *collectionViewLayout = [[TMainBottomTB3CollectionViewLayout alloc] init];
    [collectionViewLayout computeIndexCellHeightWithWidthBlock:^CGFloat(NSIndexPath *indexPath,CGFloat itemWidth) {
        
        CGFloat height = [self.heightArr[indexPath.item] floatValue];
        return height;
    }];
    self.collectionViewLayout = collectionViewLayout;
    
    //注册头视图 现在是自定义的collectionViewLayout结果注册头视图不起作用
    collectionViewLayout.headerReferenceSize = CGSizeMake(TScreenWidth, 250);//设置collectionView头视图的大小
    //[self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewIdentifier"];
    
    [self registerNib:[UINib nibWithNibName:@"TMainBottomTB3CollectionReusableView" bundle:[NSBundle mainBundle]]forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewIdentifier"];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    
}

- (NSArray *)heightArr{
    if(!_heightArr && self.liveListModels.count > 0){
        //随机生成高度
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < self.liveListModels.count; i++) {
            [arr addObject:@(arc4random()%100+120)];
        }
        _heightArr = [arr copy];
    }
    return _heightArr;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.liveListModels.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"TMainBottomTB3CollectionViewCell";
    
    TMainBottomTB3CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //
    TLiveListModel *liveListModel = self.liveListModels[indexPath.item];

    cell.titleLabel.text = [@"瀑布流" stringByAppendingString:[@(indexPath.item) stringValue]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:liveListModel.creator[@"portrait"]]];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerViewIdentifier" forIndexPath:indexPath];
        view.backgroundColor = [UIColor redColor];
        
        return view;
    }
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0){
    return YES;
}
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
//    NSLog(@"moveItemAtIndexPath");
//    
//    //取出源item数据
//    
//    id objc = [self.liveListModels objectAtIndex:sourceIndexPath.item];
//    
//    [self.liveListModels exchangeObjectAtIndex:destinationIndexPath.item withObjectAtIndex:sourceIndexPath.item];
//    
//    //从资源数组中移除该数据
//    
////    [self.liveListModels removeObject:objc];
////    
////    //将数据插入到资源数组中的目标位置上
////    
////    [self.liveListModels insertObject:objc atIndex:destinationIndexPath.item];
//    
//}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(TScreenWidth, 250);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGSize size = CGSizeMake(100, 100);
//    return size;
//}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);

    TLivePlayerViewController *livePlayerVC = [[TLivePlayerViewController alloc] init];
    
    livePlayerVC.liveListModel = self.liveListModels[indexPath.row];
    
    [self.viewController.navigationController pushViewController:livePlayerVC animated:YES];
}

#pragma mark - 长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self];
    _moveIndexPath = [self indexPathForItemAtPoint:touchPoint];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
//            if (_isEditing == NO) {
//                self.isEditing = YES;
//                [self.collectionView reloadData];
//                [self.collectionView layoutIfNeeded];
//            }
            if (_moveIndexPath.section == 0) {
                TMainBottomTB3CollectionViewCell *selectedItemCell = (TMainBottomTB3CollectionViewCell *)[self cellForItemAtIndexPath:_moveIndexPath];
                _originalIndexPath = [self indexPathForItemAtPoint:touchPoint];
                if (!_originalIndexPath) {
                    return;
                }
                _snapshotView = [selectedItemCell snapshotViewAfterScreenUpdates:YES];
                _snapshotView.center = [recognizer locationInView:self];
                [self addSubview:_snapshotView];
                selectedItemCell.hidden = YES;
                [UIView animateWithDuration:0.2 animations:^{
                    _snapshotView.transform = CGAffineTransformMakeScale(1.03, 1.03);
                    _snapshotView.alpha = 0.98;
                }];
            }
            
        } break;
        case UIGestureRecognizerStateChanged: {
            
            _snapshotView.center = [recognizer locationInView:self];
            
            if (_moveIndexPath.section == 0) {
//                NSLog(@"%f--%f",_snapshotView.top,_snapshotView.bottom);
//                printf("%f--%f\n",_snapshotView.top,_snapshotView.bottom);
//                printf("height:%f\n",self.height);
                if (((_snapshotView.top + 40) - self.contentOffset.y) < 0 && self.contentOffset.y > 0) {
                    CGFloat gap = 0 - (_snapshotView.top - self.contentOffset.y);
//                    printf("top gap:%f\n",gap);
                    CGFloat change = self.contentOffset.y - gap;
                    if (change < 0) change = 0;
                    self.contentOffset = CGPointMake(0, change);
                }else if ((_snapshotView.bottom - 40) > (self.height + self.contentOffset.y)) {
                    CGFloat gap = _snapshotView.bottom - (self.height + self.contentOffset.y);
//                    printf("bottom gap:%f\n",gap);
                    CGFloat change = self.contentOffset.y + gap;
                    if (change > (self.contentSize.height - self.height)) change = self.contentOffset.y;
                    self.contentOffset = CGPointMake(0, change);
                }
                if (_moveIndexPath && ![_moveIndexPath isEqual:_originalIndexPath] && _moveIndexPath.section == _originalIndexPath.section) {
                    NSMutableArray *array = self.liveListModels;
                    NSInteger fromIndex = _originalIndexPath.item;
                    NSInteger toIndex = _moveIndexPath.item;
                    if (fromIndex < toIndex) {
                        for (NSInteger i = fromIndex; i < toIndex; i++) {
                            [array exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                        }
                    }else{
                        for (NSInteger i = fromIndex; i > toIndex; i--) {
                            [array exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
                        }
                    }
                    [self moveItemAtIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
                    _originalIndexPath = _moveIndexPath;
                }
            }
            
        } break;
        case UIGestureRecognizerStateEnded: {
            TMainBottomTB3CollectionViewCell *cell = (TMainBottomTB3CollectionViewCell *)[self cellForItemAtIndexPath:_originalIndexPath];
            cell.hidden = NO;
            [_snapshotView removeFromSuperview];
        } break;
        case UIGestureRecognizerStateCancelled:{
            TMainBottomTB3CollectionViewCell *cell = (TMainBottomTB3CollectionViewCell *)[self cellForItemAtIndexPath:_originalIndexPath];
            cell.hidden = NO;
            [_snapshotView removeFromSuperview];
        }break;
            
        default: break;
    }
}


@end










