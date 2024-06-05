//
//  InputViewController.swift
//  PICApp
//
//  Created by m1 on 2024/4/30.
//

import UIKit
import PIC

public let sdkUrl = "https://rpa.lingdiman.com"
class InputVC : UIViewController{
    
    @IBOutlet weak var keyInput: UITextField!
    
    @IBOutlet weak var secretInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showPlatfromAction(_ sender: Any) {
        if self.keyInput.text?.lengthOfBytes(using: .utf8) == 0{
            return
        }
        let params : [String : Any] = [
            "IsCache": false,  // 是否缓存页面
            "IsLogout": true, // 是否退出已登录状态
            "TimeOut": 120      // 页面运行有效时间
        ]
        let key = self.keyInput.text ?? ""
        let secret = self.secretInput.text ?? ""
        
        PICSDK.shared.delegate = self
        PICSDK.shared.openPIC(urlStr: sdkUrl, key: key, secret: secret, id: 1, parmas: params) { success in
            debugPrint("open success \(success)")
        }

        
    }
    @IBAction func platformListAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showPlatform", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlatform"{
            if let destinationVC = segue.destination as? ViewController,
               let key = self.keyInput.text,
               let secret = self.secretInput.text {
                destinationVC.key = key
                destinationVC.secret = secret
            }
        }

    }
    
}



extension InputVC: PICSDKDelegate{

    
    func onNext(msg: String) {
        debugPrint("===============> onNext: \(msg)")
    }
    
    func onError(msg: String) {
        debugPrint("===============> onError: \(msg)")
    }
    
    func onResult(msg: String, data: String?) {
        debugPrint("===============> onResult: \(msg), data: \(data ?? "")")
    }
        
    
}
