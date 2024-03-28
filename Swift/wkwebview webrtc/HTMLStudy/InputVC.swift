//
//  InputVC.swift
//  HTMLStudy
//
//  Created by 刘春奇 on 2021/4/1.
//  Copyright © 2021 charlotte. All rights reserved.
//

import UIKit

class InputVC: UIViewController {
    
    
    var inputTxt : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let urlTextFiled = UITextField.init(frame: CGRect(x: 20, y: 0, width: self.view.bounds.size.width-20, height: 50))
        urlTextFiled.clearButtonMode = .always
        urlTextFiled.borderStyle = .roundedRect
        urlTextFiled.placeholder = "url"
        self.view.addSubview(urlTextFiled)
        urlTextFiled.center = self.view.center
        self.inputTxt = urlTextFiled
        
        
        
        let btn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        self.view.addSubview(btn)
        btn.setTitle("跳转", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y + 50)
        
        btn.addTarget(self, action: #selector(toWEB), for: .touchUpInside)
        

//        urlTextFiled.text = "https://appr.tc/"
        urlTextFiled.text = "https://support-uat.360-jr.com/360jr-callcenter/jssip-demo.html"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputTxt?.resignFirstResponder()
    }
    
    
    @objc func toWEB() {
        self.inputTxt?.resignFirstResponder()

        let web = WKWebViewController()
        web.inputUrl = self.inputTxt?.text ?? ""
        
        self.navigationController?.pushViewController(web, animated: true)
    }
}
