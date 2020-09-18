 //
//  CharacteristicsViewController.m
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/26.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "CharacteristicsViewController.h"

@interface CharacteristicsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HMAccessoryDelegate>

@end

@implementation CharacteristicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accessory.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.service.characteristics.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CharacteristicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CharacteristicCollectionViewCell" forIndexPath:indexPath];
    HMCharacteristic *characteristic = self.service.characteristics[indexPath.row];
    
    
    [characteristic readValueWithCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            // Successfully read the value
            id value = characteristic.value;
            NSLog(@"%@",characteristic.characteristicType);
            if ([characteristic.characteristicType isEqualToString: HMCharacteristicTypePowerState]) {
                cell.characteristicName.text = [value  isEqual: @0] ? @"关":@"开";

            }else if([characteristic.characteristicType isEqualToString: HMCharacteristicTypeRotationDirection]){
                cell.characteristicName.text = [value  isEqual: @0]? @"顺时针":@"逆时针";

            }else if([characteristic.characteristicType isEqualToString: HMCharacteristicTypeRotationSpeed]){
                cell.characteristicName.text = [NSString stringWithFormat:@"速度%@",value];
            }else{
                cell.characteristicName.text = [NSString stringWithFormat:@"%@%@",value,characteristic.localizedDescription];

            }
        }
        else {
            // Unable to read the value
            cell.characteristicName.text = @" Unable to read the value";

        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HMCharacteristic *characteristic = self.service.characteristics[indexPath.row];
    [characteristic readValueWithCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            // Successfully read the value
            id value = characteristic.value;
            if ([characteristic.characteristicType isEqualToString: HMCharacteristicTypePowerState]) {
                value = [value  isEqual: @0] ? @1 :@0;
                [self writeValue:value characteristic:characteristic];
            }else if([characteristic.characteristicType isEqualToString: HMCharacteristicTypeRotationDirection]){
                value = [value  isEqual: @0] ? @1 :@0;
                [self writeValue:value characteristic:characteristic];
            }else if([characteristic.characteristicType isEqualToString: HMCharacteristicTypeRotationSpeed]){
                //TODO: TODO: FAN SPEED INPUT
            }else{
                //TODO: TODO: ELSE ABLE
            }
        }
        else {
            // Unable to read the value
            NSLog(@"Unable to read the value");
        }
    }];
}



#pragma mark - HMAccessoryDelegate
- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic{
    self.accessory = accessory;
    [self.characteristiCollectionView reloadData];
}

- (void)writeValue:(id)value characteristic:(HMCharacteristic *)characteristic{
    [SVProgressHUD show];
    [characteristic writeValue:value completionHandler:^(NSError * _Nullable error) {
        
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"更改为%@",value]];
            [self.characteristiCollectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"操作失败error is %@",error]];
        }
        [SVProgressHUD dismissWithDelay:1];
    }];
}

@end
