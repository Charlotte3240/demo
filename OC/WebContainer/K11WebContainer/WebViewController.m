//
//  WebViewController.m
//  UiWebViewCache
//
//  Created by 刘春奇 on 16/4/27.
//  Copyright © 2016年 com.hc-nsqk. All rights reserved.
//

#import "WebViewController.h"
#import "CustomURLCache.h"
#import "MBProgressHUD.h"
@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, retain) UIWebView *web;
@property (nonatomic, retain) UILabel *label;
@end


@implementation WebViewController

@synthesize webView = _webView;


- (void)dealloc{
    //remove notification
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refresh" object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
//                                                                     diskCapacity:200 * 1024 * 1024
//                                                                         diskPath:nil
//                                                                        cacheTime:0];
//        [CustomURLCache setSharedURLCache:urlCache];
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refresh" object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    self.webView = webView;
    
    [self.view addSubview:_webView];
    
    NSString* url = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
    if (url.length == 0) {
        url = @"https://www.cloudnapps.com";
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
   /*
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"后退" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc]initWithTitle:@"前进" style:UIBarButtonItemStylePlain target:self action:@selector(forward)];
    
    NSArray *leftItems = @[backItem,forwardItem];
    self.navigationItem.leftBarButtonItems = leftItems;
    */

}
/*
- (void)goback {
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
    }
}
- (void)forward{
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}
 */

- (void)refresh{
    NSString* url = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
    if (url.length == 0) {
        url = @"https://www.cloudnapps.com";
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
}



#pragma mark - webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    NSString *string = @"$(\".infoEdit\").on(\'touchstart click\', \'a.loveItBut\', function(){\
//    var $me = $(this);\
//    var id = $me.attr(\'data\');\
//    if($me.attr(\'add\')){\
//        return ;\
//    }\
//    var $loveIt = $(\'span.loveIt[data=\'+ id+ \']\');\
//    var loveNum = parseInt($loveIt.text());\
//    $loveIt.text(++ loveNum);\
//    $me.attr(\'add\', true);\
//    });\
//    ";
//    [webView stringByEvaluatingJavaScriptFromString:string];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}
@end
