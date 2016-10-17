//
//  ViewController.m
//  SafariWebViewController
//
//  Created by 刘春奇 on 16/1/4.
//  Copyright © 2016年 cloudnapps.com. All rights reserved.
//

#import "ViewController.h"
#import <SafariServices/SafariServices.h>
@interface ViewController ()<SFSafariViewControllerDelegate>

@end

@implementation ViewController
{
    UITextField *text;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"跳转到 Safari web view controller" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(pushWeb) forControlEvents:UIControlEventTouchUpInside];
    text = [[UITextField alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    text.backgroundColor = [UIColor grayColor];
    [self.view addSubview:text];
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(200, 100, 100, 100);
    clearBtn.backgroundColor = [UIColor redColor];
    [clearBtn setTitle:@"clear" forState:UIControlStateNormal];
    [self.view addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clear{
    text.text = @"";
}
- (void)pushWeb{
    SFSafariViewController *sfaVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://ocnswx536.bkt.clouddn.com/metro2.pkpass"]];
    sfaVC.delegate = self;
    [self presentViewController:sfaVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SFSafariViewControllerDelegate
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    NSLog(@"已经打开web");
}
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{
    NSLog(@"web 打开未成功");
}

@end
