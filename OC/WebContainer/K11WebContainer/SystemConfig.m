//
//  SystemConfig.m
//  K11WebContainer
//
//  Created by 刘春奇 on 16/5/4.
//  Copyright © 2016年 com.Cloudnapps. All rights reserved.
//

#import "SystemConfig.h"
#import "CustomURLCache.h"
@implementation SystemConfig

+ (SystemConfig*)shared{
    static SystemConfig* sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[SystemConfig alloc] init];
        }
    });
    return sharedInstance;
}


- (void)registerDefaultsFromSettingsBundle

{
    
    NSString* url = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
    if(url == nil)
        url = @"http://123.59.74.177:10000/hk/system/index.do";
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"url"];
    
//    BOOL cache = [[NSUserDefaults standardUserDefaults] boolForKey:@"cache"];
//    if(cache == YES){
//        cache = NO;
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cache"];
//        CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
//        [urlCache removeAllCachedResponses];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
//    }
}

@end

