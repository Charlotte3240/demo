//
//  SampleHandler.swift
//  BroadcastExtension
//
//  Created by 刘春奇 on 2021/4/22.
//

import ReplayKit

class SampleHandler: RPBroadcastSampleHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // 广播开始
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        debugPrint("开始直播")
    }
    
    override func broadcastPaused() {
        // 暂停广播
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // 继续广播
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        // 结束广播
        // User has requested to finish the broadcast.
        debugPrint("结束直播")
        
    }
    
    // 发送不同的 buffer
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            // Handle video sample buffer
//            debugPrint("视频buffer")
            break
        case RPSampleBufferType.audioApp:
            // Handle audio sample buffer for app audio
//            debugPrint("app audio buffer")
            break
        case RPSampleBufferType.audioMic:
            // Handle audio sample buffer for mic audio
//            debugPrint("mic audio buffer")
            break
        @unknown default:
            // Handle other sample buffer types
            fatalError("Unknown type of sample buffer")
        }
    }
}
