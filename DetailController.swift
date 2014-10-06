//
//  DetailController.swift
//  Topadmin
//
//  Created by james on 14-10-6.
//  Copyright (c) 2014年 woowen. All rights reserved.
//
import UIKit

class DetailController: UIViewController,HttpProtocol,UIWebViewDelegate {
    
    
    @IBOutlet weak var webView: UIWebView!
    var eHttp: HttpController = HttpController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let timeLineUrl = "http://top.mogujie.com/app_top_v142_twitter/note?_uid=1jf4k&_swidth=720&timestamp=1412602346&_channel=NAOtop&_atype=android&_mgj=d81f70fe2c5500d57fb2fe69eb03a4f11412602346&_sdklevel=18&_network=2&sign=zT6KqyEMlt9fF9oqROC626raReJVEQNl%2F1wEq%2FMb14euJEDWSRfBiWCISM7YBEGWO%2BhjijAT7CVtlxe%2FAPl%2BNA%3D%3D&tid=11tv0&_aver=142&_fs=NAOtop142&_did=99000537220553&_source=NAOtop142"
        eHttp.delegate = self
        eHttp.onSearchUrl(timeLineUrl)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didRecieveResult(result: NSDictionary){
        webView.delegate = self
        
        if result["result"] != nil{
            var url = NSURL(string: "http://top.mogujie.com/top/share/note?tid=11ts8")
            var request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    func webViewDidStartLoad(webView: UIWebView){
        NSLog("webViewDidStartLoad")
     }
        
    func webViewDidFinishLoad(webView: UIWebView){
        NSLog("webViewDidStartLoad")
        println(1231231)
    }
        
    }
}