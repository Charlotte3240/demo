//
//  NotificationCenter.swift
//  BroadcastDemo
//
//  Created by chunqi.liu on 2022/10/26.
//

import Foundation



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
}


