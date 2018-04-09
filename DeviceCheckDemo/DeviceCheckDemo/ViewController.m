//
//  ViewController.m
//  DeviceCheckDemo
//
//  Created by 刘春奇 on 2017/11/20.
//  Copyright © 2017年 Charlotte. All rights reserved.
//

#import "ViewController.h"
#import <DeviceCheck/DeviceCheck.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNewDeviceId];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"send" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = self.view.center;
    [btn addTarget: self action:@selector(getNewDeviceId) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
}
- (NSString *)getNewDeviceId {
    if ([DCDevice.currentDevice isSupported]) {
        [DCDevice.currentDevice generateTokenWithCompletionHandler:^(NSData * _Nullable token, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.description);
            } else {
                // upload token to APP server
                NSString *deviceToken = [token base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

                NSLog(@"token is --- %@", deviceToken);
            }
        }];
    }
    return @"";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
