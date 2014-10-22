import UIKit

class ListvController: UIViewController ,UITableViewDataSource,UITableViewDelegate,HttpProtocol,UIScrollViewDelegate{
    
    var eHttp: HttpController = HttpController()
    @IBOutlet weak var searchObj: UISearchBar!
    var listData: NSMutableArray = NSMutableArray()
    var tmpListData: NSMutableArray = NSMutableArray()
    var pager:Int = 1
    var imageCache = Dictionary<String,UIImage>()
    var tid: String = ""

    
    let cellImage = 1
    let cellLabel1 = 2
    let cellLabel2 = 3
    let cellLabel3 = 4
    
    let refreshControl = UIRefreshControl()
    
 // var timeLineUrl = "http://top.mogujie.com/app_top_v142_timeline/pubtimeline?_uid=1jf4k&_swidth=720&timestamp=1412437672&_channel=NAOtop&_atype=android&_mgj=541648ca87e6ca9e8d9a1790639c34351412437672&_sdklevel=18&_network=2&sign=pZqBZDt0XE1Ss7UX0u6UxfYr1RtfyOuyU04ahLrLpHGuJEDWSRfBiWCISM7YBEGWO%2BhjijAT7CVtlxe%2FAPl%2BNA%3D%3D&mbook=&_aver=142&_fs=NAOtop142&_did=99000537220553&_source=NAOtop142"
    var timeLineUrl = "http://top.mogujie.com/top/zadmin/app/yituijian?sign=Mx3KdFcp1pGbaU4PLk82p9sAON6%2FXfJwJjiKf%2FjNMD8J3YyXyjPQS%2FUUQmMMjduXNoZXMsS6cXMF66wmRMs%2Bsw%3D%3D"
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupRefresh(){
        self.tableView.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.tableView.headerEndRefreshing()
            })
        })
        
        self.tableView.addFooterWithCallback({
            var nextPage = String(self.pager + 1)
            var tmpTimeLineUrl = self.timeLineUrl + "&page=" + nextPage as NSString
            self.eHttp.delegate = self
            self.eHttp.onSearchUrl(tmpTimeLineUrl)
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.tableView.footerEndRefreshing()
                //self.tableView.setFooterHidden(true)
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        eHttp.delegate = self
        eHttp.onSearchUrl(timeLineUrl)
        self.setupRefresh()

//        //添加下拉刷新手势
//        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
//        refreshControl.attributedTitle = NSAttributedString(string: "松手刷新")
//        tableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(self.listData.count == 0){
            if(self.tmpListData.count != 0){
                self.listData = self.tmpListData
            }
        }else{
            if(self.tmpListData.count != 0){
                var tmpListDataCount = self.tmpListData.count
                    for(var i:Int = 0; i < tmpListDataCount; i++){
                        self.listData.addObject(self.tmpListData[i])
                    }
  //              self.tmpListData.removeAllObjects()
            }
        }
        return listData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier("list", forIndexPath: indexPath)

        
        let rowData: NSDictionary = self.listData[indexPath.row] as NSDictionary

        
        var img = cell?.viewWithTag(cellImage) as UIImageView
        
        img.image = UIImage(named: "default.jpg")
        
        let url = rowData["cover"] as String!
        
        if (url != ""){
            let image = self.imageCache[url] as UIImage?
            if !(image != nil){
                let imageUrl:NSURL = NSURL(string:url)
                //println(imageUrl)
                let request: NSURLRequest = NSURLRequest(URL: imageUrl)
                //异步获取
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!)-> Void in
                    let imgTmp = UIImage(data: data)
                    img.image = imgTmp
                    self.imageCache[url] = imgTmp
                })
            }else{
                img.image = image
            }
        }
        var label1 = cell?.viewWithTag(cellLabel1) as UILabel
        var label2 = cell?.viewWithTag(cellLabel2) as UILabel
        var label3 = cell?.viewWithTag(cellLabel3) as UILabel
        //label换行
        label1.numberOfLines = 0
        label1.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        label1.text = rowData["content"]? as NSString
        label2.text = rowData["user"]?["uname"] as NSString

        var outputFormat = NSDateFormatter()
        outputFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
        outputFormat.locale = NSLocale(localeIdentifier: "shanghai")
        //发布时间
        let pubTime = NSDate(timeIntervalSince1970: rowData["pubTime"] as NSTimeInterval)
        label3.text = outputFormat.stringFromDate(pubTime)
        
        return cell as UITableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let trueData: NSDictionary = self.listData[indexPath.row] as NSDictionary
        self.tid = trueData["tid"] as NSString        
        self.performSegueWithIdentifier("detail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            var instance = segue.destinationViewController as DetailController
            instance.timeLineUrl = self.tid
        }
    }
    //返回按钮
    @IBAction func close(segue: UIStoryboardSegue){
//        self.tmpListData.removeAllObjects()
    }
    
    func didRecieveResult(result: NSDictionary){
        if (result["result"] != nil){
            self.tmpListData = result["result"]?["list"] as NSMutableArray
            self.pager = result["result"]?["page"] as NSNumber
            self.tableView.reloadData()
        }
    }
    
    //滚动list的时候隐藏键盘
    func scrollViewDidScroll(scrollView: UIScrollView){
        searchObj.resignFirstResponder()
    }
    
    //下拉刷新方法
    func refreshData() {
        self.tableView.reloadData()
    }



    
}