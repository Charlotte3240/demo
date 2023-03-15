//
//  ViewController.swift
//  OCR
//
//  Created by 360-jr on 2023/2/2.
//

import UIKit
import Vision
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup aftesr loading the view.
        
        
        // 触发测试按钮
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 80, height: 35)
        btn.setTitle("start", for: .normal)
        btn.center = self.view.center
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        // 预热ocr模型
        predictImage(imageName: "img/test")
        
    }

    @objc func btnAction(){
        startPredictIndex()
    }
    
    func startPredictIndex(){
        for (i,path) in testPaths.enumerated(){
            debugPrint("start index:",i)
            autoreleasepool{
                predictImage(imageName: path)
            }
        }
    }
    
    
    func predictImage(imageName : String){
        //img/ocrtest
        let path = imageName.split(separator: ".").first ?? ""
        guard let path = Bundle.main.path(forResource: "\(path)", ofType: "png"), let inputImgae = UIImage(contentsOfFile: path) else{
            debugPrint("not found input image name \(imageName)")
            return
        }

        guard let buffer = self.imageToCVPixelBuffer(image: inputImgae)else{
            debugPrint("image to cvpixel buffer failed \(imageName)")
            return
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: buffer, orientation: .up)

//        let handler = VNImageRequestHandler(cgImage: inputImgae.cgImage!,orientation: CGImagePropertyOrientation(.up))

        let request = VNRecognizeTextRequest(completionHandler: recognizeTextRequestHandler(request:error:))
        request.tagName = imageName
        request.recognitionLevel = .accurate
//        request.recognitionLanguages = ["zh-Hans","zh-Hant"]
        request.recognitionLanguages = ["zh","en"]
//        if #available(iOS 16.0, *) { // 自动识别语言
//            request.automaticallyDetectsLanguage = true
//        } else {
//            // Fallback on earlier versions
//        }
        
        do {
            // 开始计时
            request.tagTime = Date().timeIntervalSince1970
            try handler.perform([request])
        } catch let error {
            print("perform request error: ",error)
        }
    }
    
    
    func recognizeTextRequestHandler(request :VNRequest , error : Error?){
        let req = request as? VNRecognizeTextRequest
        debugPrint(req?.tagName ?? "")
        print("time:",Date().timeIntervalSince1970 - (req?.tagTime ?? 0))

        if error != nil{
            debugPrint("recognize fail ,tagName: \(req?.tagName ?? "") , startTime: \(req?.tagTime ?? 0)")
            debugPrint(error)
            return
        }
        guard let observations = request.results as? [VNRecognizedTextObservation] else{
            return
        }
        let resultStrings :[Content] = observations.compactMap { ob in
//            print(ob.topCandidates(1).first?.string ?? "")
//            print(ob.boundingBox)
            
            // send result to golang service
            let txt = ob.topCandidates(1).first?.string ?? ""
            let pos = "\(ob.boundingBox.origin.x),\(ob.boundingBox.origin.y),\(ob.boundingBox.size.width),\(ob.boundingBox.size.height)"
            
            return Content(txt: txt,position: pos)
        }
                
        var netReq = OcrRequest()
        netReq.path = req?.tagName ?? ""
        netReq.content = resultStrings
        
        sendResult(result: netReq)

    }
    
    func sendResult(result : OcrRequest){
        guard result.path?.isEmpty == false else{
            return
        }
        
        
        var postData : Data
        do {
            postData = try JSONEncoder().encode(result)
            var request = URLRequest(url: URL(string: "http://192.168.100.23:2233/writeData")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "POST"
            request.httpBody = postData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil{
                    print("\(result.path ?? "") 已发送")
                }
            }
            task.resume()

        } catch let error {
            debugPrint("转json 失败\(error)")
            return

        }
    }

}


// 给request 扩展信息
extension VNRecognizeTextRequest{
    private struct tagDic{
        static var imageName: String = ""
        static var startTime : Date = Date()
    }
    
    public var tagName : String? {
        get{
            return objc_getAssociatedObject(self, &tagDic.imageName) as? String
        }
        set(value){
            guard let name : String = value else{
                return
            }
            objc_setAssociatedObject(self, &tagDic.imageName, name, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
    public var tagTime : Double? {
        get{
            return objc_getAssociatedObject(self, &tagDic.startTime) as? Double
        }
        set(value){
            guard let num : Double = value else {
                return
            }
            objc_setAssociatedObject(self, &tagDic.startTime, num, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    
}



struct OcrRequest :Codable{
    var path : String?
    var content :[Content]?
}

struct Content :Codable{
    var txt, position: String?
}


extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError("init cgImagePropertyOrientation fail \(uiOrientation)")
        }
    }
}
extension UIImage.Orientation {
    init(_ cgOrientation: UIImage.Orientation) {
        switch cgOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError("init uiimage orientation fail \(cgOrientation)")
        }
    }
}


extension ViewController{
    func imageToCVPixelBuffer(image:UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
}
