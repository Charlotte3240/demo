//
//  HCGetWifiInfo.h
//  GetWifiInfo
//
//  Created by 刘春奇 on 2021/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCGetWifiInfo : NSObject
+(BOOL) isWiFiOpened;
+ (NSDictionary *)fetchSSIDInfo;
@end

NS_ASSUME_NONNULL_END
