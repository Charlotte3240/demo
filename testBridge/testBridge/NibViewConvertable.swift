//
//  NibViewConvertable.swift
//  zy
//
//  Created by 张永 on 2017/6/5.
//  Copyright © 2017年 Lc. All rights reserved.
//

import Foundation
import UIKit

public protocol LcViewWithXibConvertable: NSObjectProtocol {

  static func lc_nibId_class() -> String
  static func lc_nib_class() -> UINib

  func lc_nibId_instance() -> String
  func lc_nib_instance() -> UINib

}

extension UIView: LcViewWithXibConvertable {

  // MARK: - LcViewWithXibConvertable protocol function
  public func lc_nib_instance() -> UINib {
    return UINib(nibName: self.lc_nibId_instance(), bundle: Bundle.main)
  }

  public func lc_nibId_instance() -> String {
    let className = NSStringFromClass(self.classForCoder)
    if className.contains(".") {
      return className.components(separatedBy: ".").last!
    } else { return className }
  }

  public static func lc_nib_class() -> UINib {
    return UINib(nibName: self.lc_nibId_class(), bundle: nil)
  }

  public static func lc_nibId_class() -> String {
    let className = NSStringFromClass(self)
    if className.contains(".") {
      return className.components(separatedBy: ".").last!
    } else { return className }
  }

  //MARK: - get nib object
  func lc_instantiateFromNib() -> UIView? {
    return self.lc_instantiateFromNibBundle(nil, owner: nil)
  }

  func lc_instantiateFromNibBundle(_ bundle: Bundle?, owner: AnyObject?) -> UIView? {

    let views = self.lc_nib_instance().instantiate(withOwner: owner, options: nil)
    for view in views {
      if (view as AnyObject).isMember(of: self.classForCoder) {
        return view as? UIView
      }
    }
    assert(false, "Exepect file:\(self.lc_nibId_instance()).xib")
    return nil
  }
}
