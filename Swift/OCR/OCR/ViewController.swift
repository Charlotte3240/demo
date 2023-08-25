//
//  ViewController.swift
//  OCR
//
//  Created by Charlotte on 2023/2/2.
//

import UIKit
import Vision
class ViewController: UIViewController {

    @IBOutlet weak var uploadNum: UILabel!
    
    @IBOutlet weak var startBtn: UIButton!
    
    let os_version  = UIDevice.current.systemVersion
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup aftesr loading the view.
        
        self.view.backgroundColor = .white
                
        // 预热ocr模型
//        predictImage(imageName: "img/test.jpg")
        predictImage(imageName: "img/QQ20230630-181813@2x.png")

        
    }
    @IBAction func startPredictAction(_ sender: Any) {
        startPredictIndex()

    }
    
    func startPredictIndex(){
        
        self.startBtn.isEnabled = false
        
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
        let type = imageName.split(separator: ".").last ?? ""
        guard let path = Bundle.main.path(forResource: "\(path)", ofType: "\(type)"), let inputImgae = UIImage(contentsOfFile: path) else{
            debugPrint("not found input image name \(imageName)")
            return
        }

//        guard let buffer = self.imageToCVPixelBuffer(image: inputImgae)else{
//            debugPrint("image to cvpixel buffer failed \(imageName)")
//            return
//        }
        
//        let handler = VNImageRequestHandler(cvPixelBuffer: buffer, orientation: .up)

        let handler = VNImageRequestHandler(cgImage: inputImgae.cgImage!,orientation: CGImagePropertyOrientation(.up))
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextRequestHandler(request:error:))
        request.tagName = imageName
        request.width = inputImgae.size.width
        request.height = inputImgae.size.height
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
            debugPrint("perform request error: ",error)
        }
    }
    
    
    func recognizeTextRequestHandler(request :VNRequest , error : Error?){
        let req = request as? VNRecognizeTextRequest
        let time = Date().timeIntervalSince1970 - (req?.tagTime ?? 0)
        let imageName = (req?.tagName ?? "").split(separator: "/").last ?? ""
        debugPrint("name:",imageName)
        debugPrint("time:",time)

        if error != nil{
            debugPrint("recognize fail ,tagName: \(req?.tagName ?? "") , startTime: \(req?.tagTime ?? 0)")
            debugPrint(error)
            return
        }
        guard let observations = request.results as? [VNRecognizedTextObservation] else{
            return
        }
        
        let resultStrings :[Content] = observations.compactMap { ob in
            debugPrint(ob.topCandidates(1).first?.string ?? "")
//            debugPrint(ob.boundingBox)
            
            
            // send result to golang service
            let txt = ob.topCandidates(1).first?.string ?? ""
            // 原点在左下角
//            let pos = "\(ob.boundingBox.origin.x),\(ob.boundingBox.origin.y),\(ob.boundingBox.size.width),\(ob.boundingBox.size.height)"
            let width = req?.width ?? 0.0
            let height = req?.height ?? 0.0
            let pos = [
                RegionPoint(x: Int(ob.topLeft.x * width),y: Int(height - ob.topLeft.y * height)),// 左上
                RegionPoint(x: Int(ob.topRight.x * width),y: Int(height - ob.topRight.y * height)),// 右上
                RegionPoint(x: Int(ob.bottomRight.x * width),y: Int(height - ob.bottomRight.y * height)),// 右下
                RegionPoint(x: Int(ob.bottomLeft.x * width),y: Int(height - ob.bottomLeft.y * height)) // 左下
            ]

            let confidence = ob.confidence
            return Content(text: txt,confidence: confidence, text_region: pos)
        }
                
        let netReq = OcrRequest(
            total_cost_seconds: time * 1000,
            rec_boxes_number: resultStrings.count,
            os_type: "IOS",
            dev_brand: "apple-vision",
            os_version: os_version,
            dev_model: self.getDeiveName(),
            img_name: "\(imageName)",
            ocr_res: resultStrings
        )
        
        if netReq.img_name == "test.jpg"{
            return
        }else{
//            sendResult(result: netReq)
        }
        

        

    }
    
    func sendResult(result : OcrRequest){
        guard result.img_name?.isEmpty == false else{
            return
        }
        
        var postData : Data
        do {
            postData = try JSONEncoder().encode(result)
            var encryptedStr = String(data: postData, encoding: .utf8) ?? ""
            encryptedStr = self.encrptyData(data: encryptedStr)
            
            let body = ["data":encryptedStr]
            let bodyData = try JSONEncoder().encode(body)
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)

            var request = URLRequest(url: URL(string: "https://voiptest.Charlotte.com/api/predictTest/log")!,timeoutInterval: 30)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = bodyData

            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    debugPrint("\(result.img_name ?? "") 已发送")
//                    debugPrint("ret: ",String(data:data ?? Data(),encoding: .utf8))
                    DispatchQueue.main.async {
                        self.startBtn.isEnabled = true
                        self.uploadNum.text = "\((Int(self.uploadNum.text ?? "") ?? 0) + 1)"
                    }
                }else{
                    DispatchQueue.main.async {
                        self.startBtn.isEnabled = true
                        let alertvc =  UIAlertController(title: "提示", message: "\(result.img_name ?? "") : \(error?.localizedDescription ?? "")", preferredStyle: .alert)
                        let dissmiss = UIAlertAction(title: "确定", style: .cancel)
                        alertvc.addAction(dissmiss)
                        self.present(alertvc, animated: true)
                    }
                }
            }
            task.resume()

        } catch let error {
            DispatchQueue.main.async {
                let alertvc =  UIAlertController(title: "提示", message: "\(result.img_name ?? "") : \(error.localizedDescription)", preferredStyle: .alert)
                let dissmiss = UIAlertAction(title: "确定", style: .cancel)
                alertvc.addAction(dissmiss)
                self.present(alertvc, animated: true)
            }

            return
        }
    }

}


