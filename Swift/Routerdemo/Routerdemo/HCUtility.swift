//
//  HCUtility.swift
//  TongdaoApp
//
//  Created by Charlotte on 2020/9/1.
//  Copyright © 2020 HK. All rights reserved.
//

import UIKit
import WebKit
class HCUtility: NSObject {
    
    static let shared = HCUtility()
        
    @available(iOS 14, *)    
    lazy var picker: HCPicker = {
        return HCPicker()
    }()
    
    
    @objc static func base64UrlToBase64(str : String) -> String{
        str.base64urlToBase64(base64url: str)
    }
    
    
    
    /// 用于OC调用 此方法桥接了一下swift extension
    /// - Parameter str: 需要urlencode的字符串
    /// - Returns: urlencode的字符串
    @objc static func urlencode(str: String) -> String{
        str.URLEncode() ?? ""
    }
    
    
    /// 获取当前环境
    /// - Returns: UAT : false , PDT : true
    @objc static func getAppEnv() -> Bool{
        return UserDefaults.standard.bool(forKey: "AppEnvironment")
    }
    
    /// 设置环境变量
    /// - Parameter pdt: true : PDT , false : UAT
    @objc static func setAppEnv(pdt : Bool){
        UserDefaults.standard.setValue(pdt, forKey: "AppEnvironment")
        if pdt == false {
//            UserDefaults.standard.setValue("http://192.168.1.111:8080/", forKey: "serverip")

            UserDefaults.standard.setValue("https://td-sit.ta-by.com/", forKey: "serverip")
        }
    }
    
    
    /// 获取serverip
    /// - Returns: 正式环境或sit环境absoluteurl
    @objc static func getBaseUrl()->String{
        guard let serverUrlStr = UserDefaults.standard.string(forKey: "serverip") else {
            return ""
        }
        return serverUrlStr
    }
    
    /// 推送token
    /// - Parameter deviceToken: 推送token data类型
    /// - Returns: string 类型 token
    @objc func getDeviceTokenString(deviceToken : Data) -> String{
        return deviceToken.convertToken()
    }
       


    
    
    /// 选择图片从相册中，不管有没有给图片权限都可以获取用户选择的图片，只在iOS14以上有效，iOS14以下使用老方法
    /// - Parameter complete: 选择的图片
    @objc static func getImageFromPhoto(complete: @escaping (_ image : UIImage) -> Void){
        if #available(iOS 14, *) {
            
            HCUtility.shared.picker.getImagesAction { (image) in
                complete(image)
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    deinit {
        print("hcutitly deinit")
    }

}



extension WKWebView{
    /// 清理wkwebview 缓存 目前策略是webvc dealloc 就会清理缓存
    /// 但是 indexDB 和 localstorage 不清理
    @objc static func clearCache(){
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies{
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
        
        
        let cahce = URLCache.shared
        cahce.removeAllCachedResponses()
        cahce.diskCapacity = 0
        cahce.memoryCapacity = 0
        
        var dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        
        //留下localstorage
        dataTypes = dataTypes.filter({
            if $0 == "WKWebsiteDataTypeIndexedDBDatabases" || $0 == "WKWebsiteDataTypeLocalStorage"{
                return false
            }else{
                return true
            }
        })
        
        let date = Date.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: date) {}

    }
    
    /// 清理全部的web 缓存 目前应用在设置页面
    @objc static func clearAllWebCache(){
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies{
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
        
        let cahce = URLCache.shared
        cahce.removeAllCachedResponses()
        cahce.diskCapacity = 0
        cahce.memoryCapacity = 0
        
        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: date) {}
        
        // 释放共享的processpool
//        if #available(iOS 10.0, *) {
//            let appdelegate =  UIApplication.shared.delegate as? AppDelegate
//            appdelegate?.freeOldPool()
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
}





extension Data{
    
    /// 用来转换 新系统版本的推送devicetoken
    /// - Returns: 字符串token
    func convertToken() -> String{
        let token = self.reduce("", {$0 + String(format: "%02X", $1)})
        return token
    }
}


extension String{
    
    /// 用来转换url中带的参数，urlstring -> dictionary
    /// - Returns: 字典类型 [string : any]
    func toDic() -> [String :Any]{
        let parmas =  self.components(separatedBy: "?").last?.components(separatedBy: "&")
        var openParmas = [String:Any]()
        for item in parmas ?? [String]() {
            let items = item.components(separatedBy: "=")
            openParmas["\(items.first ?? "")"] = "\(items.last ?? "")"
        }
        return openParmas
    }
    
    func base64urlToBase64(base64url: String) -> String {
        var base64 = base64url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        return base64
    }
    
    func base64ToBase64url(base64: String) -> String {
        let base64url = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }

}


extension String {
    // URL Decode
    func URLDecode() -> String? {
        return self.removingPercentEncoding
    }
    
    // URL Encode
    func URLEncode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet(charactersIn: "!*'\"();:@&=+$,/?%#[]% ").inverted) // `CFURLCreateStringByAddingPercentEscapes` is deprecated
    }
}
