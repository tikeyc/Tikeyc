//
//  TDragCollectionView.m
//  Tikeyc
//
//  Created by ways on 2017/11/3.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TDragCollectionView.h"

static NSString *indentifierCell = @"indentifierCell";

static NSString *kItemForTypeIdentifier = @"kItemForTypeIdentifier";

@interface TDragCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImage *image;

@end

@implementation TDragCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            //make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    _imageView.image = _image;
}

@end


@interface TDragCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,
                                  UICollectionViewDragDelegate,UICollectionViewDropDelegate>

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong)NSMutableArray *dataSourceList;

@property (nonatomic,strong)NSIndexPath *dragIndexPath;

@end

@implementation TDragCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame collectionViewLayout:self.flowLayout];
    if (self) {
        [self initProperty];
    }
    return self;
}



#pragma mark - init


- (void)initProperty {
    
    
    
    self.dataSource = self;
    self.delegate = self;
    //
    if (@available(iOS 11.0, *)) {
        self.dragDelegate = self;
        self.dropDelegate = self;
        //dragInteractionEnabled 属性在 iPad 上默认是YES，在 iPhone 默认是 NO，只有设置为 YES 才可以进行 drag 操作
        self.dragInteractionEnabled = YES;
        /*reorderingCadence （重排序节奏）
         UICollectionViewReorderingCadenceImmediate：默认值，当开始移动的时候就立即回流集合视图布局，可以理解为实时的重新排序
         UICollectionViewReorderingCadenceFast：如果你快速移动，CollectionView 不会立即重新布局，只有在停止移动的时候才会重新布局
         UICollectionViewReorderingCadenceSlow：停止移动再过一会儿才会开始回流，重新布局
         */
        self.reorderingCadence = UICollectionViewReorderingCadenceImmediate;
        //弹簧加载是一种导航和激活控件的方式，在整个系统中，当处于 dragSession 的时候，只要悬浮在cell上面，就会高亮，然后就会激活
        self.springLoaded = YES;
    } else {
        // Fallback on earlier versions
    }
    
    
    [self registerClass:[TDragCollectionViewCell class] forCellWithReuseIdentifier:indentifierCell];
    
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //最小行间距(默认为10)
        _flowLayout.minimumLineSpacing = 10;
        //最小item间距（默认为10）
        _flowLayout.minimumInteritemSpacing = 5;
        int kMagin = _flowLayout.minimumInteritemSpacing;
        CGFloat itemWidth = (TScreenWidth - 4 * kMagin) / 3;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth/0.618);
        //设置senction的内边距
        _flowLayout.sectionInset = UIEdgeInsetsMake(kMagin, kMagin, kMagin, kMagin);
        //设置UICollectionView的滑动方向
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

- (NSMutableArray *)dataSourceList {
    if (!_dataSourceList) {
        NSMutableArray *tempArray = [@[] mutableCopy];
        for (NSInteger i = 0; i <= 33; i++) {
            UIImage *image;
            if (i % 2) {
                image = [UIImage imageNamed:@"live_icon.jpg"];
            } else {
                image = [UIImage imageNamed:@"beauty1.jpg"];
            }
            
            [tempArray addObject:image];
        }
        _dataSourceList = tempArray;
    }
    return _dataSourceList;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceList.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TDragCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifierCell forIndexPath:indexPath];
    
//    if (indexPath.row % 2) {
//        cell.backgroundColor = [UIColor redColor];
//    } else {
//        cell.backgroundColor = [UIColor orangeColor];
//    }
    
    cell.image = self.dataSourceList[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//在上面设置
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake((TScreenWidth - 40)/3, 200);
//}

#pragma mark - UICollectionViewDragDelegate

/* 提供一个 给定 indexPath 的可进行 drag 操作的 item（类似 hitTest: 方法周到该响应的view ）
 * 如果返回 nil，则不会发生任何拖拽事件
 */
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    
    if (@available(iOS 11.0, *)) {
        NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:self.dataSourceList[indexPath.item]];
        //    itemProvider.preferredPresentationSize
        //    session.progressIndicatorStyle = UIDropSessionProgressIndicatorStyleNone;
        
        [itemProvider registerItemForTypeIdentifier:kItemForTypeIdentifier loadHandler:^(NSItemProviderCompletionHandler  _Null_unspecified completionHandler, Class  _Null_unspecified __unsafe_unretained expectedValueClass, NSDictionary * _Null_unspecified options) {
            
        }];
        
        //    itemProvider registerDataRepresentationForTypeIdentifier:<#(nonnull NSString *)#> visibility:<#(NSItemProviderRepresentationVisibility)#> loadHandler:<#^NSProgress * _Nullable(void (^ _Nonnull completionHandler)(NSData * _Nullable, NSError * _Nullable))loadHandler#>
        
        UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:itemProvider];
        
        self.dragIndexPath = indexPath;
        return @[item];
    } else {
        // Fallback on earlier versions
    }
    
    return nil;
}

