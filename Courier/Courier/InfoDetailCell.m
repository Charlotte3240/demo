//
//  InfoDetailCell.m
//  Courier
//
//  Created by 刘春奇 on 2017/7/6.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "InfoDetailCell.h"

@implementation InfoDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfoDic:(NSDictionary *)infoDic{
    if (_infoDic != infoDic) {
        _infoDic = infoDic;
    }
    [self setNeedsLayout];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.cellText.text = self.infoDic[@"status"];
    
    NSString *dateString = self.infoDic[@"time"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.date.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"HH:mm:ss"];
    self.time.text = [formatter stringFromDate:date];
    
}

@end
