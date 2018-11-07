//
//  AttributeLabel.m
//  Courier
//
//  Created by 刘春奇 on 2017/7/7.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//
#define kWBLinkPhoneName @"phone" //NSString

#import "AttributeLabel.h"
#import "YYText.h"

typedef NS_ENUM(NSUInteger, LinkType)
{
    LinkTypeUnknown,
    LinkTypeURL,
    LinkTypeTag,
    LinkTypeTopic,
    LinkTypeAt,
    LinkTypeEmail,
    LinkTypePhoneNum
};
@implementation AttributeLabel

- (void)awakeFromNib{
    [super awakeFromNib];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:self.sourceData];
    
    YYLabel *label = [YYLabel new];
    label.frame = self.bounds;
    label.attributedText = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    label.numberOfLines = 0;
    [self addSubview:label];
    
    [text yy_setTextHighlightRange:text.yy_rangeOfAll
                             color:[UIColor blueColor]
                   backgroundColor:[UIColor grayColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             NSLog(@"tap text range:...");
                         }];
    
    
}
//phone 正则
- (NSRegularExpression *)regexPhone
{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"^[1-9][0-9]{4,11}$" options:kNilOptions error:NULL];
    });
    return regex;
}

@end
