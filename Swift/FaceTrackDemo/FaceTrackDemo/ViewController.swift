//
//  ViewController.swift
//  FaceTrackDemo
//
//  Created by 刘春奇 on 2018/8/21.
//  Copyright © 2018年 Cloudnapps. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var preview: UIView!
    
    
    var session : AVCaptureSession?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var outPut : AVCaptureVideoDataOutput?
    var videoDataOutputQueue: DispatchQueue?

    var captureDeviceResolution: CGSize = CGSize()

    var captureDevice: AVCaptureDevice?

    var rootLayer: CALayer?
    var detectionOverlayLayer: CALayer?
    var detectedFaceRectangleShapeLayer: CAShapeLayer?

    
    
    private var detectionRequests: [VNDetectFaceRectanglesRequest]?

    private var trackingRequests: [VNTrackObjectRequest]?

    lazy var sequenceRequestHandler = VNSequenceRequestHandler()

    
    var uploadImage : TimeInterval = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if self.session != nil  && !(self.session?.isRunning)!{
            self.session?.startRunning()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.session?.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建session
        self.session = createCaptureSession()

        //准备追踪
        self.prepareVisionRequest()
        
        self.session?.startRunning()
        
        

    }
    
    

    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        var requestHandlerOptions: [VNImageOption: AnyObject] = [:]
        
        let cameraIntrinsicData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil)
        if cameraIntrinsicData != nil {
            requestHandlerOptions[VNImageOption.cameraIntrinsics] = cameraIntrinsicData
        }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to obtain a CVPixelBuffer for the current output frame.")
            return
        }
        
        let exifOrientation = self.exifOrientationForCurrentDeviceOrientation()

        guard let requests = self.trackingRequests, !requests.isEmpty else {
            // No tracking object detected, so perform initial detection
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                                            orientation: exifOrientation,
                                                            options: requestHandlerOptions)
            
            do {
                guard let detectRequests = self.detectionRequests else {
                    return
                }
                try imageRequestHandler.perform(detectRequests)
            } catch let error as NSError {
                NSLog("Failed to perform FaceRectangleRequest: %@", error)
            }
            return
        }
        
        
        do {
            try self.sequenceRequestHandler.perform(requests,
                                                    on: pixelBuffer,
                                                    orientation: exifOrientation)
        } catch let error as NSError {
            NSLog("Failed to perform SequenceRequest: %@", error)
        }
        
        // Setup the next round of tracking.
        var newTrackingRequests = [VNTrackObjectRequest]()
        for trackingRequest in requests {
            
            guard let results = trackingRequest.results else {
                return
            }
            
            guard let observation = results[0] as? VNDetectedObjectObservation else {
                return
            }
            
            if !trackingRequest.isLastFrame {
                if observation.confidence > 0.3 {
                    trackingRequest.inputObservation = observation
                } else {
                    trackingRequest.isLastFrame = true
                }
                newTrackingRequests.append(trackingRequest)
            }
        }
        self.trackingRequests = newTrackingRequests
        
        if newTrackingRequests.isEmpty {
            // Nothing to track, so abort.
            
            DispatchQueue.main.sync {
                self.clearAllPersionIdenUI()
            }
            
            return
        }
        
        //has face detect and track obj
        
        //TODO: Upload image condition
        if (Date().timeIntervalSince1970 - self.uploadImage) >= 2 {
            self.uploadImage = Date().timeIntervalSince1970
            self.uploadImage(sampleBuffer: sampleBuffer)
        }
        
        
        
        
        
