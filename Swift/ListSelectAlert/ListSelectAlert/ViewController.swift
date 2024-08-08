//
//  ViewController.swift
//  ListSelectAlert
//
//  Created by 360-jr on 2024/8/8.
//

import UIKit


class ViewController: UIViewController {
    
    var popopAlertView : PopupView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let data = [
            ListCellModel(id: "1", title: "hello"),
            ListCellModel(id: "2", title: "hello 222"),
        ]
        popopAlertView = PopupView(titleString: "请选择关闭原因:", dataList: data,confirmBlock: { index, title in
            print(index, title)
        }, cancelBlock: {
            print("cancel")
        })
    }

    @IBAction func showPopupView(_ sender: Any) {
        self.popopAlertView?.show()
        
//        DispatchQueue.main.asyncAfter(deadline: 2) {[weak self] in
//            self?.popopAlertView?.hidden()
//        }
    }
    
}

