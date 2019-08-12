//
//  DetailTableBannerCell.swift
//  HZEMALL
//
//  Created by Charlotte on 2019/8/7.
//  Copyright © 2019 com.nsqk.chunqi.liu. All rights reserved.
//

import UIKit
import SnapKit
class DetailTableBannerCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // banner
        let banner = SDCycleScrollView.init(frame: CGRect.zero, imageNamesGroup: ["banner1","banner2","banner3","banner4","banner5"])
        banner?.pageControlAliment = .init(0)
        self.addSubview(banner!)
        
        banner?.snp.makeConstraints({ (m) in
            m.left.right.top.equalToSuperview()
            m.bottom.equalToSuperview()
        })

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
