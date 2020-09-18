//
//  TreeCell.swift
//  HCTreeTableView
//
//  Created by 刘春奇 on 2018/6/9.
//  Copyright © 2018年 Cloudnapps. All rights reserved.
//

import UIKit

class TreeCell: UITableViewCell {
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var stateView: UIImageView!
    
    @IBOutlet weak var leftSpace: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    var node : Node = Node(){
        didSet{
            self.setNeedsLayout()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.text = node.name
        
        if node.level == 1{
            self.titleLabel.font = UIFont.systemFont(ofSize: 20)

        }else{
            self.titleLabel.font = UIFont.systemFont(ofSize: (CGFloat(20-2*(node.level ?? 0))))

        }
        
        
        if node.isLear == true {
            self.stateView.image = nil
        }else{
            if node.isOpen == true{
                self.stateView.image = #imageLiteral(resourceName: "tree_ex.png")
            }else{
                self.stateView.image = #imageLiteral(resourceName: "tree_ec.png")
            }
        }
        self.leftSpace.constant = CGFloat(15*(node.level ?? 0))
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
