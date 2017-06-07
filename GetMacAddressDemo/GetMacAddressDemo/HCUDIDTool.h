//
//  HCUDIDTool.h
//  GetMacAddressDemo
//
//  Created by 刘春奇 on 2017/5/31.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPAddress.h"

@interface HCUDIDTool : NSObject
+ (void) _setDict:(id)dict forPasteboard:(id)pboard;
+ (NSMutableDictionary*) _getDictFromPasteboard:(id)pboard;
+ (NSString*) valueWithError:(NSError **)error;
@end
