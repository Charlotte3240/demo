//
//  ViewController.swift
//  BroadcastDemo
//
//  Created by 360-jr on 2022/10/21.
//

import UIKit
import ReplayKit
import VideoConference
class ViewController: UIViewController {

    var broadcastPicker : RPSystemBroadcastPickerView?
    
    var timer : Timer?
    var timeNum = 0

    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeLabel.text = "\(timeNum)"
        self.view.backgroundColor = .white
        
        broadcastPicker = RPSystemBroadcastPickerView(frame: CGRect.zero)
        broadcastPicker?.preferredExtension = "com.nsqk.com.BroadcastDemo.broadcast"
        broadcastPicker?.showsMicrophoneButton = false
        view.addSubview(broadcastPicker!)
        broadcastPicker?.center = self.view.center

        
        // 通过UIKit 查看当前screen 是否在被录屏、镜像等
        let isCaptured =  UIScreen.main.isCaptured
        debugPrint("是否在被recorded, AirPlayed, mirrored ... :",isCaptured)
        
        // 注册UI Screen Capture Did change notification
        NotificationCenter.default.addObserver(self, selector: #selector(scrrenCaptureDidChange(notification: )), name: UIScreen.capturedDidChangeNotification, object: nil)
        
        // 检查screens.count  >1 时可能会有mirro 或者插了显示器
        let count =  UIScreen.screens.count
        debugPrint("screens count :",count)
        
        // 截屏检测UIApplication.userDidTakeScreenshotNotification
//        UIApplication.userDidTakeScreenshotNotification
        
        // refresh label by timer
//        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] timer in
//            self?.timeNum += 1
//            self?.timeLabel.text = "\(self?.timeNum ?? 0)"
//
//        })
                
        
        
    }
    
    
    
    func startedScreenShare(){
        let socket = HCSocketConnectionRead(path: "")
        socket?.openWithStreamDelegate(delegate: self)
    }
    
    
    
    // Object is the UIScreen which changed. [object isCaptured] is the new value of captured property.
    // 监控当前屏幕的录屏状态变化， 进入/退出录屏 都会收到通知
    @objc func scrrenCaptureDidChange (notification : Notification){
        debugPrint("screen capture did change : ",UIScreen.main.isCaptured)
    }
    
    @IBAction func preparBroadcast(_ sender: Any) {
        VCMeet.shared.setupBroadcast(groupId: "group.charlotte.liu.broadcast")
        
    }
    @IBAction func exitSDK(_ sender: Any) {
        VCMeet.shared.exitSDK()
    }
    
    // 代替系统RPSystemBroadcastPickerView 进行开启或关闭
    @IBAction func startOrStopBroadcast(_ sender: Any) {
        // find broadcast button
        self.broadcastPicker?.subviews.forEach({ view in
            if view.isKind(of: UIButton.self){
                if let btn = view as? UIButton{
                    btn.sendActions(for: .allEvents)
                }
            }
        })
        
        self.startedScreenShare()
        
    }
    
    // 开始应用内录制
    @IBAction func startInAppRecord(_ sender: Any){
        
        RPScreenRecorder.shared().startCapture { buffer, type, error in
            switch type{
            case .video:
                debugPrint("video data")
                self.updateUI()
                break
            case .audioApp:break
            case .audioMic:break
            @unknown default:
                break
            }
        }
    }
    
    
    func updateUI(){
        DispatchQueue.main.async {
            self.timeNum += 1
            self.timeLabel.text = "\(self.timeNum)"
        }
    }
    
    
    // 关闭应用内录制
    @IBAction func stopInAppRecord(_ sender: Any){
        RPScreenRecorder.shared().stopCapture { err in
            if let err = err{
                debugPrint("stop capture fail:",err)
            }
        }
    }
}



extension ViewController : StreamDelegate{
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode{
        case .openCompleted:
            debugPrint("client stream open completed")
        case .hasBytesAvailable:
            self.readByteFromMessage(stream: aStream)

        case .endEncountered:
            debugPrint("stream server end encountered")
            // server 停止 结束 screen share
            
        case .errorOccurred:
            debugPrint("server stream error encountered:\(String(describing: aStream.streamError))")
        default: break
        }

    }
    
    
    func readByteFromMessage(stream : Stream){
        guard let inputStream = stream as? InputStream else{
            debugPrint("not input stream")
            return
        }
        
        if inputStream.hasBytesAvailable == false{
            // 没有字节可以读
            debugPrint("no bytes available")
            return
        }
        
        
        
        
    }
    
}
