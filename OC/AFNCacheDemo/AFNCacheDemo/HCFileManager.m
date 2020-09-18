//
//  HCFileManager.m
//  AFNCacheDemo
//
//  Created by 刘春奇 on 2017/3/15.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "HCFileManager.h"
#define FILE_MANAGER [NSFileManager defaultManager]

@implementation HCFileManager{
    NSString *_directory;//目录
}

+ (instancetype)currentCache {
    return [self globalCache];
}

+ (instancetype)globalCache {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
    
}

- (instancetype)init{
    NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    //  bundleIdentifier/HCCache
    cachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"HCCache"] copy];
    return [self initWithCacheDirectory:cachesDirectory];
}

//把路径转成文件名称
static inline NSString* cachePathForKey(NSString* directory, NSString* key) {
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return [directory stringByAppendingPathComponent:key];
}
//创建_directory 目录
- (instancetype)initWithCacheDirectory:(NSString*)cacheDirectory {
    if (self = [super init]) {
        _directory = cacheDirectory;

        NSMutableDictionary *cacheInfo = [[NSMutableDictionary dictionaryWithContentsOfFile:cachePathForKey(cacheDirectory, @"HCCache.plist")] mutableCopy];
        if (!cacheInfo) {
            cacheInfo = [NSMutableDictionary dictionary];
        }
        //创建cache 文件夹
        /*
         /Users/Charlotte/Library/Developer/CoreSimulator/Devices/215BBBEC-0CF8-4BCE-AFD0-BC555B88CA38/data/Containers/Data/Application/B3F0E686-D89A-47EC-9683-1B9624107045/Library/Caches/com.hc-nsqk.hc.AFNCacheDemo/HCCache
         */
        BOOL isDir;
        NSError *error = nil;
        if (![FILE_MANAGER fileExistsAtPath:_directory isDirectory:&isDir]) {
            //不存在此文件夹  创建文件夹
            [FILE_MANAGER createDirectoryAtPath:_directory withIntermediateDirectories:YES attributes:nil error:&error];
            if(!error)
                NSLog(@"创建文件夹成功");
            else
                NSLog(@"创建文件夹失败 error is%@",error);
        }
    }
    return self;
}




#pragma mark - method use
- (void)setObject:(id<NSCoding>)anyObject forKey:(NSString *)key{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:anyObject];
    NSString* cachePath = cachePathForKey(_directory, key);

}


@end
