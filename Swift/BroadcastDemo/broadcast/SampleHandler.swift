//
//  SampleHandler.swift
//  Broadcast
//
//  Created by Charlotte on 2022/10/21.
//

import ReplayKit

import VideoToolbox
import CoreMedia
import VideoConference


enum BroadcastError : Error{
    case unknowErr
}

class SampleHandler: RPBroadcastSampleHandler {
    
    private var uploader : SamplerUploader?
    private var connection : HCSocketConnectionWrite?
    
    override init() {
        super.init()
        if let conn = HCSocketConnectionWrite(path: ""){
            self.connection = conn
            setupConnection()
            
            uploader = SamplerUploader(connection: conn)
        }
        VCMeet.shared.initBroadcast()
        
    }
    

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        VCMeet.shared.startBroadcast()
        self.openConnection()
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
        debugPrint("Broadcast paused")

    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
        debugPrint("Broadcast resumed")

    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        debugPrint("Broadcast finished")
        VCMeet.shared.stopBroadcast()
        
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            // Handle video sample buffer
//            VCMeet.shared.sendSampleBuffer(buffer: sampleBuffer, type: sampleBufferType)
            self.uploader?.send(buffer: sampleBuffer)

            break
        case RPSampleBufferType.audioApp:
            // Handle audio sample buffer for app audio
            break
        case RPSampleBufferType.audioMic:
            // Handle audio sample buffer for mic audio
            break
        @unknown default:
            // Handle other sample buffer types
            fatalError("Unknown type of sample buffer")
        }
    }
    
    // 切换到其他app时 获取app的 bundle ID
    override func broadcastAnnotated(withApplicationInfo applicationInfo: [AnyHashable : Any]) {
        let bundleId = applicationInfo[RPApplicationInfoBundleIdentifierKey]
        if bundleId != nil{
            debugPrint("Broadcast Annotated application :",bundleId as? String ?? "")
        }else{
            debugPrint("applicationInfo :",applicationInfo)
        }
    }
    
}


extension SampleHandler{
    // 监听socket服务关闭状态
    func setupConnection(){
        connection?.didClose = { err in
            debugPrint("socker server closed")
            if let err = err{
                self.finishBroadcastWithError(err)
            }else{
                let customErr = NSError(domain: RPRecordingErrorDomain, code: 10001,userInfo: [NSLocalizedDescriptionKey:"screen sharing stopped"])
                self.finishBroadcastWithError(customErr)
            }
        }
    }
    // 链接本地socket服务器
    func openConnection(){
        let queue = DispatchQueue(label: "Broadcast.connectTimer.hc")
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(100), leeway: .milliseconds(500))
        timer.setEventHandler {[weak self] in
            guard self?.connection?.open() == true else{
                return
            }
            debugPrint("connect success")
            timer.cancel()
        }
        timer.resume()
        
    }
}
