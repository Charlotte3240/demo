//
//  ViewController.swift
//  BroadcastDemo
//
//  Created by chunqi.liu on 2022/10/21.
//

import UIKit
import ReplayKit

public enum Constants {
    public static let bufferMaxLength = 10240
}


class ViewController: UIViewController {

    var broadcastPicker : RPSystemBroadcastPickerView?
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    var message : SampleMessage?
    var readLength = Constants.bufferMaxLength
    
    var connection : SocketConnection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        broadcastPicker = RPSystemBroadcastPickerView(frame: .zero)
        if #available(iOS 12.2, *) {
            // 12.2 以上才有用，否则指定了之后不显示自己的app，会录屏到相册中
            broadcastPicker?.preferredExtension = "com.nsqk.com.BroadcastDemo.broadcast"
        }
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
                
                

    }
    
    
    
    
    // Object is the UIScreen which changed. [object isCaptured] is the new value of captured property.
    // 监控当前屏幕的录屏状态变化， 进入/退出录屏 都会收到通知
    @objc func scrrenCaptureDidChange (notification : Notification){
//        debugPrint("screen capture did change : ",UIScreen.main.isCaptured)
    }
    
    @IBAction func preparBroadcast(_ sender: Any) {
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.charlotte.liu.broadcast")
        let socketFilePath = sharedContainer?.appendingPathComponent("rtc_SSFD").path ?? ""

        self.connection = SocketConnection.init(filePath: socketFilePath)
        self.connection?.open(with: self)

        HCBroadcast.shared.prepar()
    }
    @IBAction func exitSDK(_ sender: Any) {
        self.connection?.close()
        self.connection = nil

        HCBroadcast.shared.exitSDK()
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
        default:
            debugPrint("server stream other eventcode :",eventCode)
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
        if self.message == nil{
            self.message = SampleMessage()
            readLength = Constants.bufferMaxLength
            
            self.message?.didComplete = {[weak self] (success , buffer , orientation) in
                if success{
                    self?.sendVideoCapture(buffer: buffer, orientation: CGImagePropertyOrientation(rawValue: UInt32(orientation ?? 1)))
                }else{
                    debugPrint("recv image fail")
                }
                self?.message = nil
            }
        }
        let bufferSize = Constants.bufferMaxLength
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        
        let numberOfBytesRead = inputStream.read(buffer, maxLength: readLength)
        if numberOfBytesRead < 0{
            debugPrint("reading bytes from stream error: ",numberOfBytesRead)
            return
        }

        autoreleasepool {
            readLength = self.message!.appentBytes(buffer: buffer, length: numberOfBytesRead)
            
            if readLength == -1 || readLength > Constants.bufferMaxLength {
                readLength = Constants.bufferMaxLength
            }
            buffer.deallocate()
        }
        
        
    }
    
    func sendVideoCapture(buffer : CVPixelBuffer?, orientation : CGImagePropertyOrientation?){
        guard let buffer = buffer, let orientation = orientation else {
            return
        }
//        debugPrint("buffer is ",buffer)
//        debugPrint("orientation is ",orientation)

        let image = CIImage(cvPixelBuffer: buffer)

        DispatchQueue.main.async {
            let uiimage = UIImage(ciImage: image)
            self.previewImageView.image = uiimage
        }
        
        
        
        
    }
    
}
