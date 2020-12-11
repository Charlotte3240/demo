//
//  HCLocalAuth.swift
//  VerifyTouchID&FaceID
//
//  Created by Charlotte on 2020/11/5.
//

import Foundation
import LocalAuthentication

struct HCLocalAuth {
    
    
    /// shared instance
    static var shared = HCLocalAuth()

    
    /// touch id description string
    static let TouchIDDesc = "TouchID"
    
    /// face id description string
    static let FaceIDDesc = "FaceID"
    
    
    /// 开启状态 false 未开启  true 开启
    var openState :Bool {
        set{
            UserDefaults.standard.setValue(newValue, forKey: "HCLocalAuthState")
        }
        get{
            UserDefaults.standard.bool(forKey: "HCLocalAuthState")
        }
    }
    
    
    // global objc
    var context = LAContext()
    
    
    // LATouchIDAuthenticationMaximumAllowableReuseDuration
    var reuseDuration : TimeInterval = 0
    
    
    /// 验证touchid时
    var reasonString : String = ""
    
    var fallbackString  : String = ""
    
    /// 是否可以用于生物验证（touchID faceID）
    /// - Returns: 返回bool 结果
    func canLocalAuth() -> Bool{
        var error : NSError?
        let result = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error != nil{
            let reason = HCLocalAuth.resolveError(error: error as! NSError)
            print(reason)
        }
        
        return result
    }
    
    /// check local auth type
    /// why not use enum, because oc use code
    /// - Returns: if faceID return true , touchId return false
    func localAuthType() -> Bool {
        return context.biometricType == .faceID
    }
    
    
    /// close touch / face ID check
    func logoutLocalAuth(){
        HCLocalAuth.shared.openState = false
    }
    
    
    /// local auth type local description
    /// - Returns: display label content
    func localAuthTypeDescription() -> String{
        localAuthType() ? HCLocalAuth.FaceIDDesc : HCLocalAuth.TouchIDDesc
    }
    
    
    mutating func localAuth(result :@escaping(( _ error : Error?) -> Void) ,reason : String){
        
        self.context = LAContext()
        
        context.localizedFallbackTitle = self.fallbackString
        
        if #available(iOS 10.0, *) {
//            context.localizedCancelTitle = cancelString
        }
        
        context.touchIDAuthenticationAllowableReuseDuration = reuseDuration
        
        var error : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, err) in
                if err != nil{
                    let errReason =  HCLocalAuth.resolveError(error: err! as NSError)
                    print(errReason)
                }else{
                    // success
                    HCLocalAuth.shared.openState = true
                }

                DispatchQueue.main.async {
                    // call back
                    result(err)
                }
            }

        }else{
            // 不支持生物识别
            print("不能进行生物验证\(error?.localizedDescription ?? "验证失败")")
//            DispatchQueue.main.async {
                let errorReason = HCLocalAuth.resolveError(error: error!)
                print(errorReason)
//            }
        }
        
    }
    
    
    /// 处理失败
    /// - Parameter error: 传入NSerror
    /// - Returns: 失败原因
    static func resolveError(error : NSError) -> String{
        var errorReason = ""
        
        switch Int32(error.code) {
        case kLAErrorPasscodeNotSet:
            errorReason = "用户没有设置密码"
        case kLAErrorUserCancel://取消生物识别
            errorReason = "其他验证方式"
        case kLAErrorTouchIDNotAvailable:
            errorReason = "没有授权\(HCLocalAuth.shared.localAuthTypeDescription())验证在此APP，请到设置中打开。"
        case kLAErrorTouchIDNotEnrolled:
            errorReason = "设备中没有人脸。请转到设备设置->\(HCLocalAuth.shared.localAuthTypeDescription())和密码并注册您的人脸。"
            // 尝试跳转到系统 设置页面
        case kLAErrorBiometryLockout:
            errorReason = "由于失败尝试过多，\(HCLocalAuth.shared.localAuthTypeDescription())已被锁定。输入密码以解锁。"
            // 尝试跳转到APP 设置页面
        default:
            errorReason = "无法识别。请使用已注册的\(HCLocalAuth.shared.localAuthTypeDescription())再试一次。"
        }
        return errorReason
    }
    
}


extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Capture these recoverable error through fabric
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        }

        return self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
}
