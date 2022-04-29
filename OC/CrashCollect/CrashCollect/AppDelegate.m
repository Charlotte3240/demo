//
//  AppDelegate.m
//  CrashCollect
//
//  Created by Charlotte on 2021/4/10.
//

#import "AppDelegate.h"
//#import "SDKInfo.h"
//#import "DeivceInfo.h"
#import "CrashCollect-Swift.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    NSLog(@"%@",SDKInfo.getSDKinfo);
    NSLog(@"%@",DeviceInfo.getDeviceInfo);
    
    return YES;
}



void UncaughtExceptionHandler(NSException *exception)
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    // 异常发生时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *crashInfo = [NSMutableDictionary dictionary];
    [crashInfo setObject:name forKey:@"crashName"];
    [crashInfo setObject:dateTime forKey:@"crashTime"];
    [crashInfo setObject:reason forKey:@"crashReason"];
    [crashInfo setObject:[stackArray componentsJoinedByString:@"\n"] forKey:@"crashStack"];
//    [crashInfo setObject:[SDKInfo ] forKey:@"SDKInfo"];
//    [crashInfo setObject:[DeivceInfo getDeviceInfo] forKey:@"deviceInfo"];
    
    [[NSUserDefaults standardUserDefaults] setObject:crashInfo forKey:@"hc-nsqk.crash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
//    NSDictionary *deviceInfo = [CrashHandler getDeviceInfo];
//
//    [crashInfo setValuesForKeysWithDictionary:appInfo];
//    [crashInfo setValuesForKeysWithDictionary:deviceInfo];
    // get history crash log
//    NSMutableArray *logArray = [NSMutableArray arrayWithArray:[CrashHandler readCrashLog]];
//    [logArray addObject:crashInfo];
//    [CrashHandler writeCrashLog:logArray];
}


@end
