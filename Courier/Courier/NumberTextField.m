//
//  NumberTextField.m
//  Courier
//
//  Created by 刘春奇 on 2017/7/6.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "NumberTextField.h"

@implementation NumberTextField

- (void)awakeFromNib{
    [super awakeFromNib];
    self.placeholder = @"请输入运单号或点击右边按钮扫描";
    
}

@end
