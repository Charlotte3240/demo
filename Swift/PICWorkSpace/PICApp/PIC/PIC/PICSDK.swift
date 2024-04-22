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
    
    var key : String? // aes key
    var secret : String? // user secret
    var token : String? // token = base64(key + secret)
    var platFormId : Int? // 平台ID
    
    @objc public func openPIC(urlStr: String, key: String, secret:String, id: Int, complete: @escaping (_ success: Bool) -> Void){
        /*
         * url: 平台URL
         * key: 就是base64 那一串
         * secret: ase加密密钥
         * id: 平台id
         */
        
        guard let data = "\(key):\(secret)".data(using: .utf8) else{
            debugPrint("base64 encode fail")
            complete(false)
            return
        }
        let token = data.base64EncodedString()
        
        self.token = token
        self.key = key
        self.secret = secret
        self.platFormId = id

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


