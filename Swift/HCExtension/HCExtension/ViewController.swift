//
//  ViewController.swift
//  HCExtension
//
//  Created by 360-jr on 2024/11/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        let color = UIColor.red.hc.hexValue()
        debugPrint(color)
        
        var str: String? = "dsad"
        debugPrint(str?.hc.isBlank)
        
        let str2 = "hello"
        debugPrint(str2.hc.isBlank)
        
        let dic: [AnyHashable: Any] = ["msg":"ok", "code": 200, "flag": false]
        dic.hc.printAllPairs()
        let dictionary: Dictionary<String, Int> = ["key1": 1, "key2": 2]
        dictionary.hc.printAllPairs()
        
    }


}

