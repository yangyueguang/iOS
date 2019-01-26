//
//  IqiyiViewController.swift
//  Freedom
import UIKit
import XExtension
import MJRefresh
import XCarryOn
class IqiyiHomeModel: NSObject {
    var search_default_word_for_ipad = ""
    var boxes = [AnyHashable]()
    var banner = [AnyHashable]()
    var index_channel_content_version = ""
}
class IqiyiBoxesModel: NSObject {
    var videos = [AnyHashable]()
    var ipad_display_type: NSNumber?
    var index_page_channel_icon = ""
    var display_type: NSNumber?
    var index_page_channel_icon_for_ipad = ""
    var video_count_for_ipad_index_page: NSNumber?
    var cid = ""
    var title = ""
    var sub_title = ""
    var redirect_type = ""
    var url_for_more_link = ""
    var is_podcast = ""
    var height: Float = 0.0
}
class IqiyiBannerModel: NSObject {
    var is_albumcover: NSNumber?
    var image_1452_578 = ""
    var image_800_450 = ""
    var platform_for_url_type = ""
    var title = ""
    var url = ""
    var url_include_ids_count: NSNumber?
    var vip_information: NSObject?
    var plid = ""
    var short_desc = ""
    var image_726_289 = ""
    var iid = ""
    var small_img = ""
    var game_information: NSObject?
    var aid = ""
    var image_640_310 = ""
    var big_img = ""
    var type = ""
    var browser_for_url_type: NSNumber?
}
class IqiyiVideosModel: NSObject {
    var yaofeng = ""
    var is_albumcover: NSNumber?
    var pv = ""
    var corner_image = ""
    var title = ""
    var url = ""
    var url_include_ids_count: NSNumber?
    var owner_nick = ""
    var short_desc = ""
    var game_information: NSObject?
    var iid = ""
    var small_img = ""
    var stripe_b_r = ""
    var plid = ""
    var aid = ""
    var owner_id = ""
    var type = ""
    var image_800x450 = ""
    var big_img = ""
}
protocol IqiyiHomeBoxCellDelegate: NSObjectProtocol {
    func didSelectHomeBox(_ video: IqiyiVideosModel?)
}
protocol IqiyiImageCardViewDelegate: NSObjectProtocol {
    func didSelectImageCard(_ imageCard: IqiyiImageCardView?, video: IqiyiVideosModel?)
}
class IqiyiImageCardView: UIView {
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var pvLabel: UILabel?
    var yaofengLabel: UILabel?
    var video: IqiyiVideosModel?
    weak var delegate: IqiyiImageCardViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.size.width - 5, height: frame.size.height - 45))
        if let aView = imageView {
            addSubview(aView)
        }
        //
        titleLabel = UILabel(frame: CGRect(x: 5, y: frame.size.height - 40, width: frame.size.width - 5, height: 20))
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleLabel?.textColor = UIColor.black
        titleLabel?.lineBreakMode = .byTruncatingTail
        //        self.titleLabel.text = video.title;
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }
        //
        pvLabel = UILabel(frame: CGRect(x: 5, y: frame.size.height - 20, width: frame.size.width - 5, height: 20))
        pvLabel?.font = UIFont.systemFont(ofSize: 11)
        pvLabel?.textColor = UIColor.lightGray
        addSubview(pvLabel!)
        //
        yaofengLabel = UILabel(frame: CGRect(x: 10, y: frame.size.height - 60, width: frame.size.width - 10, height: 20))
        yaofengLabel?.font = UIFont.systemFont(ofSize: 11)
        yaofengLabel?.textColor = UIColor.white
        //        self.yaofengLabel.text = video.yaofeng;
        addSubview(yaofengLabel!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapImageCard(_:)))
        addGestureRecognizer(tap)
        
    }
    init(frame: CGRect, video: IqiyiVideosModel?) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.size.width - 5, height: frame.size.height - 45))
        if let aView = imageView {
            addSubview(aView)
        }
        //
        titleLabel = UILabel(frame: CGRect(x: 5, y: frame.size.height - 40, width: frame.size.width - 5, height: 20))
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleLabel?.textColor = UIColor.black
        titleLabel?.lineBreakMode = .byTruncatingTail
        //        self.titleLabel.text = video.title;
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }
        //
        pvLabel = UILabel(frame: CGRect(x: 5, y: frame.size.height - 20, width: frame.size.width - 5, height: 20))
        pvLabel?.font = UIFont.systemFont(ofSize: 11)
        pvLabel?.textColor = UIColor.lightGray
        addSubview(pvLabel!)
        //
        yaofengLabel = UILabel(frame: CGRect(x: 10, y: frame.size.height - 60, width: frame.size.width - 10, height: 20))
        yaofengLabel?.font = UIFont.systemFont(ofSize: 11)
        yaofengLabel?.textColor = UIColor.white
        //        self.yaofengLabel.text = video.yaofeng;
        addSubview(yaofengLabel!)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setVideo(_ video: IqiyiVideosModel?) {
        self.video = video
        //这里不能用self.video,只能用_video
        imageView?.sd_setImage(with: URL(string: video?.small_img ?? ""), placeholderImage: UIImage(named: "rec_holder"))
        titleLabel?.text = video?.title
        if (video?.type == "playlist") {
            pvLabel?.text = video?.pv
            if (video?.yaofeng == "") {
                yaofengLabel?.text = video?.stripe_b_r
            } else {
                yaofengLabel?.text = video?.yaofeng
            }
        } else {
            if (video?.short_desc == "") {
                pvLabel?.text = video?.pv
            } else {
                pvLabel?.text = video?.short_desc
            }
            yaofengLabel?.text = video?.stripe_b_r
        }
    }
    @objc func onTapImageCard(_ sender: UITapGestureRecognizer?) {
        Dlog(video)
        delegate?.didSelectImageCard(self, video: video)
    }
}
class IqiyiHomeBoxCell: UITableViewCell,IqiyiImageCardViewDelegate {
    private var titleLabel: UILabel?
    private var iconV : UIImageView!
    private var cardView1: IqiyiImageCardView!
    private var cardView2: IqiyiImageCardView!
    private var cardView3: IqiyiImageCardView!
    private var cardView4: IqiyiImageCardView!
    var boxes: IqiyiBoxesModel?
    weak var delegate: IqiyiHomeBoxCellDelegate?
    func ainit(tableView: UITableView?) {
        let menuID = "JFHomeBoxCell"
        var cell = tableView?.dequeueReusableCell(withIdentifier: menuID) as? IqiyiHomeBoxCell
        if cell == nil {
            cell = IqiyiHomeBoxCell(style: .default, reuseIdentifier: menuID)
        }
        cell?.selectionStyle = .none
    }
    func initViews() {
        //背景
        let backView = UIView(frame: CGRect(x: 0, y: 5, width: APPW, height: 40 + 300))
        backView.backgroundColor = UIColor.white
        addSubview(backView)
        //头
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 40))
        backView.addSubview(headView)
        //
        iconV = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        backView.addSubview(imageView!)
        //
        titleLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 100, height: 40))
        titleLabel?.textColor = blacktextcolor
        headView.addSubview(titleLabel!)
        //
        let lineView = UIView(frame: CGRect(x: 5, y: 38, width: APPW - 10, height: 1))
        lineView.backgroundColor = .gray
        backView.addSubview(lineView)
        //图
        cardView1 = IqiyiImageCardView(frame: CGRect(x: 0, y: 40, width: (APPW - 5) / 2, height: 150))
        cardView2 = IqiyiImageCardView(frame: CGRect(x: (APPW - 5) / 2, y: 40, width: (APPW - 5) / 2, height: 150))
        cardView3 = IqiyiImageCardView(frame: CGRect(x: 0, y: 40 + 150, width: (APPW - 5) / 2, height: 150))
        cardView4 = IqiyiImageCardView(frame: CGRect(x: (APPW - 5) / 2, y: 40 + 150, width: (APPW - 5) / 2, height: 150))
        cardView1.tag = 100
        cardView2.tag = 101
        cardView3.tag = 102
        cardView4.tag = 103
        cardView1.delegate = self
        cardView2.delegate = self
        cardView3.delegate = self
        cardView4.delegate = self
        backView.addSubview(cardView1)
        backView.addSubview(cardView2)
        backView.addSubview(cardView3)
        backView.addSubview(cardView4)
    }
    func setBoxes(_ boxes: IqiyiBoxesModel?) {
        titleLabel?.text = boxes?.title
        imageView?.sd_setImage(with: URL(string: boxes?.index_page_channel_icon ?? ""), placeholderImage: nil)
        let video1 = IqiyiVideosModel.parse(boxes?.videos[0] as! NSDictionary)
        let video2 = IqiyiVideosModel.parse(boxes?.videos[1] as! NSDictionary)
        let video3 = IqiyiVideosModel.parse(boxes?.videos[2] as! NSDictionary)
        let video4 = IqiyiVideosModel.parse(boxes?.videos[3] as! NSDictionary)
        //    [_cardView1 setVideo:video1];
        cardView1.video = video1
        cardView2.video = video2
        cardView3.video = video3
        cardView4.video = video4
    }
    func didSelectImageCard(_ imageCard: IqiyiImageCardView?, video: IqiyiVideosModel?) {
        delegate?.didSelectHomeBox(video)
    }
        
}
class IqiyiHomeVideoBoxCell: UITableViewCell {
    var boxes: IqiyiBoxesModel?
    
