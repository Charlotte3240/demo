//
//  SearchAccessoriesController.h
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/26.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchAccessoriesController : UIViewController

@property HMAccessoryBrowser *accessoryBrowser;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)HMHome *myHome;
@property (nonatomic,strong)HMRoom *myRoom;

@end
