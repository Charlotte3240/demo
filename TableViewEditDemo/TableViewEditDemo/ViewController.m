//
//  ViewController.m
//  TableViewEditDemo
//
//  Created by 刘春奇 on 15/12/30.
//  Copyright © 2015年 cloudnapps.com. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
@interface ViewController ()

@end

@implementation ViewController
{
    UITableView *myTableView;
    NSMutableArray *dataList;
    NSMutableArray *selectdArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataList = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSDictionary *dic = @{@"num":[NSString stringWithFormat:@"%d",i],@"isSelect":@NO};
        [dataList addObject:dic];
    }
    selectdArray = [NSMutableArray array];
    myTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    myTableView.delegate = self;
    myTableView.allowsSelectionDuringEditing = YES;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    //load edit Btn
    [self loadEditBtn];
}

- (void)loadEditBtn{
    [myTableView setEditing:NO animated:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(changeEditMode)];
}

- (void)changeEditMode{
    [myTableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancle" style:UIBarButtonItemStyleDone target:self action:@selector(loadEditBtn)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

//创建tableviewcell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *iden = @"demoCell";
    MyTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.textLabel.text = dataList[indexPath.row][@"num"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.mSelected = [ (NSNumber *)dataList[indexPath.row][@"isSelect"] boolValue];

    return cell;
}
//删除某行
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [dataList removeObjectAtIndex:indexPath.row];
        [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
//更改删除文字
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *delTitle = @"删除一行数据";
    return delTitle;
}
//移动单元格 更新数据
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [dataList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

//设置单元格编辑方式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= dataList.count) {
        if (myTableView.isEditing) {
            MyTableViewCell *cell = (MyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell changeMSelectedState];
            NSMutableDictionary *dic = [dataList[indexPath.row] mutableCopy];
            dic[@"isSelect"] = [NSNumber numberWithBool:cell.mSelected];
            [dataList replaceObjectAtIndex:indexPath.row withObject:dic];
            NSLog(@"%@",dataList);
        }
        
    }
}

//使tableview可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//使tableview可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}






@end
