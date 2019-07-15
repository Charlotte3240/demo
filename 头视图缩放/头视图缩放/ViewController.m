//
//  ViewController.m
//  头视图缩放
//
//  Created by 红尘 on 15/8/31.
//  Copyright (c) 2015年 红尘. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController{
    UIImageView *imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"二维码.jpg"];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = imageView;
    
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"demoCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y+64;//根据实际选择加不加上NavigationBarHight（44、64 或者没有导航条）
    if (y < 0) {
        CGRect frame = imageView.frame;
        frame.origin.y = 64;
        frame.size.height =  -(scrollView.contentOffset.y);
        //contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = frame;
        NSLog(@"frame y:%f x:%f ",imageView.frame.origin.y,imageView.frame.origin.x);
    }
}

@end
