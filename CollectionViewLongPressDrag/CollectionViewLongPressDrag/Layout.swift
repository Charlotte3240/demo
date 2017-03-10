//
//  Layout.swift
//  CollectionViewLongPressDrag
//
//  Created by 刘春奇 on 2016/11/24.
//  Copyright © 2016年 刘春奇. All rights reserved.
//

import UIKit

class Layout: UICollectionViewFlowLayout {
    override init() {
      super.init()
        self.minimumInteritemSpacing = 10
        self.minimumLineSpacing = 10
        self.itemSize = CGSize.init(width: 180, height: 40)
        self.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
