//
//  SearchAccessoriesController.m
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/26.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "SearchAccessoriesController.h"
#import "SearchAccessoriesTableCell.h"
@interface SearchAccessoriesController ()<HMAccessoryBrowserDelegate,UITableViewDelegate,UITableViewDataSource>


@end

@implementation SearchAccessoriesController{
    NSMutableArray *_dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataList = [NSMutableArray array];
    self.accessoryBrowser = [[HMAccessoryBrowser alloc] init];
    self.accessoryBrowser.delegate = self;
    [self.accessoryBrowser startSearchingForNewAccessories];

}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
    NSLog(@"%@",accessory.name);
    [_dataList addObject:accessory];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.accessoryBrowser stopSearchingForNewAccessories];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchAccessoriesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchAccessoriesTableCell"];
    if (cell == nil) {
        cell = [[SearchAccessoriesTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchAccessoriesTableCell"];
    }
    HMAccessory *accessory = _dataList[indexPath.row];
    cell.textLabel.text = accessory.name;
    cell.detailTextLabel.text = accessory.uniqueIdentifier.UUIDString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HMAccessory *accessory = _dataList[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addanAccessory" object:nil userInfo:@{@"obj":accessory}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
