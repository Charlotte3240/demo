//
//  HClog.swift
//  PIC
//
//  Created by m1 on 2024/4/22.
//

import Foundation

class HClog{
    // 根据是否开启debug 模式再打开控制台log输出
    static func log(_ msg : String){
        if PICSDK.shared.isDebug{
            debugPrint(msg)
        }
    }
}
