//
//  HCBundleEx.swift
//  Routerdemo
//
//  Created by Charlotte on 2020/12/8.
//

import UIKit

extension Bundle{
    /// 获取APP 图标
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }// app icon
}
