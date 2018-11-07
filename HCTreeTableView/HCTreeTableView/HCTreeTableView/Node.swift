//
//  Node.swift
//  HCTreeTableView
//
//  Created by 刘春奇 on 2018/6/9.
//  Copyright © 2018年 Cloudnapps. All rights reserved.
//

import UIKit

class Node: NSObject {

    var isOpen = false
    var name : String?
    var children :[Node] = []
    var id : Int?
    var pid : Int?
    var isLear = false
    var isHasChildren = false
    
    var level : Int?
    
    var ico :String?
    
    var isSeleted = false
    
    
    
    
    
    
}
