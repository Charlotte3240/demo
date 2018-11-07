//
//  ViewController.swift
//  HCTreeTableView
//
//  Created by 刘春奇 on 2018/6/9.
//  Copyright © 2018年 Cloudnapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let path = Bundle.main.path(forResource: "testJson", ofType: "json")
        
        //2 获取json文件里面的内容,NSData格式
        
        let jsonData=NSData(contentsOfFile: path!)
        
        //3 解析json内容
        
        let json = try? JSONSerialization.jsonObject(with: jsonData! as Data, options:[]) as! [[String:Any]]

        let treetableView  = TreeTableView.init(frame: self.view.bounds, style: .plain)
        self.view.addSubview(treetableView)
        treetableView.nodeData = json
        
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

