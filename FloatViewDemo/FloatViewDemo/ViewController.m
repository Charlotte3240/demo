//
//  ViewController.m
//  FloatViewDemo
//
//  Created by 刘春奇 on 2017/4/5.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *floatView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    floatView.backgroundColor = [UIColor blueColor];
    [[UIApplication sharedApplication].keyWindow addSubview:floatView];
}
- (IBAction)pushAction:(id)sender {
    ViewController2 *vc2 = [[ViewController2 alloc]init];
    [self.navigationController pushViewController:vc2 animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
