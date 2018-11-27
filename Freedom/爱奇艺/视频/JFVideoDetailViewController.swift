//
//  JFVideoDetailViewController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
class JFVideoDetailModel: NSObject {
    var total_vv = ""
    var duration: NSNumber?
    var total_comment: NSNumber?
    var img = ""
    var title = ""
    var play_url = ""
    var channel_pic = ""
    var cats = ""
    var plid = ""
    var isVuser = ""
    var type = ""
    var username = ""
    var format_flag: NSNumber?
    var img_hd = ""
    var iid = ""
    var subed_num: NSNumber?
    var item_id = ""
    var user_desc = ""
    var desc = ""
    var user_play_times = ""
    var stripe_bottom = ""
    var cid: NSNumber?
    var userid: NSNumber?
    var total_fav: NSNumber?
    var limit: NSNumber?
    var item_media_type = ""
}
class JFRecommentModel: NSObject {
    var total_pv: NSNumber?
    var pubdate = ""
    var img_16_9 = ""
    var pv_pr = ""
    var duration: NSNumber?
    var pv = ""
    var total_comment: NSNumber?
    var img = ""
    var title = ""
    var state = ""
    var cats = ""
    var username = ""
    var tags = [AnyHashable]()
    var img_hd = ""
    var itemCode = ""
    var total_down = ""
    var total_up = ""
    var desc = ""
    var stripe_bottom = ""
    var userid = ""
    var total_fav: NSNumber?
    var reputation = ""
    var limit = ""
    var time = ""
}
class JFRecommentVideoCell:BaseTableViewCell{

    let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    let titleLabel = UILabel(frame: CGRect(x: 100, y: 10, width: 200, height: 20))
    let timeLabel = UILabel(frame: CGRect(x: 100, y: 40, width: 200, height: 20))
    let pvLabel = UILabel(frame: CGRect(x: APPW - 100, y: 20, width: 80, height: 20))
    override func initUI() {
        self.addSubviews([iconImageView, titleLabel, timeLabel,pvLabel])
    }

    func setRecommentModel(_ recommentModel: JFRecommentModel?) {
        iconImageView.sd_setImage(with: URL(string: recommentModel?.img ?? ""), placeholderImage: UIImage(named: "rec_holder"))
        titleLabel.text = recommentModel?.title
        pvLabel.text = recommentModel?.pv_pr
        timeLabel.text = recommentModel?.time
        iconImageView.image = UIImage(named: "userLogo")
        titleLabel.text = "title"
        timeLabel.text = "time"
        pvLabel.text = "pvlabel"
    }

}
class JFVideoDetailCell: UITableViewCell {
    var iconImageView: UIImageView?
    var userNameLabel: UILabel?
    var playItemsLabel: UILabel?
    var userDesLabel: UILabel?
    var subscribeButton: UIButton?
    var subedNumberLabel: UILabel?
    var titleLabel: UILabel?
    var descLabel: UILabel?
    var videoDetailModel: JFVideoDetailModel?
    func setVideoDetailModel(_ videoDetailModel: JFVideoDetailModel?) {
        self.videoDetailModel = videoDetailModel
        iconImageView?.sd_setImage(with: URL(string: videoDetailModel?.channel_pic ?? ""), placeholderImage: UIImage(named: "tudoulogo"))
        userNameLabel?.text = videoDetailModel?.username
        if let aTimes = videoDetailModel?.user_play_times {
            playItemsLabel?.text = "播放：\(aTimes)"
        }
        userDesLabel?.text = videoDetailModel?.user_desc
        subedNumberLabel?.text = "\(videoDetailModel?.subed_num ?? 0)人订阅"
        titleLabel?.text = videoDetailModel?.title
        descLabel?.text = videoDetailModel?.desc
    }

}
class IqiyiVideoDetailViewController: IqiyiBaseViewController {
    
        var videoDetailTableView: UITableView?
        var videoDetailWebView: UIWebView?
        var iid = ""
        
