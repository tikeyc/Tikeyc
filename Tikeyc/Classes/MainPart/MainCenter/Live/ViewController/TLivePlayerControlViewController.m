//
//  TLivePlayerControlViewController.m
//  Tikeyc
//
//  Created by ways on 16/9/23.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLivePlayerControlViewController.h"

#import "TLPCMessageListTableView.h"

#import "TLivePlayerControlViewModel.h"

#import "TPLCGiftView.h"
#import "TLPCShareAnimation.h"

@interface TLivePlayerControlViewController ()<UITextFieldDelegate>

{
    dispatch_source_t _timer;
}

@property (nonatomic,strong)TLivePlayerControlViewModel *livePlayerControlViewModel;

///////////////头部视图部分
@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImgView;

@property (strong, nonatomic) IBOutlet UIButton *attentionButton;

@property (strong, nonatomic) IBOutlet UICollectionView *headUserListCollectionView;

///////////////礼物
@property (strong, nonatomic) IBOutlet TPLCGiftView *giftView;


///////////////弹幕
@property (strong, nonatomic) IBOutlet UIView *barrageSuperView;


//////////////////消息列表
@property (strong, nonatomic) IBOutlet TLPCMessageListTableView *messageListTableView;


//////////////////底部按钮控件
@property (strong, nonatomic) IBOutlet UIView *bottomControlSuperView;

@property (strong, nonatomic) IBOutlet UIButton *showTextFieldButton;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIButton *giftButton;
@property (strong, nonatomic) IBOutlet TLPCShareAnimation *shareButton;

//////////////////输入部分
@property (strong, nonatomic) IBOutlet UITextField *accessoryTextField;//隐藏的，用以辅助textFieldSuperView的弹出

@property (strong, nonatomic) IBOutlet UIView *textFieldSuperView;

@property (strong, nonatomic) IBOutlet UISwitch *flakboxbarrageButton;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

//////////////////

@end

@implementation TLivePlayerControlViewController

- (void)dealloc
{
    dispatch_source_cancel(_timer);
    
    [self.shareButton stopAnimation];
    
    [BarrageManager attempDealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initSubViewAndProperty];
    
    [self bindRACSignal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // 收到内存警告时，清楚弹幕缓冲池 When you receive a memory warning，clean the barrage's cache
    [self.livePlayerControlViewModel.manager didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    dispatch_source_cancel(_timer);
    
    [self.livePlayerControlViewModel.manager closeBarrage];
    
    [self.shareButton stopAnimation];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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

- (TLivePlayerControlViewModel *)livePlayerControlViewModel{
    if (!_livePlayerControlViewModel) {
        _livePlayerControlViewModel = [[TLivePlayerControlViewModel alloc] init];
    }
    return _livePlayerControlViewModel;
}

- (void)initSubViewAndProperty{
    //
    self.userPhotoImgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"live_icon" ofType:@"jpg"]];
    //
    self.headUserListCollectionView.backgroundColor = [UIColor clearColor];
    self.headUserListCollectionView.dataSource = (id)self.livePlayerControlViewModel;
    self.headUserListCollectionView.delegate = (id)self.livePlayerControlViewModel;
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    self.headUserListCollectionView.collectionViewLayout = flowLayout;
    //
    [self.headUserListCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //
    self.textFieldSuperView.frame = CGRectMake(0, 0, kScreenWidth, 50);
    //
    self.giftView = [[[NSBundle mainBundle] loadNibNamed:@"TPLCGiftView" owner:nil options:NULL] lastObject];
    [self.view addSubview:self.giftView];
    TWeakSelf(self)
    [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(16));
        make.width.equalTo(@(180));
        make.height.equalTo(@(40));
        make.bottom.equalTo(weakself.barrageSuperView.mas_top).offset(-20);
    }];
    [self.giftView startGiftNumLabelAnimation];
}

#pragma mark - bind RACSignal