//        // Perform face landmark tracking on detected faces.
//        var faceLandmarkRequests = [VNDetectFaceLandmarksRequest]()
//
//        // Perform landmark detection on tracked faces.
//        for trackingRequest in newTrackingRequests {
//
//            let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request, error) in
//
//                if error != nil {
//                    print("FaceLandmarks error: \(String(describing: error)).")
//                }
//
//                guard let landmarksRequest = request as? VNDetectFaceLandmarksRequest,
//                    let results = landmarksRequest.results as? [VNFaceObservation] else {
//                        return
//                }
//
//                // Perform all UI updates (drawing) on the main queue, not the background queue on which this handler is being called.
//                DispatchQueue.main.async {
//                    self.drawFaceObservations(results)
//                }
//            })
//
//            guard let trackingResults = trackingRequest.results else {
//                return
//            }
//
//            guard let observation = trackingResults[0] as? VNDetectedObjectObservation else {
//                return
//            }
//            let faceObservation = VNFaceObservation(boundingBox: observation.boundingBox)
//            faceLandmarksRequest.inputFaceObservations = [faceObservation]
//
//            // Continue to track detected facial landmarks.
//            faceLandmarkRequests.append(faceLandmarksRequest)
//
//            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
//                                                            orientation: exifOrientation,
//                                                            options: requestHandlerOptions)
//
//            do {
//                try imageRequestHandler.perform(faceLandmarkRequests)
//            } catch let error as NSError {
//                NSLog("Failed to perform FaceLandmarkRequest: %@", error)
//            }
//
//        }
        
        
        
        
        // Perform face Rectangle tracking on detected faces.
        var faceRectanglesRequests = [VNDetectFaceRectanglesRequest]()

        // Perform faceRectangle detection on tracked faces.
        for trackingRequest in newTrackingRequests {

            let faceRectanglesRequest = VNDetectFaceRectanglesRequest(completionHandler: { (request, error) in

                if error != nil {
                    print("FaceRectangles error: \(String(describing: error)).")
                }

                guard let landmarksRequest = request as? VNDetectFaceRectanglesRequest,
                    let results = landmarksRequest.results as? [VNFaceObservation] else {
                        return
                }

                // Perform all UI updates (drawing) on the main queue, not the background queue on which this handler is being called.
                DispatchQueue.main.async {
                    self.drawFaceObservations(results)
                }
            })

            guard let trackingResults = trackingRequest.results else {
                return
            }

            guard let observation = trackingResults[0] as? VNDetectedObjectObservation else {
                return
            }

//            print(observation.boundingBox)

//            let faceObservation = VNFaceObservation(boundingBox: observation.boundingBox)
//            faceLandmarksRequest.inputFaceObservations = [faceObservation]

            // Continue to track detected facial landmarks.
            faceRectanglesRequests.append(faceRectanglesRequest)

            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                                            orientation: exifOrientation,
                                                            options:  requestHandlerOptions)
            do {
                try imageRequestHandler.perform(faceRectanglesRequests)
            } catch let error as NSError {
                NSLog("Failed to perform FaceRectanglesRequest: %@", error)
            }
        }
        
    }
    
    //MARK: - radians change
    fileprivate func radiansForDegrees(_ degrees: CGFloat) -> CGFloat {
        return CGFloat(Double(degrees) * Double.pi / 180.0)
    }

    //MARK : - get image exif infromation use device orientation
    func exifOrientationForDeviceOrientation(_ deviceOrientation: UIDeviceOrientation) -> CGImagePropertyOrientation {
        
        switch deviceOrientation {
        case .portraitUpsideDown:
            return .rightMirrored
            
        case .landscapeLeft:
            return .downMirrored
            
        case .landscapeRight:
            return .upMirrored
            
        default:
            return .leftMirrored
        }
    }
    func exifOrientationForCurrentDeviceOrientation() -> CGImagePropertyOrientation {
        return exifOrientationForDeviceOrientation(UIDevice.current.orientation)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - prepare vision track
    
    fileprivate func prepareVisionRequest(){
        var requests = [VNTrackObjectRequest]()
        
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { (request, error) in
            if (error != nil){
                print("face detection request init error is \(String(describing: error))")
            }
            
            
            guard let detectionRequest = request as? VNDetectFaceRectanglesRequest , let results = detectionRequest.results as? [VNFaceObservation] else{
                return
            }
            
            //添加追踪request
            DispatchQueue.main.sync {
                for observation in results{
                    let faceTrackRequest = VNTrackObjectRequest(detectedObjectObservation: observation)
                    requests.append(faceTrackRequest)
                }
                
                self.trackingRequests = requests
                
            }
            
        }
        
        self.detectionRequests = [faceDetectionRequest]
        
        self.sequenceRequestHandler = VNSequenceRequestHandler()
        
        self.setupVisionDrawingLayers()

        
    }
    

    // MARK: Drawing Vision Observations
    
    fileprivate func setupVisionDrawingLayers() {
        let captureDeviceResolution = self.captureDeviceResolution
        
        let captureDeviceBounds = CGRect(x: 0,
                                         y: 0,
                                         width: captureDeviceResolution.width,
                                         height: captureDeviceResolution.height)
        
        let captureDeviceBoundsCenterPoint = CGPoint(x: captureDeviceBounds.midX,
                                                     y: captureDeviceBounds.midY)
        
        let normalizedCenterPoint = CGPoint(x: 0.5, y: 0.5)
        
        guard let rootLayer = self.rootLayer else {
            self.presentErrorAlert(message: "view was not property initialized")
            return
        }
        
        let overlayLayer = CALayer()
        overlayLayer.name = "DetectionOverlay"
        overlayLayer.masksToBounds = true
        overlayLayer.anchorPoint = normalizedCenterPoint
        overlayLayer.bounds = captureDeviceBounds
        overlayLayer.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        
        let faceRectangleShapeLayer = CAShapeLayer()
        faceRectangleShapeLayer.name = "RectangleOutlineLayer"
        faceRectangleShapeLayer.bounds = captureDeviceBounds
        faceRectangleShapeLayer.anchorPoint = normalizedCenterPoint
        faceRectangleShapeLayer.position = captureDeviceBoundsCenterPoint
        faceRectangleShapeLayer.fillColor = nil
        faceRectangleShapeLayer.strokeColor = UIColor.green.withAlphaComponent(0.7).cgColor
        faceRectangleShapeLayer.lineWidth = 5
        faceRectangleShapeLayer.shadowOpacity = 0.7
        faceRectangleShapeLayer.shadowRadius = 5
        
        
        overlayLayer.addSublayer(faceRectangleShapeLayer)
        rootLayer.addSublayer(overlayLayer)
        
        self.detectionOverlayLayer = overlayLayer
        self.detectedFaceRectangleShapeLayer = faceRectangleShapeLayer
        
        self.updateLayerGeometry()
    }
    
    fileprivate func updateLayerGeometry() {
        guard let overlayLayer = self.detectionOverlayLayer,
            let rootLayer = self.rootLayer,
            let previewLayer = self.previewLayer
            else {
                return
        }
        
        CATransaction.setValue(NSNumber(value: true), forKey: kCATransactionDisableActions)
        
        let videoPreviewRect = previewLayer.layerRectConverted(fromMetadataOutputRect: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        var rotation: CGFloat
        var scaleX: CGFloat
        var scaleY: CGFloat
        
        // Rotate the layer into screen orientation.
        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            rotation = 180
            scaleX = videoPreviewRect.width / captureDeviceResolution.width
            scaleY = videoPreviewRect.height / captureDeviceResolution.height
            
        case .landscapeLeft:
            rotation = 90
            scaleX = videoPreviewRect.height / captureDeviceResolution.width
            scaleY = scaleX
            
        case .landscapeRight:
            rotation = -90
            scaleX = videoPreviewRect.height / captureDeviceResolution.width
            scaleY = scaleX
            
        default:
            rotation = 0
            scaleX = videoPreviewRect.width / captureDeviceResolution.width
            scaleY = videoPreviewRect.height / captureDeviceResolution.height
        }
        
        // Scale and mirror the image to ensure upright presentation.
        let affineTransform = CGAffineTransform(rotationAngle: radiansForDegrees(rotation))
            .scaledBy(x: scaleX, y: -scaleY)
        overlayLayer.setAffineTransform(affineTransform)
        
//        let subviewTransform = CGAffineTransform(rotationAngle: radiansForDegrees(rotation))
//            .scaledBy(x: -scaleX, y: scaleY)
//
//
//        for subview in self.preview.subviews{
//            subview.layer.setAffineTransform(subviewTransform)
//
//        }

        
        // Cover entire screen UI.
        let rootLayerBounds = rootLayer.bounds
        overlayLayer.position = CGPoint(x: rootLayerBounds.midX, y: rootLayerBounds.midY)
    }
    
  
    
    fileprivate func addIndicators(to faceRectanglePath: CGMutablePath, for faceObservation: VNFaceObservation , faces : [VNFaceObservation]) {
        let displaySize = self.captureDeviceResolution
        
        let faceBounds = VNImageRectForNormalizedRect(faceObservation.boundingBox, Int(displaySize.width), Int(displaySize.height))
        faceRectanglePath.addRect(faceBounds)
        
//        let layer = CALayer()
//        layer.borderColor = UIColor.red.cgColor
//        layer.borderWidth = 3
//        layer.name = "rectangle"
//        layer.frame = CGRect(x: faceBounds.origin.x, y: displaySize.width  - (faceBounds.width + faceBounds.origin.y), width: faceBounds.size.height, height: faceBounds.size.width)
//
//        self.previewLayer?.addSublayer(layer)
        

        
        if faces.count == 1 {
            for subview in self.preview.subviews{
//                subview.frame = CGRect(x: faceBounds.origin.x, y: displaySize.width  - 20 - (faceBounds.width + faceBounds.origin.y), width: faceBounds.size.height, height: 20)
                subview.frame = CGRect(x: faceBounds.origin.x, y: (20 + faceBounds.origin.y), width: faceBounds.size.height, height: 20)

                
                
                
            }
            
            
        }
        
        
    }
    

    
    
    /// - Tag: DrawPaths
    fileprivate func drawFaceObservations(_ faceObservations: [VNFaceObservation]) {
        guard let faceRectangleShapeLayer = self.detectedFaceRectangleShapeLayer
            else {
                return
        }
        
        CATransaction.begin()

        CATransaction.setValue(NSNumber(value: true), forKey: kCATransactionDisableActions)
//
        let faceRectanglePath = CGMutablePath()
//
        
//        for sublayer in (self.previewLayer?.sublayers)! {
//            if sublayer.name == "rectangle" {
//                sublayer.removeFromSuperlayer()
//            }
//        }
        
        for faceObservation in faceObservations {
            self.addIndicators(to: faceRectanglePath,
                               for: faceObservation, faces : faceObservations)
        }
        
        faceRectangleShapeLayer.path = faceRectanglePath

        self.updateLayerGeometry()

        CATransaction.commit()
        
        
        
        
        
    }
    
    
    //MARK: - create session
    
    fileprivate func createCaptureSession() -> AVCaptureSession?{
        let captureSession = AVCaptureSession()
        
        do {
            //1. create input device
            let inputdevice = try self.createInputDevice(for: captureSession)
            //2. config video output
            self.configureVideoDataOutput(for: inputdevice.device, resolution: inputdevice.resolution, captureSession: captureSession)
            //3. desginate prewview layer
            self.designatePreviewLayer(for: captureSession)
            
            return captureSession
        } catch let executionError as NSError {
            self.presentError(executionError)
        } catch {
            self.presentErrorAlert(message: "An unexpected failure has occured")
        }
        
        
        
        return nil
    }
    
    fileprivate func designatePreviewLayer(for captureSession: AVCaptureSession) {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = videoPreviewLayer
        
        videoPreviewLayer.name = "CameraPreview"
        videoPreviewLayer.backgroundColor = UIColor.black.cgColor
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        let previewRootLayer = self.preview.layer
        
        self.rootLayer = previewRootLayer
        
        previewRootLayer.masksToBounds = true
        videoPreviewLayer.frame = previewRootLayer.bounds
        previewRootLayer.addSublayer(videoPreviewLayer)
    }

    
    
    
    //TAG : - config output
    fileprivate func configureVideoDataOutput(for inputDevice: AVCaptureDevice, resolution: CGSize, captureSession: AVCaptureSession) {
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        //丢弃过期的视频帧
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
//        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey:kCVPixelFormatType_32BGRA] as [String : Any]

        let videoDataOutputQueue = DispatchQueue(label: "com.cloudnapps.VisionFaceTrack")
        //设置视频帧代理
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }
        
        
        
        videoDataOutput.connection(with: .video)?.isEnabled = true
        
        if let captureConnection = videoDataOutput.connection(with: AVMediaType.video) {
            //设置深度捕捉
            if captureConnection.isCameraIntrinsicMatrixDeliverySupported {
                captureConnection.isCameraIntrinsicMatrixDeliveryEnabled = true
            }
        }
        
        self.outPut = videoDataOutput
        self.videoDataOutputQueue = videoDataOutputQueue
        
        self.captureDevice = inputDevice
        self.captureDeviceResolution = resolution
    }
    
    
    //TAG : - create input device
    fileprivate func createInputDevice(for captureSession:AVCaptureSession) throws -> (device: AVCaptureDevice, resolution: CGSize){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        //找到这个device
        if let device = deviceDiscoverySession.devices.first{
            //创建input
            if let deviceInput = try? AVCaptureDeviceInput(device: device){
                //添加input
                if (captureSession .canAddInput(deviceInput)){
                    captureSession.addInput(deviceInput)
                }
                //设置分辨率
                
                if let highestResolution = self.highestResolution420Format(for: device){

                    try device.lockForConfiguration()
                    device.activeFormat = highestResolution.format
                    device.unlockForConfiguration()

                    //返回设备 分辨率
                    return (device,highestResolution.resolution)

                }
                
            }
        }
        throw NSError(domain: "ViewController", code: 1, userInfo: nil)


    }
    
    
    //config input resolution
    fileprivate func highestResolution420Format(for device: AVCaptureDevice) -> (format: AVCaptureDevice.Format, resolution: CGSize)? {
        var highestResolutionFormat: AVCaptureDevice.Format? = nil
        var highestResolutionDimensions = CMVideoDimensions(width: 0, height: 0)
        
        for format in device.formats {
            let deviceFormat = format as AVCaptureDevice.Format
            
            let deviceFormatDescription = deviceFormat.formatDescription
            if CMFormatDescriptionGetMediaSubType(deviceFormatDescription) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange {
                let candidateDimensions = CMVideoFormatDescriptionGetDimensions(deviceFormatDescription)
                if (highestResolutionFormat == nil) || (candidateDimensions.width > highestResolutionDimensions.width) {
                    highestResolutionFormat = deviceFormat
                    highestResolutionDimensions = candidateDimensions
                }
            }
        }
        
        if highestResolutionFormat != nil {
            let resolution = CGSize(width: CGFloat(highestResolutionDimensions.width), height: CGFloat(highestResolutionDimensions.height))
            return (highestResolutionFormat!, resolution)
        }
        
        return nil
    }
    
    
    
    // MARK: Helper Methods for Error Presentation
    
    fileprivate func presentErrorAlert(withTitle title: String = "Unexpected Failure", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true)
    }
    
    fileprivate func presentError(_ error: NSError) {
        self.presentErrorAlert(withTitle: "Failed with error \(error.code)", message: error.localizedDescription)
    }
    
    
    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage?
    {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        
        
        let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
        
        func convert(cmage:CIImage) -> UIImage
        {
            let context:CIContext = CIContext.init(options: nil)
            let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
            let image:UIImage = UIImage.init(cgImage: cgImage)
            return image
        }
        let image : UIImage = convert(cmage: ciimage)

        return image
        
        
//        // Lock the base address of the pixel buffer
//        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
//
//
//        // Get the number of bytes per row for the pixel buffer
//        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);
//
//        // Get the number of bytes per row for the pixel buffer
//        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
//        // Get the pixel buffer width and height
//        let width = CVPixelBufferGetWidth(imageBuffer!);
//        let height = CVPixelBufferGetHeight(imageBuffer!);
//
//        // Create a device-dependent RGB color space
//        let colorSpace = CGColorSpaceCreateDeviceRGB();
//
//        // Create a bitmap graphics context with the sample buffer data
//        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
//        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
//        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
//        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
//        // Create a Quartz image from the pixel data in the bitmap graphics context
//        let quartzImage = context?.makeImage();
//        // Unlock the pixel buffer
//        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
//
//        if quartzImage == nil {
//            return nil
//        }
//
//        // Create an image object from the Quartz image
//        let image = UIImage.init(cgImage: quartzImage!);
//
//        return (image);
    }
    

}


