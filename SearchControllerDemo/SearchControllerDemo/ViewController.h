//
//  ViewController.h
//  SearchControllerDemo
//
//  Created by 刘春奇 on 2016/9/30.
//  Copyright © 2016年 刘春奇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong)UISearchController *searchController;
@end