    private var titleLabel: UILabel!
    private var icon: UIImageView!
    private var cardView1: IqiyiImageCardView!
    private var cardView2: IqiyiImageCardView!
    private var cardView3: IqiyiImageCardView!
    private var cardView4: IqiyiImageCardView!
    private var cardView5: IqiyiImageCardView!
    private var cardView6: IqiyiImageCardView!
    func initViews() {
        //背景
        let backView = UIView(frame: CGRect(x: 0, y: 5, width: APPW, height: 40 + 230 + 230))
        backView.backgroundColor = UIColor.white
        addSubview(backView)
        //头
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 40))
        backView.addSubview(headView)
        //
        icon = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        backView.addSubview(icon)
        //
        titleLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 100, height: 40))
        titleLabel.textColor = gradtextcolor
        headView.addSubview(titleLabel)
        //
        let lineView = UIView(frame: CGRect(x: 5, y: 38, width: APPW - 10, height: 1))
        lineView.backgroundColor = .gray
        backView.addSubview(lineView)
        //图
        cardView1 = IqiyiImageCardView(frame: CGRect(x: 0, y: 40, width: (APPW - 5) / 3, height: 230))
        cardView2 = IqiyiImageCardView(frame: CGRect(x: (APPW - 5) / 3, y: 40, width: (APPW - 5) / 3, height: 230))
        cardView3 = IqiyiImageCardView(frame: CGRect(x: (APPW - 5) * 2 / 3, y: 40, width: (APPW - 5) / 3, height: 230))
        cardView4 = IqiyiImageCardView(frame: CGRect(x: 0, y: 40 + 230, width: (APPW - 5) / 3, height: 230))
        cardView5 = IqiyiImageCardView(frame: CGRect(x: (APPW - 5) / 3, y: 40 + 230, width: (APPW - 5) / 3, height: 230))
        cardView6 = IqiyiImageCardView(frame: CGRect(x: (APPW - 5) * 2 / 3, y: 40 + 230, width: (APPW - 5) / 3, height: 230))
        backView.addSubview(cardView1)
        backView.addSubview(cardView2)
        backView.addSubview(cardView3)
        backView.addSubview(cardView4)
        backView.addSubview(cardView5)
        backView.addSubview(cardView6)
    }
    func setBoxes(_ boxes: IqiyiBoxesModel?) {
        titleLabel.text = boxes?.title
        imageView?.sd_setImage(with: URL(string: boxes?.index_page_channel_icon ?? ""), placeholderImage: nil)
        let video1 = IqiyiVideosModel.parse(boxes?.videos[0] as! NSDictionary)
        let video2 = IqiyiVideosModel.parse(boxes?.videos[1] as! NSDictionary)
        let video3 = IqiyiVideosModel.parse(boxes?.videos[2] as! NSDictionary)
        let video4 = IqiyiVideosModel.parse(boxes?.videos[3] as! NSDictionary)
        let video5 = IqiyiVideosModel.parse(boxes?.videos[4] as! NSDictionary)
        let video6 = IqiyiVideosModel.parse(boxes?.videos[5] as! NSDictionary)
        cardView1.video = video1
        cardView2.video = video2
        cardView3.video = video3
        cardView4.video = video4
        cardView5.video = video5
        cardView6.video = video6
    }
}
class IqiyiViewController: IqiyiBaseViewController ,IqiyiHomeBoxCellDelegate {
        var homeTableView: UITableView?
        
