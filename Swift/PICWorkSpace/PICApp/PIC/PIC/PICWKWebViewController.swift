//
//  PICWKWebViewController.swift
//  PIC
//
//  Created by m1 on 2024/3/28.
//

import Foundation
import WebKit

// https://igjj.ccb.com/qgzfgjj/login
// https://api.hc-nsqk.com/tmp/ccb.js

// https://www.etax.chinatax.gov.cn
// https://api.hc-nsqk.com/tmp/chinatax.js

let jsDic = [
    "https://igjj.ccb.com/qgzfgjj/login":"https://api.hc-nsqk.com/tmp/ccb.js",
    "https://www.etax.chinatax.gov.cn":"https://api.hc-nsqk.com/tmp/chinatax.js"
]

// 下载js文件链接
let fetchJsUrl = "http://150.158.10.87/rpa/api/platform/resource"


enum LoadingStatus{
    case loading
    case end
}

// onDecode 使用
struct BridgeModel : Codable{
    var uuid : String?
    var data : String?
}

let nullValue: Any? = nil


class PICWKWebViewController: UIViewController {
        
    let jsBridgeFuncNames = ["exitSDK","onLog","onStatus","onDecode","onData","onDataAppend","onStartActivityUrl"]

    var callStarted = false
    
    
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
        // 添加所有交互方法
        self.jsBridgeFuncNames.forEach({
            configuration.userContentController.add(WeakScriptMessageDelegate(self), name: $0)
        })
        
