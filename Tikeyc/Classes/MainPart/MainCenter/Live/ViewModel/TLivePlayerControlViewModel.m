//
//  TLivePlayerControlViewModel.m
//  Tikeyc
//
//  Created by ways on 16/9/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLivePlayerControlViewModel.h"

@interface TLivePlayerControlViewModel ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BarrageManagerDelegate>



@end

@implementation TLivePlayerControlViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initRACSignal];
    }
    return self;
}


#pragma mark - init bind

- (void)initRACSignal{
    
    @weakify(self)
    self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            /*
            [TServiceTool GET:nil parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];*/
            
            
            return nil;
        }];
        
        
        return signal;
    }];
    
    [self.requestCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *result) {
        @strongify(self)
        
        
    }];
    
    /**
     //按理来说总共会执行3此监听请求执行状态，默认会执行一次（所以skip跳过第一次）。
     
     @param x 请求正在执行时x为1，介绍时x为0
     */
    [[self.requestCommand.executing skip:1] subscribeNext:^(id x) {
//        [x boolValue] ? [SVProgressHUD show] : [SVProgressHUD dismiss];
    }];
    
}



#pragma mark - 弹幕

- (void)creatBarrageViewWithSuperView:(UIView *)barrageSuperView{
    
    _manager = [BarrageManager shareManager];
    
    //出现的View
    _manager.bindingView = barrageSuperView;
    
    //delegate
    _manager.delegate = self;
    
    //弹幕显示位置
    _manager.displayLocation = BarrageDisplayLocationTypeDefault;
    
    //滚动方向
    _manager.scrollDirection = BarrageScrollDirectRightToLeft;
    
    //滚动速度
    _manager.scrollSpeed = 30;
    
    //收到内存警告的处理方式
    _manager.memoryMode = BarrageMemoryWarningModeHalf;
    
    //刷新时间
    _manager.refreshInterval = 1.0;
    
    //开始滚动 manager主动获取弹幕，另外一种方式，`[_manager showBarrageWithDataSource:m]` 退出弹幕即可
    [_manager startScroll];
    
    
    //_manager被动接收弹幕，如果一次性传入较多的数据，岂不是一下子创建很多弹幕？！
    //    int a = arc4random() % 10000;
    //    NSString *str = [NSString stringWithFormat:@"%d 呵呵哒",a];
    //
    //    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    //    [attr addAttribute:NSForegroundColorAttributeName value:TRandomColor_RGB range:NSMakeRange(0, str.length)];
    //
    //    BarrageModel *m = [[BarrageModel alloc] initWithBarrageContent:attr];
    //    m.displayLocation = BarrageDisplayLocationTypeDefault;
    //    m.barrageType = BarrageDisplayTypeVote;
    
    //    [_manager showBarrageWithDataSource:m];
}

- (void)dealloc {
    [_manager toDealloc];
}

#pragma mark - BarrageManagerDelegate
- (id)barrageManagerDataSource {
    
    //演示需要：随机弹幕方向
    //    int barrageScrollDierct = arc4random() % 4;
    _manager.scrollDirection = BarrageScrollDirectRightToLeft;//(NSInteger)barrageScrollDierct;
    
    //生成弹幕信息
    int a = arc4random() % 10000;
    NSString *str = [NSString stringWithFormat:@"弹幕 %d",a];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:TRandomColor_RGB range:NSMakeRange(0, str.length)];
    
    BarrageModel *m = [[BarrageModel alloc] initWithBarrageContent:attr];
    m.displayLocation = BarrageDisplayLocationTypeDefault;
    m.barrageType = BarrageDisplayTypeIconText;
    
    m.nickName = [[NSMutableAttributedString alloc] initWithString:@"💖💖弹弹弹幕幕幕💖😌💕💕💕💕"];
    
    return m;
}

- (void)showBarrage:(UIButton *)showBtn {
    showBtn.selected = !showBtn.isSelected;
    [_manager closeBarrage];
}

- (void)pauseBarrage:(UIButton *)pauseBtn{
    pauseBtn.selected = !pauseBtn.isSelected;
    [_manager pauseScroll];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        imgView.backgroundColor = [UIColor purpleColor];
        imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"live_icon" ofType:@"jpg"]];
        
        [TKCAppTools setViewCornerCircleWithView:imgView];
        [cell.contentView addSubview:imgView];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end








