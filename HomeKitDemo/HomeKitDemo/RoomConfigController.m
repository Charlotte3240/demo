//
//  RoomConfigController.m
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/25.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "RoomConfigController.h"
#import "SearchAccessoriesController.h"
#import "ServicesViewcontroller.h"
@interface RoomConfigController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation RoomConfigController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateAccessories];

}

- (void)updateAccessories{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"addanAccessory" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        HMAccessory *accessory = x.userInfo[@"obj"];
        [self addAccessory:accessory];
    }] ;

}

- (void)addAccessory:(HMAccessory *)accessory{
    __weak HMHome *home = self.myHome;
    __weak HMRoom *room = self.myRoom;
    
    [home addAccessory:accessory completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"HOME添加配件失败 error is %@",error);
        } else {
            if (accessory.room != room) {
                [home assignAccessory:accessory toRoom:room completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"把配件拖进房间失败");
                    }else{
                        NSLog(@"把配件拖进房间成功");
                        [self.accessoryCollectionView reloadData];
                    }
                }];
            }
        }
    }];
    

}
- (IBAction)addAccessoryAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchAccessoriesController *searchVC = [sb instantiateViewControllerWithIdentifier:@"SearchAccessoriesController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _myRoom.accessories.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AccessoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AccessoryCollectionViewCell" forIndexPath:indexPath];
    HMAccessory *accessory = _myRoom.accessories[indexPath.row];
    cell.accessoryName.text = accessory.name;
    cell.accessoryStatus.text = accessory.reachable ? @"yes":@"no";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HMAccessory *accessory = _myRoom.accessories[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ServicesViewcontroller *servicesVC = [sb instantiateViewControllerWithIdentifier:@"ServicesViewcontroller"];
    servicesVC.accessory = accessory;
    [self.navigationController pushViewController:servicesVC animated:YES];
}

@end
