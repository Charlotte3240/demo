//
//  ViewController.swift
//  Setting
//
//  Created by 刘春奇 on 2018/8/20.
//  Copyright © 2018年 Cloudnapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //key  is  the  Identifier
        print(UserDefaults.standard.object(forKey: "name_preference") as? String ?? "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