/* 当接收到添加item响应时，会调用该方法向已经存在的drag会话中添加item
 * 如果需要，可以使用提供的点（在集合视图的坐标空间中）进行其他命中测试。
 * 如果该方法未实现，或返回空数组，则不会将任何 item 添加到拖动，手势也会正常的响应
 */
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    if (@available(iOS 11.0, *)) {
        NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:self.dataSourceList[indexPath.item]];
        UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:itemProvider];
        return @[item];
    } else {
        // Fallback on earlier versions
    }
    return nil;
}

/* 允许对从取消或返回到 CollectionView 的 item 使用自定义预览
 * UIDragPreviewParameters 有两个属性：visiblePath 和 backgroundColor
 * 如果该方法没有实现或者返回nil，那么整个 cell 将用于预览
 */
- (nullable UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView dragPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 可以在该方法内使用 贝塞尔曲线 对单元格的一个具体区域进行裁剪
    if (@available(iOS 11.0, *)) {
        UIDragPreviewParameters *parameters = [[UIDragPreviewParameters alloc] init];
        CGFloat previewWidth = self.flowLayout.itemSize.width;
        CGFloat previewHeight = self.flowLayout.itemSize.height;
        CGRect rect = CGRectMake(0, 0, previewWidth, previewHeight);
        parameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5];
        parameters.backgroundColor = [UIColor clearColor];
        return parameters;
    } else {
        // Fallback on earlier versions
    }
    
    return nil;
}

/* 当 lift animation 完成之后开始拖拽之前会调用该方法
 * 该方法肯定会对应着 -collectionView:dragSessionDidEnd: 的调用
 */
- (void)collectionView:(UICollectionView *)collectionView dragSessionWillBegin:(id<UIDragSession>)session {
    NSLog(@"dragSessionWillBegin --> drag 会话将要开始");
}

// 拖拽结束的时候会调用该方法
- (void)collectionView:(UICollectionView *)collectionView dragSessionDidEnd:(id<UIDragSession>)session {
    NSLog(@"dragSessionDidEnd --> drag 会话已经结束");
}

#pragma mark - UICollectionViewDropDelegate


/* 当用户开始进行 drop 操作的时候会调用这个方法
 * 使用 dropCoordinator 去置顶如果处理当前 drop 会话的item 到指定的最终位置，同时也会根据drop item返回的数据更新数据源
 * 如果该方法不做任何事，将会执行默认的动画
 */
- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    
    NSIndexPath *destinationIndexPath = coordinator.destinationIndexPath;
    UIDragItem *dragItem = coordinator.items.firstObject.dragItem;
    UIImage *image = self.dataSourceList[self.dragIndexPath.row];
    
    // 正常的加载数据的方法
    if ([dragItem.itemProvider canLoadObjectOfClass:[UIImage class]]) {
        [dragItem.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            // 回调在非主线程
            UIImage *image = (UIImage *)object;
        }];
    }
    
    // 如果开始拖拽的 indexPath 和 要释放的目标 indexPath 一致，就不做处理
    if (self.dragIndexPath.section == destinationIndexPath.section && self.dragIndexPath.row == destinationIndexPath.row) {
        return;
    }
    
    // 更新 CollectionView
    [collectionView performBatchUpdates:^{
        // 目标 cell 换位置
        [self.dataSourceList removeObjectAtIndex:self.dragIndexPath.item];
        [self.dataSourceList insertObject:image atIndex:destinationIndexPath.item];
        
        [collectionView moveItemAtIndexPath:self.dragIndexPath toIndexPath:destinationIndexPath];
    } completion:^(BOOL finished) {
        
    }];
    
    [coordinator dropItem:dragItem toItemAtIndexPath:destinationIndexPath];
    
    
    
    // 创建 PlaceHolder
    //    coordinator
    /* Animate the dragItem to an automatically inserted placeholder item.
     *
     * A placeholder cell will be created for the reuse identifier and inserted at the specified indexPath without requiring a dataSource update.
     *
     * The cellUpdateHandler will be called whenever the placeholder cell becomes visible; -collectionView:cellForItemAtIndexPath: will not be called
     * for the placeholder.
     *
     * Once the dragItem data is available, you can exchange the temporary placeholder cell with the final cell using
     * the placeholder context method -commitInsertionWithDataSourceUpdates:
     *
     * UICollectionViewDropPlaceholderContext also conforms to UIDragAnimating to allow adding alongside animations and completion handlers.
     */
    //    - (id<UICollectionViewDropPlaceholderContext>)dropItem:(UIDragItem *)dragItem toPlaceholder:(UICollectionViewDropPlaceholder*)placeholder;
}

