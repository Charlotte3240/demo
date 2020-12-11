//
//  HCObjectEx.swift
//  Routerdemo
//
//  Created by Charlotte on 2020/12/8.
//

import UIKit

class HCObjectEx: NSObject {

}

// MARK: - swift 优雅的判断字符串是否是空字符串

extension Optional where Wrapped == String{
    
    /// check String? colleciton is whiteSpace
    var isBlank : Bool{
        return self?.isBlank ?? true
    }
}
extension String{
    /// check String cellection is whiteSpace
    var isBlank : Bool{
        return allSatisfy({$0.isWhitespace})
    }

}

// MARK: - 获取bundleName MoudleName
extension NSObject{
    @objc static func currentMoudleName()->String{
        let object = NSStringFromClass(self) as NSString
        let module = object.components(separatedBy: ".").first!
        return module
    }

    static func bundleName() -> String {

        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return appName
        }
        return ""
    }

}
