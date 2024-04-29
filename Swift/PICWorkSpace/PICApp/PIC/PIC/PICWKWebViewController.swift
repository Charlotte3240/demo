//
//  PICWKWebViewController.swift
//  PIC
//
//  Created by m1 on 2024/3/28.
//

import Foundation
import WebKit

// 下载js文件链接
fileprivate let fetchJsUrl = "/api/platform/resource"

// 上传log 链接
fileprivate let uploadLogUrl = "/api/log/save"

// 交互方法
fileprivate let jsBridgeFuncNames = ["onLog","onStatus","onDecode","onData","onDataAppend","onStartActivityUrl","onCallJs"]


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
        

    var callStarted = false
    
    // on data append 会替换这个字符串
    var tmpData: String = ""
    
    
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
        jsBridgeFuncNames.forEach({
            configuration.userContentController.add(WeakScriptMessageDelegate(self), name: $0)
        })
        
        var webView = WKWebView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height),
                                configuration: configuration)
        webView.navigationDelegate = self
        
//        if #available(iOS 16.4, *) {
//            webView.isInspectable = true
//        } else {
//            // Fallback on earlier versions
//        }

        
        return webView
    }()
    
    fileprivate lazy var indictorView: IndicatorView = {
        let indictor = IndicatorView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height))
        indictor.loadingText = PICSDK.shared.platFormName ?? ""
        return indictor
    }()
        
    
    /// web 页面地址
    var webUrl : String = ""
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        
        self.view.addSubview(self.indictorView)
        self.indictorView.showIndictor(status: .loading)
                
        
        let timeoutAfter = PICSDK.shared.params["TimeOut"] as? Int ?? 60
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(integerLiteral: timeoutAfter)) {[weak self] in
            self?.exitSDK {
                PICSDK.shared.onError(err: "timeout error")
            }
        }
        
        
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
        let url = "\(PICSDK.shared.serviceUrl ?? "")\(fetchJsUrl)"
        downloadJSFile(url: url) {[weak self] result in
            switch result{
            case.success(let jsContent):
                DispatchQueue.main.async {
                    self?.injectJSContent(jsContent.replacingOccurrences(of: #"platform: "android""#, with: #"platform: "ios""#))
                }
            case.failure(let error):
                HClog.log("download logic js file \(error)")
                PICSDK.shared.onError(err: "download logic file fail")
                self?.onResultFail()
            }
        }
        
        // 监控app 再次进入前台
//        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        
    }


    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title"{
            self.navigationItem.title = self.webView.title
        }else if keyPath == "estimatedProgress"{
            HClog.log("load progress: \(self.webView.estimatedProgress)")
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func writeJs(_ jsStr: String = ""){
        self.webView.evaluateJavaScript(jsStr) { (result, error) in
            if error == nil{
                HClog.log("write js success : \(jsStr)")
            }else{
                HClog.log("write js error is \(jsStr) , \(error)")
            }
        }
    }
    
    // 下载js文件内容
    func downloadJSFile(url: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: url) else{
            PICSDK.shared.onError(err: "logic file url formatter error")
            self.onResultFail()
            return
        }
        var request = URLRequest(url: url, timeoutInterval: 30)
        let auth = PICSDK.shared.token ?? ""
        let psw = "\(PICSDK.shared.secret?.prefix(16) ?? "")"
        let param = try? JSONSerialization.data(withJSONObject: PICSDK.shared.params, options: [])
        request.addValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parama: [String: Any] = [
            "id":PICSDK.shared.platFormId ?? 0,
            "device": HCTool.getDeiveName(),
            "screen": "\(UIScreen.main.bounds.size.width),\(UIScreen.main.bounds.size.height)",
            "package": HCTool.getMainBundleId(),
            "params": String(data: param ?? Data(), encoding: .utf8) ?? ""
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
                  let jsFileName = content["Name"] as? String,
                  let result = HCEncrypt.decrypt(psw: psw, encryptedText: jsStr) else {
                completion(.failure(NSError(domain: "Invalid data", code: -1, userInfo: nil)))
                return
            }
            self.indictorView.loadingText = jsFileName
            completion(.success(result))
        }
        
        task.resume()
    }
    func injectJSContent(_ jsContent: String) {
        guard let url = URL.init(string: self.webUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            PICSDK.shared.onError(err: "url formatter error")
            self.onResultFail()
            return
        }
        
        let userScript = WKUserScript(source: jsContent, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        self.webView.configuration.userContentController.addUserScript(userScript)

        let req = URLRequest.init(url: url,cachePolicy: .reloadIgnoringLocalCacheData,timeoutInterval: TimeInterval.init(30))
        
        PICSDK.shared.onNext(next: "init webview")
        self.webView.load(req)
    }
    
    
    
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "title")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        // 移除所有方法
        for funcName in jsBridgeFuncNames{
            self.webView.configuration.userContentController.removeScriptMessageHandler(forName: funcName)
        }
                        
        //移除监听
        NotificationCenter.default.removeObserver(self)
        HClog.log("webview deinit")
        
    }
    
}




