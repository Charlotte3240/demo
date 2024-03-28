//
//  SubtitleLabel.swift
//  KTVText
//
//  Created by 360-jr on 2024/1/8.
//

import Foundation
import UIKit

class SubtitleLabel : UILabel{
    public var originalText = "如果您同意，办理公证并且债务加入人为您承担部分债务，公证后您若违约则无需诉讼直接接受加入人住所低于或财产所在地等法院执行。"
    public var progress : CGFloat = 0.0
    
    var noReadyColor : UIColor = .white
    var readyColor : UIColor = .white
    
    
    private var animatedLabel = UILabel()
    

    init(frame: CGRect , noreadyColor: UIColor, readyColor: UIColor) {
        self.noReadyColor = noreadyColor
        self.readyColor = readyColor
        
        super.init(frame: frame)

        
        self.animatedLabel.frame = frame
        self.addSubview(animatedLabel)
        self.animatedLabel.textColor = noReadyColor
        self.animatedLabel.numberOfLines = 0

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func updateProgress(progress : CGFloat){
        // 获取文字个数
        let allCount = self.originalText.count
        // 按照百分比更新文字颜色，向下取整
        
        let colorCount = Int(floor(progress * CGFloat(allCount)))
        
        if colorCount > allCount{
            return
        }
        
        let attributedText = NSMutableAttributedString(string: originalText)
        let range = NSRange(location: 0, length: colorCount)
        attributedText.addAttribute(.foregroundColor, value: readyColor, range: range)

        // 更新 UILabel 的 attributedText
        animatedLabel.attributedText = attributedText

        
    }

}
