//
//  ViewController.swift
//  MoeWiki
//
//  Created by 刘春奇 on 2016/12/19.
//  Copyright © 2016年 刘春奇. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController,NJKWebViewProgressDelegate,UIWebViewDelegate {
    
    let baseUrl = "https://zh.moegirl.org/Mainpage"
    var webview = UIWebView()
    var text : String = ""
    
    var progressview = NJKWebViewProgressView()
    var progressProxy = NJKWebViewProgress()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.addSubview(progressview)
    }
    
     override func viewWillDisappear(_ animated: Bool) {
        progressview.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webview = UIWebView.init()
        progressProxy = NJKWebViewProgress.init()
        progressProxy.webViewProxyDelegate = self
        progressProxy.progressDelegate = self
        webview.delegate = progressProxy
        webview.delegate = self
        
        let progressBarHeight : CGFloat = 2.0
        let  navigationBarBounds = self.navigationController?.navigationBar.bounds;
        let y = CGFloat((navigationBarBounds?.size.height)!) - progressBarHeight
        
        let barFrame = CGRect.init(x: 0, y: y, width: (navigationBarBounds?.size.width)!, height: progressBarHeight)
        progressview = NJKWebViewProgressView.init(frame: barFrame)
        
        
        progressview.autoresizingMask = [UIViewAutoresizing.flexibleWidth,UIViewAutoresizing.flexibleTopMargin]
        
        webview.frame = self.view.bounds
        self.view.addSubview(webview)
        webview.loadRequest(URLRequest.init(url: URL.init(string: baseUrl)!))
        
    }
    
    
    func webViewProgress(_ webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        progressview.setProgress(progress, animated: true)
        self.title = webview.stringByEvaluatingJavaScript(from: "document.title")
    }
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        print("error is \(error)")
    }


    @IBAction func homeAction(_ sender: Any) {
        webview.loadRequest(URLRequest.init(url: URL.init(string: baseUrl)!))
    }
}

