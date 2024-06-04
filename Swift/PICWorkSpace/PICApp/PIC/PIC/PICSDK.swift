//
//  PICSDK.swift
//  PIC
//
//  Created by m1 on 2024/3/28.
//

import Foundation
import UIKit

@objc public protocol PICSDKDelegate : NSObjectProtocol{
    
    /// 执行过程回调
    /// - Parameter next: 回调参数
    func onNext(msg: String)
    
    /// 错误回调
    /// - Parameter err: 错误参数
    func onError(msg: String)
    
    /// 结果回调
    /// - Parameter ret: 结果参数
    func onResult(msg: String, data: String?)
}



public class PICSDK: NSObject{
    @objc public static let shared = PICSDK()
    @objc public var delegate : PICSDKDelegate?
    
    var isDebug = false
    
    var key : String? // aes key
    var secret : String? // user secret
    
    var serviceUrl : String?
    
    var token : String? // token = base64(key + secret)
    var platFormId : Int? // 平台ID
    var platFormName : String? // 平台名称
    var params = [String: Any]()
    
    var platFormList = [PlatForm]()
    
    
    @objc public func fetchPlatForm(urlStr: String, key: String, secret: String, complete: @escaping (_ list: [PlatForm]?, _ err: String) -> Void){
        /*
         * urlStr: 平台URL的前半部分
         * key: 就是base64 那一串
         * secret: ase加密密钥
         * id: 平台id
         */
        let fetchUrlStr = urlStr + "/api/platform/list"
        let user = #"\#(key):\#(secret)"#
        guard let data = user.data(using: .utf8) else{
            complete(nil, "key or secret wrong")
            return
        }
        let base64Str = data.base64EncodedString()
        
        guard let url = URL(string: fetchUrlStr) else{
            complete(nil, "fetch platform url wrong")
            return
        }
        var request = URLRequest(url: url,timeoutInterval: 30)
        request.addValue("Basic \(base64Str)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                complete(nil, "fetch platform data fail: \(error?.localizedDescription ?? "")")
                return
            }
            do {
                let model = try JSONDecoder().decode(FetchPlatform.self, from: data)
                self.platFormList = model.Data.List
                self.serviceUrl = urlStr
                complete(model.Data.List, "")
            } catch let error {
                complete(nil, "fetch platform unmarshal response fail: \(error.localizedDescription)")
            }
            
        }

        task.resume()
        
    }
    
    @objc public func openPIC(urlStr: String, key: String, secret:String, id: Int, parmas: [String: Any], complete: @escaping (_ success: Bool) -> Void){
        /*
         * urlStr: 平台URL
         * key: 就是base64 那一串
         * secret: ase加密密钥
         * id: 平台id
         */
        
        guard let data = "\(key):\(secret)".data(using: .utf8) else{
            HClog.log("base64 encode fail")
            complete(false)
            return
        }
        let token = data.base64EncodedString()
        
        self.token = token
        self.key = key
        self.secret = secret
        self.platFormId = id
        self.platFormName = self.platFormList.filter({$0.id == self.platFormId}).first?.title
        self.params = parmas
        if parmas["IsCache"] as? Bool == nil{
            self.params["IsCache"] = false
        }
        if parmas["IsLogout"] as? Bool == nil{
            self.params["IsLogout"] = true
        }
        if parmas["TimeOut"] as? Int == nil{
            self.params["TimeOut"] = 60
        }

        guard URL.init(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") != nil else {
            PICSDK.shared.onError(err: #"WebView > start > platform url formatter wrong"#)
            complete(false)
            return
        }
        
        self.serviceUrl = urlStr
        
        let wkVc = PICWKWebViewController()
        let nav = UINavigationController(rootViewController: wkVc)
        nav.modalPresentationStyle = .fullScreen
        UIViewController.current()?.present(nav, animated: true)
        complete(true)
    }
    
    
    func onError(err: String){
        if let delegate = PICSDK.shared.delegate, delegate.responds(to: #selector(delegate.onError(msg:))){
            delegate.onError(msg: err)
        }
    }
    
    func onNext(next: String){
        if let delegate = PICSDK.shared.delegate, delegate.responds(to: #selector(delegate.onNext(msg:))){
            delegate.onNext(msg: next)
        }
    }
    
    func onResult(msg : String, data: String?){
        if let delegate = PICSDK.shared.delegate, delegate.responds(to: #selector(delegate.onResult(msg:data:))){
            delegate.onResult(msg: msg, data: data)
        }
    }
    
    
    
}


