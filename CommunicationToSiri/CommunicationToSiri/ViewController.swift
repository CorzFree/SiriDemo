//
//  ViewController.swift
//  CommunicationToSiri
//
//  Created by crw on 2016/10/6.
//  Copyright © 2016年 crw. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    
    @IBOutlet weak var authLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func authClick(_ sender: UIButton) {
        
        INPreferences.requestSiriAuthorization {
            
            switch $0{
            case .authorized:
                self.authLabel.text = "用户已授权"
                break
            case .notDetermined:
                self.authLabel.text = "未决定"
                break
            case .restricted:
                self.authLabel.text = "权限受限制"
                break
            case .denied:
                self.authLabel.text = "拒绝授权"
                break
            }
        }
    }
    
}

