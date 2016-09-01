//
//  TQRCodeWebViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/31.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TQRCodeWebViewController.h"

@interface TQRCodeWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;




@end

@implementation TQRCodeWebViewController


- (void)dealloc
{
    [SVProgressHUD dismiss];
}

- (instancetype)initWithURL:(NSURL *)webURL{
    self = [super init];
    if (self) {
        self.webURL = webURL;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self loadWebView];
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


#pragma mark - 

- (void)loadWebView{
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.webURL]];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [SVProgressHUD dismiss];
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"currentURL:%@",currentURL);

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

@end
















