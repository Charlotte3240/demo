//
//  HCTool.swift
//  PIC
//
//  Created by 360-jr on 2024/4/22.
//

import Foundation
import UIKit

class HCTool{
    /// 获取手机型号
    class func getDeiveName() -> String{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machine = Mirror(reflecting: systemInfo.machine).children.reduce("") { iden, ele in
            guard let value = ele.value as? Int8, value != 0 else{
                return iden
            }
            return iden + String(UnicodeScalar(UInt8(value)))
        }
        
//        return HCEncrypt.encrypt(source: machine)
        return machine
    }
    
    /// 获取系统版本
    class func getOsVersion() -> String{
        return UIDevice.current.systemVersion//HCEncrypt.encrypt(source: UIDevice.current.systemVersion)
    }
    /// 获取app bundleid
    class func getMainBundleId() -> String{
        guard let infoDic = Bundle.main.infoDictionary, let bundleId = infoDic["CFBundleIdentifier"] as? String else {
            return ""
        }
//        return HCEncrypt.encrypt(source: bundleId)
        return bundleId
    }
}
