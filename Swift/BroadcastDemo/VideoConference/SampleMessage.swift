//
//  SampleMessage.swift
//  VideoConference
//
//  Created by 360-jr on 2022/11/8.
//

import Foundation
import CoreVideo

public struct Message {
    
}


public class SampleMessage :NSObject{
    
    private(set) var imageBuffer : CVImageBuffer?
    private var framedMessage : CFHTTPMessage?
    private var imageOrientation : Int?
    
    typealias CompleteBlock = (_ success : Bool , _ message : Message) -> Void
    
    var didComplete : CompleteBlock?
    
    override init() {
        super.init()
        self.imageBuffer = nil
    }
    
    // 返回缺失的字节数，如果长度不够返回 -1
    public func appentBytes(buffer :UnsafePointer<UInt8>, length :Int) -> Int{
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
        let contentLengthStr = (CFHTTPMessageCopyHeaderFieldValue(framedMessage, "Content-Length" as CFString)?.takeUnretainedValue() ?? "") as NSString
        let contentLength = contentLengthStr.integerValue
        // get message length
        let bodyData = (CFHTTPMessageCopyBody(framedMessage)?.takeUnretainedValue() ?? Data() as CFData) as Data
        let bodyLength = bodyData.count
        
        let missingBytesCount = bodyLength - contentLength
        if missingBytesCount == 0{
            self.unwarpMessage(message: framedMessage)
        }
        
        
        return missingBytesCount
    }
    
    // CFHTTPMessage to image
    func unwarpMessage(message : CFHTTPMessage) -> Bool{
        return true
    }
    
    
    func copyImageData(data :Data , pixelBuffer : CVPixelBuffer){
        
    }
    
    
    deinit{
        debugPrint("message deinit")
    }
    
}
