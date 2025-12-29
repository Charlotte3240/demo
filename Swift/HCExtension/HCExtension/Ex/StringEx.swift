//
//  StringEx.swift
//  HCExtension
//
//  Created by 360-jr on 2024/11/11.
//

import Foundation

extension String: HCExtension{}

extension Optional where Wrapped == String{
    var isBlank : Bool{
        return self?.hc.isBlank ?? true
    }
}


extension HCHelper where Base == String{
    /// check string cellection is whiteSpace
    var isBlank : Bool{
        return self.base.allSatisfy({$0.isWhitespace})
    }
    
    
    /// json字符串转字典
    /// - Returns: 字典
    func toDictionary() -> [String : Any]? {
        
        var result : [String : Any]?
        guard !self.base.isEmpty else { return result }
        
        guard let dataSelf = self.base.data(using: .utf8) else {
            return result
        }
        
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf,
                           options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
    
    }
    
    /// 获取Base URL
    /// - Returns: 返回 scheme + host + port
    func getBaseUrlStr() -> String?{
        guard let url = URL(string: self.base) else{
            return nil
        }
        let path = url.path
        let baseUrlStr = self.base.prefix(self.base.lengthOfBytes(using: .utf8) - path.lengthOfBytes(using: .utf8))
        return "\(baseUrlStr)"
    }

    
}