/* 该方法是提供释放方案的方法，虽然是optional，但是最好实现
 * 当 跟踪 drop 行为在 tableView 空间坐标区域内部时会频繁调用
 * 当drop手势在某个section末端的时候，传递的目标索引路径还不存在（此时 indexPath 等于 该 section 的行数），这时候会追加到该section 的末尾
 * 在某些情况下，目标索引路径可能为空（比如拖到一个没有cell的空白区域）
 * 请注意，在某些情况下，你的建议可能不被系统所允许，此时系统将执行不同的建议
 * 你可以通过 -[session locationInView:] 做你自己的命中测试
 */
- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(nullable NSIndexPath *)destinationIndexPath {
    
    /**
     CollectionView将会接收drop，但是具体的位置要稍后才能确定
     不会开启一个缺口，可以通过添加视觉效果给用户传达这一信息
     UICollectionViewDropIntentUnspecified,
     
     drop将会被插入到目标索引中
     将会打开一个缺口，模拟最后释放后的布局
     UICollectionViewDropIntentInsertAtDestinationIndexPath,
     
     drop 将会释放在目标索引路径，比如该cell是一个容器（集合），此时不会像 👆 那个属性一样打开缺口，但是该条目标索引对应的cell会高亮显示
     UICollectionViewDropIntentInsertIntoDestinationIndexPath,
     */
    UICollectionViewDropProposal *dropProposal;
    // 如果是另外一个app，localDragSession为nil，此时就要执行copy，通过这个属性判断是否是在当前app中释放，当然只有 iPad 才需要这个适配
    if (session.localDragSession) {
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    } else {
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    }
    
    return dropProposal;
}

/* 通过该方法判断对应的item 能否被 执行drop会话
 * 如果返回 NO，将不会调用接下来的代理方法
 * 如果没有实现该方法，那么默认返回 YES
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session {
    // 假设在该 drop 只能在当前本 app中可执行，在别的 app 中不可以
    if (session.localDragSession == nil) {
        return NO;
    }
    return YES;
}

/* 当drop会话进入到 collectionView 的坐标区域内就会调用，
 * 早于- [collectionView dragSessionWillBegin] 调用
 */
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnter:(id<UIDropSession>)session {
    NSLog(@"dropSessionDidEnter --> dropSession进入目标区域");
}

/* 当 dropSession 不在collectionView 目标区域的时候会被调用
 */
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidExit:(id<UIDropSession>)session {
    NSLog(@"dropSessionDidExit --> dropSession 离开目标区域");
}

/* 当dropSession 完成时会被调用，不管结果如何
 * 适合在这个方法里做一些清理的操作
 */
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnd:(id<UIDropSession>)session {
    NSLog(@"dropSessionDidEnd --> dropSession 已完成");
}

/* 当 item 执行drop 操作的时候，可以自定义预览图
 * 如果没有实现该方法或者返回nil，整个cell将会被用于预览图
 *
 * 该方法会经由  -[UICollectionViewDropCoordinator dropItem:toItemAtIndexPath:] 调用
 * 如果要去自定义占位drop，可以查看 UICollectionViewDropPlaceholder.previewParametersProvider
 */
- (nullable UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView dropPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

@end








