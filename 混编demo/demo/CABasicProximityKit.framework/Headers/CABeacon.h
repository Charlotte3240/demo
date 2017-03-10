//
//  CABeacon.h
//  CABasicProximityKit
//
//  Created by Leon Fu on 4/26/16.
//  Copyright © 2016 Cloudnapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CABeacon : NSObject <NSCoding>

@property (nonatomic, strong) NSUUID* uuid;
@property (nonatomic, assign) NSUInteger major;
@property (nonatomic, assign) NSUInteger minor;
@property (nonatomic, assign) NSString* identifier;

@end
