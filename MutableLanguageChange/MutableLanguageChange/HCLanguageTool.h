//
//  HCLanguageTool.h
//  MutableLanguageChange
//
//  Created by 刘春奇 on 2017/2/28.
//  Copyright © 2017年 刘春奇. All rights reserved.
//
#define HCGetStringWithKeyFromTable(key,table) [[HCLanguageTool shardInstance] getStringForKey:key withTable:table]
#define CNS @"zh-Hans"
#define EN @"en"
#define CNH @"zh-Hant"
#import <Foundation/Foundation.h>

@interface HCLanguageTool : NSObject

+ (id)shardInstance;


/**
 从bundle（table  就是string的名字）中取出这个key对应的文字
 
 @param key string文件中的key
 @param table string文件的名字
 @return key对应的文字
 */
- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;


/**
 英文和简体中文来回切换
 */
- (void)changeNowLanguage;


/**
 切换到一种语言
 
 @param language 语言宏
 */
- (void)setNewLanguage:(NSString *)language;




@end
