//
//  CABasicProximityManager.h
//  CABasicProximityKit
//
//  Created by Leon Fu on 4/26/16.
//  Copyright © 2016 Cloudnapps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CABasicConfig.h"
#import "CABasicProximityManagerDelegate.h"


@interface CABasicProximityManager : NSObject

@property NSObject<CABasicProximityManagerDelegate>* delegate;

+ (CABasicProximityManager *) setup: (CABasicConfig *)config;

+ (CABasicProximityManager*) shared;

//you can add serveral specific beacons, check the return value if limit exceeds by system or or monitorUUIDOnly in config is not NO
- (BOOL) addMonitoredBeacon: (NSString*) beaconUUID withMajor:(NSUInteger)major withMinor:(NSUInteger)minor;

//add a new UUID beacons set will replace the old one, check the return value if limit exceeds by system or monitorUUIDOnly in config is not YES
- (BOOL) addMonitoredBeacon:(NSString *)beaconUUID;

- (BOOL) removeMonitoredBeacon: (NSString*) beaconUUID withMajor:(NSUInteger)major withMinor:(NSUInteger)minor;

- (BOOL) removeMonitoredBeacon:(NSString *)beaconUUID;

- (void) startMonitoring;

- (void) resetWithNewConfig:(CABasicConfig*) config;

- (void) stopMonitoring;

- (BOOL) setGeoRegion:(CLLocationCoordinate2D)coord withRadius:(double)radius;

@end
