//
//  RoomConfigController.h
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/25.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccessoryCollectionView.h"
#import "AccessoryCollectionViewCell.h"
@interface RoomConfigController : UIViewController

@property (weak, nonatomic) IBOutlet AccessoryCollectionView *accessoryCollectionView;
@property (nonatomic,strong)HMRoom *myRoom;
@property (nonatomic,strong)HMHome *myHome;
@end
