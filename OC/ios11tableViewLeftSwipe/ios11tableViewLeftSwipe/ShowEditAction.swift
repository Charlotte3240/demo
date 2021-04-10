////
////  ShowEditAction.swift
////  ios11tableViewLeftSwipe
////
////  Created by Charlotte on 2020/12/22.
////  Copyright © 2020 com.cloudnapps. All rights reserved.
////
//
import UIKit

@objc protocol PrivateMethodRevealer {
    @objc optional func setShowingDeleteConfirmation(arg1: Bool)
    @objc optional func _endSwipeToDeleteRowDidDelete(arg1: Bool)
}

extension LeftSwipeTableViewCell : PrivateMethodRevealer{
    @objc func showActions() {

        
        (superview?.superview as? AnyObject)?._endSwipeToDeleteRowDidDelete?(arg1: false)
        (self as AnyObject).setShowingDeleteConfirmation?(arg1: true)
    }

    
    func _endSwipeToDeleteRowDidDelete(arg1: Bool){
        print(arg1)
        Temp().changeImp()
    }
    func setShowingDeleteConfirmation(arg1: Bool){
        print(arg1)
        Temp().changeImp()
    }

}




class Temp: NSObject {
    func changeImp(){
        let word :String = ":noitamrifnoCeteleDgniwohStes"
        var hiddenString: String = ""
        for char in word.reversed() {
            hiddenString.append(char)
        }
        
//        let hiddenString = word.reversed()
        let originalSelector = NSSelectorFromString("\(hiddenString)")
        let swizzledSelector = NSSelectorFromString("hideRowActions(_:)")
        guard let originalMethod = class_getInstanceMethod(LeftSwipeTableViewCell.classForCoder(), originalSelector) else { return  }
        let swizzledMethod = class_getInstanceMethod(UITableViewCell.classForCoder(), swizzledSelector)
        class_addMethod(UITableViewCell.classForCoder(), originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        method_exchangeImplementations(originalMethod, swizzledMethod!)

    }
}



//extension UITableViewCell {
//    func showRowActions(arg1: Bool = true) {}
//
//    public override static func initialize() {
//        struct Static {
//            static var token:  = 0
//        }
//
//        guard self === UITableViewCell.self else {return}
//
//        dispatch_once(&Static.token) {
//            let hiddenString = String(":noitamrifnoCeteleDgniwohStes".characters.reverse())
//            let originalSelector = NSSelectorFromString(hiddenString)
//            let swizzledSelector = #selector(showRowActions(_:))
//            let originalMethod = class_getInstanceMethod(self, originalSelector)
//            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//            class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//            method_exchangeImplementations(originalMethod, swizzledMethod)
//        }
//    }
//}
//
//extension UITableView {
//    func hideRowActions(arg1: Bool = false) {}
//
//    public override static func initialize() {
//        struct Static {
//            static var token: dispatch_once_t = 0
//        }
//
//        guard self === UITableView.self else {return}
//
//        dispatch_once(&Static.token) {
//            let hiddenString = String(":eteleDdiDwoReteleDoTepiwSdne_".characters.reverse())
//            let originalSelector = NSSelectorFromString(hiddenString)
//            let swizzledSelector = #selector(hideRowActions(_:))
//            let originalMethod = class_getInstanceMethod(self, originalSelector)
//            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//            class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//            method_exchangeImplementations(originalMethod, swizzledMethod)
//        }
//    }
//}
