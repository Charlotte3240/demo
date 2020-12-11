//
//  HCPicker.swift
//  PHPicker
//
//  Created by Charlotte on 2020/9/28.
//
import PhotosUI
import UIKit

@available(iOS 14, *)
@objc class HCPicker : NSObject{
        
    static let shared = HCPicker()
    
    typealias Complete = (_ image : UIImage) -> Void
    
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
    
    @objc static func sharedInstance()->HCPicker{
        return HCPicker.shared
    }
    
    /// 弹出选择图片界面
    @objc func getImagesAction(_ complete : @escaping Complete){
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
    
    /// 展示受限制的相册
    func showLimitedImages(){
        if self.currentStatus == .limited{
            let library = PHPhotoLibrary.shared()
            library.presentLimitedLibraryPicker(from: UIViewController.current()!)
        }
    }
        
    
    deinit {
        print("hcpicker deinit")
    }

    
}


// MARK: - 保存图片
import Photos
import PhotosUI
extension UIImage{
    func requestPhotoAuth( complete: @escaping (_ errStr:String?)-> Void){
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                var failReason = ""
                switch status{
                case .notDetermined:
                    failReason = "请打开相册的访问开关"
                case .restricted:
                    failReason = "因系统原因，无法访问相册！"
                case .denied:
                    failReason = "请打开相册的访问开关"
                case .authorized,.limited:
                    // 可以访问相册，或访问限制的相册
                    break
                @unknown default:
                    failReason = "因系统原因，无法访问相册！"
                }
                complete(failReason)
                print("访问相册错误原因\(failReason)")
            }
        }
    }

    
    /// 保存图片到相册
    /// - Parameters:
    ///   - image: 要保存的图片
    ///   - result: 保存结果回调
    func save(image : UIImage, result:@escaping (_ success :Bool)->Void){

        PHPhotoLibrary.shared().performChanges({

            _ = PHAssetChangeRequest.creationRequestForAsset(from: image)

        }, completionHandler: { (success, error) in
            result(success)
        })
    }

    /// 保存图片到本地相册
    /// - Parameter image: 图片
    @objc func savePhotoToPhone(result:@escaping (_ success :Bool)->Void){

        self.requestPhotoAuth {_ in
            DispatchQueue.main.async {
                self.save(image: self, result: result)
            }
        }
    }
}




@available(iOS 14, *)
extension HCPicker : PHPickerViewControllerDelegate{
     func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]){
        if results.count == 0{
            // 没有选择任何媒体
            picker.dismiss(animated: true, completion: nil)
        }else{
            // 获取媒体
            guard let pickerResult = results.first?.itemProvider else {
                return
            }
            guard pickerResult.canLoadObject(ofClass: UIImage.self) else {
                return
            }
            // 加载选中的图片
            pickerResult.loadObject(ofClass: UIImage.self) { (image, erro) in
                guard let media  = image as? UIImage else{ return }
                DispatchQueue.main.async {
                    if self.completeBlock != nil{
                        self.completeBlock!(media)
                    }
                    picker.dismiss(animated: true, completion: nil)
                }
            }
        }
        print(results)
    }

}


