//
//  QRScanViewController.swift
//  DesktopExtension
//
//  Created by 360-jr on 2022/12/2.
//

import UIKit

struct ScanQRImage {
    
    /// 扫描二维码
    /// - Parameter callback: 返回二维码的信息
    func scan (_ callback :(String) -> Void){
        
    }
    
    /// 读取二维码
    /// - Parameter callback: 返回二维码的信息
    func read (_ callback :(String) -> Void){
        
    }
}



import AVFoundation
class QRScanViewController : UIViewController{
    var preview : UIView?
    var shadowView : UIView?
    var shadowImageView :UIImageView?
    var timer : Timer?
    
    var inputDevice : AVCaptureDeviceInput?
    var cameraDevice : AVCaptureDevice?
    
    var output : AVCaptureMetadataOutput?
    
    var session : AVCaptureSession?
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var torchOpen = false
    
    var qrcodeResults = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        guard checkCameraHardware() else{
            alertMessage(message: "设备不支持相机")
            return
        }
        checkCameraAuth {[weak self] success in
            if !success{
                self?.alertMessage(message: "没有给相机权限")
                return
            }
        }
        
        settingUI()
        
        startCamera()
        
        addFlashLightBtn()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.doRotateAction()
    }
    
    
    
    func settingUI(){
        self.preview = UIView()
        self.preview?.bounds = self.view.bounds
        self.preview?.center = self.view.center
        self.view.addSubview(preview!)
        
        self.shadowView = UIView()
        // 边长
        let sideLen = UIScreen.main.bounds.width * 0.75
        shadowView?.frame = CGRect(x: 0, y: 0, width: sideLen, height: sideLen)
        shadowView?.center = self.view.center
        shadowView?.clipsToBounds = true
        self.view.addSubview(shadowView!)
        
        shadowImageView = UIImageView(image: UIImage(named: "shadow"))
        shadowImageView?.frame = CGRect(x: 0, y: -(shadowView?.bounds.height ?? 0), width: sideLen, height: sideLen)
        self.shadowView?.addSubview(shadowImageView!)
        
        self.startAnimate()
        
        let backBtn = UIButton(type: .system)
        backBtn.tintColor = .white
        backBtn.setImage(UIImage(systemName: "arrowshape.turn.up.backward"), for: .normal)
        backBtn.frame = CGRect(x: 15, y: 50, width: 50, height: 50)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
    }
    
    func startCamera(){
        guard let device = findCameraDevice() else{
            alertMessage(message: "没有找到合适的摄像头，建议更换设备")
            return
        }
        self.cameraDevice = device
        
        do {
             try self.inputDevice = AVCaptureDeviceInput(device: device)
        }catch let error{
            alertMessage(message: "设置摄像头出错: \(error.localizedDescription)")
        }
        
        do {
            try device.lockForConfiguration()
            // 实时白平衡
            if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance){
                device.whiteBalanceMode = .continuousAutoWhiteBalance
            }
            // 实时自动对焦
            if device.isFocusModeSupported(.continuousAutoFocus){
                device.focusMode = .continuousAutoFocus
            }
            // 实时自动曝光
            if device.isExposureModeSupported(.continuousAutoExposure){
                device.exposureMode = .continuousAutoExposure
            }
            
            device.unlockForConfiguration()

        } catch let error {
            alertMessage(message: "camera setting error :\(error.localizedDescription)")
        }
        
        self.output = AVCaptureMetadataOutput()
        self.output?.rectOfInterest = self.view.bounds
        self.output?.setMetadataObjectsDelegate(self, queue: .main)
        
        let session = AVCaptureSession()
        self.session = session
        
        self.session?.sessionPreset = .high
        if let input = self.inputDevice{
            if self.session?.canAddInput(input) == true{
                self.session?.addInput(input)
            }
        }
        if let output = self.output{
            if self.session?.canAddOutput(output) == true{
                self.session?.addOutput(output)
            }
        }
        self.output?.metadataObjectTypes = self.output?.availableMetadataObjectTypes
        //[.code128, .upce, .code39 , .code39Mod43 , .ean13 ,.ean8 , .code93 , .pdf417, .qr , .aztec , .interleaved2of5 , .itf14 , .dataMatrix]
        
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer = previewLayer
        self.previewLayer?.videoGravity = .resizeAspectFill
        self.previewLayer?.frame = self.view.bounds
        self.previewLayer?.connection?.videoOrientation = self.getDeviceDirection()
        self.preview?.layer.insertSublayer(previewLayer, at: 0)
        
        DispatchQueue.global().async {
            session.startRunning()
        }
        
        
    }
    
    
    func addFlashLightBtn(){
        if checkCameraTorchOrFlash(){
            // 手电筒
            let flashLightBtn = UIButton(type: .system)
            flashLightBtn.tintColor = .white
            flashLightBtn.setImage(UIImage(named: "flashLight"), for: .normal)
            self.view.addSubview(flashLightBtn)
            flashLightBtn.addTarget(self, action: #selector(flashLightToggle), for: .touchUpInside)
            
            flashLightBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            flashLightBtn.center = CGPoint(x: self.view.center.x, y: UIScreen.main.bounds.size.height - 200)
        }

    }
    
    @objc func flashLightToggle(){
        
        do {
            if torchOpen{
                try self.cameraDevice?.lockForConfiguration()
                self.cameraDevice?.torchMode = .off
                self.cameraDevice?.unlockForConfiguration()
                self.torchOpen.toggle()
            }else{
                try self.cameraDevice?.lockForConfiguration()
                try self.cameraDevice?.setTorchModeOn(level: 0.6)
                self.cameraDevice?.unlockForConfiguration()
                self.torchOpen.toggle()
            }
        } catch let error {
            alertMessage(message: "开启或关闭闪光灯失败: \(error.localizedDescription)")
        }
    }

    
    func startAnimate(){
        if timer == nil{
            timer = Timer.scheduledTimer(timeInterval: 1.8, target: self, selector: #selector(shadowViewStartAnimate), userInfo: nil, repeats: true)
        }
        timer?.fire()

    }
    func endAnimate(){
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func shadowViewStartAnimate(){
        guard let animateView = self.shadowImageView else{
            return
        }
        let startPosition = CGRect(x: 0, y: -animateView.bounds.size.height, width: animateView.bounds.size.width, height: animateView.bounds.size.height)
        animateView.frame = startPosition
        let endPosition = CGRect(x: 0, y: animateView.bounds.size.height, width: animateView.bounds.size.width + 50, height: animateView.bounds.size.height)
        UIView.animate(withDuration: 1.5, delay: 0) {
            animateView.frame = endPosition
        }
    }
    
    func doRotateAction(){
        self.previewLayer?.frame = self.preview?.bounds ?? CGRect.zero
        self.previewLayer?.connection?.videoOrientation = self.getDeviceDirection()
        self.output?.rectOfInterest = self.view.bounds
        
        self.preview?.center = self.view.center
    }
    
    
    @objc func backAction(){
        self.dismiss(animated: true)
    }
    
    
}

//MARK: - ouput info
extension QRScanViewController: AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        var qrResults = [AVMetadataMachineReadableCodeObject]()
        metadataObjects.forEach({
            if $0.type == .qr{
                if let transformObj = self.previewLayer?.transformedMetadataObject(for: $0),
                   let obj = transformObj as? AVMetadataMachineReadableCodeObject{
                    //                    obj.bounds // 平面方框
                    //                    obj.corners // 二维码4个顶点
                    qrResults.append(obj)
                }
            }
        })
        if qrResults.count >= 1{
            self.session?.stopRunning()
            self.endAnimate()
        }
        
        qrResults.forEach({
            if ($0.stringValue ?? "").count > 0{
                qrcodeResults.append($0.stringValue ?? "")
            }
            
            
            let redView = UIView()
            redView.backgroundColor = .red
            redView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            redView.layer.cornerRadius = 15.0
            self.view.addSubview(redView)
            redView.center = CGPoint(x: $0.bounds.origin.x + $0.bounds.size.width/2, y: $0.bounds.origin.y + $0.bounds.size.height/2)
            
            // 绘制顶点覆盖 和 二维码覆盖
//            genFillLayer(obj: $0, previewLayer: self.previewLayer)
        })
    }
    
    
    /// 生成覆盖视图
    /// - Parameters:
    ///   - obj: 传入metaobj
    ///   - previewLayer: 传入摄像头预览图层
    func genFillLayer(obj : AVMetadataMachineReadableCodeObject, previewLayer : AVCaptureVideoPreviewLayer?){
        // 对顶点和二维码进行填充颜色
        let (cornersPath , barcodePath) = genCornerBoxAndBarcodeBoxPath(obj: obj)
        let cornerLayer = CAShapeLayer()
        cornerLayer.path = cornersPath.cgPath
        cornerLayer.lineWidth = 3.0
        cornerLayer.strokeColor = UIColor.green.cgColor
        cornerLayer.fillColor = UIColor.green.withAlphaComponent(0.5).cgColor
        
        let barcodeLayer = CAShapeLayer()
        barcodeLayer.path = barcodePath.cgPath
        barcodeLayer.lineWidth = 2.0
        barcodeLayer.strokeColor = UIColor.blue.cgColor
        barcodeLayer.fillColor = UIColor.blue.withAlphaComponent(0.3).cgColor
        
        previewLayer?.addSublayer(cornerLayer)
        previewLayer?.addSublayer(barcodeLayer)

    }
    
    /// 生成cornersPath 和 barcodePath
    /// - Parameter obj: metaDataObj
    /// - Returns: (顶点贝塞尔 , 二维码贝塞尔)
    func genCornerBoxAndBarcodeBoxPath(obj : AVMetadataMachineReadableCodeObject) -> (UIBezierPath,UIBezierPath){
        let cornersPath : UIBezierPath = UIBezierPath()
        for (index, corner) in obj.corners.enumerated(){
            if index == 0 {
                cornersPath.move(to: corner)
            }else {
                cornersPath.addLine(to: corner)
            }
        }
        let barcodePath : UIBezierPath = UIBezierPath.init(rect: obj.bounds)
        
        return (cornersPath, barcodePath)
    }
}


