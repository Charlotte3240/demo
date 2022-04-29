//
//  SDKInfo.swift
//  CrashCollect
//
//  Created by Charlotte on 2021/4/10.
//

import Foundation
@objc class SDKInfo :NSObject {
    @objc static func getSDKinfo() -> String{
        let infoDic = Bundle.main.infoDictionary
        let majorVersion = infoDic?["CFBundleShortVersionString"] as? String ?? ""
        let minorVersion = infoDic?["CFBundleVersion"] as? String ?? ""
        
        return "\(majorVersion) \(minorVersion)"
    }
}
