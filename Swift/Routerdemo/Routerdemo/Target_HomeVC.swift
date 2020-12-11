//
//  Target_HomeVC.swift
//  Routerdemo
//
//  Created by Charlotte on 2020/12/7.
//

import UIKit

@objcMembers public class Target_Home: NSObject {
    @objc public func Action_getADData(params:[AnyHashable:Any]){
        print("get ad data")
        print(params)
    }
    @objc public func Action_getdata(params:[AnyHashable:Any]){
        print(params)
        print("get data")
    }
    
    @objc public func Action_fool(params:[AnyHashable:Any]){
        if let callback = params["callback"] as? (String) -> Void {
            callback("callback success")
        }
        print(params)
    }
}


extension CTMediator{
    typealias callback = (String) -> Void
    func getADData() {
        self.performTarget("Home", action: "getdata", params: [kCTMediatorParamsKeySwiftTargetModuleName:"Routerdemo" ,"page":1,"banner":2,"callback":(()->Void).self], shouldCacheTarget: false)
                
        self.performTarget("Home", action: "getADData", params: [kCTMediatorParamsKeySwiftTargetModuleName:"Routerdemo","page":1,"type":2], shouldCacheTarget: false)
    }
    
    func fool(callback:@escaping callback){
        self.performTarget("Home", action: "fool", params: [kCTMediatorParamsKeySwiftTargetModuleName:Target_Home.currentMoudleName(),"callback":callback], shouldCacheTarget: false)

    }
    // swift ->extension -> swift
    @objc public func A_showSwift(callback:@escaping (String) -> Void) -> UIViewController? {
         let params = [
             "callback":callback,
             kCTMediatorParamsKeySwiftTargetModuleName:"Routerdemo"
             ] as [AnyHashable : Any]
         if let viewController = self.performTarget("Routerdemo", action: "fool", params: params, shouldCacheTarget: false) as? UIViewController {
             return viewController
         }
         return nil
     }
     // swift ->extension -> oc
     @objc public func A_showObjc(callback:@escaping (String) -> Void) -> UIViewController? {
         let callbackBlock = callback as @convention(block) (String) -> Void
         let callbackBlockObject = unsafeBitCast(callbackBlock, to: AnyObject.self)
         let params = ["callback":callbackBlockObject] as [AnyHashable:Any]
         if let viewController = self.performTarget("Routerdemo", action: "fool", params: params, shouldCacheTarget: false) as? UIViewController {
             return viewController
         }
         return nil
     }
}
