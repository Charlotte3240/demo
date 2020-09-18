//
//  ViewController.swift
//  Responder
//
//  Created by Charlotte on 2020/9/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        let scrollView = DemoScrollview()
        
        scrollView.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 300)
        scrollView.backgroundColor = UIColor.red
        self.view.addSubview(scrollView)
        
        
        let button = DemoBtn(type: .system)
        
        button.setTitle("button", for: .normal)
        
        button.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        
        button.center = CGPoint.init(x: self.view.center.x, y: scrollView.bounds.size.height)
        
        button.backgroundColor = UIColor.yellow
        
        scrollView.addSubview(button)
        
        
        
    }
    
    
    


}

