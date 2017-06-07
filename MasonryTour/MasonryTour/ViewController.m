//
//  ViewController.m
//  MasonryTour
//
//  Created by 刘春奇 on 2017/5/16.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *box = [[UIView alloc] init];
    box.backgroundColor = [UIColor redColor];
    [self.view addSubview:box];
    
    [box mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.top.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.bottom.equalTo(self.view).with.offset(-10);
    }];
    
//    [box mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(10,10,10,10));
//    }];
    
    //mas update constraints
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [box mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).with.offset(20);
                make.top.equalTo(self.view).with.offset(20);
                make.right.equalTo(self.view).with.offset(-20);
                make.bottom.equalTo(self.view).with.offset(-20);
            }];
        });
    
    NSDate *date1 = [NSDate date];
    NSDate *date2 = [NSDate date];
    
    
    [date1 compare:date2]
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
