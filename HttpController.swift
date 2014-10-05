//
//  HttpController.swift
//  Topadmin
//
//  Created by james on 14-10-4.
//  Copyright (c) 2014年 woowen. All rights reserved.
//

import Foundation

protocol HttpProtocol{
    func didRecieveResult(result: NSDictionary)
}
class HttpController: NSObject{
    
    var delegate: HttpProtocol?
    
    func onSearchUrl(url: String){
        var nsUrl: NSURL = NSURL(string: url)
        var request: NSURLRequest = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!)->Void in
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            self.delegate?.didRecieveResult(jsonResult)
            
        })
    }
}