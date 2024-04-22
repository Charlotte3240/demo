//
//  ViewController.swift
//  PICApp
//
//  Created by m1 on 2024/3/28.
//

import UIKit
import PIC


class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataList :[List] = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        fetchPlatforms()
        
    }

    
    func fetchPlatforms(){
        let user = #"keyuser:JHyzA6VQhNNdDNMcDRrXq48wH1YDNw5"#
        guard let data = user.data(using: .utf8) else{
            debugPrint("base64 encode fail")
            return
        }
        let base64Str = data.base64EncodedString()
        
        var request = URLRequest(url: URL(string: "http://150.158.10.87/rpa/api/platform/list")!,timeoutInterval: Double.infinity)
        request.addValue("Basic \(base64Str)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
              }
            do {
                let model = try JSONDecoder().decode(FetchPlatform.self, from: data)
                self.dataList = model.Data.List
                DispatchQueue.main.async {[weak self] in
                    self?.tableView.reloadData()
                }
            } catch let error {
                print(String(describing: error))
            }
            
        }

        task.resume()

    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "platformCell") as! PlatformCell
        let model = self.dataList[indexPath.row]

        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataList[indexPath.row]
        let key = "keyuser"
        let secret = "JHyzA6VQhNNdDNMcDRrXq48wH1YDNw5"

        PICSDK.shared.openPIC(urlStr: model.url, key: key, secret: secret, id: model.id) { success in
            debugPrint("open success \(success)")
        }
    }
    
    
}
