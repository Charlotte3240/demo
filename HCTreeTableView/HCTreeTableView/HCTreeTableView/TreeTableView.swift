//
//  TreeTableView.swift
//  HCTreeTableView
//
//  Created by 刘春奇 on 2018/6/9.
//  Copyright © 2018年 Cloudnapps. All rights reserved.
//

import UIKit

class TreeTableView: UITableView , UITableViewDelegate, UITableViewDataSource {
    
    
    public var cellSelectBlock:( (_ selectId:Int,_ selectName:String,_ selectLevel:Int,_ selectPid:String)->() )?

    var nodes : [Node] = []
    
    var allNodes :[[String:Any]] = []
    
    var expandFirst = false
    
    var expanedIndex = 0
    
    var expandDesignId : String?
    
    var lastSeletNode: Node?
    
    var nodeData : [[String:Any]]?{
        didSet{
            flatData(data: nodeData!)
            nodes = dealData(data: nodeData ?? [[String:Any]](),level: 1)
            
            if nodes.count > 0 {
                let node = nodes.first
                node?.isSeleted = true
                nodes[0] = node!

            }
            
            if expandFirst == true{
                self.expandFirstData()
            }
            
            if self.expandDesignId != nil {
                self.expandDesignationId(sameId: expandDesignId!)
            }
            
            self.reloadData()

            if self.expandDesignId != nil{
                self.selectRow(at: IndexPath(row: expanedIndex, section: 0), animated: true, scrollPosition: .top)
            }else{
                self.selectRow(at: IndexPath(row: expanedIndex, section: 0), animated: true, scrollPosition: .none)

            }
            
            
        }
    }
    
    
    func expandFirstData() -> () {
        if nodes.count == 0 {
            return
        }
        if nodes.first?.isLear == true {
            return
        }else{
            
            
            func expandSubData(index:Int){
                let node = nodes[index]
                node.isOpen = true
                let addNodes = findChildrenData(selectNode: nodes[index])
                nodes.insert(contentsOf: addNodes, at: index+1)
                expanedIndex = index+1
                if nodes[expanedIndex].isLear == false {
                    expandSubData(index: expanedIndex)
                }
            }
            
            expandSubData(index: 0)

            
        }
    }
    
