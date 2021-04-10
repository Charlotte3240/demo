//
//  LoginVc.swift
//  Rx
//
//  Created by Charlotte on 2020/12/25.
//

import UIKit
import TextFieldEffects
import RxSwift
class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: IsaoTextField!
    @IBOutlet weak var password: IsaoTextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    var disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let userValid = userName.rx.text.orEmpty
            .map({$0.count > 0})
            .share(replay: 1)
        
        userValid.subscribe { (e) in
            if e.element!{
                self.userName.placeholder = "username vaild success"
            }else{
                self.userName.placeholder = "username vaild fail"
            }

        }.disposed(by: self.disposedBag)
        
        let pwdValid = password.rx.text.orEmpty
            .map({$0.count >= 8 && $0.count <= 16})
            .share(replay: 1)
        pwdValid.subscribe { (e) in
            if e.element!{
                self.password.placeholder = "pwd vaild success"
            }else{
                self.password.placeholder = "pwd vaild fail"
            }
        }.disposed(by: self.disposedBag)
        
        
        let _ = Observable.combineLatest(userValid,pwdValid)
            .map({$0 && $1})
            .share(replay: 1)
            .bind(to: self.loginBtn.rx.isEnabled)
            .disposed(by: self.disposedBag)
        
        self.loginBtn.rx.tap.subscribe { (e) in
            API.token(username: self.userName.text ?? "", pwd: self.password.text ?? "")
                .flatMapFirst(API.userinfo(token:))
                .subscribe(onNext: { (userinfo) in
                    print(userinfo)
                }, onError: { (error) in
                    print(print(error))
                })
                .disposed(by: self.disposedBag)
        }.disposed(by: self.disposedBag)
        
        
        
        
    }
    
}
