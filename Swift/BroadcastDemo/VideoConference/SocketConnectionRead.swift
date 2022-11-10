//
//  SocketConnectionRead.swift
//  VideoConference
//
//  Created by 360-jr on 2022/11/3.
//

import Foundation

//MARK: - server 读取文件
public class HCSocketConnectionRead{
    private var filePath : String
    private var socketServer : Int32 = -1
    
    
    private var networkQueue : DispatchQueue?
    private var shouldKeepRunning = false

    private var address : sockaddr_un?
    
    private var inputStream : InputStream?
    private var outputStream : OutputStream?
    
    private var listeningSource : DispatchSourceRead?
    
    
    public init?(path : String?) {
        if let path, path.isEmpty == false{
            filePath = path
        }else{
            let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: VCMeet.shared.groupId ?? "")
            let socketFilePath = sharedContainer?.appendingPathExtension("rtc_SSFD").path ?? ""
            filePath = socketFilePath
        }
        
        socketServer = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        if socketServer < 0{
            debugPrint("create socket read fail")
            return nil
        }
        
        if setupSocketServer() == false{
            Darwin.close(self.socketServer)
            return nil
        }
        
        
    }
    
    
    
    public func openWithStreamDelegate(delegate : StreamDelegate) {
        let status = Darwin.listen(self.socketServer, 10)// 第二个参数可以替换成 SOMAXCONN
        if status < 0{
            debugPrint("socker server listen fail")
            return
        }
        let listeningSource = DispatchSource.makeReadSource(fileDescriptor: self.socketServer)
        listeningSource.setEventHandler { [weak self] in
            var addrlen: socklen_t = 0, addr = sockaddr()
            //MARK: - todo ("self.socketServer 为0 不知道是否有隐患")
            guard let socketServer = self?.socketServer else{
                debugPrint("self.socketserver is nil")
                return
            }
            let clientSocket = Darwin.accept(socketServer, &addr, &addrlen)
            
            if clientSocket < 0 {
                debugPrint("accpet connection fail")
                return
            }
            
            var readStream : Unmanaged<CFReadStream>?
            var writeStream : Unmanaged<CFWriteStream>?
            
            CFStreamCreatePairWithSocket(kCFAllocatorDefault, socketServer, &readStream, &writeStream)
            
            self?.inputStream = readStream?.takeRetainedValue()
            self?.inputStream?.delegate = delegate
            self?.inputStream?.setProperty(kCFBooleanTrue, forKey: Stream.PropertyKey(kCFStreamPropertyShouldCloseNativeSocket as String))
            
            self?.outputStream = writeStream?.takeRetainedValue()
            self?.outputStream?.setProperty(kCFBooleanTrue, forKey: Stream.PropertyKey(kCFStreamPropertyShouldCloseNativeSocket as String))

            self?.scheduleStreams()

            self?.inputStream?.open()
            self?.outputStream?.open()
        }
        
        self.listeningSource = listeningSource
        listeningSource.resume()
        
        
        
    }
    
    
    
    public func close(){
        unscheduleStreams()
        
        self.inputStream?.delegate = nil
        self.outputStream?.delegate = nil
        
        self.inputStream?.close()
        self.outputStream?.close()
        
        self.listeningSource?.cancel()
        
        Darwin.close(self.socketServer)
        
    }
    
    
    

    
}


extension HCSocketConnectionRead {
    
    func setupSocketServer() -> Bool{
        debugPrint("opening sock server")
        
        guard setupAddress() else {
            debugPrint("socket server setup address fail")
            return false
        }
        
        guard bind() else{
            debugPrint("socket server bind address fail")
            return false
        }
        
        guard FileManager.default.fileExists(atPath: filePath) else{
            debugPrint("sock sever file missing")
            return false
        }
        
        return true
    }

    
    func setupAddress() -> Bool{
        var addr = sockaddr_un()
        
        guard filePath.count < MemoryLayout.size(ofValue: addr.sun_path) else {
            print("failure: fd path is too long")
            return false
        }
        // unlink
        _ = withUnsafeMutablePointer(to: &filePath) { ptr in
            Darwin.unlink(ptr)
        }
        // copy
        _ = withUnsafeMutablePointer(to: &addr.sun_path.0) { ptr in
            filePath.withCString {
                strncpy(ptr, $0, filePath.count)
            }
        }
        
        return true
    }
    
    func bind() -> Bool{
        guard var addr = address else{
            return false
        }
        
        let status = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.bind(socketServer, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }
        guard status == noErr else{
            debugPrint("bind fail status is \(status)")
            return false
        }
        
        return true
    }
    
    func scheduleStreams (){
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
    func unscheduleStreams (){
        networkQueue?.sync { [weak self] in
            self?.inputStream?.remove(from: .current, forMode: .common)
            self?.outputStream?.remove(from: .current, forMode: .common)
        }
        
        shouldKeepRunning = false
    }
}