extension ViewController{
    
    /// upload image to server
    ///
    /// - Parameter sampleBuffer: output delegate samplebuffer
    func uploadImage(sampleBuffer:CMSampleBuffer) {
        
        
        guard var image = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            return
        }
        
        image = self.fixOrientation(orimage: image)
        guard var imageData = UIImageJPEGRepresentation(image, 0.5) else {
            return
        }
        
        while imageData.count/1000/1000 > 4 {
            let tempImage = UIImage.init(data: imageData)
            imageData = UIImageJPEGRepresentation(tempImage!, 0.5)!
        }
        
        let session = URLSession.shared
        
        var request = URLRequest.init(url: URL.init(string: "http://facecameraapi.demo.store.cloudnapps.com/api/v1/face-recog/check")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("5b06788100f27e4c2cb843ee", forHTTPHeaderField: "store-id")

        request.httpMethod = "POST"
        
        let bodyDic = ["dataUrl":"data:image/jpeg;base64,\(imageData.base64EncodedString())"]
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyDic, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil{
                print("upload image error is \(String(describing: error))")
                return
            }

            do{
                let dict  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let res = dict as? [[String:Any]] ?? [[String:Any]]()
                
                print(res)
                
                DispatchQueue.main.sync {
                    self.updatePersonIdenUI(userInfo: res)
                }
                
            }catch let error {
                print(error)
            }

            print(response as Any)
            
            
            
        }
            
