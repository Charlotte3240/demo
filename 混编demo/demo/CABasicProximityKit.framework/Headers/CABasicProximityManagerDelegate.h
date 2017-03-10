//
//  CABasicProximityManagerDelegate.h
//  CABasicProximityKit
//
//  Created by Leon Fu on 4/26/16.
//  Copyright © 2016 Cloudnapps. All rights reserved.
//

#ifndef CABasicProximityManagerDelegate_h
#define CABasicProximityManagerDelegate_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CABeacon.h"

@class CABasicProximityManager;

@protocol CABasicProximityManagerDelegate <NSObject>

//triggered when entering a beacon's region
//triggered distance only depends on the beacon transmit power settings
@optional
-(void) proximityManager:(CABasicProximityManager *) manager didEnterBeacon: (CABeacon*) beacon;

//triggered when exiting a beacon's region
//triggered distance only depends on the beacon transmit power settings
@optional
-(void) proximityManager:(CABasicProximityManager *) manager didExitBeacon: (CABeacon*) beacon;

//ONLY works when monitorUUIDOnly is YES
//triggered when the neareast beacon is changed or there's no nearest beacon any more (beacon = nil)
//depends on ignoreFarWhenNearestChange whether proximity far is into account or not
@optional
-(void) proximityManager:(CABasicProximityManager *) manager didChangeNearestBeacon: (CABeacon*) beacon;

//triggered when the ranged beacons info changed, it only constantly work when app is in foreground
@optional
-(void) proximityManager:(CABasicProximityManager *) manager rangedNearbyBeacons: (NSArray<CLBeacon *> *)beacons;

//triggered when entering the defined regional area
@optional
-(void) proximityManager:(CABasicProximityManager *)manager didEnterGeoRegion: (CLLocationCoordinate2D)center;
@end


#endif /* CABasicProximityManagerDelegate_h */
