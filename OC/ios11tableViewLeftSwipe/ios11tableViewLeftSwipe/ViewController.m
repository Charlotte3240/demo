//
//  ViewController.m
//  ios11tableViewLeftSwipe
//
//  Created by 刘春奇 on 2017/11/6.
//  Copyright © 2017年 com.cloudnapps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableview;


@end

@implementation ViewController{
    NSArray *_dataList;
}

- (UITableView *)myTableview{
    if (_myTableview == nil) {
        _myTableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
    }
    return _myTableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataList = @[@1,@2,@3,@4,@5,@6,@7,@8,@9];
    [self.view addSubview:self.myTableview];

}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"leftswipecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataList[indexPath.row]];
    return cell;
}

//swipe delegate

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *firstAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"normalStyle" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"normal action response");
        completionHandler(YES);

    }];
    
    UIContextualAction *secondAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"destructiveStyle" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"destructive action response");
        completionHandler(YES);

    }];
    
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[firstAction,secondAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *firstAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"normalStyle" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"normal action response");
        
        completionHandler(YES);

        
    }];
    
    UIContextualAction *secondAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"destructiveStyle" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"destructive action response");
        //delete indexpath row
        NSMutableArray *temp = [_dataList mutableCopy];
        [temp removeObjectAtIndex:indexPath.row];
        _dataList = [temp mutableCopy];
        NSLog(@"%@",_dataList);
        completionHandler(YES);

    }];
    
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[secondAction,firstAction]];
//    config.performsFirstActionWithFullSwipe = NO;

    return config;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
