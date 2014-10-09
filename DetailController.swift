//
//  DetailController.swift
//  Topadmin
//
//  Created by james on 14-10-6.
//  Copyright (c) 2014年 woowen. All rights reserved.
//
import UIKit

class DetailController: UIViewController,HttpProtocol,UIWebViewDelegate {
    
 
    @IBOutlet weak var loadImg: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    var eHttp: HttpController = HttpController()
    var timeLineUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        timeLineUrl = "http://top.mogujie.com/top/share/note?tid=" + timeLineUrl
        var url = NSURL(string: self.timeLineUrl)
        var request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didRecieveResult(result: NSDictionary){
        
    }
    //页面加载前
    func webViewDidStartLoad(webView: UIWebView){
        loadImg.startAnimating()
     }
    
    func webViewDidFinishLoad(webView: UIWebView){
        loadImg.stopAnimating()
        loadImg.removeFromSuperview()
    }
        
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?){
        self.parentViewController?.didMoveToParentViewController(UIViewController())
    }
        
    @IBAction func backBtn(sender: AnyObject) {       
            self.performSegueWithIdentifier("back", sender: self)
    }
        
    
}