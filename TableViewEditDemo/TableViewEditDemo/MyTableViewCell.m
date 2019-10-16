//
//  MyTableViewCell.m
//  TableViewEditDemo
//
//  Created by 刘春奇 on 15/12/30.
//  Copyright © 2015年 cloudnapps.com. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //...
        _mSelected = NO;
        CGRect indicatorFrame = CGRectMake(-30, fabs(self.frame.size.height - 30)/ 2, 30, 30);
        _mSelectedIndicator = [[UIImageView alloc] initWithFrame:indicatorFrame];
//        _mSelectedIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:_mSelectedIndicator];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    if (_mSelected)
    {
        if (((UITableView *)self.superview).isEditing)
        {
            self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
        }
        else
        {
            self.backgroundView.backgroundColor = [UIColor clearColor];
        }
        
        self.textLabel.textColor = [UIColor darkTextColor];
//        [_mSelectedIndicator setImage:[UIImage imageNamed:@"select.png"]];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor grayColor];
//        [_mSelectedIndicator setImage:[UIImage imageNamed:@"unselect.png"]];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [UIView commitAnimations];
}

- (void)changeMSelectedState
{
    _mSelected = !_mSelected;
    [self setNeedsLayout];
}
@end
