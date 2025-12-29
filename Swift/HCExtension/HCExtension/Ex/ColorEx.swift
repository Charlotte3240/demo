//
//  ColorEx.swift
//  HCExtension
//
//  Created by 360-jr on 2024/11/11.
//

import UIKit

extension UIColor: HCExtension{}

extension HCHelper where Base: UIColor{
    func hexValue() -> String{
        let components = self.base.cgColor.components
          let r: CGFloat = components?[0] ?? 0.0
          let g: CGFloat = components?[1] ?? 0.0
          let b: CGFloat = components?[2] ?? 0.0
          let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
          return hexString
    }
}
