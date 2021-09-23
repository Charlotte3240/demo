//
//  Utility.swift
//  HTMLStudy
//
//  Created by admin on 2019/6/6.
//  Copyright © 2019 charlotte. All rights reserved.
//

import UIKit


let screenWidth = UIScreen.main.bounds.size.width

let screenHeight = UIScreen.main.bounds.size.height


class Utility: NSObject {

}

extension UIViewController{
    func showConfirmAlert(msg : String? , callBack : @escaping () -> Void){
         let alert = UIAlertController.init(title: "提示", message: msg ?? "", preferredStyle: .alert)
         
         let confirmAction = UIAlertAction.init(title: "确定", style: .destructive) { (action) in
             callBack()
         }
         alert.addAction(confirmAction)
         
         let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
         alert.addAction(cancelAction)
         self.present(alert, animated: true, completion: nil)

     }
    
    func showAlert(msg: String?, callback: () -> Void){
        func showConfirmAlert(msg : String? , callBack : @escaping () -> Void){
             let alert = UIAlertController.init(title: "提示", message: msg ?? "", preferredStyle: .alert)
             
             let confirmAction = UIAlertAction.init(title: "确定", style: .destructive) { (action) in
                 callBack()
             }
             alert.addAction(confirmAction)
             self.present(alert, animated: true, completion: nil)

         }
    }
}
