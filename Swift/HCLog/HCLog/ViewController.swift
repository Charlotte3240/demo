//
//  ViewController.swift
//  HCLog
//
//  Created by Charlotte on 2021/11/9.
//

import UIKit
import CocoaLumberjack

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLogComponent()
        
        DDLogDebug("this is debug message",level: .debug)
        DDLogInfo("this is info message",level: .info)
        DDLogWarn("this is warning message",level: .warning)
        DDLogError("this is error message",level: .error)

    }
    /// 获取所有日志文件路径
    /// - Returns: 路径数组，时间倒序排列
    func getLogFiles() -> [String]?{
        if let fileLogger = DDLog.sharedInstance.allLoggers.filter({$0.isMember(of: DDFileLogger.self)}).last as? DDFileLogger{
            return fileLogger.logFileManager.sortedLogFilePaths
        }else{
            return nil
        }
    }

    /// 初始化 log 组件
    func initLogComponent(){
        // 写入文件
        let fileLogger : DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24小时 滚动频率
        fileLogger.maximumFileSize = 1024 * 10 // 10kb大小 滚动
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7 // 保存7个文件
        fileLogger.logFormatter = FileLogForamatter()
        DDLog.add(fileLogger)
        
        
        // 输出到命令行
        if #available(iOS 10.0, *) {
            DDOSLogger.sharedInstance.logFormatter = OSLogForamatter()
            DDLog.add(DDOSLogger.sharedInstance)
        } else {
            // Fallback on earlier versions
        }
        
    }

    /// 上传日志文件
    func uploadLogFiles(){
        // 默认上传所有，递归查询上传
        // 上传成功后删除这项日志
    }

    /// 删除日志文件
    func delLogFiles(path : String){
        
    }


    
   
    
    
}