        var webView = WKWebView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height),
                                configuration: configuration)
        webView.navigationDelegate = self
        
        //TODO: - 上线后移除
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        } else {
            // Fallback on earlier versions
        }

        
        return webView
    }()
    
    fileprivate lazy var indictorView: IndicatorView = {
        let indictor = IndicatorView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height))
        return indictor
    }()
        
    
    /// web 页面地址
    var webUrl : String = ""
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
//        self.view.addSubview(self.indictorView)
//        self.indictorView.showIndictor(status: .loading)
        
        
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

        
        // 下载js 后注入js
        downloadJSFile() {[weak self] result in
            switch result{
            case.success(let jsContent):
                DispatchQueue.main.async {
                    self?.injectJSContent(jsContent.replacingOccurrences(of: #"platform: "android""#, with: #"platform: "ios""#))
                }
            case.failure(let error):
                debugPrint("download logic js file \(error)")
                PICSDK.shared.onError(err: "download logic fail")
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
    
    func writeJs(_ jsStr: String = ""){
        self.webView.evaluateJavaScript(jsStr) { (result, error) in
            if error == nil{
                debugPrint("write js success : \(jsStr)")
            }else{
                debugPrint("write js error is \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    // 下载js文件内容
    func downloadJSFile(completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: URL(string: fetchJsUrl)!,timeoutInterval: 30)
        let auth = PICSDK.shared.token ?? ""
        let psw = "\(PICSDK.shared.secret?.prefix(16) ?? "")"
        request.addValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parama: [String: Any] = [
            "id":PICSDK.shared.platFormId ?? 0,
            "device": HCTool.getDeiveName(),
            "screen": "\(UIScreen.main.bounds.size.width),\(UIScreen.main.bounds.size.height)",
            "package": HCTool.getMainBundleId(),
            "isHarmony": "false"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parama, options: [])
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                  let content = result["Data"] as? [String: Any],
                  let jsStr = content["Js"] as? String,
                  let result = HCEncrypt.decrypt(psw: psw, encryptedText: jsStr) else {
                completion(.failure(NSError(domain: "Invalid data", code: -1, userInfo: nil)))
                return
            }
            
            completion(.success(result))
        }
        
        task.resume()
    }
    func injectJSContent(_ jsContent: String) {
        guard let url = URL.init(string: self.webUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            PICSDK.shared.onError(err: "传入URL格式错误")
            return
        }
        
        let userScript = WKUserScript(source: jsContent, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        self.webView.configuration.userContentController.addUserScript(userScript)

        let req = URLRequest.init(url: url,cachePolicy: .reloadIgnoringLocalCacheData,timeoutInterval: TimeInterval.init(10))
        self.webView.load(req)
    }
    
    
    func showLoading(status: LoadingStatus){
        
        switch status{
        case .loading:
            // show loading image
            self.indictorView.showIndictor(status: .loading)
            break
        case .end:
            // show end image
            break
        }
    }

    
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "title")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        // 移除所有方法
        self.jsBridgeFuncNames.forEach {[weak self] funcName in
            self?.webView.configuration.userContentController.removeScriptMessageHandler(forName: funcName)
        }
                
        //移除监听
        NotificationCenter.default.removeObserver(self)
        debugPrint("webview deinit")
        
    }
    
}




// MARK: - WKScriptMessageHandler  js交互
extension PICWKWebViewController: WKScriptMessageHandler{
    ///接收js调用方法
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        
        debugPrint("recv message handler func: \(message.name), body: \(message.body)")

        switch message.name {
        case "exitSDK":
            self.exitSDK()
        case "onLog":
            self.onLog(data: message.body as? String ?? "")
        case "onStatus":
            self.onStatus(data: message.body as? Int ?? 0)
        case "onDecode":
            self.onDecode(data: message.body as? [String:String] ?? [String:String]())
        case "onData":
            self.onData(data: message.body as? String ?? "")
        case "onDataAppend":
            self.onDataAppend(data: message.body as? String ?? "")
        case "onStartActivityUrl":
            self.onStartActivityUrl(data: message.body as? String ?? "")
            
        default:
            break
            
        }
    }
    
    func onStartActivityUrl(data: String){
        if let url = URL(string: data){
            let req = URLRequest(url: url)
            self.webView.load(req)
        }
    }
    
    func onDataAppend(data : String){
        
    }
    
    func onData(data : String){
        // json 字符串
    }
    
    func onDecode(data : [String: String]?){
        var jsStr = ""
        let uuid = data?["uuid"] as? String ?? ""
        let base64 = data?["data"] as? String ?? ""
        let qrContent = self.getQrCodeContent(content: base64)
        if qrContent.isEmpty{
            debugPrint("解析onDecode json 数据失败")
            jsStr = #"""
                window.rpa.callback(\#(uuid),\#(qrContent),'not found qr code')
            """#

        }else{
            jsStr = #"""
                window.rpa.callback("\#(uuid)","\#(qrContent)")
            """#
        }
        debugPrint("will write jsContent: \(jsStr)")
        self.writeJs(jsStr)
        
    }
    
    func onStatus(data: Int){
        
    }

    func onLog(data : String){
        
    }
    
    func exitSDK(){
        DispatchQueue.main.async {[weak self] in
            self?.dismiss(animated: true) {
                
            }
        }
    }

    
    func startRPA(){
        // 执行rpa.start
        self.writeJs(#"""
    (function() {
            if(window.rpa) {
                window.rpa.start('\#(self.webView.url?.relativePath ?? "")');
            }
        }
    )()
    """#)

    }
    
    func getQrCodeContent(content : String) -> String{
        // 您的 Base64 图像字符串
        let base64String = content

        // 将 Base64 字符串解码为 Data
        guard let imageData = Data(base64Encoded: base64String), let image = UIImage(data: imageData) else {
            print("Invalid Base64 image string")
            return ""
        }
        

        // 将 UIImage 转换为 CIImage
        guard let ciImage = CIImage(image: image) else {
            print("Failed to create CIImage from UIImage")
            return ""
        }

        // 创建 CIDetector 实例
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                   context: nil,
                                   options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

        // 检测二维码特征
        let features = detector?.features(in: ciImage)

        // 遍历检测到的特征
        for feature in features as? [CIQRCodeFeature] ?? [] {
            if let messageString = feature.messageString {
                print("Detected QR code message: \(messageString)")
            }
        }
        
        return (features?.first as? CIQRCodeFeature)?.messageString ?? ""

    }
    

    
}
// MARK: - WKScriptMessageHandler 交互结束

// 跳转代理
extension PICWKWebViewController: WKNavigationDelegate{
    ///在网页加载完成时调用js方法
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("load finish")
        if self.callStarted == true{
            return
        }
        self.callStarted = true
        self.startRPA()
        
        
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
        let absoluteString = navigationAction.request.url?.absoluteString.removingPercentEncoding ?? ""
        debugPrint("current url is \(absoluteString)")
        
        if absoluteString.hasPrefix("alipays://") || absoluteString.hasPrefix("alipay://"){
            guard let openUrl = navigationAction.request.url else{
                debugPrint("alipay url foramatter error")
                return
            }
            UIApplication.shared.open(openUrl) { success in
                debugPrint("open alipay \(success)")
            }
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow)
        }
    
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
