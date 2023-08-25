//
//  LoggerFormatter.swift
//  HCLog
//
//  Created by Charlotte on 2021/11/9.
//

import Foundation
import CocoaLumberjack.DDDispatchQueueLogFormatter

class FileLogForamatter : DDDispatchQueueLogFormatter{
    let dateFormatter :DateFormatter
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.formatterBehavior = .behavior10_4
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssSSSZZZZZ"
        super.init()
        
    }
    
    override func format(message logMessage: DDLogMessage) -> String? {
        let dateAndTime = dateFormatter.string(from: logMessage.timestamp)
        let levelPrefix = LoggerFormatter.genPrefix(level: logMessage.flag)
        return "\(dateAndTime) [\(logMessage.fileName):\(logMessage.function ?? ""):\(logMessage.line)] \(levelPrefix): \(logMessage .message)"
    }
}

class OSLogForamatter : DDDispatchQueueLogFormatter{
    override init() {
        super.init()
    }
    
    override func format(message logMessage: DDLogMessage) -> String? {
        let levelPrefix = LoggerFormatter.genPrefix(level: logMessage.flag)
        return "[\(logMessage.fileName):\(logMessage.function ?? ""):\(logMessage.line)] \(levelPrefix): \(logMessage .message)"
    }
    
}

fileprivate class LoggerFormatter{
    class func genPrefix(level : DDLogFlag) -> String{
        var prefix = ""
        switch level{
        case.info:
            prefix = "INFO    [x]"
        case .warning:
            prefix = "WARNING [x]"
        case .debug:
            prefix = "DEBUG   [x]"
        case .error:
            prefix = "ERROR   [x]"
        default:
            prefix = "UNKOWN  [x]"
        }
        return prefix
    }

}
