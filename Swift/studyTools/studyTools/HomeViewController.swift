//
//  HomeViewController.swift
//  studyTools
//
//  Created by 360-jr on 2023/6/14.
//

import UIKit

class HomeViewController : UIViewController{

    override func viewDidLoad(){
        super.viewDidLoad()
    }
    @IBAction func playZh(_ sender: Any) {
        self.performSegue(withIdentifier: "showZhPlayer", sender: nil)
    }
    @IBAction func playEn(_ sender: Any) {
        self.performSegue(withIdentifier: "showEnPlayer", sender: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showZhPlayer" {
            let resultsViewController = segue.destination as! PlayerViewController
            resultsViewController.lan = .zh_ch
        }else if segue.identifier == "showEnPlayer"{
            let resultsViewController = segue.destination as! PlayerViewController
            resultsViewController.lan = .en_us
        }

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print(identifier)
        return true
    }
}
