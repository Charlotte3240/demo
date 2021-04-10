//
//  ViewController.swift
//  Rx
//
//  Created by Charlotte on 2020/12/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import HandyJSON
import WebKit
class ViewController: UIViewController {

    var disposedBag = DisposeBag()
    
    
    lazy var webview : WKWebView = {
        let webview = WKWebView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width/2, height: self.view.bounds.size.height/2), configuration: WKWebViewConfiguration())
        return webview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MARK: - button click
        let button = UIButton(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        button.setTitle("button", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.center = self.view.center
        self.view.addSubview(button)
        
        button.rx.tap.subscribe { (event) in
            print(event)
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let loginvc = sb.instantiateViewController(identifier: "LoginViewController")
//            loginvc.modalPresentationStyle = .fullScreen
            self.present(loginvc, animated: true, completion: nil)
            
            
        }.disposed(by: self.disposedBag)
        
//        let school = School()
//        let observeSequence = ObserveSequence()
        
//        return
        
        // MARK: - scroll content observer
        let scrollView = UIScrollView.init()
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        scrollView.rx.contentOffset.subscribe { (point) in
            print(point)
        }.disposed(by: self.disposedBag)
        
        // MARK: - block call
        
        // show htmlstr
        self.view.addSubview(self.webview)
        self.webview.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
            m.width.equalTo(self.view.bounds.size.width/2)
            m.height.equalTo(self.view.bounds.size.height/2)
        }
        let tap = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tap)
        tap.rx.event.bind { (tap) in
            self.webview.isHidden = true
        }.disposed(by: self.disposedBag)
        
        let urlReq = URLRequest(url: URL(string: "https://www.baidu.com")!)
        URLSession.shared.rx.data(request: urlReq)
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe { (data) in
            let str = String.init(decoding: data, as: UTF8.self)
                self.webview.loadHTMLString(str, baseURL: nil)
        } onError: { (error) in
            print(error)
        } onCompleted: {
            print("complete")
        } onDisposed: {
            print("disposed")
        }.disposed(by: self.disposedBag)
        
        
        // MARK: - notification
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "testnotification"), object: nil).subscribe { (notification) in
            print(notification.element?.userInfo as Any)
            
            
        }.disposed(by: self.disposedBag)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "testnotification"), object: nil, userInfo: ["key":"value"])

        
        // MARK: - depend
        API.token(username: "username", pwd: "password")
            .flatMapFirst(API.userinfo(token:))
            .subscribe(onNext: { (userInfo) in
                print(userInfo)
            }, onError: { (error) in
                print(error)
            }, onCompleted: {
                print("complete")
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: self.disposedBag)
        
        
        // MARK: - zip
        let teacherId = 666
        Observable.zip(API.teacher(teachId: teacherId),API.teacherComment(teacherId: teacherId))
            .subscribe(onNext: { (teacher,commonts) in
                print(teacher,commonts)
            }, onError: { (error) in
                print("get teacher or commonts fail \(error)")
            }, onCompleted: {
                print("get info success")
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: self.disposedBag)
        
        
        
    }
    
    
    
    


}


struct UserInfo {
    var name :String?
    var age : Int?
}

struct Teacher {
    var name : String?
    var age : Int?
}

struct Commont {
    var text : String?
    var time : String?
}

enum API {
    
    static func token(username : String,pwd : String) -> Observable<String>{
        Observable<String>.just("token")
    }
    
    static func userinfo(token : String) -> Observable<UserInfo>{
        Observable<UserInfo>.just(UserInfo.init(name: "name", age: 18))
    }
    
    static func teacher(teachId : Int) -> Observable<Teacher>{
        Observable<Teacher>.just(Teacher(name: "teacher", age: 40))
    }
    
    static func teacherComment(teacherId : Int) -> Observable<[Commont]>{
        Observable<[Commont]>.just([Commont].init(repeating: Commont(text: "this is commont", time: "2020.12.25"), count: 3))
    }
    
}