- (void)bindRACSignal{
    @weakify(self)
    /////////////////////////////////弹幕部分
    self.barrageSuperView.backgroundColor = [UIColor clearColor];
    [self.livePlayerControlViewModel creatBarrageViewWithSuperView:self.barrageSuperView];
    
    //////////////////////////////////////////按钮事件
    //
    [[self.flakboxbarrageButton rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *switchButton) {
        @strongify(self)
        if (switchButton.on) {
            [self.livePlayerControlViewModel.manager startScroll];
        }else{
            [self.livePlayerControlViewModel.manager closeBarrage];
        }
    }];
    //
    [[self.showTextFieldButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        self.bottomControlSuperView.hidden = YES;
        //
        self.accessoryTextField.inputAccessoryView = nil;
        self.accessoryTextField.inputAccessoryView = self.textFieldSuperView;
        [self.accessoryTextField becomeFirstResponder];
        [self.textField becomeFirstResponder];
    }];
    //
    [[self.sendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if ([self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length != 0) {
            [self addMessageModelWithMessage:self.textField.text];
            self.textField.text = nil;//情况输入框
        }
        
    }];
    //////////////////////////////////////////键盘输入
    self.accessoryTextField.delegate = self;
    self.textField.delegate = self;
//    RAC(self.messageListTableView,messageListModels) =
    self.messageListTableView.messageListModels = [NSMutableArray array];
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self)
        UITextField *textField = [[(RACTuple *)x allObjects] firstObject];
        if ([textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length != 0) {
//            [self.textField resignFirstResponder];
//            [self.accessoryTextField resignFirstResponder];
//            self.bottomControlSuperView.hidden = NO;
            //
            [self addMessageModelWithMessage:textField.text];
            self.textField.text = nil;//情况输入框
        }
    }];
    //
    RACSignal *didSignal = [TNotificationCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil];
    RACSignal *willSignal = [TNotificationCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil];
    RAC(self.view,top) = [[didSignal merge:willSignal] map:^id(id value) {
        @strongify(self)
        if ([value name] == UIKeyboardWillHideNotification) {
            return @(0);
        }
        CGRect keyboardRect = [[[value userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"%@",NSStringFromCGRect(keyboardRect));

        return @(-(keyboardRect.size.height - 85 + 25));
        
    }];
    
    //////////////////////////////////////////消息列表
    [[self.livePlayerControlViewModel.requestCommand execute:nil] subscribeNext:^(id x) {
        
    }];
    //模拟刷新消息列表
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0*NSEC_PER_SEC); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self)
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //定时结束后的UI处理
            });
        }else{
//            NSLog(@"时间 = %d",timeout);
            NSString *strTime = [NSString stringWithFormat:@"定时器发送消息中...(%dS)",timeout];
            NSLog(@"strTime = %@",strTime);
            dispatch_async(dispatch_get_main_queue(), ^{
                //定时过程中的UI处理
                [self addMessageModelWithMessage:@"定时器发送消息中..."];
            });
            
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

#pragma mark - Actions

- (void)addMessageModelWithMessage:(NSString *)message{
    //
    TPLCMessageModel *messageModel = [[TPLCMessageModel alloc] init];
    messageModel.message = message;
    messageModel.userNickName = @"💕💖阿福卡💕💖:";
    [self.messageListTableView.messageListModels addObject:messageModel];
    [self.messageListTableView reloadData];
}

#pragma mark - touches 点击弹幕

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
    [self.accessoryTextField resignFirstResponder];
    
    self.bottomControlSuperView.hidden = NO;
    
    //
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.barrageSuperView];
    [[self.livePlayerControlViewModel.manager barrageScenes] enumerateObjectsUsingBlock:^(BarrageScene * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layer.presentationLayer hitTest:touchPoint]) {
            //弹幕类型为投票类型时，为弹幕添加点击事件，请在此处添加
            /* if barrage's type is ` BarrageDisplayTypeVote `, add your code here*/
            NSLog(@"message = %@",obj.model.message.string);
        }
    }];
}


@end














