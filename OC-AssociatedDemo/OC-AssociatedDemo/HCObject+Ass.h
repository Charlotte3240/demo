//
//  HCObject+Ass.h
//  OC-AssociatedDemo
//
//  Created by Charlotte on 2020/9/11.
//

#import "HCObject.h"

NS_ASSUME_NONNULL_BEGIN
static char *HCkey = "HCkey";

@interface HCObject (Ass)
@property (nonatomic,copy)NSString *categoryStr;

@end

NS_ASSUME_NONNULL_END
