//
//  HCObject+Ass.m
//  OC-AssociatedDemo
//
//  Created by Charlotte on 2020/9/11.
//

#import "HCObject+Ass.h"
#import <objc/runtime.h>
@implementation HCObject (Ass)

- (NSString *)categoryStr{
    return objc_getAssociatedObject(self, HCkey);
}

- (void)setCategoryStr:(NSString *)categoryStr{
    objc_setAssociatedObject(self, HCkey, categoryStr, OBJC_ASSOCIATION_COPY);
}
@end
