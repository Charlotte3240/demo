//
//  NibViewBridge.swift
//  zy
//
//  Created by 张永 on 2017/6/5.
//  Copyright © 2017年 Lc. All rights reserved.
//

import Foundation
import UIKit

public extension Double {
  public var float: Float {
    return Float(self)
  }
}
extension UIDevice {

  var osVersion: Float {
    return (self.systemVersion as NSString).floatValue
  }
}

extension String {

  public var double: Double? {
    let formatter = NumberFormatter()
    return formatter.number(from: self) as? Double
  }
}

var osVersions: Float {
  return (UIDevice.current.systemVersion as NSString).floatValue
}

// MARK: - Bridge protocol
@objc public protocol LcViewWithXibBridge { }

extension UIView {

  open override func awakeAfter(using aDecoder: NSCoder) -> Any? {

    if class_conformsToProtocol(self.classForCoder, LcViewWithXibBridge.self) {
      let version = class_getVersion(self.classForCoder)

      if version == 0 {

        print(self.classForCoder)
        class_setVersion(self.classForCoder, 1)
        return self.instantiateRealView(self)
      }

      class_setVersion(self.classForCoder, 0)
      return self

    }
    return self
  }

  func instantiateRealView(_ placeholdView: UIView) -> UIView? {

    let realView = placeholdView.lc_instantiateFromNib()

    realView?.tag = placeholdView.tag
    realView?.frame = placeholdView.frame
    realView?.bounds = placeholdView.bounds
    realView?.isHidden = placeholdView.isHidden
    realView?.clipsToBounds = placeholdView.clipsToBounds
    realView?.autoresizingMask = placeholdView.autoresizingMask
    realView?.isUserInteractionEnabled = placeholdView.isUserInteractionEnabled
    realView?.translatesAutoresizingMaskIntoConstraints = placeholdView.translatesAutoresizingMaskIntoConstraints

    guard placeholdView.constraints.count > 0, realView != nil else { fatalError("no Constraint on view or view is nil") }

    placeholdView.constraints.forEach { (constraint) in

      let newConstraint = constraint

      if #available(iOS 9.0, *) {
        let referenceItem = class_getInstanceVariable(NSLayoutAnchor<AnyObject>.classForCoder() as AnyClass, "_referenceItem")

        let firstAnchorItem = object_getIvar(newConstraint.value(forKey: "firstAnchor"), referenceItem!)

        if let consFView = firstAnchorItem as? UIView, consFView == self {
          object_setIvar(newConstraint.value(forKey: "firstAnchor"), referenceItem!, realView)
        } else { fatalError("can not get first anchor item ") }

        if newConstraint.value(forKey: "secondAnchor") != nil {
          let secondAnchorItem = object_getIvar(newConstraint.value(forKey: "secondAnchor"), referenceItem!)

          if let consSView = secondAnchorItem as? UIView, consSView == self {
            object_setIvar(newConstraint.value(forKey: "secondAnchor"), referenceItem!, realView)
          } else { fatalError("can not get second anchor item ") }

        }
      } else {
        if newConstraint.firstItem as! NSObject == self {
          newConstraint.setValue(realView, forKey: "firstItem")
        }

        if newConstraint.secondItem as! NSObject == self {
          newConstraint.setValue(realView, forKey: "secondItem")
        }
      }

      if UIDevice().osVersion > 7.0 {
        newConstraint.identifier = constraint.identifier
      }

      realView?.addConstraint(newConstraint)
    }
    return realView
  }
}
