//
//  PICWKWebViewController.swift
//  PIC
//
//  Created by 360-jr on 2024/3/28.
//

import Foundation
import WebKit

class PICWKWebViewController: UIViewController {
        
    fileprivate lazy var webView: WKWebView = {
        
        //与js交互配置
        let configuration = WKWebViewConfiguration()
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            // Fallback on earlier versions
        }
        
        ///偏好设置
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true

        configuration.preferences = preferences
        
        configuration.selectionGranularity = WKSelectionGranularity.character
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "exitSDK")

        
        var webView = WKWebView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height),
                                configuration: configuration)
        webView.navigationDelegate = self
        
        
        return webView
    }()
        
    
    /// web 页面地址
    var webUrl : String = ""{
        willSet{
            let urlStr = newValue;
            guard let url = URL.init(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
                PICSDK.shared.onError(err: "传入URL格式错误")
                return
            }

            let req = URLRequest.init(url: url,cachePolicy: .reloadIgnoringLocalCacheData,timeoutInterval: TimeInterval.init(10))
            self.webView.load(req)
        }
    }
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        
        
        let top = NSLayoutConstraint.init(item: self.webView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint.init(item: self.webView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint.init(item: self.webView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint.init(item: self.webView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)

        
        self.view.addConstraints([top,right,bottom,left])
        
        
        self.webView.uiDelegate = self
        
        // 监听title
        self.webView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        
        //监听进度条
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)

    }

    func exitSDK(){
        DispatchQueue.main.async {[weak self] in
            self?.dismiss(animated: true) {
                
            }
        }
    }
    
    

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title"{
            self.navigationItem.title = self.webView.title
        }else if keyPath == "estimatedProgress"{
            debugPrint(self.webView.estimatedProgress)
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "title")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        
        //移除监听app will terminate , pip 相关通知
        NotificationCenter.default.removeObserver(self)
        debugPrint("webview deinit")
        
    }
    
}




// MARK: - WKScriptMessageHandler
extension PICWKWebViewController: WKScriptMessageHandler{
    ///接收js调用方法
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        switch message.name {
            
        case "exitSDK":
            self.exitSDK()
            
        default:
            break
            
        }
    }
    
    
    // 写入js 通知h5 跳转等待结果页面
    func notifyH5LocationToResult(){
        let actionStr = #"""
            alert("这是一个警告框！");
        """#
        
        self.writeJs(actionStr)
    }
    
    
    
    
    func writeJs(_ jsStr: String = ""){
        self.webView.evaluateJavaScript(jsStr) { (result, error) in
            if error == nil{
                debugPrint("write js success : \(jsStr)")
            }else{
                debugPrint("write js error is \(error?.localizedDescription ?? "")")
            }
        }
    }
    
}


// 跳转代理
extension PICWKWebViewController: WKNavigationDelegate{
    ///在网页加载完成时调用js方法
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("load finish")
        //TODO: - 追加JS内容
        self.notifyH5LocationToResult()

    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("start load")
    }
    
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("load error \(error)")
        PICSDK.shared.onError(err: "load error \(error)")

    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint("navigation error \(error)")
        PICSDK.shared.onError(err: "navigation error \(error)")

        // 超时 或者 加载失败 隔1s 重试
//        let error  = error as NSError
//        if error.code == URLError.notConnectedToInternet.rawValue || error.code == URLError.timedOut.rawValue{
//            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                if let loadErrorUrl = error.userInfo["NSErrorFailingURLKey"] as? URL {
//                    let loadErrorReq = URLRequest.init(url: loadErrorUrl, cachePolicy: .reloadIgnoringLocalCacheData,timeoutInterval: TimeInterval.init(10))
//                    self.webView.load(loadErrorReq)
//                }
//            }
//        }
    }
    //Called when the web view begins to receive web content.
    // write cookie
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
                
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let response = navigationResponse.response as? HTTPURLResponse
        if response?.statusCode == 302 ||
            response?.statusCode == 301 ||
            response?.statusCode == 200{
            decisionHandler(.allow)
        }else{
            decisionHandler(.cancel)
            PICSDK.shared.onError(err: "navigation error \(response.debugDescription)")
        }
        
    }
    
    
}

// MARK: - WKUIDelegate
extension PICWKWebViewController: WKUIDelegate{
    // show js alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController.init(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确定", style: .default) { (action) in
            
        }
        alert.addAction(action)
        
        

        self.present(alert, animated: true, completion: nil)
        completionHandler()

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
        debugPrint("WeakScriptMessageDelegate is deinit")
    }
}
