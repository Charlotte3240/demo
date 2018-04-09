//
//  ViewController2.m
//  SearchControllerDemo
//
//  Created by 刘春奇 on 2016/9/30.
//  Copyright © 2016年 刘春奇. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()<UISearchControllerDelegate,UISearchResultsUpdating>
@property (nonatomic,strong)NSArray *items;
@property (nonatomic,strong)NSArray *searchResults;
@property (nonatomic,strong)UISearchController *searchController;
@end

@implementation ViewController2

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.frame =CGRectMake(self.searchController.searchBar.frame.origin.x,self.searchController.searchBar.frame.origin.y,self.searchController.searchBar.frame.size.width,44.0);
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    self.myTableView.tableHeaderView = self.searchController.searchBar;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.items = @[@"瓦洛兰 Valoran",
                   @"德玛西亚 Demacia",
                   @"诺克萨斯 Noxus",
                   @"艾欧尼亚 Ionia",
                   @"皮尔特沃夫 Piltover",
                   @"弗雷尔卓德 Freijord",
                   @"班德尔城 Bandle City",
                   @"战争学院 The Institute of War",
                   @"祖安 Zaun",
                   @"卡拉曼达 Kalamanda",
                   @"蓝焰岛 Blue Flame Island",
                   @"哀嚎沼泽 Howling Marsh",
                   @"艾卡西亚 Icathia",
                   @"铁脊山脉 Ironspike Mountains",
                   @"库莽古丛林 Kumungu",
                   @"洛克法 Lokfar",
                   @"摩根小道 Morgon Pass",
                   @"塔尔贡山脉 Mountain Targon",
                   @"瘟疫丛林 Plague Jungles",
                   @"盘蛇河 Serpentine River",
                   @"恕瑞玛沙漠 Shurima Desert",
                   @"厄尔提斯坦 Urtistan",
                   @"巫毒之地 Voodoo Lands",
                   @"水晶之痕 Crystal Scar",
                   @"咆哮深渊 Howling Abyss",
                   @"熔岩洞窟 Magma Chambers",
                   @"试炼之地 Proving Grounds",
                   @"召唤师峡谷 Summoner's Rift",
                   @"扭曲丛林 Twisted Treeline"];
    self.searchController.delegate = self;
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.searchController.active) ? self.searchResults.count : self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.textLabel.text = (!self.searchController.active) ? self.items[indexPath.row] : self.searchResults[indexPath.row];
    
    return cell;
}


//筛选关键字
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    
    self.searchResults = [self.items filteredArrayUsingPredicate:resultPredicate];
    [self.myTableView reloadData];
}


#pragma mark - UISearchControllerDelegate
//searchcontoller
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString scope:[[self.searchController.searchBar scopeButtonTitles] objectAtIndex:[self.searchController.searchBar selectedScopeButtonIndex]]];
    
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    
}

@end
