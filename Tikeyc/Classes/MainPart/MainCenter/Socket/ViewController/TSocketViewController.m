//
//  TSocketViewController.m
//  Tikeyc
//
//  Created by ways on 2017/10/11.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TSocketViewController.h"

#import "TSocketManager.h"
#import "TCocoaAsyncSocketManager.h"
#import "TWebSocketManager.h"

@interface TSocketViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)sendMessageAction:(UIButton *)sender;
- (IBAction)connectionSocketAction:(UIButton *)sender;
- (IBAction)closeSocketAction:(UIButton *)sender;

@end

@implementation TSocketViewController

- (void)dealloc
{
    //[[TSocketManager share] disConnect];
    [[TCocoaAsyncSocketManager share] disConnect];
//    [[TWebSocketManager share] disConnect];
    //
    [SVProgressHUD dismiss];
    [TNotificationCenter removeObserver:self];
    [self removeObserverBlocks];
    NSLog(@"%@ 成功销毁了，无内存泄漏",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
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

- (IBAction)sendMessageAction:(UIButton *)sender {
    
    //[[TSocketManager share] sendMsg:self.textView.text];
    
    [[TCocoaAsyncSocketManager share] sendMsg:self.textView.text];
    
//    [[TWebSocketManager share] sendMsg:self.textView.text];
    
}

- (IBAction)connectionSocketAction:(UIButton *)sender {
//    int socket = [[TSocketManager share] connect];
//    if (socket == 0) {
//        [SVProgressHUD showErrorWithStatus:@"连接失败"];
//    }
    
    BOOL socket = [[TCocoaAsyncSocketManager share] connect];
    if (!socket) {
        [SVProgressHUD showErrorWithStatus:@"连接失败"];
    }
    
//    [[TWebSocketManager share] connect];
}

- (IBAction)closeSocketAction:(UIButton *)sender {
    //[[TSocketManager share] disConnect];
    
    [[TCocoaAsyncSocketManager share] disConnect];
    
//    [[TWebSocketManager share] disConnect];
}

@end














