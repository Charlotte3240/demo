//
//  DeviceInfo.swift
//  CrashCollect
//
//  Created by Charlotte on 2021/4/10.
//

import Foundation
import SystemConfiguration
@objc class DeviceInfo: NSObject {
    
    @objc static func getDeviceInfo() -> String{
        return DeviceInfo.getName()
    }
    
    static func getName() -> String{
        var systemInfo = utsname()

        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)

        let identifier = machineMirror.children.reduce("") { identifier, element in

            guard let value = element.value as? Int8, value != 0 else{ return identifier }

            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return DeviceInfo.matchPhoneName(iden: identifier)
    }
    
    static func matchPhoneName(iden : String?) -> String{
        guard iden != nil ,iden?.isEmpty == false else {
            return "unknown"
        }
        if iden == "iPhone3,1"    { return "iPhone 4" }
        if iden == "iPhone3,2"    { return "iPhone 4" }
        if iden == "iPhone3,3"    { return "iPhone 4" }
        if iden == "iPhone4,1"    { return "iPhone 4S" }
        if iden == "iPhone5,1"    { return "iPhone 5" }
        if iden == "iPhone5,2"    { return "iPhone 5 (GSM+CDMA)" }
        if iden == "iPhone5,3"    { return "iPhone 5c (GSM)" }
        if iden == "iPhone5,4"    { return "iPhone 5c (GSM+CDMA)" }
        if iden == "iPhone6,1"    { return "iPhone 5s (GSM)" }
        if iden == "iPhone6,2"    { return "iPhone 5s (GSM+CDMA)" }
        if iden == "iPhone7,1"    { return "iPhone 6 Plus" }
        if iden == "iPhone7,2"    { return "iPhone 6" }
        if iden == "iPhone8,1"    { return "iPhone 6s" }
        if iden == "iPhone8,2"    { return "iPhone 6s Plus" }
        if iden == "iPhone8,4"    { return "iPhone SE" }
        // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
        if iden == "iPhone9,1"    { return "iPhone 7" }
        if iden == "iPhone9,2"    { return "iPhone 7 Plus" }
        if iden == "iPhone9,3"    { return "iPhone 7" }
        if iden == "iPhone9,4"    { return "iPhone 7 Plus" }
        if iden == "iPhone10,1"   { return "iPhone_8" }
        if iden == "iPhone10,4"   { return "iPhone_8" }
        if iden == "iPhone10,2"   { return "iPhone_8_Plus" }
        if iden == "iPhone10,5"   { return "iPhone_8_Plus" }
        if iden == "iPhone10,3"   { return "iPhone X" }
        if iden == "iPhone10,6"   { return "iPhone X" }
        if iden == "iPhone11,8"   { return "iPhone XR" }
        if iden == "iPhone11,2"   { return "iPhone XS" }
        if iden == "iPhone11,6"   { return "iPhone XS Max" }
        if iden == "iPhone11,4"   { return "iPhone XS Max" }
        if iden == "iPhone12,1"   { return "iPhone 11" }
        if iden == "iPhone12,3"   { return "iPhone 11 Pro" }
        if iden == "iPhone12,5"   { return "iPhone 11 Pro Max" }
        if iden == "iPhone12,8"   { return "iPhone SE2" }
        if iden == "iPhone13,1"   { return "iPhone 12 mini" }
        if iden == "iPhone13,2"   { return "iPhone 12" }
        if iden == "iPhone13,3"   { return "iPhone 12 Pro" }
        if iden == "iPhone13,4"   { return "iPhone 12 Pro Max" }
        if iden == "iPod1,1"      { return "iPod Touch 1G" }
        if iden == "iPod2,1"      { return "iPod Touch 2G" }
        if iden == "iPod3,1"      { return "iPod Touch 3G" }
        if iden == "iPod4,1"      { return "iPod Touch 4G" }
        if iden == "iPod5,1"      { return "iPod Touch (5 Gen)" }
        if iden == "iPad1,1"      { return "iPad" }
        if iden == "iPad1,2"      { return "iPad 3G" }
        if iden == "iPad2,1"      { return "iPad 2 (WiFi)" }
        if iden == "iPad2,2"      { return "iPad 2" }
        if iden == "iPad2,3"      { return "iPad 2 (CDMA)" }
        if iden == "iPad2,4"      { return "iPad 2" }
        if iden == "iPad2,5"      { return "iPad Mini (WiFi)" }
        if iden == "iPad2,6"      { return "iPad Mini" }
        if iden == "iPad2,7"      { return "iPad Mini (GSM+CDMA)" }
        if iden == "iPad3,1"      { return "iPad 3 (WiFi)" }
        if iden == "iPad3,2"      { return "iPad 3 (GSM+CDMA)" }
        if iden == "iPad3,3"      { return "iPad 3" }
        if iden == "iPad3,4"      { return "iPad 4 (WiFi)" }
        if iden == "iPad3,5"      { return "iPad 4" }
        if iden == "iPad3,6"      { return "iPad 4 (GSM+CDMA)" }
        if iden == "iPad4,1"      { return "iPad Air (WiFi)" }
        if iden == "iPad4,2"      { return "iPad Air (Cellular)" }
        if iden == "iPad4,4"      { return "iPad Mini 2 (WiFi)" }
        if iden == "iPad4,5"      { return "iPad Mini 2 (Cellular)" }
        if iden == "iPad4,6"      { return "iPad Mini 2" }
        if iden == "iPad4,7"      { return "iPad Mini 3" }
        if iden == "iPad4,8"      { return "iPad Mini 3" }
        if iden == "iPad4,9"      { return "iPad Mini 3" }
        if iden == "iPad5,1"      { return "iPad Mini 4 (WiFi)" }
        if iden == "iPad5,2"      { return "iPad Mini 4 (LTE)" }
        if iden == "iPad5,3"      { return "iPad Air 2" }
        if iden == "iPad5,4"      { return "iPad Air 2" }
        if iden == "iPad6,3"      { return "iPad Pro 9.7" }
        if iden == "iPad6,4"      { return "iPad Pro 9.7" }
        if iden == "iPad6,7"      { return "iPad Pro 12.9" }
        if iden == "iPad6,8"      { return "iPad Pro 12.9" }

        if iden == "AppleTV2,1"      { return "Apple TV 2" }
        if iden == "AppleTV3,1"      { return "Apple TV 3" }
        if iden == "AppleTV3,2"      { return "Apple TV 3" }
        if iden == "AppleTV5,3"      { return "Apple TV 4" }

        if iden == "i386"         { return "Simulator" }
        if iden == "x86_64"       { return "Simulator" }



        return "unknown"
        
    }
    
}
