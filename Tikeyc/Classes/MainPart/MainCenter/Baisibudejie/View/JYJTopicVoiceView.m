//
//  JYJTopicVoiceView.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/24.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTopicVoiceView.h"
#import "JYJTopic.h"
#import "UIImageView+WebCache.h"

#import <FreeStreamer/FSAudioStream.h>

@interface TFSAudioStreamManager : NSObject

@property (nonatomic,strong)FSAudioStream *fsAudioStream;
@property (nonatomic, assign) NSInteger lastIndexPathRow;

@end

@implementation TFSAudioStreamManager

static TFSAudioStreamManager *streamManager = nil;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamManager = [[TFSAudioStreamManager alloc] init];
    });
    return streamManager;
}

@end

@interface JYJTopicVoiceView ()

@property (nonatomic,strong) FSAudioStream *audioPlayer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *voicelengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)playButtonAction:(UIButton *)sender;


@end
@implementation JYJTopicVoiceView

+ (instancetype)voiceView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationEnterBackground
{
//    [_audioPlayer stop];
//    [self.playButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
}

- (void)setTopic:(JYJTopic *)topic {
    _topic = topic;
    
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    // 播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    // 时长
    NSInteger minute = topic.voicetime / 60;
    NSInteger second = topic.voicetime % 60;
    self.voicelengthLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}


- (IBAction)playButtonAction:(UIButton *)sender {
    
    //playButtonPlay  playButtonPause
    FSAudioStream *lastFSAudioStream = [TFSAudioStreamManager shareManager].fsAudioStream;
    
    if (lastFSAudioStream && lastFSAudioStream.isPlaying) {
        
        [lastFSAudioStream pause];
        if ([TFSAudioStreamManager shareManager].lastIndexPathRow != self.currentIndexPath.row) {
            [self.audioPlayer play];
        }
    } else {
        [self.audioPlayer play];
        
    }
    
    
}


- (FSAudioStream *)audioPlayer {
    
    if ([TFSAudioStreamManager shareManager].fsAudioStream) {
        [[TFSAudioStreamManager shareManager].fsAudioStream stop];
    }
    
    // 1.获取要播放音频文件的URL
    NSURL *voiceURL = [NSURL URLWithString:self.topic.voiceuri];
    // 创建FSAudioStream对象
    _audioPlayer = [[FSAudioStream alloc]initWithUrl:voiceURL];
    
    _audioPlayer.onFailure = ^(FSAudioStreamError error,NSString *description){
        NSLog(@"播放过程中发生错误，错误信息：%@",description);
    };
    
    TWeakSelf(self)
    _audioPlayer.onStateChange = ^(FSAudioStreamState state) {
        switch (state) {
            case kFsAudioStreamPlaying:
            {
                [weakself.playButton setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
            }
                break;
            case kFsAudioStreamStopped:
            {
                [weakself.playButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
            }
                break;
            case kFsAudioStreamPaused:
            {
                [weakself.playButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
    };
    
    _audioPlayer.onCompletion = ^{
        NSLog(@"播放完成!");
        
    };
    // 设置声音
    [_audioPlayer setVolume:1.0];
    
    [TFSAudioStreamManager shareManager].fsAudioStream = _audioPlayer;
    [TFSAudioStreamManager shareManager].lastIndexPathRow = self.currentIndexPath.row;
    
    return _audioPlayer;
}

@end








