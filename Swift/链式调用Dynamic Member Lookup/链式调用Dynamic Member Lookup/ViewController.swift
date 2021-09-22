//
//  ViewController.swift
//  链式调用Dynamic Member Lookup
//
//  Created by Charlotte on 2021/9/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        // 没有提示，但是可以随意设置keypath
//        var p = Person(info: ["title" : "首页"])
//        p.names = "avicii"
        
//        print(p.names) // Optional("avicii")
//        print(p.name) // nil
        
        // 带有提示，但是不能随意设置keypath，只能设置Info中有的属性
//        var p = Person(info: Person.Info(name: "avicii"))
//        
//        p.info.name = "other name"
//        
//        print(p.name,p.info.name,p.info)
        
        let view = Setter(subject: UIView())
            .backgroundColor(.yellow)
            .tag(200)
            .frame(CGRect(x: 0, y: 0, width: 100, height: 100))
            .center(self.view.center)
            .subject
        self.view.addSubview(view)
        
    }


}


@dynamicMemberLookup
struct Setter<Subject> {
    let subject : Subject
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Subject,Value>) -> ((Value) -> Setter<Subject>){
        var subject = self.subject
        
        return { value in
            subject[keyPath: keyPath] = value
            
            return Setter(subject: subject)
        }
    }
}

@dynamicMemberLookup
struct Person {
    
    struct Info {
        var name : String
    }
    
    var info: Info
    
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Info,Value>) -> Value{
        get{
            info[keyPath: keyPath]
        }
        
        set{
            info[keyPath: keyPath] = newValue
        }
    }
    
//    subscript(dynamicMember infoKey :String) -> Any?{
//        get{
//            return info[infoKey]
//        }
//        set{
//            info[infoKey] = newValue
//        }
//    }
}




