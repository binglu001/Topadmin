import UIKit

class ListvController: UIViewController ,UITableViewDataSource,UITableViewDelegate,HttpProtocol,UIScrollViewDelegate{
    
    var eHttp: HttpController = HttpController()
    @IBOutlet weak var searchObj: UISearchBar!
    var listData: NSArray = NSArray()
    var imageCache = Dictionary<String,UIImage>()
    var tid: String = ""

    
    let cellImage = 1
    let cellLabel1 = 2
    let cellLabel2 = 3
    let cellLabel3 = 4
    
    let refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let timeLineUrl = "http://top.mogujie.com/app_top_v142_timeline/pubtimeline?_uid=1jf4k&_swidth=720&timestamp=1412437672&_channel=NAOtop&_atype=android&_mgj=541648ca87e6ca9e8d9a1790639c34351412437672&_sdklevel=18&_network=2&sign=pZqBZDt0XE1Ss7UX0u6UxfYr1RtfyOuyU04ahLrLpHGuJEDWSRfBiWCISM7YBEGWO%2BhjijAT7CVtlxe%2FAPl%2BNA%3D%3D&mbook=&_aver=142&_fs=NAOtop142&_did=99000537220553&_source=NAOtop142"
        
        
        eHttp.delegate = self
        eHttp.onSearchUrl(timeLineUrl)

        //添加下拉刷新手势

        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松手刷新新闻")
        tableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return listData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
//        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "list")
//        
//        let rowData: NSDictionary = self.listData[indexPath.row] as NSDictionary
//        cell.textLabel?.text = rowData["cover"] as String
//        cell.detailTextLabel?.text = rowData["content"] as NSString
//        cell.imageView?.image = UIImage(named: "http://s8.mogucdn.com//b7//pic//141004//1e12tm_ieygmzbsmyydem3cmmytambqmmyde_512x343.jpg_640x690.jpg")
//
//        return cell
        
        let cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier("list", forIndexPath: indexPath)
        
        let rowData: NSDictionary = self.listData[indexPath.row] as NSDictionary

        
        var img = cell?.viewWithTag(cellImage) as UIImageView
        
        img.image = UIImage(named: "default.jpg")
        let url = rowData["cover"] as String
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

        var label1 = cell?.viewWithTag(cellLabel1) as UILabel
        var label2 = cell?.viewWithTag(cellLabel2) as UILabel
        var label3 = cell?.viewWithTag(cellLabel3) as UILabel
        //label换行
        label1.numberOfLines = 0
        label1.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        label1.text = rowData["content"] as NSString
        label2.text = rowData["user"]?["uname"] as NSString

        var outputFormat = NSDateFormatter()
        outputFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
        outputFormat.locale = NSLocale(localeIdentifier: "shanghai")
        //发布时间
        let pubTime = NSDate(timeIntervalSince1970: rowData["pubTime"] as NSTimeInterval)
        label3.text = outputFormat.stringFromDate(pubTime)
        //变量赋值为tid

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

        if (result["result"] != nil){
            self.listData = result["result"]?["list"] as NSArray
            //println(self.listData)
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
        self.refreshControl.endRefreshing()
    }



    
}