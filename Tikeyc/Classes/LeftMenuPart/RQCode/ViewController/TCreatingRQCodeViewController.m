//
//  TCreatingRQCodeViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/30.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TCreatingRQCodeViewController.h"


#import "HCHeader.h"

@interface TCreatingRQCodeViewController ()


@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UIButton *creatingButton;
@property (strong, nonatomic) IBOutlet UIButton *QRImgView;


@end

@implementation TCreatingRQCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self bindRACSignal];
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

#pragma mark - bind

- (void)bindRACSignal{
    
    TWeakSelf(self)
    [[self.creatingButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakself.view endEditing:YES];
        
        UIImage *image = [HCCreateQRCode createQRCodeWithString:weakself.inputTextField.text ViewController:weakself];
        [weakself.QRImgView setBackgroundImage:image forState:UIControlStateNormal];
        weakself.QRImgView.userInteractionEnabled = image ? YES : NO;
    }];
    
    //
    RAC(self.QRImgView,userInteractionEnabled) = [RACObserve(self.QRImgView, currentBackgroundImage) map:^id(UIImage *value) {
        if (value) {
            return @(YES);
        }
        return @(NO);
    }];
    [[self.QRImgView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [TAlertView showWithTitle:nil message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"扫描图中二维码"] type:UIAlertControllerStyleActionSheet andParentView:nil andAction:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [TScaningLocalCode scanLocaImage:weakself.QRImgView.currentBackgroundImage];
            }
        } ];
    }];
}

#pragma mark - Actions

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}



@end




