//
//  DetailTableView.swift
//  HZEMALL
//
//  Created by Charlotte on 2019/8/7.
//  Copyright © 2019 com.nsqk.chunqi.liu. All rights reserved.
//

import UIKit

class DetailTableView: UITableView {


    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        
        // banner
        self.register(DetailTableBannerCell.self, forCellReuseIdentifier: "DetailTableBannerCell")

        // amount  , kind of shop
        self.register(UINib.init(nibName: "DetailAmountCell", bundle: nil), forCellReuseIdentifier: "DetailAmountCell")
        self.register(UINib.init(nibName: "DetailSpecificationModelCell", bundle: nil), forCellReuseIdentifier: "DetailSpecificationModelCell")
        
        
        
        // choose specification

        self.tableHeaderView = UIView()
        
        self.delegate = self
        
        self.dataSource = self
        
        self.tableFooterView = self.footerView()
    
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func footerView () -> UILabel{
        
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 40)
        label.textAlignment = .center
        label.text = "Pull down to view details"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        
        return label
    }
    
    
}



extension DetailTableView : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            // banner
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableBannerCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailAmountCell", for: indexPath) as! DetailAmountCell
            cell.selectionStyle = .none
            return cell

        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailSpecificationModelCell", for: indexPath) as! DetailSpecificationModelCell
            cell.selectionStyle = .none
            return cell

        }
        else{
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: "detailCell")
    
            cell.textLabel?.text = "\(indexPath.row)"
    
            return cell
        }
        

    }
    
    
}
