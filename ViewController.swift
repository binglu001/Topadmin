//
//  ViewController.swift
//  Topadmin
//
//  Created by james on 14-10-4.
//  Copyright (c) 2014年 woowen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var uNameLabel: UITextField!
    
    @IBOutlet weak var pwdLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        uNameLabel.resignFirstResponder()
        pwdLabel.resignFirstResponder()
        
    }
    @IBAction func LoginBtn(sender: AnyObject) {
        
    }

}

