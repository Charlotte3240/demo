//
//  VCMeet.swift
//  BroadcastDemo
//
//  Created by Charlotte on 2022/10/26.
//

import Foundation
import ReplayKit

public class VCMeet: NSObject {
    
    @objc public static let shared = VCMeet()
    
    @objc var groupId : String? = "group.charlotte.liu.broadcast"
    
    var cfCenter :DarwinNotificationCenter?

    private var socketClient : HCSocketConnectionWrite?

    @objc public func openSDK(){
        
    }
    @objc public func exitSDK(){
        // 推出sdk 时 需要释放监听通知
        if self.cfCenter != nil{
            self.cfCenter?.delegate = nil
            self.cfCenter = nil
        }
    }
    
    
    /// 对屏幕共享进行参数设置
    /// - Parameter groupId: APP group ID
    @objc public func setupBroadcast(groupId : String){
        if self.cfCenter != nil{
            return
        }
        self.groupId = groupId
        cfCenter = DarwinNotificationCenter()
        cfCenter?.observeNotification()
        cfCenter?.delegate = self
    }
    
    private var clientConnection : HCSocketConnectionWrite?

    @objc public func initBroadcast(){
        //TODO: - connect local socket server
//        clientConnection = HCSocketConnectionWrite(path: "")
//        clientConnection?.didClose = {[weak self] err in
//            debugPrint("client connection did close \(String(describing: err))")
//        }

    }

    @objc public func startBroadcast(){
        DarwinNotificationCenter.postNotification(event: .broadcastStart)
    }
    
    @objc public func stopBroadcast(){
        DarwinNotificationCenter.postNotification(event: .broadcastStop)
    }
    
    /// 发送sample buffer 给app
    /// - Parameters:
    ///   - buffer: buffer data
    ///   - type: buffer type
    @objc public func sendSampleBuffer(buffer : CMSampleBuffer, type : Any){
        // 排除视频之外的数据
        let type = type as? Int ?? 0
        if type != 1{
            return
        }
        
        if self.socketClient != nil{
            
        }
        
        
    }
    
    
}



extension VCMeet : BroadcastEventDelegate{
    func broadcastStarted (){
        debugPrint("recv broadcast started")
    }
    func broadcastStoped (){
        debugPrint("recv broadcast stoped")
    }

}

