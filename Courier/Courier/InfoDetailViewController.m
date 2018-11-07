//
//  InfoDetailViewController.m
//  Courier
//
//  Created by 刘春奇 on 2017/7/6.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "InfoDetailViewController.h"
#import "InfoDetailCell.h"
@interface InfoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InfoDetailViewController{
    NSArray *_dataList;
    NSString *_type;
    NSString *_numCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.body.allKeys containsObject:@"result"]) {
        NSDictionary *resDic = self.body[@"result"];
        if ([resDic.allKeys containsObject:@"list"]) {
            _dataList = self.body[@"result"][@"list"];
            //最后状态
//            _dataList.firstObject;
        }
        if ([resDic.allKeys containsObject:@"type"]) {
            _type = self.body[@"result"][@"type"];
            //快递公司
        }
        if ([resDic.allKeys containsObject:@"number"]) {
            _numCode = self.body[@"result"][@"number"];
            //快递单号
            
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"InfoDetailCell";
    InfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[InfoDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.infoDic = _dataList[indexPath.row];

    return cell;
}

@end
