//
//  HCPicker.swift
//  PHPicker
//
//  Created by Charlotte on 2020/9/28.
//
import PhotosUI
import UIKit

class HCPicker {
    
    public static let shared = HCPicker()
        
    typealias Complete = (_ images : [UIImage]) -> Void
    
    var completeBlock : Complete?
    fileprivate var currentLevel : PHAccessLevel = .readWrite
    fileprivate var currentStatus : PHAuthorizationStatus {
        get{
            return PHPhotoLibrary.authorizationStatus(for: self.currentLevel)
        }
        set{}
    }
    
    /// 获取媒体的类型 默认是图片
    var mediaType : PHPickerFilter = .images
        
    
    /// set 0 is mean system max count
    var numberOflimited = 1
    
    /// 申请相册权限
    /// - Parameter callBack: 返回申请到的相册权限
    func requestAuth(callBack : @escaping (PHAuthorizationStatus) -> Void){
        PHPhotoLibrary.requestAuthorization(for: self.currentLevel) { (status) in
            callBack(status)
        }
    }
    
    
    /// 检查读取相册权限
    /// - Parameter level: 级别 分为 .readwrite 和 .addOnly
    /// - Returns: 返回 权限
    func checkPhotoAuthStatus(_ level : PHAccessLevel = .readWrite) -> PHAuthorizationStatus{
        
        let authStatus = PHPhotoLibrary.authorizationStatus(for: level)
        
        print(authStatus.rawValue)
        
        switch authStatus{
        case .notDetermined:
            print("没有弹窗确认")
        case .restricted:
            print("受限制的 比如 系统的行为 儿童模式 或者定制机器不允许访问照片")
        case .denied:
            print("拒绝")
        case .authorized:
            print("完全开放")
        case .limited:
            print("限制选择照片")
        @unknown default:
            break
        }
        
        self.currentStatus = authStatus
        self.currentLevel = level
        
        return authStatus
    }
    
    
    /// 弹出选择图片界面
    func getImages(_ complete : @escaping (_ images : [UIImage]) -> Void){
        if #available(iOS 14, *) {
            let library = PHPhotoLibrary.shared()

            var config = PHPickerConfiguration(photoLibrary: library)
            // default 1 , 0 is mean system max count
            config.selectionLimit = numberOflimited
            
            // 1 .images
            // 2 .videos
            // 3 .livePhotos
            config.filter = self.mediaType
            
            let picker = PHPickerViewController(configuration: config)
            
            picker.modalPresentationStyle = .fullScreen
            
            picker.delegate = self
            
            UIViewController.current()?.present(picker, animated: true) {}
            self.completeBlock = complete
        }
    }
    
    func showLimitedImages(){
        if self.currentStatus == .limited{
            let library = PHPhotoLibrary.shared()
            library.presentLimitedLibraryPicker(from: UIViewController.current()!)
        }
    }
    
    func save(image : UIImage, result:@escaping (_ success :Bool)->Void){
        
        if currentStatus == .limited || currentStatus == .authorized{
            PHPhotoLibrary.shared().performChanges({
                
                _ = PHAssetChangeRequest.creationRequestForAsset(from: image)
                                        
            }, completionHandler: { (success, error) in
                result(success)
                
            })
        }else{
            // 没有写权限
            result(false)
        }
        
    }

    
}

extension HCPicker : PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]){
        picker.dismiss(animated: true, completion: nil)

        if results.count == 0{
            // 没有选择任何媒体
        }else{
            // 获取媒体
            var count = 0
            var images = [UIImage]()
            
            
            results.forEach { (result) in
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if error != nil{
                        images.append(UIImage())
                        count += 1
                        print("此照片不能选取 error \(error)")

                    }
                    if let image  = image as? UIImage{
                        images.append(image)
                        count += 1
                        if count == self.numberOflimited{
                            if self.completeBlock != nil{
                                DispatchQueue.main.async {
                                    self.completeBlock!(images)
                                    UIViewController.current()?.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
    }

}

extension UIApplication {
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        } else {
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
}


extension UIViewController {
    // MARK: - 找到当前显示的viewcontroller
    class func current(base: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        if let split = base as? UISplitViewController{
            return current(base: split.presentingViewController)
        }
        return base
    }
    

}

