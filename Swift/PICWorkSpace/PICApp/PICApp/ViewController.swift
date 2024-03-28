//
//  ViewController.swift
//  PICApp
//
//  Created by 360-jr on 2024/3/28.
//

import UIKit
import PIC


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        btn.setTitle("打开SDK", for: .normal)
        btn.addTarget(self, action: #selector(openSDK), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.center = self.view.center

        
    }

    
    @objc func openSDK(){
        PICSDK.shared.openPIC(urlStr: "https://www.baidu.com") { success in
            debugPrint("open success \(success)")
        }
    }

}

