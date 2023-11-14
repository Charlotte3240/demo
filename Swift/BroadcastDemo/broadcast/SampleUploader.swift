//
//  SampleUploader.swift
//  VideoConference
//
//  Created by chunqi.liu on 2022/10/28.
//

import Foundation
import CoreMedia
import ReplayKit
public enum Constants {
    public static let bufferMaxLength = 10240
}


public class SamplerUploader {
    
    private var connection : HCSocketConnectionWrite
    
    private var frameCount = 0

    @Atomic private var isReady = false
    private let serialQueue : DispatchQueue
    
    private var sendData : Data?
    private var byteIndex  = 0
    
    private static var imageContext = CIContext(options: nil)
    
    
    public init(connection: HCSocketConnectionWrite) {
        self.serialQueue = DispatchQueue.init(label: "hc-nsqk.com.broadcast.sampleUploader")
        self.connection = connection
        
        self.setupConnection()
    }
    

    
    // 控制数据发送
    @discardableResult public func send(buffer sampleBuffer : CMSampleBuffer) -> Bool{
        frameCount += 1
        if frameCount % 3 != 0 {
            return false
        }
        
        guard isReady == true else{
            return false
        }
        isReady = false
        
        sendData = self.prepareImageData(sampleBuffer)
        
        serialQueue.async {[weak self] in
            self?.sendDataChunk()
        }
        
        return true
    }
    

    
  
    
}


extension SamplerUploader {
    // 设置链接回调
    func setupConnection(){
        connection.didOpen = {[weak self] in
            self?.isReady = true
        }
        
        connection.streamHasSpaceAviable = { [weak self] in
            self?.serialQueue.async {
                self?.isReady = !(self?.sendDataChunk() ?? true)
            }
        }
    }
    
    // 发送数据给socket 服务端
    @discardableResult func sendDataChunk() -> Bool{
        guard let dataToSend = sendData else{
            return false
        }
        
        var byteLeft = dataToSend.count - byteIndex
        var length = byteLeft > Constants.bufferMaxLength ? Constants.bufferMaxLength : byteLeft
        
        length = dataToSend[byteIndex..<(byteIndex + length)].withUnsafeBytes({
            guard let ptr = $0.bindMemory(to: UInt8.self).baseAddress else{
                return 0
            }
            return connection.writerToStream(buffer: ptr, maxLength: length)
        })
        
        if length > 0 {
            byteIndex += length
            byteLeft -= length
            
            if byteLeft == 0{
                self.sendData = nil
                byteIndex = 0
            }
        }else{
            debugPrint("write buffer to stream fail")
        }
        
        return true
    }
    
    //serialized sample buffer to Data, send to socket server
    func prepareImageData(_ buffer : CMSampleBuffer) -> Data?{
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            debugPrint("image buffer not available")
            return nil
        }
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        let scaleFactor = 2.0
        let width = CVPixelBufferGetWidth(imageBuffer)/Int(scaleFactor)
        let height = CVPixelBufferGetHeight(imageBuffer)/Int(scaleFactor)
        let orientation = CMGetAttachment(buffer, key: RPVideoSampleOrientationKey as CFString, attachmentModeOut: nil)?.uintValue ?? 0
        
        let scaleTransform = CGAffineTransform(scaleX: CGFloat(1.0/scaleFactor), y: CGFloat(1.0/scaleFactor))
        let bufferData = self.jpegData(from: imageBuffer, scale: scaleTransform)
        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        
        guard let messageData = bufferData else{
            debugPrint("corrupted image buffer")
            return nil
        }
        
        let httpResponse = CFHTTPMessageCreateResponse(nil, 200, nil, kCFHTTPVersion1_1).takeRetainedValue()
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Content-Length" as CFString, String(messageData.count) as CFString)
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Buffer-Width" as CFString, String(width) as CFString)
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Buffer-Height" as CFString, String(height) as CFString)
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Buffer-Orientation" as CFString, String(orientation) as CFString)
        
        CFHTTPMessageSetBody(httpResponse, messageData as CFData)
        
        let serializedMessage = CFHTTPMessageCopySerializedMessage(httpResponse)?.takeRetainedValue() as Data?
        
        return serializedMessage
    }
    
    
    func jpegData(from buffer : CVPixelBuffer, scale scaleTransform : CGAffineTransform) ->Data?{
        var image = CIImage(cvPixelBuffer: buffer)
        image = image.transformed(by: scaleTransform)
        
        guard let colorSpace = image.colorSpace else{
            return nil
        }
        let options : [CIImageRepresentationOption : Float] = [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption : 1.0]
        
        let imageData = SamplerUploader.imageContext.jpegRepresentation(of: image, colorSpace: colorSpace, options: options)
        
        return imageData
    }
    
}
