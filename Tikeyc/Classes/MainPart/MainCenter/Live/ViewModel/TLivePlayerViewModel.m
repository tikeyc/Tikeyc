//
//  TLivePlayerViewModel.m
//  Tikeyc
//
//  Created by ways on 16/9/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLivePlayerViewModel.h"

@implementation TLivePlayerViewModel

- (instancetype)initWithPlayer:(id <IJKMediaPlayback>)player{
    self = [super init];
    if (self) {
        [self initRACSignalWithPlayer:player];
    }
    return self;
}


#pragma mark - init bind

- (void)initRACSignalWithPlayer:(id <IJKMediaPlayback>)player{
    //
    [self installMovieNotificationObserversWithPlayer:player];
}

#pragma Install Notifiacation

- (void)installMovieNotificationObserversWithPlayer:(id <IJKMediaPlayback>)player {
    
    
    RACSignal *signal1 = [TNotificationCenter rac_addObserverForName:IJKMPMoviePlayerLoadStateDidChangeNotification object:player];
    
    RACSignal *signal2 = [TNotificationCenter rac_addObserverForName:IJKMPMoviePlayerPlaybackDidFinishNotification object:player];
    
    RACSignal *signal3 = [TNotificationCenter rac_addObserverForName:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    
    RACSignal *signal4 = [TNotificationCenter rac_addObserverForName:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:player];
    
    @weakify(self)
    [[[signal1 merge:signal2] merge:[signal3 merge:signal4]] subscribeNext:^(NSNotification *notification) {
        id <IJKMediaPlayback> player = notification.object;
        @strongify(self)
        if ([notification.name isEqualToString:IJKMPMoviePlayerLoadStateDidChangeNotification]) {
            IJKMPMovieLoadState loadState = player.loadState;
            
            if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
                NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
            }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
                NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
                [player play];
            } else {
                NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
            }
        }else if ([notification.name isEqualToString:IJKMPMoviePlayerPlaybackDidFinishNotification]){
            int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
            switch (reason) {
                case IJKMPMovieFinishReasonPlaybackEnded:
                    NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
                    break;
                    
                case IJKMPMovieFinishReasonUserExited:
                    NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
                    break;
                    
                case IJKMPMovieFinishReasonPlaybackError:
                    NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
                    break;
                    
                default:
                    NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
                    break;
            }
        }else if ([notification.name isEqualToString:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification]){
            NSLog(@"mediaIsPrepareToPlayDidChange\n");
        }else if ([notification.name isEqualToString:IJKMPMoviePlayerPlaybackStateDidChangeNotification]){
            switch (player.playbackState) {
                case IJKMPMoviePlaybackStateStopped:
                    NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)player.playbackState);
                    break;
                    
                case IJKMPMoviePlaybackStatePlaying:
                    NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)player.playbackState);
                    break;
                    
                case IJKMPMoviePlaybackStatePaused:
                    NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)player.playbackState);
                    break;
                    
                case IJKMPMoviePlaybackStateInterrupted:
                    NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)player.playbackState);
                    break;
                    
                case IJKMPMoviePlaybackStateSeekingForward:
                case IJKMPMoviePlaybackStateSeekingBackward: {
                    NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)player.playbackState);
                    break;
                }
                    
                default: {
                    NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)player.playbackState);
                    break;
                }
            }
        }
    }];
    
}

@end










