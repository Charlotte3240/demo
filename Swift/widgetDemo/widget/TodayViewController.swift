//
//  TodayViewController.swift
//  widget
//
//  Created by 刘春奇 on 2016/11/14.
//  Copyright © 2016年 刘春奇. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //通过userdefault 共享数据
//        self.actionLabel.text = UserDefaults.init(suiteName: "group.com.chunqi.widgetDemo")?.object(forKey: "widgetString") as! String?
        
        //通过filemanager 共享数据
        self.actionLabel.text = self.shareDataByFileManager()
        
        
        if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)) {
            //在ios10 中支持折叠
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        }
        
        self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
    
        self.actionButton.addTarget(self, action: #selector(openButtonPressed), for: UIControlEvents.touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    //折叠change size
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        print("maxWidth %f maxHeight %f",maxSize.width,maxSize.height)
        
        if activeDisplayMode == NCWidgetDisplayMode.compact {
            self.preferredContentSize = CGSize(width:maxSize.width,height: 110);
        }else{
            self.preferredContentSize = CGSize(width: maxSize.width,height: 200);
        }

    }
    
    func openButtonPressed() -> Void {
        let url : URL = URL.init(string: "widgetDemo://red")!
        self.extensionContext?.open(url, completionHandler: {(isSucces) in
            print("点击了红色按钮，来唤醒APP，是否成功 : \(isSucces)")
        })
        
    }

    func shareDataByFileManager() -> String {
        var url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.chunqi.widgetDemo")
        url = url?.appendingPathComponent("Library/Caches/widget", isDirectory: true)
        var str = ""
        
        do {
            str =  try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
        } catch let error {
            print(error)
        }
        
        return str
        
    }
    
}
