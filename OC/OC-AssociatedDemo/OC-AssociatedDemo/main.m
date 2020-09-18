//
//  main.m
//  OC-AssociatedDemo
//
//  Created by Charlotte on 2020/9/11.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "HCObject.h"
#import "HCObject+Ass.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
            
//        HCObject *obj = [[HCObject alloc]init];
        
        Class cls = NSClassFromString(@"HCObject");
        
        HCObject *obj = [[cls alloc]init];
        
        obj.objName = @"obj name";
        obj.categoryStr = @"1234561";
        
        
        
        NSLog(@"%@  %@",obj.objName,obj.categoryStr);
        
        
    }
    return 0;
}
