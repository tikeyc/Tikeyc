//
//  JYJTopicVideoView.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/24.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTopicVideoView.h"
#import "JYJTopic.h"
#import "UIImageView+WebCache.h"
#import "JYJShowPictureViewController.h"

@interface JYJTopicVideoView ()<ZFPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;

@property (strong, nonatomic) UIButton *playButton;

@end

@implementation JYJTopicVideoView

+ (instancetype)videoView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    // 给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    self.imageView.tag = 101;
    //
    // 代码添加playerBtn到imageView上
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
        make.width.height.mas_equalTo(50);
    }];
    //
//    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)setTopic:(JYJTopic *)topic {
    _topic = topic;
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    // 播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    // 时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

- (void)showPicture {
    JYJShowPictureViewController *showPicture = [[JYJShowPictureViewController alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}


- (void)playButtonAction:(UIButton *)sender {
    
    // 取出字典中的第一视频URL
    NSURL *videoURL = [NSURL URLWithString:self.topic.videouri];
    
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
    playerModel.title            = self.topic.text;
    playerModel.videoURL         = videoURL;
    playerModel.placeholderImageURLString = self.topic.large_image;
    playerModel.scrollView       = self.tableView;
    playerModel.indexPath        = self.currentIndexPath;
    // 赋值分辨率字典
//    playerModel.resolutionDic    = dic;
    // player的父视图tag
    playerModel.fatherViewTag    = self.imageView.tag;
    
    // 设置播放控制层和model
    [self.playerView playerControlView:nil playerModel:playerModel];
    // 下载功能
    self.playerView.hasDownload = NO;
    // 自动播放
    [self.playerView autoPlayTheVideo];
    
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = (id)self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}


#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url {
    
}

@end
