//
//  main.swift
//  OSLgger
//
//  Created by 360-jr on 2024/3/21.
//

import Foundation
import OSLog

extension Logger{
    private static var subsystem = Bundle.main.bundleIdentifier ?? ""
    
    static let viewCycle = Logger(subsystem: subsystem, category: "viewCycle")
    
    static let statistics = Logger(subsystem: subsystem, category: "statistics")

}



Logger.viewCycle.info("hello world")

// 添加对齐
let maxMessageLengh = 15
Logger.statistics.info("\("dasdas") \("dsadasdas",align: .left(columns: maxMessageLengh)) \("dsadsadsadas")")
Logger.statistics.info("\("dasdas") \("dsadas1122das",align: .left(columns: maxMessageLengh)) \("dsadsadsadas")")

// 显示两位小数
Logger.statistics.info("\("dasdas") \("dsadas1122das",align: .left(columns: maxMessageLengh)) \(3.1415926,format: .fixed(precision: 2))")