// 给request 扩展信息
extension VNRecognizeTextRequest{
    private struct tagDic{
        static var imageName: String = ""
        static var startTime : Date = Date()
        static var width : CGFloat = 0.0
        static var height : CGFloat = 0.0
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
    
    public var width : CGFloat? {
        get{
            return objc_getAssociatedObject(self, &tagDic.width) as? CGFloat
        }
        set(value){
            guard let num : CGFloat = value else {
                return
            }
            objc_setAssociatedObject(self, &tagDic.width, num, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    public var height : CGFloat? {
        get{
            return objc_getAssociatedObject(self, &tagDic.height) as? CGFloat
        }
        set(value){
            guard let num : CGFloat = value else {
                return
            }
            objc_setAssociatedObject(self, &tagDic.height, num, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    
}



struct OcrRequest :Codable{
    var total_cost_seconds : Double?
    var det_cost_seconds : Double = 0.0
    var rec_cost_seconds : Double = 0.0
    var rec_boxes_number : Int?
    var os_type : String?
    var dev_brand: String?
    var os_version: String?
    var dev_model : String?
    var img_name : String?
    var ocr_res :[Content]?
}

struct Content :Codable{
    var text: String?
    var confidence : Float?
    var text_region:[RegionPoint]?
}

struct RegionPoint: Codable{
    var x,y :Int?
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

import SystemConfiguration

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
    
    
    func getDeiveName() -> String{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machine = Mirror(reflecting: systemInfo.machine).children.reduce("") { iden, ele in
            guard let value = ele.value as? Int8, value != 0 else{
                return iden
            }
            return iden + String(UnicodeScalar(UInt8(value)))
        }
        
        return machine
    }
}


extension ViewController{
    func encrptyData(data : String) -> String{
//        let pubPath = Bundle.main.path(forResource: "pub", ofType: "pem")
//        return RSAObjC.encrypt(data, keyFilePath: pubPath)
        
        return data.data(using: .utf8)?.base64EncodedString() ?? ""
    }
}


extension ViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
            return
        }

        let credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential,credential)
    }
}
