//
//  ViewController.swift
//  localAuth_TouchId
//
//  Created by 刘春奇 on 2016/11/23.
//  Copyright © 2016年 刘春奇. All rights reserved.
//

import UIKit
import LocalAuthentication
extension String {
    var toInt:Int{
        return NumberFormatter().number(from: self)!.intValue
    }
    var toFloat:Float{
        return NumberFormatter().number(from: self)!.floatValue
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let version = Bundle.main.infoDictionary?["DTPlatformVersion"] as? String{
            if version.toFloat >= 8.0 {
                self.localAuth()
            }
        }
        
    }
    
    func localAuth() -> Void {
        let context = LAContext()
        var error :NSError? = nil
        let response = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) as Bool
        if error != nil {
            print((error?.localizedDescription)! as String)
        }
        if response {
            print("能够响应指纹识别")
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "放上您的猪爪", reply: { (success : Bool, error: Error?) in
                if success{
                    print("验证指纹成功")
                }else{
                    print("验证失败")
                }
            })
        }else{
                print("没有指纹功能或者未开启指纹功能")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