// MARK: - WKScriptMessageHandler  js交互
extension PICWKWebViewController: WKScriptMessageHandler{
    ///接收js调用方法
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        
        HClog.log("recv message handler func: \(message.name), body: \(message.body)")

        switch message.name {
        case "onLog":
            self.onLog(data: message.body as? String ?? "")
        case "onStatus":
            self.onStatus(data: message.body as? Int ?? 0)
        case "onDecode":
            self.onDecode(data: message.body as? [String:String] ?? [String:String]())
        case "onData":
            self.onData(data: message.body as? [String: String] ?? [String: String]())
        case "onDataAppend":
            self.onDataAppend(data: message.body as? String ?? "")
        case "onStartActivityUrl":
            self.onStartActivityUrl(data: message.body as? String ?? "")
        case "onCallJs":
            self.onCallJs(data: message.body as? [String: String] ?? [String: String]())
            
        default:
            break
            
        }
    }
    
    func onCallJs(data : [String: String]){
        // 解析uuid
        let uuid = data["uuid"] ?? ""
        if uuid.isBlank{
            PICSDK.shared.onError(err: "onData uuid is blank")
            return
        }
        
        let jsFileName = data["data"] ?? ""
        if jsFileName.isBlank {
            HClog.log("onCallJs fileName is blank")
            return
        }
        
        let urlStr = "\(PICSDK.shared.serviceUrl ?? "")/static/js/\(jsFileName)"
        guard let url = URL(string: urlStr) else{
            PICSDK.shared.onError(err: "oncall logic file url formatter error")
            return
        }
        var request = URLRequest(url: url, timeoutInterval: 30)
        let auth = PICSDK.shared.token ?? ""
        request.addValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                HClog.log("download oncall logic js file \(error)")
                PICSDK.shared.onError(err: "download oncall logic file fail")
                return
            }
            guard let data = data,
                  let jsContent = String(data: data, encoding: .utf8) else {
                HClog.log("oncall logic js file data problem")
                PICSDK.shared.onError(err: "oncall logic js file data problem")
                return
            }
            DispatchQueue.main.async {[weak self] in
                let jsStr = #"""
                \#(jsContent);
                    window.rpa.callback("\#(uuid)",true);
                """#
                self?.writeJs(jsStr)

                
            }
        }
        
        task.resume()
    }
    
    @objc func enterForeground(){
        // 执行rpa.start
        self.writeJs(#"""
    (function() {
            if(window.rpa) {
                window.rpa.start();
            }
        }
    )()
    """#)
        HClog.log("->>>>>>>>>>>enter foreground again")
    }
    
    func onStartActivityUrl(data: String){
        if let url = URL(string: data){
            let req = URLRequest(url: url)
            self.webView.load(req)
        }
    }
    
    func onDataAppend(data : String){
        self.tmpData = data
    }
    
    func onData(data : [String: String]){
        // 解析uuid
        let uuid = data["uuid"] ?? ""
        if uuid.isBlank{
            PICSDK.shared.onError(err: "onData uuid is blank")
            return
        }
        

        // 组装 js 字符串
        let jsStr = #"""
            window.rpa.callback("\#(uuid)",'\#(self.tmpData)')
        """#
        self.writeJs(jsStr)

    }
    
    func onDecode(data : [String: String]?){
        var jsStr = ""
        let uuid = data?["uuid"] as? String ?? ""
        let base64 = data?["data"] as? String ?? ""
        let qrContent = self.getQrCodeContent(content: base64)
        if qrContent.isBlank{
            PICSDK.shared.onError(err: "parse onDecode data fail")
            jsStr = #"""
                window.rpa.callback(\#(uuid),\#(qrContent),'not found qr code')
            """#
        }else{
            jsStr = #"""
                window.rpa.callback("\#(uuid)","\#(qrContent)")
            """#
        }
        self.writeJs(jsStr)
        
    }
    
    func onStatus(data: Int){
        switch data{
        case 0:
            self.indictorView.showIndictor(status: .hidden)
        case 1:
            self.indictorView.showIndictor(status: .loading)
        case 2:
            self.indictorView.showIndictor(status: .collecting)
        case 3:
            self.indictorView.showIndictor(status: .end)
            DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
                self?.exitSDK {
                    PICSDK.shared.onResult(msg: "success", data: self?.tmpData)
                }
            }
        default:
            HClog.log("unknow status: \(data)")
            break
        }
    }

    func onLog(data : String){
        if data.isBlank{
            return
        }
        // 上传日志到服务器
        guard let url = URL(string: "\(PICSDK.shared.serviceUrl ?? "")\(uploadLogUrl)") else{
            HClog.log("logi file url formatter error")
            return
        }
        var request = URLRequest(url: url, timeoutInterval: 30)
        let auth = PICSDK.shared.token ?? ""
        request.addValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // 获取当前时间戳
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let parama = [["\(timestamp)":data]]
        let jsonData = try? JSONSerialization.data(withJSONObject: parama, options: [])

        let body: [String:Any] = [
            "id":PICSDK.shared.platFormId ?? 0,
            "logs":String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
              HClog.log("上传日志失败: \(error?.localizedDescription ?? "")")
              return
          }
            HClog.log("上传日志: \(String(data: data, encoding: .utf8) ?? "")")
        }

        task.resume()
    }
    
    func exitSDK(complete: @escaping () -> Void){
        DispatchQueue.main.async {[weak self] in
            self?.dismiss(animated: true) {
                complete()
            }
        }
    }
    
    func onResultFail(){
        self.exitSDK {
            PICSDK.shared.onResult(msg: "fail", data: nil)
        }
    }

    
    func startRPA(){
        // 注入parmas
        let parma = PICSDK.shared.params
        if let jsonData = try? JSONSerialization.data(withJSONObject: parma, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8){
            self.writeJs(#"""
        (function() {try{Object.assign(window.rpa, {platform: 'ios', params: \#(jsonString)});}catch(e){console.log(e);} })();
        """#)
        }
        
        
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
            HClog.log("Invalid Base64 image string")
            return ""
        }
        

        // 将 UIImage 转换为 CIImage
        guard let ciImage = CIImage(image: image) else {
            HClog.log("Failed to create CIImage from UIImage")
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
                HClog.log("Detected QR code message: \(messageString)")
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
        PICSDK.shared.onNext(next: "load url finish")
//        if self.callStarted == true{
//            return
//        }
//        self.callStarted = true
        self.startRPA()
        
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        PICSDK.shared.onNext(next: "start load url")
    }
    
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        PICSDK.shared.onError(err: "load error \(error)")
        self.onResultFail()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
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
        HClog.log("current url is \(absoluteString)")
        
        if absoluteString.hasPrefix("alipays://") || absoluteString.hasPrefix("alipay://"){
            guard let openUrl = navigationAction.request.url else{
                HClog.log("alipay url foramatter error")
                return
            }
            UIApplication.shared.open(openUrl) { success in
                HClog.log("open third platform \(success)")
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
        HClog.log("WeakScriptMessageDelegate is deinit")
    }
}
