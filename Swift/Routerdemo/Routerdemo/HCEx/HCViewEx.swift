//
//  HCViewEx.swift
//  Routerdemo
//
//  Created by Charlotte on 2020/12/8.
//

import UIKit

extension UIView{
    /// UIView 转图片
    /// - Returns: UIImage
    @objc func convertViewToImage() -> UIImage{
        let size = self.bounds.size
        ///  size : view size
        /// opaque : 是否非透明，半透明需要false
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
        
    }
    
}
