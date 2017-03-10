//
//  ViewController.m
//  CoreAnimationTour
//
//  Created by 刘春奇 on 2017/1/11.
//  Copyright © 2017年 刘春奇. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.center = self.view.center;
    
    //new a  layer
    CALayer *blueLayer = [[CALayer alloc]init];
    blueLayer.frame = CGRectMake(25, 25, 50, 50);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [view.layer addSublayer:blueLayer];
    
//    blueLayer.contents
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
