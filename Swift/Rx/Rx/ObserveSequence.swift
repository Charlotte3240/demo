//
//  ObserveSequence.swift
//  Rx
//
//  Created by Charlotte on 2020/12/25.
//

import UIKit

class ObserveSequence: NSObject {
    override init() {
        super.init()
        
        // tap sequence
        let taps : Array<Void> = [(),(),()]
        taps.forEach({UIViewController.showAlert()})
        
    }
    
 
}

extension UIViewController {
    static func showAlert() {
        let alertView = UIAlertView.init(title: "title", message: "message", delegate: nil, cancelButtonTitle: "cancel")
        alertView.show()
    }
}

import RxSwift
import Kingfisher
class ClickViewController: UIViewController {
    var disposedBag = DisposeBag()
    
    var netImage : UIImage = UIImage(){
        didSet{
            self.rx_netImage.onNext(1)
        }
    }
    
    var rx_netImage : BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.blue
        self.view.addSubview(btn)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        btn.center = self.view.center
        
        // 创建点击事件的序列
        let taps : Observable<Void> = btn.rx.tap.asObservable()
        taps.subscribe { (next) in
            UIViewController.showAlert()
        }.disposed(by: self.disposedBag)
        
        
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.left.top.equalToSuperview()
            m.width.height.equalTo(200)
        }
        
        
        // 发送subjec 后，订阅就可以接收
        self.rx_netImage.subscribe { (e) in
            print("subjec subscribe \(e)")
            imageView.image = self.netImage
        }.disposed(by: self.disposedBag)
        
        
        self.getImagefromNet()
        

        
    }
    
    func getImagefromNet() {
        guard let url = URL.init(string: "https://dss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=137662163,2033337145&fm=58.png") else {
            return
        }
        ImageDownloader.default.downloadImage(with: url, completionHandler: { result in
            switch result{
            case .success(let res):
                print("success")
                self.netImage = res.image
            case .failure(let error):
                print(error)
                break
            }
            
        })
    }
}
