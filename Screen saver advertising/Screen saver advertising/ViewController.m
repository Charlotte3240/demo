//
//  ViewController.m
//  Screen saver advertising
//
//  Created by 刘春奇 on 2017/3/14.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSTimer *_timer;
    int _repeatCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.view.backgroundColor = [UIColor whiteColor];
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //初始化一个定时器
    NSLog(@"现在时间 %@",[NSDate date]);
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(displayAd) userInfo:nil repeats:YES];
    _repeatCount = 0;
    //开启定时器
    [_timer fire];
}

- (void)displayAd{
    _repeatCount++;
    NSLog(@"定时器调用 次数为%d",_repeatCount);
    if (_repeatCount == 1) {
        return;
    }
    self.view.backgroundColor = [UIColor blueColor];
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}

@end
