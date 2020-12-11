//
//  ViewController.swift
//  VerifyTouchID&FaceID
//
//  Created by Charlotte on 2020/11/5.
//

import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var authStateLabel: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 检查是否可以用生物验证 
        let canAuth = HCLocalAuth.shared.canLocalAuth()
        
        print("是否可以用于生物验证\(canAuth)")
        
        if canAuth{
            let authType = HCLocalAuth.shared.localAuthType() ? "face id":"touch id"
            self.authStateLabel.text = authType + (HCLocalAuth.shared.openState ? "开启状态" : "关闭状态")
        }else{
            
        }
        
        
    }

    @IBAction func verifyAction(_ sender: Any) {
        HCLocalAuth.shared.localAuth(result: { (error ) in
            if error == nil{
                // 验证成功
            }else{
                // 验证失败
                print("验证失败\(String(describing: error))")
            }
        }, reason: "需要验证识别")
    }
    
}