        private var videoDM: JFVideoDetailModel?
        private var recommendArray = [AnyHashable]()
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        //用push方法推出时，Tabbar隐藏
        loadVideoDetailData()
        loadRecommentData()
        initTableView()
        initWebView()
        initNav()
    }
    
    func initNav() {
        navigationController?.navigationBar.isHidden = true
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 20))
        backView.backgroundColor = UIColor.black
        view.addSubview(backView)
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 15, y: 20, width: 30, height: 30)
        backBtn.addTarget(self, action: Selector("OnBackBtn:"), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "cellLeft"), for: .normal)
        view.addSubview(backBtn)
    }
    func initTableView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 220, width: APPW, height: APPH - 220), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsets.zero
        videoDetailTableView = tableView
        view.addSubview(videoDetailTableView!)
    }
    
    // MARK: - 初始化webView
    func initWebView() {
        videoDetailWebView = UIWebView(frame: CGRect(x: 0, y: 20, width: APPW, height: 220))
        view.addSubview(videoDetailWebView!)
    }
    
    func onBackBtn(_ sender: UIButton?) {
        navigationController?.popViewController(animated: true)
    }
    func loadVideoDetailData() {
        self.videoDM = JFVideoDetailModel()
        recommendArray = [AnyHashable]()
//        let urlStr = FreedomTools.sharedManager().url(withVideoDetailData: iid)
//            [AFHTTPSessionManager manager].get(url, parameters: nil, progress: nil, success: {(_ task: URLSessionDataTask, _ responseObject: Any?) -> Void in
//                let videoDM = JFVideoDetailModel.mj_object(withKeyValues: responseObject?["detail"])
//                self.videoDM = videoDM
//                let videoUrl = FreedomTools.shared().url(withVideo: self.iid)
//                if let anUrl = URL(string: videoUrl) {
//                    self.videoDetailWebView.loadRequest(URLRequest(url: anUrl))
//                }
//                self.videoDetailTableView.reloadData()
//            }, failure: {(_ task: URLSessionDataTask?, _ error: Error) -> Void in
//            })
    }
    func loadRecommentData() {
        let urlStr = FreedomTools.sharedManager().url(withRecommentdata: iid)
        let url = (urlStr! as NSString)//.addingPercentEscapes(using: .utf8)
//        [AFHTTPSessionManager manager].get(url, parameters: nil, progress: nil, success: {(_ task: URLSessionDataTask, _ responseObject: Any?) -> Void in
//            //这个地方要先移除模型数组里面数据
//            recommendArray.removeAll()
//            var resultArray = responseObject?["results"] as? [AnyHashable]
//            var i = 0
//            while i < (resultArray?.count ?? 0) {
//                let recommendM = JFRecommentModel.mj_object(withKeyValues: resultArray[i])
//                recommendM.time = self.convertTime(recommendM.duration)
//                recommendArray.append(recommendM)
//                i
//            }
//            i += 1
//            self.videoDetailTableView.reloadData()
//        }, failure: {(_ task: URLSessionDataTask?, _ error: Error) -> Void in
//        })
    }
    func convertTime(_ time: Int) -> String? {
        let currentSeconds = Float64(time)
        var mins = Int(currentSeconds / 60.0)
        let hours = Int(Double(mins) / 60.0)
        let secs: Int = Int(fmodf(Float(currentSeconds), 60.0))
        mins = Int(fmodf(Float(mins), 60.0))
        let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
        let minsString = mins < 10 ? "0\(mins)" : "\(mins)"
        let secsString = secs < 10 ? "0\(secs)" : "\(secs)"
        if hours == 0 {
            return "\(minsString):\(secsString)"
        } else {
            return "\(hoursString):\(minsString):\(secsString)"
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        } else {
            return 75
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let ID = "JFVideoDetailCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? JFVideoDetailCell
            if cell == nil {
                cell = JFVideoDetailCell(style: .default, reuseIdentifier: ID)
                cell?.iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
                cell?.userNameLabel = UILabel(frame: CGRect(x: 80, y: 0, width: 200, height: 20))
                cell?.playItemsLabel = UILabel(frame: CGRect(x: 80, y: 20, width: 200, height: 20))
                cell?.userDesLabel = UILabel(frame: CGRect(x: 200, y: 10, width: 100, height: 20))
                cell?.subscribeButton = UIButton(frame: CGRect(x: 200, y: 30, width: 100, height: 30))
                cell?.subedNumberLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 20))
                cell?.titleLabel = UILabel(frame: CGRect(x: 0, y: 120, width: 100, height: 20))
                cell?.descLabel = UILabel(frame: CGRect(x: 0, y: 140, width: 100, height: 20))
                cell?.subscribeButton?.backgroundColor = UIColor.green
                cell?.addSubviews([(cell?.iconImageView)!, (cell?.userNameLabel)!, (cell?.playItemsLabel)!, (cell?.userDesLabel)!, (cell?.subscribeButton)!, (cell?.subedNumberLabel)!, (cell?.titleLabel)!, (cell?.descLabel)!])
            }
            cell?.selectionStyle = .none
            if (videoDM != nil) {
                cell?.videoDetailModel = videoDM
            }
            return cell!
        } else {
            let ID = "JFRecommentVideoCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? JFRecommentVideoCell
            if cell == nil {
                // 从xib中加载cell
                cell = JFRecommentVideoCell(style: .default, reuseIdentifier: ID)
            }
            cell?.selectionStyle = .none
//            cell.setRecommentModel = recommendArray[indexPath.row - 1]
            return cell!
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
//            let recommendM: JFRecommentModel? = recommendArray[indexPath.row - 1]
//            iid = recommendM?.itemCode
            DispatchQueue.main.async(execute: {() -> Void in
                self.loadVideoDetailData()
                self.loadRecommentData()
            })
        }
    }

    
    
}
