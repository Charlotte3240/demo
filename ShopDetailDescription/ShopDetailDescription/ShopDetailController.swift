//
//  ShopDetailController.swift
//  HZEMALL
//
//  Created by Charlotte on 2019/8/6.
//  Copyright © 2019 com.nsqk.chunqi.liu. All rights reserved.
//

import UIKit
import WebKit

public let bootomBarHeight : CGFloat = 40.0

public let screenWidth = UIScreen.main.bounds.size.width

public let screenHeight = UIScreen.main.bounds.size.height



class ShopDetailController: UIViewController {

    
    var table: DetailTableView?
    
    var web : WKWebView?
    
    var webBox : UIView?
    
    var scrollThreshold : CGFloat = 80.0
    
    var webHeaderView: UILabel?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "商品详情"
        
        self.setUpUI()
    
    }
    
    
    
    @objc func collectionAction(){
        
    }
    @objc func shareAction(){
        
    }
    
    func setUpUI(){
        // table
        let table = DetailTableView()
        
        table.delegate = self
        
        self.table = table
        
        self.view.addSubview(table)
        
        table.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(-64)
            m.left.equalToSuperview()
            m.width.equalTo(screenWidth)
            m.height.equalTo(screenHeight-bootomBarHeight+64)
        }
        
        self.loadDesc()

        
    }
 
    
    func loadDesc(){
        // description
        let descWeb = WKWebViewController.init()
        
        descWeb.url = "https://www.baidu.com"
        
        self.addChild(descWeb)
        
        self.view.addSubview(descWeb.view)
        
        self.webBox = descWeb.view
        
        self.web = descWeb.webView
        
        descWeb.webView.scrollView.delegate = self
        
        
        descWeb.view.snp.makeConstraints { (m) in
            m.left.equalToSuperview()
            m.top.equalTo(self.table!.snp.bottom).offset(1000)
            m.width.equalTo(screenWidth)
            m.height.equalTo(screenHeight-bootomBarHeight)
        }
        
        
        let label = UILabel()
        label.textAlignment = .center
        label.text = "drag down to top"
        label.font = UIFont.systemFont(ofSize: 13)
        
        label.textColor = UIColor.gray
        descWeb.webView.scrollView.addSubview(label)
        label.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(-scrollThreshold)
            m.left.equalToSuperview()
            m.width.equalTo(screenWidth)
            m.height.equalTo(scrollThreshold)
        }
        self.webHeaderView = label

    }
    
    
    
    
}

extension ShopDetailController : UIScrollViewDelegate,UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 570
            
        }else if indexPath.row == 1{
            return 50
        }else{
            return 44
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        // TODO: - you can set title in diffrent page and ohter operation in this position
        if scrollView == self.table{

        }else if scrollView == self.web{

        }
        
    }

    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        
        let beyondOffSetY = scrollView.contentSize.height - screenHeight

        if scrollView == self.table{
            if offSetY - beyondOffSetY >= scrollThreshold {
                self.goToWebDetail()
            }

        }else {
            if offSetY <= -scrollThreshold, offSetY < 0 {
                self.backToTableDetail()
            }

        }
        
        
    }
    func goToWebDetail() {
        
        
        self.web?.scrollView.contentInset = UIEdgeInsets.init(top: self.scrollThreshold, left: 0, bottom: self.scrollThreshold, right: 0)

        UIView.animate(withDuration: 0.3) {
            self.navigationItem.title = "Shop Detail"
            
            self.web?.scrollView.contentOffset.y = 0
            
            self.webBox?.snp.remakeConstraints({ (m) in
                m.top.equalToSuperview()
                m.left.equalToSuperview()
                m.width.equalTo(screenWidth)
                m.height.equalTo(screenHeight-64-bootomBarHeight)
                
            })
            
            self.table?.snp.remakeConstraints({ (m) in
                m.top.equalTo(screenHeight)
                m.left.equalToSuperview()
                m.width.equalTo(screenWidth)
                m.height.equalTo(screenHeight-bootomBarHeight)
                
            })
            
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    func backToTableDetail() {
        
        UIView.animate(withDuration: 0.3, animations: {
            

            self.table?.snp.remakeConstraints({ (m) in
                m.top.equalToSuperview().offset(-64)
                m.left.equalToSuperview()
                m.width.equalTo(screenWidth)
                m.height.equalTo(screenHeight-bootomBarHeight+64)
                
            })
            
            self.webBox?.snp.remakeConstraints({ (m) in
                m.top.equalToSuperview().offset(screenHeight*2)
                m.left.equalToSuperview()
                m.width.equalTo(screenWidth)
                m.height.equalTo(screenHeight-bootomBarHeight)

            })
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.navigationItem.title = "商品详情"
    }
    
}
