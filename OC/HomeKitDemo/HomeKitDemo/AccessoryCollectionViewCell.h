//
//  AccessoryCollectionViewCell.h
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/25.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *accessoryName;
@property (weak, nonatomic) IBOutlet UILabel *accessoryStatus;

@end