//MARK: - 权限校验
extension QRScanViewController{
    func checkCameraAuth(_ callback : @escaping (Bool) -> Void) {
        var result = false

        let group = DispatchGroup()

        DispatchQueue.global().async(group: group, execute: {
            group.enter()
            AVCaptureDevice.requestAccess(for: .video) { (res) in
                result = res
                group.leave()
            }
        })
        group.notify(queue: .main) {
            callback(result)
        }
    }
    
    func checkCameraHardware() -> Bool{
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false{
            return false
        }
        return true
    }
    
    func checkCameraTorchOrFlash() -> Bool{
        guard let device = self.cameraDevice else{
            return false
        }
        if device.hasFlash && device.hasTorch {
            return true
        }
        return false
    }
    
    func findCameraDevice() -> AVCaptureDevice?{
        if let device = AVCaptureDevice.default(.builtInTripleCamera, for: .video, position: .back){
            return device
        }
        if let device = AVCaptureDevice.default(.builtInTelephotoCamera, for: .video, position: .back) {
            return device
        }
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera,.builtInTelephotoCamera], mediaType: .video, position: .back)
        return discoverySession.devices.last
    }
    
    func getDeviceDirection() -> AVCaptureVideoOrientation{
        switch UIDevice.current.orientation{
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    func alertMessage(message :String){
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { action in
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
