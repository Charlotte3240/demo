//
//  HCQuery.m
//  Courier
//
//  Created by 刘春奇 on 2017/7/6.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "HCQuery.h"
#import <UIKit/UIKit.h>
@implementation HCQuery

+ (void)queryCourier:(NSString *)number withSuccess:(FinishBlock)successBlock{
    NSString *appcode = @"8dd10a9e488b45f7ba7a6b80953cc883";
    NSString *host = @"http://jisukdcx.market.alicloudapi.com";
    NSString *path = @"/express/query";
    NSString *method = @"GET";
    NSString *querys = [NSString stringWithFormat:@"?number=%@&type=auto",number];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (error == nil) {
                NSDictionary *body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                successBlock(body,error);
            }
            NSLog(@"%@", error);
        });
        
        
    }];
    [task resume];
    
}



@end
