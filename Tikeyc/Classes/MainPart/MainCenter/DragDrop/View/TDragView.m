//
//  TDragView.m
//  Tikeyc
//
//  Created by ways on 2017/11/6.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TDragView.h"

@interface TDragView()<UIDragInteractionDelegate,UIDropInteractionDelegate>

@property (nonatomic, strong) UIImageView *dragImgView;

@end

@implementation TDragView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperty];
    }
    return self;
}


#pragma mark - init

- (void)initProperty {
    [self addDragAndDropInterraction:self.dragImgView];
}

- (UIImageView *)dragImgView {
    if (!_dragImgView) {
        _dragImgView = [[UIImageView alloc] init];
        _dragImgView.frame = CGRectMake(0, 0, 200, 200);
        _dragImgView.image = [UIImage imageNamed:@"live_icon.jpg"];
        _dragImgView.layer.cornerRadius = 10;
        _dragImgView.layer.masksToBounds = YES;
        _dragImgView.userInteractionEnabled = YES;
        [self addSubview:_dragImgView];
    }
    return _dragImgView;
}


#pragma mark -

- (void)addDragAndDropInterraction:(UIView *)view {
    // 想让一个控件可被拖动，首先要给该控件添加 UIDragInteraction 对象
    if (@available(iOS 11.0, *)) {
        UIDragInteraction *dragInteratcion = [[UIDragInteraction alloc] initWithDelegate:self];
#warning 一定要添加这个代码！！！
        dragInteratcion.enabled = YES;
        [view addInteraction:dragInteratcion];
        
        UIDropInteraction *dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
        //    dropInteraction.allowsSimultaneousDropSessions = YES;
        [view addInteraction:dropInteraction];
    } else {
        // Fallback on earlier versions
    }

}

- (void)_loadImageWithItemProvider:(NSItemProvider *)itemProvider center:(CGPoint)center {
    NSLog(@"_loadImageWithItemProvider:center:");
    // 该方法用于取出数据
    if (@available(iOS 11.0, *)) {
        NSProgress *progress = [itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            // 回调的代码块默认就在主线程
            UIImage *image = (UIImage *)object;
            self.dragImgView.image = image;
            self.dragImgView.center = center;
            
        }];
        // 是否完成
        BOOL isFinished = progress.isFinished;
        // 当前已完成进度
        CGFloat progressSoFar = progress.fractionCompleted;
        
        [progress cancel];
    } else {
        // Fallback on earlier versions
    }
    
}


#pragma mark - UIDragInteractionDelegate

/**
 开始拖拽 添加了 UIDragInteraction 的控件 会调用这个方法，从而获取可供拖拽的 item
 如果返回 nil，则不会发生任何拖拽事件
 */
- (nonnull NSArray<UIDragItem *> *)dragInteraction:(nonnull UIDragInteraction *)interaction itemsForBeginningSession:(nonnull id<UIDragSession>)session {
    NSLog(@"itemsForBeginningSession");
    // 该方法进行提供数据
    
    if (@available(iOS 11.0, *)) {
        NSItemProvider *provider = [[NSItemProvider alloc] initWithObject:self.dragImgView.image];
        UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:provider];
        dragItem.localObject = self.dragImgView.image;
        return @[dragItem];
    } else {
        // Fallback on earlier versions
    }
    return nil;
}

/**
 对刚开始拖动处于 lift 状态的 item 会有一个 preview 的预览功效，其动画是系统自动生成的，但是需要我们通过该方法提供 preview 的相关信息
 如果返回 nil，就相当于指明该 item 没有预览效果
 如果没有实现该方法，interaction.view 就会生成一个 UITargetedDragPreview
 */
- (nullable UITargetedDragPreview *)dragInteraction:(UIDragInteraction *)interaction previewForLiftingItem:(UIDragItem *)item session:(id<UIDragSession>)session {
    
    NSLog(@"previewForLiftingItem");
    
    if (@available(iOS 11.0, *)) {
        UIDragPreviewParameters *previewParameters = [[UIDragPreviewParameters alloc] init];
        previewParameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:self.dragImgView.bounds cornerRadius:10];
        UITargetedDragPreview *dragPreview = [[UITargetedDragPreview alloc] initWithView:interaction.view parameters:previewParameters];
        return dragPreview;
    } else {
        // Fallback on earlier versions
    }
    return nil;
}

// 向当前已经存在的拖拽事件中添加一个新的 UIDragItem
- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForAddingToSession:(id<UIDragSession>)session withTouchAtPoint:(CGPoint)point {
    return nil;
}

