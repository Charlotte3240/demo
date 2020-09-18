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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                                                     diskCapacity:200 * 1024 * 1024
                                                                         diskPath:nil
                                                                        cacheTime:0];
        [CustomURLCache setSharedURLCache:urlCache];
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    self.webView = webView;

    [self.view addSubview:_webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://123.59.74.177:10000/hk/system/index.do"]]];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"后退" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc]initWithTitle:@"前进" style:UIBarButtonItemStylePlain target:self action:@selector(forward)];
    
    NSArray *leftItems = @[backItem,forwardItem];
    self.navigationItem.leftBarButtonItems = leftItems;
}
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

- (void)refresh{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://image.baidu.com/"]]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
}



#pragma mark - webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}
@end