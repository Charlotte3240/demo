//
//  HCFileManager.h
//  AFNCacheDemo
//
//  Created by 刘春奇 on 2017/3/15.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HCFileManager : NSObject
+ (instancetype)currentCache;

//储存result 到Cache
- (void)setObject:(id<NSCoding>)anyObject forKey:(NSString *)key;

//读取Cache
- (id<NSCoding>)objectForKey:(NSString *)key;

//清空Cache
- (void)clearCache;

@end
