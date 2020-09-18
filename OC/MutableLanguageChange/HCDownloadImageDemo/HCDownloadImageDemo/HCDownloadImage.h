//
//  HCDownloadImage.h
//  MagicSDKPlayer
//
//  Created by 刘春奇 on 2017/2/10.
//  Copyright © 2017年 刘春奇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCDownloadImage : NSObject
typedef void(^FinishDidBlock) (NSString *location);
typedef void(^FailureBlock) (NSError *error);

+ (void)downloadImage:(NSURL *)url withCompleteBlock:(FinishDidBlock)finish andErrorBlock:(FailureBlock)failure;

+ (BOOL)checkfolderContainFile:(NSString *)fileName;

+ (NSURL *)changeServerUrlToLocalUrl:(NSString *)fileName;

+ (void)copyToCurrentFolder:(NSString *)fileName;

+ (void)reloadOriginalName:(NSString *)fileName;
@end
