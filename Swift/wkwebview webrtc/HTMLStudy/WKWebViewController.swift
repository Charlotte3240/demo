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
        // 视频页面播放支持

        configuration.preferences = preferences
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        
        configuration.selectionGranularity = WKSelectionGranularity.character
        configuration.userContentController = WKUserContentController()
        
        // 给webview与swift交互方法起名字，webview给swift发消息的时候会用到
        
        
//        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "sendMessageToiOS")
//        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "openVC")
//        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "closeVC")
//        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "exitSDK")



        
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
    
    
    var inputUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        
        self.webView.uiDelegate = self
        
//        let fileString = Bundle.main.path(forResource: "demo", ofType: "html")!
//
//        self.webView.loadFileURL(URL.init(fileURLWithPath: fileString), allowingReadAccessTo: Bundle.main.bundleURL)
        
        
//        let url = "https://test.webrtc.org/"
        
        guard let url = URL.init(string: self.inputUrl ?? "") else{
//            showAlert(msg: "url格式不对") {}
            showMessage(msg: "url 格式不对")
            return
        }
        

        let req =  URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData,timeoutInterval: TimeInterval.init(30))
        self.webView.load(req)

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
    
    
    
    
    deinit {
//        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "sendMessageToiOS")
//        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "openVC")
//        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "closeVC")
//        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "exitSDK")
        
//        self.webView.removeObserver(self, forKeyPath: "title")
//        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        
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
            
        case "sendMessageToiOS":
            self.receiveCustomerMessage(mgs: message.body as? String ?? "")
        case "openVC":
            self.openVC()
        case "closeVC":
            self.closeVC()
        case "exitSDK":
            self.exitSDK()
            
        default:
            break
            
        }
    }
    
    //MARK: - 与js交互
    
    
    /// 退出sdk
    func exitSDK() {
        self.writeJs("receiveMessageFromiOS('exitSDK')")
    }
    
    /// 关闭视频会议
    func closeVC() {
        self.writeJs("receiveMessageFromiOS('closeVC')")

    }
    
    /// 打开视频会议
    func openVC(){
        self.writeJs("receiveMessageFromiOS('openVC')")
    }
    
    /// 收到js发来的自定义消息
    /// - Parameter mgs: 消息参数
    func receiveCustomerMessage(mgs : String) {
        self.writeJs("receiveMessageFromiOS('\(mgs)')")
    }
    
    
    func writeJs(_ jsStr: String = ""){
        self.webView.evaluateJavaScript(jsStr) { (result, error) in
            if error == nil{
                print("write js success")
            }else{
                print("write js error is \(error?.localizedDescription ?? "")")
            }
        }
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
        print("webview navigation error \(error)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // 超时 或者 加载失败 隔1s 重试
        let error  = error as NSError
        if error.code == URLError.notConnectedToInternet.rawValue || error.code == URLError.timedOut.rawValue{
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                if let loadErrorUrl = error.userInfo["NSErrorFailingURLKey"] as? URL {
                    let loadErrorReq = URLRequest.init(url: loadErrorUrl, cachePolicy: .reloadIgnoringLocalCacheData,timeoutInterval: TimeInterval.init(10))
                    self.webView.load(loadErrorReq)
                }
            }
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let response = navigationResponse.response as? HTTPURLResponse
        if response?.statusCode == 302 ||
            response?.statusCode == 301 ||
            response?.statusCode == 200{
            decisionHandler(.allow)
        }else{
            decisionHandler(.cancel)
        }

    }
    //Called when the web view begins to receive web content.
    // write cookie
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
                
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
