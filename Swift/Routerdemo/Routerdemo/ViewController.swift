//
//  ViewController.swift
//  Routerdemo
//
//  Created by Charlotte on 2020/12/7.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        btn.setTitle("test", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(btn)
        btn.center = self.view.center
        btn.addTarget(self, action: #selector(testFunc), for: .touchUpInside)
        
        
        let sel =  #selector(foo(name:))
        print(sel)
        
        
    }
    
    @objc func testFunc(){
        CTMediator.sharedInstance().fool(callback: { (str) in
            print(str)
        })
        
        
    }

    @objc func foo(name:String)->Bool{
     return false
    }

}

