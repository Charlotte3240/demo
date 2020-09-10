//
//  AppDelegate.m
//  TESTDEO
//
//  Created by 红尘 on 15/7/24.
//  Copyright (c) 2015年 红尘. All rights reserved.
//

#import "AppDelegate.h"



CLLocationDistance const DistanceFilter = 100;
CLLocationDistance const DistanceRadius = 30000;
NSString* const GeoFencingIdentifier = @"demoIden";

NSString* const LocationHandlerDidUpdateLocation = @"LocationHandlerDidUpdateLocation";
NSString* const LocationHandlerDidChangeRegion = @"LocationHandlerDidChangeRegion";
@interface AppDelegate ()<CLLocationManagerDelegate>

@end



@implementation AppDelegate
{
    //地理围栏
    CLLocationManager* _locManager;
    CLCircularRegion* _geoRegion;
    BOOL _locationChanged;


}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    [self initLocationHandler];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if ([CLLocationManager significantLocationChangeMonitoringAvailable])
    {
        [_locManager stopMonitoringSignificantLocationChanges];
        [_locManager startMonitoringSignificantLocationChanges];
        NSLog(@"startSignificantLocationChange Triggered");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void) initLocationHandler
{
    _locManager = [[CLLocationManager alloc] init];
    if ([_locManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locManager requestAlwaysAuthorization];
    }
    _locManager.delegate = self;
    _locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locManager.distanceFilter = DistanceFilter;
    //[_locManager startUpdatingLocation];
    
    if ([CLLocationManager significantLocationChangeMonitoringAvailable])
    {
        [_locManager stopMonitoringSignificantLocationChanges];
        [_locManager startMonitoringSignificantLocationChanges];
        NSLog(@"startSignificantLocationChange Triggered");
    }
    [self startGeoFencing];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.lastObject;
    NSLog(@"%f  %f",location.coordinate.latitude,location.coordinate.longitude);
//    [self startGeoFencing];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier UpdatingLocationTaskID = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (UpdatingLocationTaskID != UIBackgroundTaskInvalid) {
                NSLog(@"Location Update failed to finish prior to expiration");
                [app endBackgroundTask:UpdatingLocationTaskID];
                UpdatingLocationTaskID = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([region.identifier isEqualToString:GeoFencingIdentifier])
        {
            NSLog(@"didEnterRegion Triggered");
            dispatch_async(dispatch_get_main_queue(), ^{
                UILocalNotification* notification = [[UILocalNotification alloc] init];
                notification.alertBody = @"enter";
                notification.fireDate = [NSDate date];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            });
        }
    });
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier UpdatingLocationTaskID = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (UpdatingLocationTaskID != UIBackgroundTaskInvalid) {
                NSLog(@"Location Update failed to finish prior to expiration");
                [app endBackgroundTask:UpdatingLocationTaskID];
                UpdatingLocationTaskID = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([region.identifier isEqualToString:GeoFencingIdentifier])
        {
            NSLog(@"didExitRegion Triggered");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startGeoFencing];
                UILocalNotification* notification = [[UILocalNotification alloc] init];
                notification.alertBody = @"exit";
                notification.fireDate = [NSDate date];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            });
        }
    });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error is %@",error);
}

- (BOOL) startGeoFencing
{
    //121.640426,31.190306
//    CLLocation *homeLoca = [[CLLocation alloc]initWithLatitude:31.188228 longitude:121.629812];
 //   CLLocation *homeLoca = [[CLLocation alloc]initWithLatitude:51.509980 longitude:-0.133700]; //london
    
    for(CLRegion* region in [_locManager monitoredRegions])
    {
        //if([region.identifier isEqualToString:GeoFencingIdentifier])
        {
            [_locManager stopMonitoringForRegion:region];
        }
    }
    
    CLLocation *homeLoca = [[CLLocation alloc]initWithLatitude:31.22083f longitude:121.52778f];
    _geoRegion = [[CLCircularRegion alloc] initWithCenter:homeLoca.coordinate radius:DistanceRadius identifier: GeoFencingIdentifier];
    [_locManager startMonitoringForRegion:_geoRegion];
    
    return YES;
}




@end