        private var dataSource = [AnyHashable]()
        private var boxesSource = [AnyHashable]()
        private var bannerSource = [AnyHashable]()
        private var headImageArray = [AnyHashable]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initNav()
        initView()
        setUpRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func setUpRefresh() {
        homeTableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {() -> Void in
            self.initData()
        })
        homeTableView?.mj_header.beginRefreshing()
    }
    func initNav() {
        let leftBarButtonItem = UIBarButtonItem(image:  UIImage(named:"qylogo_p"), style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightUploadBarButtonItem = UIBarButtonItem(image: UIImage(named:"wcamera"), style: .done, target: nil, action: nil)
        let rightHistoryBarButtonItem = UIBarButtonItem(image: UIImage(named:"whistory"), style: .plain, target: self, action: #selector(self.rightHistoryBarButtonItemClick))
        let rightSearchBarButtonItem = UIBarButtonItem(image: UIImage(named:"wsearch"), style: .plain, target: self, action: #selector(self.rightSearchBarButtonItemClick))
        navigationItem.rightBarButtonItems = [rightSearchBarButtonItem, rightUploadBarButtonItem, rightHistoryBarButtonItem] as? [UIBarButtonItem]
    }
    /*搜索*/
    
    func rightSearchBarButtonItemClick() {
        let searchHistoryVC = IqiyiSearchHistoryViewController()
        navigationController?.pushViewController(searchHistoryVC, animated: true)
    }
    
    func rightHistoryBarButtonItemClick() {
        let watchRecordVC = IqiyiWatchRecordViewController()
        navigationController?.pushViewController(watchRecordVC, animated: true)
    }
    func initData() {
        dataSource = [AnyHashable]()
        boxesSource = [AnyHashable]()
        bannerSource = [AnyHashable]()
        headImageArray = [AnyHashable]()
//        let urlStr = urlWithHomeData
//        [AFHTTPSessionManager manager].get(urlStr, parameters: nil, progress: nil, success: {(_ task: URLSessionDataTask, _ responseObject: Any?) -> Void in
//            self.homeTableView.mj_header.endRefreshing()
//            headImageArray.removeAll()
//            let homeModel = JFHomeModel.mj_object(withKeyValues: responseObject)
//            var boxesArray = [AnyHashable]()
//            var bannerArray = [AnyHashable]()
//            var i = 0
//            while i < homeModel.boxes.count {
//                var boxesModel = JFBoxesModel.mj_object(withKeyValues: homeModel.boxes[i])
//                boxesModel.height = self.getHeight(boxesModel)
//                boxesArray.append(boxesModel)
//            }
//            for j in 0..<homeModel.banner.count {
//                var bannerModel = JFBannerModel.mj_object(withKeyValues: homeModel.banner[j])
//                bannerArray.append(bannerModel)
//                headImageArray.append(bannerModel.small_img)
//            }
//            boxesSource = boxesArray
//            bannerSource = bannerArray
//            homeTableView.reloadData()
//        }
    }
    func initView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64), style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsets.zero
        homeTableView = tableView
        view.addSubview(homeTableView!)
    }
    func getHeight(_ boxes: IqiyiBoxesModel?) -> Float {
        var height: Float = 0
        height = height + 40
        if boxes?.display_type ?? 0 == 1 {
            height = height + 2 * 150
            return height + 5
        } else if boxes?.display_type ?? 0 == 2 {
            height = height + 2 * 230
            return height + 5
        } else {
            return height + 5
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 180
        } else {
            let height: CGFloat? = CGFloat(((boxesSource[indexPath.row - 1] as? IqiyiBoxesModel)?.height)!)
            return height ?? 0.0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bannerSource.count > 0 {
            return boxesSource.count + 1
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let box: IqiyiBoxesModel? = boxesSource[indexPath.row - 1] as? IqiyiBoxesModel
        if box?.display_type ?? 0 == 1 {
            let cell = IqiyiHomeBoxCell(style: .default, reuseIdentifier: "")
            cell.boxes = boxesSource[indexPath.row - 1] as? IqiyiBoxesModel
            cell.delegate = self
            return cell
        } else if box?.display_type ?? 0 == 2 {
            let cell = IqiyiHomeVideoBoxCell(style: .default, reuseIdentifier: "")
            cell.initViews()
            cell.boxes = box
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func didSelectHomeBox(_ video: IqiyiVideosModel?) {
        let videoDetailVC = IqiyiVideoDetailViewController()
        videoDetailVC.iid = (video?.iid)!
        navigationController?.pushViewController(videoDetailVC, animated: true)
    }
    
}
