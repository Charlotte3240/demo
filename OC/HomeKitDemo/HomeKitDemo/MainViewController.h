//
//  MainViewController.h
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/24.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomesCollectionView.h"
#import "HomesCollectionViewCell.h"
#import "RoomsCollectionView.h"
#import "RoomsCollectionViewCell.h"
@interface MainViewController : UIViewController

@property (nonatomic,strong)HMHomeManager *homeManager;
@property (weak, nonatomic) IBOutlet HomesCollectionView *homeCollectionView;
@property (weak, nonatomic) IBOutlet RoomsCollectionView *roomCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *currentHomeLabel;
@end
