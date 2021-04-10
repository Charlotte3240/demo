//
//  LeftSwipeTableViewCell.m
//  ios11tableViewLeftSwipe
//
//  Created by Charlotte on 2020/12/22.
//  Copyright © 2020 com.cloudnapps. All rights reserved.
//

#import "LeftSwipeTableViewCell.h"
#import "ios11tableViewLeftSwipe-Swift.h"

@implementation LeftSwipeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
//        [self setupUI];
    }
    return self;
}


- (void)setupUI{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(0, 0, 100, 30)];
    button.titleLabel.textColor = UIColor.blueColor;
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [self.contentView addSubview:button];
    button.center = self.contentView.center;
    [button addTarget:self action:@selector(beginEdit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)beginEdit{
    [self showActions];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
