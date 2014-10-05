//
//  ListController.swift
//  Topadmin
//
//  Created by james on 14-10-4.
//  Copyright (c) 2014年 woowen. All rights reserved.
//

import Foundation
class ListController: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate, HttpProtocol {

    var eHttp: HttpController = HttpController()
    var listData: NSArray = NSArray()
    
    @IBOutlet weak var listView: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return listData.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let timeLineUrl = "http://top.mogujie.com/app_top_v142_timeline/pubtimeline?_uid=1jf4k&_swidth=720&timestamp=1412437672&_channel=NAOtop&_atype=android&_mgj=541648ca87e6ca9e8d9a1790639c34351412437672&_sdklevel=18&_network=2&sign=pZqBZDt0XE1Ss7UX0u6UxfYr1RtfyOuyU04ahLrLpHGuJEDWSRfBiWCISM7YBEGWO%2BhjijAT7CVtlxe%2FAPl%2BNA%3D%3D&mbook=&_aver=142&_fs=NAOtop142&_did=99000537220553&_source=NAOtop142"
        eHttp.delegate = self
        eHttp.onSearchUrl(timeLineUrl)
        
        var cell: UICollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier("listCell", forIndexPath: indexPath) as? UICollectionViewCell
        

        if cell == nil{
            cell = UICollectionViewCell()

        }

        
        let rowData: NSDictionary = self.listData[indexPath.row] as NSDictionary
        return cell!

    }

    

    
    func didRecieveResult(result: NSDictionary){
//        println(result["result"]?["list"])
        
        
        if ((result["result"]?["list"]) != nil){
            self.listData = result["result"]?["list"] as NSArray
            self.listView.reloadData()
        }
        
    }
    
    
    
}