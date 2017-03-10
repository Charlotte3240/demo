//
//  ViewController.swift
//  demo
//
//  Created by 刘春奇 on 2016/10/19.
//  Copyright © 2016年 刘春奇. All rights reserved.
//

import UIKit
import CABasicProximityKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CABasicProximityManager .shared().addMonitoredBeacon("dsa")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

