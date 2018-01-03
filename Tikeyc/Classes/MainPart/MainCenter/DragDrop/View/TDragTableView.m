//
//  TDragTableView.m
//  Tikeyc
//
//  Created by ways on 2017/11/6.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TDragTableView.h"

static NSString *const identifier = @"kDragCellIdentifier";

#define row_height 200

@interface TDragTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIImage *image;

@end

@implementation TDragTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_imgView];
        _imgView.frame = CGRectMake(5, 5, TScreenWidth - 10, row_height - 10);
//        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@10);
//            make.top.equalTo(@10);
//            make.right.equalTo(@10);
//            make.bottom.equalTo(@10);
//            //make.edges.mas_equalTo(UIEdgeInsetsZero);
//        }];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    _imgView.image = _image;
}

@end

@interface TDragTableView ()<UITableViewDataSource,UITableViewDelegate,
                             UITableViewDragDelegate,UITableViewDropDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourceList;
@property (nonatomic, strong) NSIndexPath *dragIndexPath;

@end

@implementation TDragTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initProperty];
    }
    return self;
}

#pragma mark - init

- (void)initProperty {
    self.dataSource = self;
    self.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        self.dragDelegate = self;
        self.dropDelegate = self;
        self.dragInteractionEnabled = YES;
    } else {
        // Fallback on earlier versions
    }
    
    self.rowHeight = row_height;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[TDragTableViewCell class] forCellReuseIdentifier:identifier];
}

- (NSMutableArray *)dataSourceList {
    if (!_dataSourceList) {
        NSMutableArray *tempArray = [@[] mutableCopy];
        for (NSInteger i = 0; i <= 33; i++) {
            //            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"thumb%ld", i]];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TDragTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.image = self.dataSourceList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView shouldSpringLoadRowAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context {
    
    return YES;
}

#pragma mark - UITableViewDragDelegate

/**
 开始拖拽 添加了 UIDragInteraction 的控件 会调用这个方法，从而获取可供拖拽的 item
 如果返回 nil，则不会发生任何拖拽事件
 */
- (nonnull NSArray<UIDragItem *> *)tableView:(nonnull UITableView *)tableView itemsForBeginningDragSession:(nonnull id<UIDragSession>)session atIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (@available(iOS 11.0, *)) {
        NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:self.dataSourceList[indexPath.row]];
        UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:itemProvider];
        self.dragIndexPath = indexPath;
        return @[item];
    } else {
        // Fallback on earlier versions
    }
    return nil;
}

- (NSArray<UIDragItem *> *)tableView:(UITableView *)tableView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    
    if (@available(iOS 11.0, *)) {
        NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:self.dataSourceList[indexPath.row]];
        UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:itemProvider];
        return @[item];
    } else {
        // Fallback on earlier versions
    }
    return nil;
}

- (nullable UIDragPreviewParameters *)tableView:(UITableView *)tableView dragPreviewParametersForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (@available(iOS 11.0, *)) {
        UIDragPreviewParameters *parameters = [[UIDragPreviewParameters alloc] init];
        CGRect rect = CGRectMake(0, 0, tableView.bounds.size.width, tableView.rowHeight);
        parameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:15];
        return parameters;
    } else {
        // Fallback on earlier versions
    }
    
    return nil;
}


#pragma mark - UITableViewDropDelegate

// 当用户开始初始化 drop 手势的时候会调用该方法
- (void)tableView:(UITableView *)tableView performDropWithCoordinator:(id<UITableViewDropCoordinator>)coordinator {
    NSIndexPath *destinationIndexPath = coordinator.destinationIndexPath;
    
    // 如果开始拖拽的 indexPath 和 要释放的目标 indexPath 一致，就不做处理
    if (self.dragIndexPath.section == destinationIndexPath.section && self.dragIndexPath.row == destinationIndexPath.row) {
        return;
    }
    
    if (@available(iOS 11.0, *)) {
        [tableView performBatchUpdates:^{
            // 目标 cell 换位置
            id obj = self.dataSourceList[self.dragIndexPath.row];
            [self.dataSourceList removeObjectAtIndex:self.dragIndexPath.row];
            [self.dataSourceList insertObject:obj atIndex:destinationIndexPath.row];
            [tableView deleteRowsAtIndexPaths:@[self.dragIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[destinationIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        // Fallback on earlier versions
    }
}

// 该方法是提供释放方案的方法，虽然是optional，但是最好实现
// 当 跟踪 drop 行为在 tableView 空间坐标区域内部时会频繁调用
// 当drop手势在某个section末端的时候，传递的目标索引路径还不存在（此时 indexPath 等于 该 section 的行数），这时候会追加到该section 的末尾
// 在某些情况下，目标索引路径可能为空（比如拖到一个没有cell的空白区域）
// 请注意，在某些情况下，你的建议可能不被系统所允许，此时系统将执行不同的建议
// 你可以通过 -[session locationInView:] 做你自己的命中测试
- (UITableViewDropProposal *)tableView:(UITableView *)tableView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(nullable NSIndexPath *)destinationIndexPath {
    
    /**
     // TableView江湖接受drop，但是具体的位置还要稍后才能确定T
     // 不会打开一个缺口，也许你可以提供一些视觉上的处理来给用户传达这一信息
     UITableViewDropIntentUnspecified,
     
     // drop 将会插入到目标索引路径
     // 将会打开一个缺口，模拟最后释放后的布局
     UITableViewDropIntentInsertAtDestinationIndexPath,
     
     drop 将会释放在目标索引路径，比如该cell是一个容器（集合），此时不会像 👆 那个属性一样打开缺口，但是该条目标索引对应的cell会高亮显示
     UITableViewDropIntentInsertIntoDestinationIndexPath,
     
     tableView 会根据dro 手势的位置在 .insertAtDestinationIndexPath 和 .insertIntoDestinationIndexPath 自动选择，
     UITableViewDropIntentAutomatic
     */
    if (@available(iOS 11.0, *)) {
        UITableViewDropProposal *dropProposal;
        // 如果是另外一个app，localDragSession为nil，此时就要执行copy，通过这个属性判断是否是在当前app中释放，当然只有 iPad 才需要这个适配
        if (session.localDragSession) {
            dropProposal = [[UITableViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UITableViewDropIntentInsertAtDestinationIndexPath];
        } else {
            dropProposal = [[UITableViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UITableViewDropIntentInsertAtDestinationIndexPath];
        }
        
        return dropProposal;
    } else {
        // Fallback on earlier versions
    }
    return nil;
}


@end







