//
//  HCUIExtension.swift
//  TongdaoApp
//
//  Created by Charlotte on 2020/8/27.
//  Copyright © 2020 HK. All rights reserved.
//

import UIKit

class HCCallTool: NSObject {
    
    /// 拨打客服电话
    @objc public func call(number: String?){
        
        guard let number = number , number.isBlank == false else {
            return
        }
        let serviceNum = "telprompt://\(number)"
        
        guard let url = URL.init(string: serviceNum) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (res) in
                print("拨打电话成功\(res)")
            }
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    


}











