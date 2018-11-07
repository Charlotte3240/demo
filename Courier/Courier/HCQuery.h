//
//  HCQuery.h
//  Courier
//
//  Created by 刘春奇 on 2017/7/6.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^FinishBlock) (NSDictionary *body,NSError *error);

@interface HCQuery : NSObject

+ (void)queryCourier:(NSString *)number withSuccess:(FinishBlock)successBlock;

@end
