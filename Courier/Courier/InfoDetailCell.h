//
//  InfoDetailCell.h
//  Courier
//
//  Created by 刘春奇 on 2017/7/6.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellText;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic,strong)NSDictionary *infoDic;
@end
