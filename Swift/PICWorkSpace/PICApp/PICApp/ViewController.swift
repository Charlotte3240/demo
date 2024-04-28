//
//  ViewController.swift
//  PICApp
//
//  Created by m1 on 2024/3/28.
//

import UIKit
import PIC

let key = "keyuser"
let secret = "JHyzA6VQhNNdDNMcDRrXq48wH1YDNw5"
//let sdkUrl = "http://150.158.10.87/rpa"
let sdkUrl = "https://rpa.lingdiman.com"


class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataList = [PlatForm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        // fetch platform list
        PICSDK.shared.fetchPlatForm(urlStr: sdkUrl, key: key, secret: secret) { list, err in
            if let list = list {
                // list.first?.id
                // list.first?.title
                // list.first.url
                self.dataList = list
                DispatchQueue.main.async {[weak self] in
                    self?.tableView.reloadData()
                }
            }else{
                debugPrint(err)
            }
        }
        
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "platformCell") as! PlatformCell
        let model = self.dataList[indexPath.row]

        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataList[indexPath.row]
        let params : [String : Any] = [
            "IsCache": false,  // 是否缓存页面
            "IsLogout": true, // 是否退出已登录状态
            "TimeOut": 120      // 页面运行有效时间
        ]
        PICSDK.shared.delegate = self
        PICSDK.shared.openPIC(urlStr: model.url, key: key, secret: secret, id: model.id, parmas: params) { success in
            debugPrint("open success \(success)")
        }
    }
    
    
}


extension ViewController: PICSDKDelegate{

    
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
