//
//  URLche.h
//  UiWebViewCache
//
//  Created by 刘春奇 on 16/4/27.
//  Copyright © 2016年 com.hc-nsqk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLCache : NSURLCache {
    NSMutableDictionary *cachedResponses;
    NSMutableDictionary *responsesInfo;
}


@property (nonatomic, retain) NSMutableDictionary *cachedResponses;
@property (nonatomic, retain) NSMutableDictionary *responsesInfo;


- (void)saveInfo;


@end
