//
//  CABasicConfig.h
//  CABasicProximityKit
//
//  Created by Leon Fu on 4/26/16.
//  Copyright © 2016 Cloudnapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CABasicConfig : NSObject

//YES: monitor all the beacons behavior with same UUID (only one), no matter what major or minor is.
//NO: monitor serveral beacons behavior with specific UUID, major and minor.
//by default it's YES
@property (nonatomic, assign) BOOL monitorUUIDOnly;

//the higher sensitivity (1-5) is, the less accuracy is
//by default it is 3
@property (nonatomic, assign) NSInteger sensitivityLevel;

//YES: ignore the beacons with FAR proximity when nearest beacon changes
//NO: nearest beacon found regardless the beacon proximity
//by default it is NO
@property (nonatomic, assign) BOOL ignoreFarWhenNearestChange;

@end
