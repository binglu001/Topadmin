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
        self.httpRequest()
        
        
     
        
        
    }
    
    func httpRequest(){
        let manager = AFHTTPRequestOperationManager()
        
        //Top链接
        let url = "http://top.mogujie.com/app_top_v142_login/mobilelogin?_swidth=720&_channel=NAOtop&_atype=android&_sdklevel=18&_network=2&_fs=NAOtop142&_did=99000537220553&_aver=142&_source=NAOtop142"
        
        let params = ["mobile": uNameLabel.text, "pwd": pwdLabel.text]

        manager.responseSerializer.acceptableContentTypes = NSSet().setByAddingObject("text/html")
        //构建Get
        manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("JSON: " + responseObject.description!)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
        
        
        
    }

}

