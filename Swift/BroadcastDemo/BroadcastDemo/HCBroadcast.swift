//
//  VCMeet.swift
//  BroadcastDemo
//
//  Created by chunqi.liu on 2022/10/26.
//

import Foundation
import ReplayKit

public class HCBroadcast: NSObject {
    
    @objc public static let shared = HCBroadcast()
        
    var cfCenter :DarwinNotificationCenter?

    
    /// 对屏幕共享进行参数设置
    @objc public func prepar(){
        if self.cfCenter != nil{
            return
        }
        cfCenter = DarwinNotificationCenter()
        cfCenter?.observeNotification()
        cfCenter?.delegate = self
    }

    
    @objc public func exitSDK(){
        // 退出时 需要释放监听通知
        if self.cfCenter != nil{
            self.cfCenter?.delegate = nil
            self.cfCenter = nil
        }
    }
    
}



extension HCBroadcast : BroadcastEventDelegate{
    func broadcastStarted (){
        debugPrint("main app: recv broadcast started")
    }
    func broadcastStoped (){
        debugPrint("main app: recv broadcast stoped")
    }

}

