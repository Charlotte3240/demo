//
//  SocketConnection.swift
//  BroadcastDemo
//
//  Created by 360-jr on 2022/10/26.
//

import Foundation


//MARK: - client 写入文件
public class HCSocketConnectionWrite :NSObject{
    // 已经打开out stream
    public var didOpen: (() -> Void)?
    // 已经关闭
    public var didClose : ((Error?) -> Void)?
    // 可以发送字节
    public var streamHasSpaceAviable : (() -> Void)?
    
    private let filepath : String
    private var socketHandle : Int32 = -1
    // 本地套接字 非网络套接字 sockaddr_in
    private var address : sockaddr_un?
    
    
    private var inputStream : InputStream?
    private var outputStream : OutputStream?

    
    private var networkQueue : DispatchQueue?
    private var shouldKeepRunning = false
    
    
    public init?(path : String?) {
        if let path = path, path.isEmpty == false{
            filepath = path
        }else{
            let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: VCMeet.shared.groupId ?? "")
            let socketFilePath = sharedContainer?.appendingPathComponent("rtc_SSFD").path ?? ""
            filepath = socketFilePath
        }
        socketHandle = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        guard socketHandle != -1 else{
            debugPrint("create socket write fail")
            return nil
        }
    }
    
    
    public func open () ->Bool{
        debugPrint("open socket connection")
        
        guard FileManager.default.fileExists(atPath: filepath) else {
            debugPrint("socket file missing")
            return false
        }
        
        guard setupAddress() else{
            debugPrint("socket setup address fail")
            return false
        }
        
        guard connectSocket() else{
            debugPrint("connect socket fail")
            return false
        }
        
        
        return true
    }
    
    
    public func close(){
        unscheduleStreams()
        
        inputStream?.delegate = nil
        outputStream?.delegate = nil
        
        inputStream?.close()
        outputStream?.close()
        
        inputStream = nil
        outputStream = nil
    }
    
    func writerToStream (buffer : UnsafePointer<UInt8>, maxLength length : Int) -> Int{
        return outputStream?.write(buffer, maxLength: length) ?? 0
    }
    
}

extension HCSocketConnectionWrite : StreamDelegate{
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event){
        switch eventCode{
        case .openCompleted:
            debugPrint("client stream open completed")
            if aStream == outputStream{
                didOpen?()
            }
        case .hasBytesAvailable:
            if aStream == inputStream{
                var buffer : UInt8 = 0
                let numberOfBytesRead = inputStream?.read(&buffer, maxLength: 1)
                if numberOfBytesRead == 0 && aStream.streamStatus == .atEnd{
                    debugPrint("server socket closed")
                    close()
                    notifyDidClose(error: nil)
                }
            }
        case .hasSpaceAvailable:
            if aStream == outputStream{
                streamHasSpaceAviable?()
            }
        case .errorOccurred:
            debugPrint("client stream error occurred : \(String(describing: aStream.streamError))")
            close()
            notifyDidClose(error: aStream.streamError)
        default: break
        }
    }
}



extension HCSocketConnectionWrite {
    public func setupAddress () -> Bool{
        var addr = sockaddr_un()
        guard filepath.count < MemoryLayout.size(ofValue: addr.sun_path) else {
            debugPrint("fd path is too lang")
            return false
        }
        
        _ = withUnsafeMutablePointer(to: &addr.sun_path.0) { ptr in
            filepath.withCString{
                strncpy(ptr, $0, filepath.count)
            }
        }
        
        address = addr
        return true
    }
    
    public func connectSocket () -> Bool{
        guard var addr = address else{
            return false
        }
        
        let status = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.connect(socketHandle, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }
        guard status == noErr else{
            debugPrint("connect fail status is \(status)")
            return false
        }
        return true
    }
    
    
    public func setupStream (){
        var readStream : Unmanaged<CFReadStream>?
        var writeStream : Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, socketHandle, &readStream, &writeStream)
        
        inputStream = readStream?.takeRetainedValue()
        inputStream?.delegate = self
        inputStream?.setProperty(kCFBooleanTrue, forKey: Stream.PropertyKey(kCFStreamPropertyShouldCloseNativeSocket as String))
        
        scheduleStreams()
        
    }
    
    public func scheduleStreams(){
        shouldKeepRunning = true
        
        networkQueue = DispatchQueue.global(qos: .userInitiated)
        networkQueue?.async {[weak self] in
            self?.inputStream?.schedule(in: .current, forMode: .common)
            self?.outputStream?.schedule(in: .current, forMode: .common)
            
            var isRunning = false
            
            repeat{
                isRunning = self?.shouldKeepRunning ?? false && RunLoop.current.run(mode: .default, before: .distantFuture)
            } while (isRunning)

        }
        
    }
    
    public func unscheduleStreams(){
        networkQueue?.sync { [weak self] in
            self?.inputStream?.remove(from: .current, forMode: .common)
            self?.outputStream?.remove(from: .current, forMode: .common)
        }
        
        shouldKeepRunning = false
    }
    
    
    public func notifyDidClose(error :Error?){
        if didClose != nil{
            didClose?(error)
        }
    }
    
}
