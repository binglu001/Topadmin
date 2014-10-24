import UIKit

class normalPoolController: UIViewController ,UITableViewDataSource,UITableViewDelegate,HttpProtocol,UIScrollViewDelegate{
    
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
    
    var timeLineUrl = "http://top.mogujie.com/top/zadmin/app/index?sign=Mx3KdFcp1pGbaU4PLk82p9sAON6%2FXfJwJjiKf%2FjNMD8J3YyXyjPQS%2FUUQmMMjduXNoZXMsS6cXMF66wmRMs%2Bsw%3D%3D"
    
    //   @IBOutlet weak var imageView: UIView!
    //    @IBOutlet weak var tableView: UITableView!
    
    
    
//    @IBOutlet var imageView: UIView!
//    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var imageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupRefresh(){
        self.tableView.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
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
                self.tableView.footerEndRefreshing()
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        eHttp.delegate = self
        eHttp.onSearchUrl(timeLineUrl)
        self.setupRefresh()
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
            }
        }
        return listData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier("list", forIndexPath: indexPath)
        
        
        let rowData: NSDictionary = self.listData[indexPath.row] as NSDictionary
        
        
        var img = cell?.viewWithTag(cellImage) as UIImageView
        
        img.image = UIImage(named: "default.png")
        
        let url = rowData["cover"] as String!
        
        if (url != ""){
            let image = self.imageCache[url] as UIImage?
            if !(image != nil){
                let imageUrl:NSURL = NSURL(string:url)
                
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
        
    }
    
    func didRecieveResult(result: NSDictionary){
        
        if (result["result"]?["list"] != nil && result["result"]?["isEnd"] as NSNumber != 1){
            self.tmpListData = result["result"]?["list"] as NSMutableArray  //list主要数据
            self.pager = result["result"]?["page"] as NSNumber  //分页显示
            self.tableView.reloadData()
        }
    }
    
    //滚动list的时候隐藏键盘
    func scrollViewDidScroll(scrollView: UIScrollView){
        //searchObj.resignFirstResponder()
    }
    
    //下拉刷新方法
    func refreshData() {
        self.tableView.reloadData()
    }
    
    
    
    
}