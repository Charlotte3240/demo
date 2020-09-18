//
//  ViewController.swift
//  widgetDemo
//
//  Created by 刘春奇 on 2016/11/14.
//  Copyright © 2016年 刘春奇. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var save: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveAction(_ sender: AnyObject) {
        //通过userdefault 共享数据
//        let userDefault = UserDefaults.init(suiteName: "group.com.chunqi.widgetDemo")
//            userDefault?.set(textField.text, forKey: "widgetString")
//            userDefault?.synchronize()
        //通过filemanager 共享数据
        self.shareDataByFileManger()
    }
    
    
    func shareDataByFileManger() -> Void {
        var url : URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.chunqi.widgetDemo")!
        url = url.appendingPathComponent("Library/Caches/widget", isDirectory: true)
        let str : String? = self.textField.text
        
        do{
            _ = try str?.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        } catch let error {
            print(error)
        }
        
        
    }

}

