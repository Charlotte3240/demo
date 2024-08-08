//
//  TableContentView.swift
//  ListSelectAlert
//
//  Created by 360-jr on 2024/8/8.
//

import UIKit

typealias ContentSelectBlock = (Int) -> Void

class TableContentCell: UITableViewCell{
    
}

class TableContentView: UITableView{
    var selectBlock : ContentSelectBlock?
    
    var data = [ListCellModel]() {
        didSet{
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)
        
        self.register(TableContentCell.self, forCellReuseIdentifier: "HCPopupTableContentCell")
        self.delegate = self
        self.dataSource = self
        
        self.backgroundColor = .white
        self.separatorStyle = .none
        
        self.tableHeaderView = UIView(frame: .zero)
        self.tableFooterView = UIView(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TableContentView : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = self.data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HCPopupTableContentCell") as! TableContentCell
        cell.textLabel?.text = info.title ?? ""
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.selectBlock != nil{
            self.selectBlock!(indexPath.row)
        }
    }
    
    
    
}
