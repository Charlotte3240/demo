//
//  ServicesViewcontroller.h
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/26.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServicesCollectionView.h"
#import "ServiceCollectionViewCell.h"
@interface ServicesViewcontroller : UIViewController
@property (weak, nonatomic) IBOutlet ServicesCollectionView *collectionView;
@property (nonatomic,strong)HMAccessory *accessory;
@end