    //转换成node
    func dealData(data:[[String:Any]] , level:Int) -> [Node] {
        var temp = [Node]()
        
        for item in data{
            let node = Node.init()
            node.name = item["name"] as? String ?? ""
            node.id = Int("\(item["id"] ?? "")")
            node.pid = Int("\(item["parentId"] ?? "")")
            if item.keys.contains("leaf"){
                node.isLear = (item["leaf"] as! Bool == true ? true : false)
            }else{
                 node.isLear = true
            }
            node.level = level
            
            node.ico = item["ico"] as? String ?? ""
            
            temp.append(node)
        }
        return temp
    }
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.register(UINib.init(nibName: "TreeCell", bundle: nil), forCellReuseIdentifier: "TreeCell")
        self.dataSource = self
        self.delegate = self
        self.separatorStyle = .none
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK:tableView delegate dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TreeCell", for: indexPath) as! TreeCell
        let node = nodes[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.node = node
        
        if node.isSeleted{
            cell.backgroundColor = UIColor.white
            cell.boxView.backgroundColor = UIColor.white
            cell.titleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.boxView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.titleLabel.textColor = UIColor.black

        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        objc_sync_enter(self)
        
        let selectNode = nodes[indexPath.row]
        
        lastSeletNode = selectNode
        
        if self.cellSelectBlock != nil{
            self.cellSelectBlock!(selectNode.id ?? 0,selectNode.name ?? "",selectNode.level ?? 1,"\(selectNode.pid ?? 0)")
        }
        
        
        //判断是不是叶子节点
        if selectNode.isLear {

        }else{
            //判断是否展开
            if selectNode.isOpen {//收起
                //更改点击展开的 isopen
                selectNode.isOpen = false
                nodes[indexPath.row] = selectNode
                //找到子节点的头和尾 循环创建indexpath 来del
                let addNodes = findChildrenData(selectNode: selectNode)

                var startIndex : Int = 0
                var endIndex : Int = 0

                for (index,item) in nodes.enumerated(){
                    if item.id == addNodes.first?.id {
                        startIndex = index
                    }else if item.id == addNodes.last?.id {
                        endIndex = index
                        func findFinalIdex(subIndex:Int) -> () {
                            let subNode = nodes[subIndex]
                            //如果有children 找出children最后一个 并再次查找children最后一个的children
                            if findChildrenData(selectNode: subNode).count > 0{
                                let childNode =                                     findChildrenData(selectNode: subNode).last

                                for (i,n) in nodes.enumerated(){
                                    if n.id == childNode?.id{
                                        endIndex = i
                                        findFinalIdex(subIndex: i)
                                        break
                                    }
                                }
                            }
                        }

                        findFinalIdex(subIndex: indexPath.row)

                    }

                }
                var tempIndexPath : IndexPath?
                var indexPathArray :[IndexPath] = []

                for i in startIndex ... endIndex{
                    tempIndexPath = IndexPath(row: i, section: 0)
                    indexPathArray.append(tempIndexPath!)
                    nodes.remove(at: startIndex)
                }


                self.deleteRows(at: indexPathArray, with: .none)



            }else{//展开
                //更改点击展开的 isopen
                selectNode.isOpen = true
                nodes[indexPath.row] = selectNode

                let addNodes = findChildrenData(selectNode: selectNode)
                var indexPathArray = [IndexPath]()
                var tempIndexPath : IndexPath?
                for (index,node) in addNodes.enumerated(){
                    nodes.insert(node, at: index+indexPath.row+1)
                    tempIndexPath = IndexPath(row: indexPath.row+index+1, section: 0)
                    indexPathArray.append(tempIndexPath!)
                }

                self.insertRows(at: indexPathArray, with: UITableViewRowAnimation.none)

            }


            self.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            self.selectRow(at: indexPath, animated: false, scrollPosition: .none)

        }
        
        let temp = nodes
        for (index,node) in temp.enumerated() {
            if node.id == selectNode.id{
                node.isSeleted = true
                nodes[index] = node
            }else{
                node.isSeleted = false
                nodes[index] = node

            }
        }
        
        tableView.reloadData()
        
        objc_sync_exit(self)
    }
    
    
    //找到子节点
    func findChildrenData(selectNode:Node) -> [Node] {
        let childrenNodes = allNodes.filter { ( nodeDic) -> Bool in
            if Int("\(nodeDic["parentId"] ?? "")") == selectNode.id{
                return true
            }else{
                return false
            }
            
        }
        return dealData(data: childrenNodes,level: (selectNode.level ?? 0)  + 1)
        
    }
    
    func expandDesignationId(sameId:String) {
        let targetNode = allNodes.filter({"\($0["id"] ?? 0)" == sameId}).first

        guard targetNode != nil else {
            return
        }
        
        //找到平级节点
        
        var samePidNodes : [Node]?

        var samePidNodeDic = allNodes.filter({"\($0["parentId"] ?? 0)" == "\(targetNode!["parentId"] ?? 0)"})
            
        
        
        var level = 1
        
        //找出所在等级
        func selectLevelInAllNodes(initLevel:Int,pid:String){
            //在已显示的列表中查找parents
            var isfind = false
            for (_,value) in nodes.enumerated() {
                if "\(value.id ?? 0)" == pid{
                    isfind = true
                    break
                }
            }
            level += 1
            if isfind {
                samePidNodes =  dealData(data: samePidNodeDic, level: level)
            }else{
                //找出pid 继续向上查找
                var tempDic = allNodes.filter { ( nodeDic) -> Bool in
                    if "\(nodeDic["id"] ?? "")" == pid{
                        return true
                    }else{
                        return false
                    }
                    
                }.first
                
                //找不到父节点说明已经是根节点
                if tempDic != nil{
                    selectLevelInAllNodes(initLevel: level, pid:"\(tempDic!["parentId"] ?? 0)")
                }else{
                    level = 1
                }
                
            }
        }
        
        selectLevelInAllNodes(initLevel: level, pid: "\(targetNode!["parentId"] ?? 0)")
        
        //找到level 继续查找上一级
        
        
        func findParentNodes(childrenNodes:[Node]){
            
            var parentsNode =  allNodes.filter({"\($0["id"] ?? 0)" == "\(childrenNodes.first?.pid ?? 0)"}).first
            
            let parentsNodeDics =  allNodes.filter({"\($0["parentId"] ?? 0)" == "\(parentsNode!["parentId"] ?? 0)"})
            
            var parentsNodes = dealData(data: parentsNodeDics, level: (childrenNodes.first?.level ?? 1) - 1)
            
            let tempParentsNodes = parentsNodes
            for (i,v) in tempParentsNodes.enumerated() {
                if "\(v.id ?? 0)" == "\(parentsNode!["id"] ?? 0)"{
                    v.isOpen = true
                    parentsNodes.remove(at: i)
                    parentsNodes.insert(v, at: i)
                }
            }
            
            
            var tempNode = parentsNodes
            var insertIndex = 0
            
            for (index,item) in parentsNodes.enumerated() {
                if "\(item.id ?? 0)" == "\(childrenNodes.first?.pid ?? 0)"{
                    insertIndex = index
                    tempNode.insert(contentsOf: childrenNodes, at: insertIndex+1)
                }
            }
            if (childrenNodes.first?.level ?? 1) - 1 == 1{
                print(tempNode)
                nodes = tempNode

            }else{
                findParentNodes(childrenNodes: tempNode)
            }
            
            
        }
        
        if  level > 1 {
            findParentNodes(childrenNodes: samePidNodes!)
        }
        
        //设置展开id selectindexpath
        for (index,rootNode) in nodes.enumerated() {
            if sameId == "\(rootNode.id ?? 0)"{
                expanedIndex = index
                break
            }
        }
        
    }
    
    
    func flatData(data:[[String:Any]]) -> (){
        
        var temp = data
        
        
        func dealDic(dic:[String:Any]){
            var tempDic = dic
            var tempArray = [[String:Any]]()
            
            if tempDic.keys.contains("children"){
                tempArray = tempDic["children"] as! [[String : Any]]
                tempDic.removeValue(forKey: "children")
                allNodes.append(tempDic)
            }else{
                allNodes.append(tempDic)
                
            }
            
            if tempArray.count > 0 {
                for item in tempArray {
                    dealDic(dic: item)
                }
            }else{
                
            }
            
            
        }
        
        for dealDicData in temp{
            dealDic(dic: dealDicData)
        }
        
        
        print(allNodes)
    }
    
}
