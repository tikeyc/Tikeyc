//
//  TLoginViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/24.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLoginViewController.h"

#import "TLoginButton.h"

#import "TLoginViewModel.h"




@interface TLoginViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImgView;

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *userPasswordTextField;

@property (strong, nonatomic) IBOutlet TLoginButton *loginButton;


@property (nonatomic,strong)TLoginViewModel *loginViewModel;

@end

@implementation TLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performSelector:@selector(performSetCornerValue) withObject:nil afterDelay:0];//进入方法查看延迟原因，以后优化该问题

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self initBindProperty];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - set 

- (TLoginViewModel *)loginViewModel{
    if (!_loginViewModel) {
        _loginViewModel = [[TLoginViewModel alloc] initLoginViewModel];
    }
    return _loginViewModel;
}

#pragma mark - init

- (void)performSetCornerValue{
    //    [TKCAppTools setViewCornerCircleWithView:self.userPhotoImgView];
    UIImage *cornerImg = [self.userPhotoImgView.image imageByRoundCornerRadius:self.userPhotoImgView.image.size.width/2];
    self.userPhotoImgView.image = cornerImg;
    [TKCAppTools setCornerWithView:self.loginButton byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
}

- (void)initBindProperty{
    TWeakSelf(self)
    //
    RAC(self.loginViewModel.loginModel,userName) = [[self.userNameTextField rac_textSignal] map:^id(NSString *value) {
//        NSLog(@"%@",value);
        if (![[value lowercaseString] isEqualToString:@"tikeyc"]) {
            weakself.userNameTextField.textColor = [UIColor redColor];
        }else{
            weakself.userNameTextField.textColor = [UIColor blackColor];
        }
        return value;
    }];
    RAC(self.loginViewModel.loginModel,userPassword) = [[self.userPasswordTextField rac_textSignal] map:^id(NSString *value) {
        if (value.length < 6) {
            weakself.userPasswordTextField.textColor = [UIColor redColor];
        }else{
            weakself.userPasswordTextField.textColor = [UIColor blackColor];
        }
        return value;
    }];
    //
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (!weakself.loginViewModel.loginButtonEnable) {
            
            [weakself.loginButton errorRevertAnimationCompletion:^{
                
            }];
        }else{
            
            
            [[weakself.loginViewModel.requestCommand execute:nil] subscribeNext:^(id x) {
                [weakself.loginButton exitAnimationCompletion:^{
                    [TAppDelegateManager gotoMainController];
                }];
            }];
            
        }
        
    }];
    //
    [self.loginViewModel.loginButtonEnableSignal subscribeNext:^(id x) {
        
    }];
    //
    RACSignal *didSignal = [TNotificationCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil];
    RACSignal *willSignal = [TNotificationCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil];
    RAC(self.view,top) = [[didSignal merge:willSignal] map:^id(id value) {
        if ([value name] == UIKeyboardWillHideNotification) {
            return @(0);
        }
        CGRect keyboardRect = [[[value userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect convertRect = [weakself.userPasswordTextField convertRect:weakself.userPasswordTextField.frame toView:weakself.view];
        NSLog(@"%@",NSStringFromCGRect(convertRect));
        if (convertRect.origin.y + convertRect.size.height > keyboardRect.origin.y) {
            NSLog(@"move");
            return @(keyboardRect.origin.y - (convertRect.origin.y + convertRect.size.height));
        }
        
        return @(0);
    }];
    
    
    
}


#pragma mark - Action

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

@end












