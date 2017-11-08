//
//  ViewController.m
//  SystemSoundDemo
//
//  Created by 刘春奇 on 2017/9/25.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ViewController{
    NSArray *_dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *arrData = [NSMutableArray array];
    NSFileManager *fileManage = [[NSFileManager alloc]init];
    NSURL *directorURL = [NSURL URLWithString:@"/System/Library/Audio"];
    NSArray *key = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    NSDirectoryEnumerator *enumerator = [fileManage enumeratorAtURL:directorURL includingPropertiesForKeys:key options:0 errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {return YES;}];
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
        }
        else if (![isDirectory boolValue])
        {
            [arrData addObject:url];  // 获取的音频存到数组
        }
    }
    _dataList = [arrData mutableCopy];
    [self.myTableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[_dataList[indexPath.row] lastPathComponent]];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(_dataList[indexPath.row]), &soundId);
}


@end
