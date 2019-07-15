//
//  ViewController.m
//  FMDBDemo
//
//  Created by 刘春奇 on 2017/9/3.
//  Copyright © 2017年 com.nsqk.chunqi.liu. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    1.创建table
    [self createTable];
    
}


- (void)createTable{
    //获取数据库路径
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    //拼接上数据库文件
    NSString *fileNamePath = [docPath stringByAppendingPathComponent:@"product.sqlite"];
    //创建DB对象
    FMDatabase *db = [FMDatabase databaseWithPath:fileNamePath];
    if (db.open) {
        //创建table
        NSString *sqlString = @"create table if not exists product(\
        _id integer primary key autoincrement,\
        name text not null ,\
        age integer not null\
        )";
        BOOL res = [db executeUpdate:sqlString];
        if (res) {
            NSLog(@"create table product success");
        }else{
            NSLog(@"create table error ");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