// 当 lift 动画准备执行的时候会调用该方法，可以在这个方法里面对拖动的 item 添加动画
- (void)dragInteraction:(UIDragInteraction *)interaction willAnimateLiftWithAnimator:(id<UIDragAnimating>)animator session:(id<UIDragSession>)session {
    NSLog(@"willAnimateLiftWithAnimator:session:");
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        if (finalPosition == UIViewAnimatingPositionEnd) {
            self.dragImgView.alpha = 0.6;
        }
    }];
}

// 当取消动画准备执行的时候会调用这个方法
- (void)dragInteraction:(UIDragInteraction *)interaction item:(UIDragItem *)item willAnimateCancelWithAnimator:(id<UIDragAnimating>)animator {
    NSLog(@"item:willAnimateCancelWithAnimator:");
    [animator addAnimations:^{
        self.dragImgView.alpha = 1;
    }];
}

// 当用户完成一次拖拽操作，并且所有相关的动画都执行完毕的时候会调用这个方法，这时候被拖动的item 应该恢复正常的展示外观
- (void)dragInteraction:(UIDragInteraction *)interaction session:(id<UIDragSession>)session didEndWithOperation:(UIDropOperation)operation {
    NSLog(@"session:didEndWithOperation:");
    
    [UIView animateWithDuration:0.25 animations:^{
        //        self.dragView.center = [session locationInView:self.view];
        self.dragImgView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (nullable UITargetedDragPreview *)dragInteraction:(UIDragInteraction *)interaction previewForCancellingItem:(UIDragItem *)item withDefault:(UITargetedDragPreview *)defaultPreview {
    NSLog(@"previewForCancellingItem");
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, interaction.view.bounds.size.width, interaction.view.bounds.size.height)];
    imageView.image = self.dragImgView.image;
    
    if (@available(iOS 11.0, *)) {
        UIDragPreviewTarget *previewTarget = [[UIDragPreviewTarget alloc] initWithContainer:interaction.view center:CGPointMake(interaction.view.bounds.size.width / 2, interaction.view.bounds.size.height / 2)];
        UITargetedDragPreview *dragPreview = [[UITargetedDragPreview alloc] initWithView:imageView parameters:[UIDragPreviewParameters new] target:previewTarget];
        return dragPreview;
    } else {
        // Fallback on earlier versions
    }
    
    return nil;
}

#pragma mark - UIDropInteractionDelegate

- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session {
    // 可以加载image的控件都可以
    return [session canLoadObjectsOfClass:[UIImage class]];
    
}

- (void)dropInteraction:(UIDropInteraction *)interaction sessionDidEnter:(id<UIDropSession>)session {
    NSLog(@"sessionDidEnter");
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    
    // 如果 session.localDragSession 为nil，说明这一操作源自另外一个app，
    if (@available(iOS 11.0, *)) {
        UIDropOperation dropOperation = session.localDragSession ? UIDropOperationMove : UIDropOperationCopy;
        
        UIDropProposal *dropProposal = [[UIDropProposal alloc] initWithDropOperation:dropOperation];
        return dropProposal;
    } else {
        // Fallback on earlier versions
    }
    return nil;
}

- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    NSLog(@"performDrop");
    // 同样的，在这个方法内部也要判断是否源自本app
    if (session.localDragSession) {
        //        CGPoint dropPoint = [session locationInView:interaction.view];
        CGPoint dropPoint = [session locationInView:self.superview];
        if (@available(iOS 11.0, *)) {
            for (UIDragItem *item in session.items) {
                [self _loadImageWithItemProvider:item.itemProvider center:dropPoint];
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

- (UITargetedDragPreview *)dropInteraction:(UIDropInteraction *)interaction previewForDroppingItem:(UIDragItem *)item withDefault:(UITargetedDragPreview *)defaultPreview {
    NSLog(@"previewForDroppingItem");
    if (item.localObject) {
        CGPoint dropPoint = defaultPreview.view.center;
        if (@available(iOS 11.0, *)) {
            UIDragPreviewTarget *previewTarget = [[UIDragPreviewTarget alloc] initWithContainer:self.dragImgView center:dropPoint];
            return [defaultPreview retargetedPreviewWithTarget:previewTarget];
        } else {
            // Fallback on earlier versions
        }
        
    } else {
        return nil;
    }
    return nil;
}

// 产生本地动画
- (void)dropInteraction:(UIDropInteraction *)interaction item:(UIDragItem *)item willAnimateDropWithAnimator:(id<UIDragAnimating>)animator {
    
    [animator addAnimations:^{
        self.dragImgView.alpha = 0;
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        self.dragImgView.alpha = 1;
    }];
}

@end












