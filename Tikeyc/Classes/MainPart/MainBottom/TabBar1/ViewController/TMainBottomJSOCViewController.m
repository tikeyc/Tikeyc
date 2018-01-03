//
//  TMainBottomJSOCViewController.m
//  Tikeyc
//
//  Created by ways on 2017/6/9.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TMainBottomJSOCViewController.h"
#import "TWebJSInterface.h"

@interface TMainBottomJSOCViewController ()<UIWebViewDelegate>


@property (nonatomic,strong)TWebJSInterface *webJSInterface;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) JSContext *context;

- (IBAction)useOCCallJS:(UIButton *)sender;

@end

@implementation TMainBottomJSOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initProperty];
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


- (void)initProperty {
    self.webView.delegate = self;
    
    _webJSInterface = [[TWebJSInterface alloc] init];
    
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"jsocIndex" ofType:@"html"];
    NSURL * url = [[NSURL alloc] initWithString:path];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    
}



#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //JS 与原生代码绑定 类似于Android 中WebView.addJavaScriptInteface(_webJSInterface,"Android");
    _context[@"iOS"] = _webJSInterface;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@",error.description);
}


#pragma mark - actions

- (IBAction)useOCCallJS:(UIButton *)sender {
    NSString *alertJS = @"alert('OC调用JS并弹出此内容')"; //准备执行的js代码
    alertJS = @"useOCCallJS('OC调用JS并弹出OC传入JS的此内容')";
    [_context evaluateScript:alertJS];//通过oc方法调用js的alert
    
}

@end







