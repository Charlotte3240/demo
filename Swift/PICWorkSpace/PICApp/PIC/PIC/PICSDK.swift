//
//  PICSDK.swift
//  PIC
//
//  Created by m1 on 2024/3/28.
//

import Foundation
import UIKit

@objc public protocol PICSDKDelegate : NSObjectProtocol{
    func onNext(next: String)
    func onError(err: String)
}



public class PICSDK: NSObject{
    @objc public static let shared = PICSDK()
    @objc public var delegate : PICSDKDelegate?
    
    @objc public func openPIC(urlStr: String, key: String, secret:String, id: String, complete: @escaping (_ success: Bool) -> Void){
        /*
         * url: 平台URL
         * key: 就是base64 那一串
         * secret: ase加密密钥
         * id: 平台id
         */
        debugPrint("加密测试:",HCEncrypt.encrypt(source: "Hellow word"))
        debugPrint("解密测试:",HCEncrypt.decrypt(source: "46lOTeU+zB6IQQ598UiLktNByITvzGihIl5UlyPUfNE="))
        

        complete(false)
        return
        
        guard URL.init(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") != nil else {
            PICSDK.shared.onError(err: "传入URL格式错误")
            complete(false)
            return
        }
        let wkVc = PICWKWebViewController()
        wkVc.modalPresentationStyle = .fullScreen
        wkVc.webUrl = urlStr
        UIViewController.current()?.present(wkVc, animated: true)
        complete(true)
    }
    
    
    func onError(err: String){
        self.delegate?.onError(err: err)
    }
    
    func onNext(next: String){
        self.delegate?.onNext(next: next)
    }
    
    
    
}


