//
//  ViewController.m
//  拉伸图片
//
//  Created by 刘春奇 on 15/12/31.
//  Copyright © 2015年 cloudnapps.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    CGSize viewSize = self.view.bounds.size;
    
    // 初始化按钮
    UIImageView *imageView = [[UIImageView alloc] init];
    // 设置尺寸
    imageView.bounds = CGRectMake(0, 0, 150, 50);
    // 设置位置
    imageView.center = CGPointMake(viewSize.width * 0.5f, viewSize.height * 0.5f);
    
    // 加载图片
    UIImage *image = [UIImage imageNamed:@"1"];
    
    
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];

    
    
    imageView.image = image;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
