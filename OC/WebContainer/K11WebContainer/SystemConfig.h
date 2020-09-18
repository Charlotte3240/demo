//
//  SystemConfig.h
//  K11WebContainer
//
//  Created by 刘春奇 on 16/5/4.
//  Copyright © 2016年 com.Cloudnapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemConfig : NSObject

+ (SystemConfig*)shared;

- (void)registerDefaultsFromSettingsBundle;

@end
