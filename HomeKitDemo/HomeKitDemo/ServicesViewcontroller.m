//
//  ServicesViewcontroller.m
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/26.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "ServicesViewcontroller.h"
#import "CharacteristicsViewController.h"
@interface ServicesViewcontroller ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ServicesViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.accessory.services.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCollectionViewCell" forIndexPath:indexPath];
    HMService *service = self.accessory.services[indexPath.row];
    cell.serviceName.text = service.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HMService *service = self.accessory.services[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CharacteristicsViewController *charateristicVC = [sb instantiateViewControllerWithIdentifier:@"CharacteristicsViewController"];
    charateristicVC.accessory = self.accessory;
    charateristicVC.service = service;
    [self.navigationController pushViewController:charateristicVC animated:YES];
    
    
}



@end
