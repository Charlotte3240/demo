//
//  Observable.swift
//  Rx
//
//  Created by Charlotte on 2020/12/28.
//

import UIKit
import RxSwift
import RxCocoa
enum HCError: Error,LocalizedError {
    case netError
    case dataError
    
    var errorDescription: String?{
        switch self {
        case .dataError:
            return "数据错误"
        case .netError:
            return "网络错误"
        }
    }
    
}


enum LoginError: Error,LocalizedError {
    case pwdLength
    var errorDescription: String?{
        return "密码长度不符合"
    }
    
}


enum CacheError : Error ,LocalizedError {
    case notfound
    case unkown
    
    var errorDescription: String?{
        switch self {
        case .notfound:
            return "cache not found"
        default:
            return "cache unkown"
        }
    }
}

class ObserverVC: UIViewController {
    var disposedBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // 生成一个可观察队列
        let numbers : Observable<Int> = Observable<Int>.create { (observe) -> Disposable in
            observe.onNext(1)
            observe.onNext(3)
            observe.onError(HCError.dataError)
            observe.onCompleted()
            return Disposables.create()
        }
        
        numbers.subscribe(onNext: { (e) in
            print(e)
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            print("complete")
        }, onDisposed: {
            print("disposed")
        }).disposed(by: self.disposedBag)
        
        
        
        typealias JSON = Any
        
        let json = Observable<JSON>.create { (observe) -> Disposable in
            
            let task = URLSession.shared.dataTask(with: URL(string: "https://www.baidu.com")!) { (data, response, error) in
                if error != nil{
                    observe.onError(error!)
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else{
                    observe.onError(HCError.dataError)
                    return
                }
                observe.onNext(json)
                observe.onCompleted()
                
            }
            task.resume()
            
            
            return Disposables.create { task.cancel() }
        }
        
        .asSingle()
        //.asCompletable()
        
        json.subscribe { (json) in
            print(json)
        } onFailure: { (error) in
            print(error.localizedDescription)
        }.disposed(by: self.disposedBag)

        
//        json.subscribe { (e) in
//            print(e)
//        } onError: { (error) in
//            print(error.localizedDescription)
//        } onCompleted: {
//            print("complete")
//        } onDisposed: {
//            print("disposed")
//        }.disposed(by: self.disposedBag)

        
        self.getRepo("ReactiveX/RxSwift")
            .subscribe { (result) in
                print("json result")
            } onFailure: { (error) in
                print(error.localizedDescription)
            } onDisposed: {
                print("disposed")
            }.disposed(by: self.disposedBag)
        
        
        //Completable
        cacheLocally().subscribe {
            print("find cache")
        } onError: { (error) in
            print(error.localizedDescription)
        }.disposed(by: self.disposedBag)

        //Maybe
        generateString().subscribe { (e) in
            print(e)
        } onError: { (error) in
            print(error.localizedDescription)
        } onCompleted: {
            print("complete")
        }.disposed(by: self.disposedBag)

        //Driver
        let query = UITextField.init()
        query.placeholder = "input something"
        self.view.addSubview(query)
        query.snp.makeConstraints { (m) in
            m.left.equalToSuperview().offset(20)
            m.top.equalToSuperview().offset(80)
            m.right.equalToSuperview().offset(-20)
            m.height.equalTo(40)
        }
        let resultLabel = UILabel.init()
        resultLabel.textColor = .black
        resultLabel.backgroundColor = .gray
        resultLabel.textAlignment = .center
        self.view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { (m) in
            m.left.right.height.equalTo(query)
            m.top.equalTo(query.snp.bottom).offset(20)
        }
        
        query.rx.text
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapFirst{ str in
                self.fetchAutoCompleteItems(str ?? "")
                    .observe(on:MainScheduler.instance)
                    .catchAndReturn(LoginError.pwdLength.localizedDescription)
                    
            }.subscribe { (str) in
                resultLabel.text = str
            } onError: { (error) in
                print(error.localizedDescription)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("disposed")
            }.disposed(by: self.disposedBag)


        
        
    }
    func fetchAutoCompleteItems(_ query:String) -> Observable<String>{
        if query.count > 6{
            return Observable<String>.just(query)
        }else{
            return Observable<String>.error(LoginError.pwdLength)
        }
        
    }
    
    
    func generateString() -> Maybe<String>{
        Maybe.create { (maybe) -> Disposable in
            //下面三个发送一个
            maybe(.success("success"))
            maybe(.error(HCError.dataError))
            maybe(.completed)

            return Disposables.create {
                
            }
        }
    }
    
    func cacheLocally() -> Completable{
        Completable.create { (completable) -> Disposable in
            
            if UserDefaults.standard.object(forKey: "localCache") == nil{
                completable(.error(CacheError.notfound))
            }else{
                completable(.completed)
            }
            return Disposables.create { }
        }
        
    }
    
    
    func getRepo(_ repo: String) -> Single<[String:Any]>{
        Single<[String:Any]>.create { (single) -> Disposable in
            let url  = URL.init(string: "https://api.github.com/repos/\(repo)")!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error{
                    single(.failure(error))
                    return
                }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                      let result = json as? [String: Any] else{
                    single(.failure(HCError.dataError))
                    return
                }
                single(.success(result))
                
            }
            task.resume()
            
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    
}
