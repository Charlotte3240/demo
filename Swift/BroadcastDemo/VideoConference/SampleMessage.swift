//
//  SampleMessage.swift
//  VideoConference
//
//  Created by 360-jr on 2022/11/8.
//

import Foundation
import CoreVideo
import CoreImage

//public struct Message {
//    public var imagebuffer : CVImageBuffer?
//    public var imageOrientation : Int?
//}


var imageContext : CIContext = CIContext()


public class SampleMessage :NSObject{

    private var framedMessage : CFHTTPMessage?
//    var message : Message?
    
    private var imageBuffer : CVImageBuffer?
    private var imageOrientation : Int?
    
    
    
    public typealias CompleteBlock = (_ success : Bool , _ buffer : CVImageBuffer? , _ imageOrientation : Int?) -> Void
    
    public var didComplete : CompleteBlock?
    
    
    public override init() {
        super.init()
//        self.message = nil
    }
    
    // 返回缺失的字节数，如果长度不够返回 -1
    public func appentBytes(buffer :UnsafeMutablePointer<UInt8>, length :Int) -> Int{
        if self.framedMessage == nil{
            self.framedMessage = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, false).takeRetainedValue()
        }
        guard let framedMessage = self.framedMessage else{
            return -2
        }
        CFHTTPMessageAppendBytes(framedMessage, buffer, length)
        if !CFHTTPMessageIsHeaderComplete(framedMessage) {
            return -1;
        }
        
        // get content length
        CFHTTPMessageCopyHeaderFieldValue(framedMessage, "Content-Length" as CFString)
        
        let contentLengthStr = (CFHTTPMessageCopyHeaderFieldValue(framedMessage, "Content-Length" as CFString)?.takeRetainedValue() ?? "") as NSString
        let contentLength = contentLengthStr.integerValue
        // get message length
        let bodyData = (CFHTTPMessageCopyBody(framedMessage)?.takeRetainedValue() ?? Data() as CFData) as Data
        let bodyLength = bodyData.count
        
        let missingBytesCount = contentLength - bodyLength
        if missingBytesCount == 0{
            let success = self.unwarpMessage(message: framedMessage)
            if self.didComplete != nil{
                self.didComplete?(success,self.imageBuffer, self.imageOrientation)
            }

//            if let buffer = self.imageBuffer, let imageOrientation = self.imageOrientation{
//                let message = Message(imagebuffer: buffer, imageOrientation: imageOrientation)
//                if self.didComplete != nil{
//                    self.didComplete?(success,self)
//                }
//            }
            
            self.imageBuffer = nil
            self.imageOrientation = nil
            self.framedMessage = nil
        }
        return missingBytesCount
    }
    
    // CFHTTPMessage to image
    func unwarpMessage(message : CFHTTPMessage) -> Bool{
        // get image content , info from CFHTTPMessage
        let width = (CFHTTPMessageCopyHeaderFieldValue(message, "Buffer-Width" as CFString)?.takeRetainedValue() ?? "") as NSString
        let height = (CFHTTPMessageCopyHeaderFieldValue(message, "Buffer-Height" as CFString)?.takeRetainedValue() ?? "") as NSString
        let orientation = (CFHTTPMessageCopyHeaderFieldValue(message, "Buffer-Orientation" as CFString)?.takeRetainedValue() ?? "") as NSString

        let messageData = (CFHTTPMessageCopyBody(message)?.takeRetainedValue() ?? Data() as CFData) as Data
        
        // Copy the pixel buffer
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width.integerValue, height.integerValue, kCVPixelFormatType_32BGRA, nil, &self.imageBuffer)
                
        if status != kCVReturnSuccess{
            debugPrint("cvpixel buffer create failed")
            return false
        }
        
        self.copyImageData(data: messageData, pixelBuffer: self.imageBuffer)
        
        self.imageOrientation = orientation.integerValue
        return true
    }
    
    
    func copyImageData(data :Data , pixelBuffer : CVPixelBuffer?){
        guard let pixelBuffer = pixelBuffer else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        
        if let image = CIImage(data: data),self.imageBuffer != nil{
            imageContext.render(image, to: self.imageBuffer!)
        }
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        
    }
    
    
    deinit{
        self.imageBuffer = nil
    }
    
}
