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
        
    }
    
    func startCamera(){
        let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera], mediaType: <#T##AVMediaType?#>, position: <#T##AVCaptureDevice.Position#>)
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
    
    func alertMessage(message :String){
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { action in
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
