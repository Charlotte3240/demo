//
//  HCNetWorkManager.h
//  AFNCacheDemo
//
//  Created by 刘春奇 on 2017/3/15.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"
#import "HCFileManager.h"

#define  HC_ReachabilityManager  [AFNetworkReachabilityManager sharedManager]
#define  HC_NetWorkManager [HCNetWorkManager currentManager]

#define MALL_SERVER_AUTH_BODY @{@"username":@"admin", @"password":@"password1"}

typedef enum{POST, GET} HTTPMETHOD;


typedef void(^FinishDidBlock) (id result);
typedef void(^FailureBlock) (NSError *error);

@interface HCNetWorkManager : NSObject

+ (instancetype)currentManager;
- (void)httpManagerHCNetworkReachabilityManage;

@end
