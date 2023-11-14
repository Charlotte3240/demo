//
//  VCMeet.swift
//  BroadcastDemo
//
//  Created by chunqi.liu on 2022/10/26.
//

import Foundation


public class Event: NSObject {
    
    static public func startBroadcast(){
        DarwinNotificationCenter.postNotification(event: .broadcastStart)
    }
    
    static public func stopBroadcast(){
        DarwinNotificationCenter.postNotification(event: .broadcastStop)
    }
        
}


/// 事件枚举
public enum ScreenShareEvent : String{
    // broadcast extension sent to main app
    case broadcastStart = "iOS_broadcast_start"
    case broadcastStop = "iOS_broadcast_stop"
    
    
    // main app sent to broadcast extension
    case finishBroadcast = "iOS_broadcast_finish"
}