        dataTask.resume()
        
        
        
    }
    
    
    
    /// clear all label ui
    fileprivate func clearAllPersionIdenUI(){
        //先清除上一次加载view
        for subView in self.preview.subviews {
            subView.removeFromSuperview()
        }
        
    }
    
    struct ServerRectangle {
        var top: Double
        var width : Double
        var left : Double
        var height : Double
    }
    
    
    ///creat persion iden ui
    fileprivate func updatePersonIdenUI(userInfo:[[String:Any]]){
        if userInfo.count == 0{
            return
        }
        
        self.clearAllPersionIdenUI()
        
        
        //重新加载标识view
        for item in userInfo {
            
            let personId = item["personId"] as? String ?? ""
            let rectangle = item["faceRectangle"]as?[String:Any] ?? [String:Any]()
            let serverRectangle = ServerRectangle.init(top: rectangle["top"] as! Double, width: rectangle["width"] as! Double, left: rectangle["left"] as! Double, height: rectangle["height"] as! Double)
            
            let faceInfo = item["faceAttributes"] as? [String:Any] ?? [String:Any]()
            let gender = "\(faceInfo["gender"] as?String  == "male" ? "男" : "女" )"
            let age = "\(faceInfo["age"] as? Int ?? 0 )"
            
            
            let label =
                UILabel.init()
            label.text = "\(age)岁  \(gender)"
            label.textColor = UIColor.green
            label.textAlignment = .center
            label.backgroundColor = UIColor.blue
            self.preview.addSubview(label)
            
            if (self.trackingRequests?.count)! > 1{
                label.frame = CGRect(x: serverRectangle.left , y: serverRectangle.top - 120.0, width: serverRectangle.width, height: 20)

            }
            
        }
        
        
    }
    
    
}




extension ViewController {
    // 修复图片旋转
    func fixOrientation( orimage:UIImage) -> UIImage {
        
        var image : UIImage
        if orimage.imageOrientation == .up {
            image = UIImage.init(cgImage: orimage.cgImage!, scale: 1, orientation: .leftMirrored)
        }else{
            image = orimage
            
        }
        
        var transform = CGAffineTransform.identity
        
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: .pi)
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
            
        default:
            break
        }
        
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(image.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(image.size.height), height: CGFloat(image.size.width)))
            break
            
        default:
            ctx?.draw(image.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(image.size.width), height: CGFloat(image.size.height)))
            break
        }
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
}
