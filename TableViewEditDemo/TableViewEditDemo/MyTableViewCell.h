//
//  MyTableViewCell.h
//  TableViewEditDemo
//
//  Created by 刘春奇 on 15/12/30.
//  Copyright © 2015年 cloudnapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property(nonatomic,assign)BOOL mSelected;
@property (nonatomic,strong)UIImageView *mSelectedIndicator;
- (void)changeMSelectedState;

@end
