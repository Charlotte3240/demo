//
//  ViewController.swift
//  WKWebViewHeaderView
//
//  Created by Charlotte on 2019/8/7.
//  Copyright © 2019 Charlotte. All rights reserved.
//

import UIKit

import WebKit

public let screenWidth = UIScreen.main.bounds.size.width

public let screenHeight = UIScreen.main.bounds.size.height


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wkwebview = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        let headerLabel = UILabel.init(frame: CGRect.init(x: 0, y: -60, width: screenWidth, height: 60))
        
        headerLabel.text = "wkwebview header view "
        
        headerLabel.textAlignment = .center
        
        wkwebview.scrollView.addSubview(headerLabel)
        
        wkwebview.scrollView.contentInset = UIEdgeInsets.init(top: 60, left: 0, bottom: 60, right: 0)
        
        
        
        self.view.addSubview(wkwebview)
        
        wkwebview.load(URLRequest.init(url: URL.init(string: "https://www.baidu.com")!))
    }


}

