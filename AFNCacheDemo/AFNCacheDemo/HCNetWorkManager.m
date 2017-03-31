//
//  HCNetWorkManager.m
//  AFNCacheDemo
//
//  Created by 刘春奇 on 2017/3/15.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "HCNetWorkManager.h"

#define MALL_SERVER_URL @"https://www.baidu.com/v1/%@"

@implementation HCNetWorkManager{
    AFHTTPSessionManager *_sessionManager;
    NSInteger _reachabilityStatus;
    NSString *_url;
}
+ (instancetype)currentManager{
    return [self sharedNetWorkManager];
}

+ (instancetype)sharedNetWorkManager{
    static id instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[[self class] alloc] init];
        
    });
    
    return instance;
}

- (instancetype)init{
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return self;
}

- (void)httpManagerHCNetworkReachabilityManage {
    
    [HC_ReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        _reachabilityStatus = status;
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable: {
                
                NSLog(@"无网络");
                
                break;
                
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                
                NSLog(@"WiFi网络");
                
                break;
                
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                
                NSLog(@"数据网络");
                
                break;
                
            }
                
            default:
                
                NSLog(@"不明网络");
                
                break;
                
        }
        
    }];
    
}

- (void)GETMethodUrl:(NSString *)urlString complete:(FinishDidBlock)success failure:(FailureBlock)fail{
    // 查看是否存在缓存
    urlString = [NSString stringWithFormat:MALL_SERVER_URL, urlString];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    _url = urlString;
    if (/* DISABLES CODE */ (0)) {
        //没有缓存 请求数据
        [_sessionManager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //储存数据当做下一次缓存
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (responses.statusCode == 401) {
                //登录服务器
                [self authenticate:GET finishDidBlock:success failureBlock:fail];
            }else{
                //其他情况返回error
                fail(error);
            }
        }];
    }else{
        //有缓存 返回缓存
        success(@"dsa");
    }
    

}


- (void) authenticate:(HTTPMETHOD)method finishDidBlock:(FinishDidBlock)finishDidBlock failureBlock:(FailureBlock)failureBlock{
    NSDictionary* dict = MALL_SERVER_AUTH_BODY;
    [_sessionManager POST:[NSString stringWithFormat:MALL_SERVER_URL,@"auth"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (method == GET)
            [self GETMethodUrl:_url complete:finishDidBlock failure:failureBlock];
        else
            NSLog(@"post or other method");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
}



@end
