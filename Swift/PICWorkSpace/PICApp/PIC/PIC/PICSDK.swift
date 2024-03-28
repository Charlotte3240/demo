//
//  PICSDK.swift
//  PIC
//
//  Created by 360-jr on 2024/3/28.
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
    
    @objc public func openPIC(urlStr: String, complete: @escaping (_ success: Bool) -> Void){
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


