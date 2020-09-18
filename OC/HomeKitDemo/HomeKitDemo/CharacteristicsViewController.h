//
//  CharacteristicsViewController.h
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/26.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacteristicsCollectionView.h"
#import "CharacteristicCollectionViewCell.h"
@interface CharacteristicsViewController : UIViewController

@property (weak, nonatomic) IBOutlet CharacteristicsCollectionView *characteristiCollectionView;
@property (nonatomic,strong)HMService *service;
@property (nonatomic,strong)HMAccessory *accessory;
@end
