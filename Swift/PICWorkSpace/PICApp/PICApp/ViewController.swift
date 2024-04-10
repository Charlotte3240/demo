//
//  ViewController.swift
//  PICApp
//
//  Created by 360-jr on 2024/3/28.
//

import UIKit
import PIC

enum SDKUrl : String{
    case gjj = "https://igjj.ccb.com/qgzfgjj/login"
    case tax = "https://www.etax.chinatax.gov.cn"
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        
    }
    @IBAction func gjjAction(_ sender: Any) {
        openSDK(url: .gjj)
    }
    
    
    @IBAction func grsdsAction(_ sender: Any) {
        openSDK(url: .tax)
    }
    
    
    func openSDK(url: SDKUrl){
        PICSDK.shared.openPIC(urlStr: url.rawValue) { success in
            debugPrint("open success \(success)")
        }
    }

}
