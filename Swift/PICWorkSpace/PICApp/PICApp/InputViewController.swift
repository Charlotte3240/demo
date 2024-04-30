//
//  InputViewController.swift
//  PICApp
//
//  Created by m1 on 2024/4/30.
//

import UIKit

class InputVC : UIViewController{
    
    @IBOutlet weak var keyInput: UITextField!
    
    @IBOutlet weak var secretInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showPlatfromAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showPlatform", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlatform"{
            if let destinationVC = segue.destination as? ViewController,
               let key = self.keyInput.text,
               let secret = self.secretInput.text {
                destinationVC.key = key
                destinationVC.secret = secret
            }
        }

    }
    
}
