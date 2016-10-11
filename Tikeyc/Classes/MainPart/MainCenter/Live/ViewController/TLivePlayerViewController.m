//
//  TLivePlayerViewController.m
//  Tikeyc
//
//  Created by ways on 16/9/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLivePlayerViewController.h"

#import "TLivePlayerControlViewController.h"

#import "TLivePlayerViewModel.h"

@interface TLivePlayerViewController ()

{
    CGPoint _startPoint;
    CGFloat _startPlayerControlVCLeft;
}

@property (nonatomic, strong) id <IJKMediaPlayback> player;
@property (nonatomic, weak) UIView *playerSubView;//weak防止不被释放

@property (nonatomic,strong)TLivePlayerViewModel *livePlayerViewModel;

@property (nonatomic,strong)TLivePlayerControlViewController *playerControlVC;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation TLivePlayerViewController

-(void)dealloc
{
    [self.player shutdown];//必须调用不然奔溃
    [TNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    [self initSubViewAndProperty];
    
    [self bindRACSignal];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
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

- (TLivePlayerViewModel *)livePlayerViewModel{
    
    if (!_livePlayerViewModel) {
        _livePlayerViewModel = [[TLivePlayerViewModel alloc] initWithPlayer:self.player];
    }
    return _livePlayerViewModel;
}

- (id <IJKMediaPlayback>)player{
    if (!_player) {
        //http://pull99.a8.com/live/1474599766932715.flv 当时看到一个学生妹，自习课在教室自播，确实不错
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.liveListModel.stream_addr] withOptions:nil];
        [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    }
    return _player;
}

- (TLivePlayerControlViewController *)playerControlVC{
    if (!_playerControlVC) {
        _playerControlVC = [[TLivePlayerControlViewController alloc] init];
        _playerControlVC.view.frame = self.playerSubView.bounds;
        _playerControlVC.view.backgroundColor = [UIColor clearColor];
    }
    return _playerControlVC;
}

- (void)initSubViewAndProperty{
    //
    UIView *playerSubView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.playerSubView = playerSubView;//weak防止不被释放
    self.playerSubView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:self.playerSubView belowSubview:self.backButton];
    //
    UIView *playerView = [self.player view];
    playerView.frame = self.playerSubView.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.playerSubView addSubview:playerView];
    
    //
    [self.playerSubView addSubview:self.playerControlVC.view];
    //
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.playerSubView addGestureRecognizer:panGR];
}

#pragma mark - bind RACSignal

- (void)bindRACSignal{
    @weakify(self)
    [[TNotificationCenter rac_addObserverForName:UIDeviceOrientationDidChangeNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
        UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
        switch (interfaceOrientation) {
            case UIInterfaceOrientationPortraitUpsideDown:{
                
            }
                break;
            case UIInterfaceOrientationPortrait:{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                self.playerSubView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            }
                break;
            case UIInterfaceOrientationLandscapeLeft:{
                self.playerSubView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                
            }
                break;
            case UIInterfaceOrientationLandscapeRight:{
                self.playerSubView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }];
    //
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - panGestureAction

- (void)panAction:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan locationInView:self.playerSubView];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            _startPoint = point;
            _startPlayerControlVCLeft = self.playerControlVC.view.left;
            //关闭键盘
            [self.playerControlVC touchesEnded:[NSSet setWithObject:[UITouch new]] withEvent:nil];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat x_offSet = point.x - _startPoint.x;
//            NSLog(@"x_offSet:%f",x_offSet);
            //
            if (_startPlayerControlVCLeft + x_offSet < 0) {
                return;
            }else if (_startPlayerControlVCLeft + x_offSet > 0){
                _playerControlVC.view.backgroundColor = TColor_RGBA(0, 0, 0, 0.05);
            }
            self.playerControlVC.view.left = _startPlayerControlVCLeft + x_offSet;
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            _playerControlVC.view.backgroundColor = [UIColor clearColor];
            //
            CGFloat controlWith = 0;
            if (_startPlayerControlVCLeft == 0) {
                controlWith = kScreenWidth/4;
            }else if (_startPlayerControlVCLeft == kScreenWidth){
                controlWith = kScreenWidth*3/4;
            }
            if (self.playerControlVC.view.left <= controlWith) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.playerControlVC.view.left = 0;
                }];
            }else if (self.playerControlVC.view.left > controlWith){
                [UIView animateWithDuration:0.3 animations:^{
                    self.playerControlVC.view.left = kScreenWidth;
                }];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            self.playerControlVC.view.left = 0;
            _playerControlVC.view.backgroundColor = [UIColor clearColor];
        }
            break;
            
        default:
            break;
    }
}

@end











