//
//  NotificationCenter.swift
//  BroadcastDemo
//
//  Created by Charlotte on 2022/10/26.
//

import Foundation

/// 监听事件枚举
public enum ScreenShareEvent : String{
    // broadcast extension sent to main app
    case broadcastStart = "iOS_broadcast_start"
    case broadcastStop = "iOS_broadcast_stop"
    
    
    // main app sent to broadcast extension
    case finishBroadcast = "iOS_broadcast_finish"
}



/// 监听回调代理
protocol BroadcastEventDelegate :AnyObject{
    func broadcastStarted ()
    func broadcastStoped ()
}


class DarwinNotificationCenter{
    var delegate : BroadcastEventDelegate?
    
    private var notificationCenter : CFNotificationCenter
    init() {
        notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
    }
    //MARK: - broadcast 中使用
    /// 发送broadcast事件
    /// - Parameter event: 广播事件 started 、 stoped
    static func postNotification (event : ScreenShareEvent){
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFNotificationName(rawValue: event.rawValue as CFString), nil, nil, true)
    }
    //MARK: - main app 中使用
    /// 开始监听broadcast组件事件回调
    func observeNotification(){
        debugPrint("start observe broadcast event emmit")
        
        let observer = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CFNotificationCenterAddObserver(notificationCenter, observer, { _, idenObserver, name, _, _ in
            if let idenObserver = idenObserver,let name = name{
                let mySelf = Unmanaged<DarwinNotificationCenter>.fromOpaque(idenObserver).takeUnretainedValue()
                mySelf.callback(name.rawValue as String)
            }
        }, ScreenShareEvent.broadcastStart.rawValue as CFString, nil, .deliverImmediately)
        CFNotificationCenterAddObserver(notificationCenter, observer, { _, idenObserver, name, _, _ in
            if let idenObserver = idenObserver,let name = name{
                let mySelf = Unmanaged<DarwinNotificationCenter>.fromOpaque(idenObserver).takeUnretainedValue()
                mySelf.callback(name.rawValue as String)
            }
        }, ScreenShareEvent.broadcastStop.rawValue as CFString, nil, .deliverImmediately)

    }
    
    ///  cfnotification 监听回调
    /// - Parameter name: 监听事件名称
    func callback (_ name : String){
        switch name{
        case ScreenShareEvent.broadcastStart.rawValue:
            if self.delegate != nil{
                self.delegate?.broadcastStarted()
            }
        case ScreenShareEvent.broadcastStop.rawValue:
            if self.delegate != nil{
                self.delegate?.broadcastStoped()
            }
        default:break
        }
    }
    
    /// 清除broadcast事件监听
    private func clearObserve(){
        let observer = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        let startName : CFNotificationName = CFNotificationName.init(ScreenShareEvent.broadcastStart.rawValue as CFString)
        let stopName : CFNotificationName = CFNotificationName.init(ScreenShareEvent.broadcastStop.rawValue as CFString)
        
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), observer, startName, nil)
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), observer, stopName, nil)
        
    }
    deinit{
        debugPrint("Darwinnotification center instance deinit")
        clearObserve()
        debugPrint("Darwinnotification center clear observe")

    }
}


