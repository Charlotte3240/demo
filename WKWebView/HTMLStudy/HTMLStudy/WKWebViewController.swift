//
//  WKWebViewController.swift
//  WebviewDemo
//
//  Created by admin on 2019/5/5.
//  Copyright © 2019 charlotte. All rights reserved.
//

import UIKit
import WebKit
class WKWebViewController: UIViewController {
    lazy var webView: WKWebView = {
        
        //与js交互配置
        let configuration = WKWebViewConfiguration()
        
        ///偏好设置
        let preferences = WKPreferences()
        
        preferences.javaScriptEnabled = true

        configuration.preferences = preferences
        
        configuration.selectionGranularity = WKSelectionGranularity.character
        
        //自适应 没有适配的HTML 写入一个meta
        let jsScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUserScript = WKUserScript.init(source: jsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUserContentController = WKUserContentController.init()
        wkUserContentController.addUserScript(wkUserScript)

        
        //WKUserContentController() //如果已经适配过移动端给一个初始值就可以了
        configuration.userContentController = wkUserContentController
        
        // 给webview与swift交互方法起名字，webview给swift发消息的时候会用到
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "getLoaclData")
        
        var webView = WKWebView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height),
                                configuration: configuration)
        webView.navigationDelegate = self
        
        return webView
    }()
    
    lazy var progressLayer : DKProgressLayer = {
        let progress = DKProgressLayer.init(frame: CGRect(x: 0, y: self.navigationController?.navigationBar.frame.size.height ?? 40, width: screenWidth, height: 4))!
        progress.progressColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        progress.progressStyle = .gradual
        return progress
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        
        self.webView.uiDelegate = self
        
        let fileString = Bundle.main.path(forResource: "demo", ofType: "html")!

        self.webView.loadFileURL(URL.init(fileURLWithPath: fileString), allowingReadAccessTo: Bundle.main.bundleURL)
        

        // 监听title
        self.webView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        
        //监听进度条
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        
        // 添加进度条layer
        self.navigationController?.navigationBar.layer.addSublayer(progressLayer)

        
       
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title"{
            self.navigationItem.title = self.webView.title
        }else if keyPath == "estimatedProgress"{
            progressLayer.progressChanged(withWKWebViewProgress: self.webView.estimatedProgress)
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func createCookies() ->[HTTPCookie?] {
        let host = "http://www.baidu.com"
        let c_token = HTTPCookie.init(properties: [
            .domain: host,
            .path:"/",
            .version:0,
            .expires:Date.init(timeIntervalSinceNow: 30*60*60),
            .name:"token",
            .value: "token"
            ])
        let c_customerId = HTTPCookie.init(properties: [
            .domain: host,
            .path:"/",
            .version:0,
            .expires:Date.init(timeIntervalSinceNow: 30*60*60),
            .name:"customerId",
            .value: "customerId"
            ])
        let c_userId = HTTPCookie.init(properties: [
            .domain: host,
            .path:"/",
            .version:0,
            .expires:Date.init(timeIntervalSinceNow: 30*60*60),
            .name:"userId",
            .value:"userId"
            ])
        return [c_token,c_customerId,c_userId];
    }
    
    
    deinit {
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "getLoaclData")
        self.webView.removeObserver(self, forKeyPath: "title")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        
    }
    
}


// MARK: - WKUIDelegate
extension WKWebViewController: WKUIDelegate{
    // show js alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController.init(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确定", style: .default) { (action) in
            completionHandler()
        }
        alert.addAction(action)
        
        
        
        self.present(alert, animated: true, completion: nil)
    }
    // show js commfirm
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController.init(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            completionHandler(false)
        }
        alert.addAction(cancelAction)
        
        let sureAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
            completionHandler(true)
        }
        alert.addAction(sureAction)
        
        self.present(alert, animated: true, completion: nil)
    }
 
    // show js input alert
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController.init(title: "提示", message: prompt, preferredStyle: .alert)
        
        alert.addTextField { (texfiled) in
            texfiled.placeholder = defaultText
        }
        
        let sureAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
            completionHandler(alert.textFields?.last?.text ?? "")
        }
        alert.addAction(sureAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


// MARK: - WKScriptMessageHandler
extension WKWebViewController: WKScriptMessageHandler{
    ///接收js调用方法
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        switch message.name {
            
        case "getLoaclData":
            self.getLocalData(str: message.body as? String ?? "")
            
        default:
            break
            
        }
    }
    
    
    func getLocalData(str:String){
        
        self.showMessage(msg: str)
        
    }
    
    
    func showMessage(msg : String){
        let alert = UIAlertController.init(title: "title", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)

    }
    
    
}
// 跳转代理
extension WKWebViewController: WKNavigationDelegate{
    ///在网页加载完成时调用js方法
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("webview did finish load")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webview did start nav")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    //Called when the web view begins to receive web content.
    // write cookie
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        // FIXME: - write cookie if you need
        return
        
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in
           let already = cookies.filter({ (cookie) -> Bool in
                if cookie.name == "customerId" || cookie.name == "token" || cookie.name == "userId"{
                    return true
                }else{
                    return false
                }
            })
            
            if already.count == 0{
                self.createCookies().forEach { (cookie) in
                    webView.evaluateJavaScript("document.cookie = '\(cookie?.name ?? "")=\(cookie?.value ?? "")';") { (res, error) in
                        if error != nil{
                            print("set cookie res is \(res ?? "") error is \(String(describing: error))")
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
}

// MARK: - fix memory recycle
class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    weak var scriptDelegate: WKScriptMessageHandler?
    init(_ scriptDelegate: WKScriptMessageHandler) {
        super.init()
        self.scriptDelegate = scriptDelegate

    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
    deinit {
        print("WeakScriptMessageDelegate is deinit")
    }
}
