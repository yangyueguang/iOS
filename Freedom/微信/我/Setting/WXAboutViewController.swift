////
////  WXAboutViewController.swift
////  Freedom
//
//import Foundation
//class WXAboutHelper: NSObject {
//    var abouSettingtData: [WXSettingGroup] = []
//    override init() {
//        super.init()
//        let item1 = WXSettingItem.createItem(withTitle: ("去评分"))
//        let item2 = WXSettingItem.createItem(withTitle: ("欢迎页"))
//        let item3 = WXSettingItem.createItem(withTitle: ("功能介绍"))
//        let item4 = WXSettingItem.createItem(withTitle: ("系统通知"))
//        let item5 = WXSettingItem.createItem(withTitle: ("举报与投诉"))
//        let group1: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([item1, item2, item3, item4, item5]))
//        abouSettingtData.append(contentsOf: [group1])
//    }
//}
//
//class WXAboutHeaderView: UITableViewHeaderFooterView {
//    var title = "" {
//        didSet {
//            titleLabel.text = title
//        }
//    }
//    var imagePath = "" {
//        didSet {
//            imageView.image = UIImage(named: imagePath)
//        }
//    }
//    var imageView = UIImageView()
//    lazy var titleLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.font = UIFont.systemFont(ofSize: 17.0)
//        titleLabel.textColor = UIColor.gray
//        titleLabel.textAlignment = .center
//        return titleLabel
//    }()
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(imageView)
//        contentView.addSubview(titleLabel)
////        imageView.mas_makeConstraints({ make in
////            make.top.mas_equalTo(self.contentView).mas_offset(4)
////            make.centerX.mas_equalTo(self.contentView)
////            make.bottom.mas_equalTo(self.titleLabel.mas_top).mas_equalTo(1)
////            make.width.mas_equalTo(self.imageView.mas_height).multipliedBy(1.13)
////        })
////        titleLabel.mas_makeConstraints({ make in
////            make.bottom.mas_equalTo(self.contentView).mas_offset(-10)
////            make.left.and().right().mas_equalTo(self.contentView)
////            make.height.mas_equalTo(25)
////        })
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}
//
//class WXAboutViewController: WXSettingViewController {
//    var helper = WXAboutHelper()
//    lazy var cmpLabel: UILabel = {
//        let cmpLabel = UILabel()
//        cmpLabel.text = "高仿微信 仅供学习\nhttps://github.com/tbl00c/TLChat"
//        cmpLabel.textAlignment = .center
//        cmpLabel.textColor = UIColor.gray
//        cmpLabel.font = UIFont.systemFont(ofSize: 12.0)
//        cmpLabel.numberOfLines = 2
//        return cmpLabel
//    }()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = "关于微信"
//        helper = WXAboutHelper()
//        data = helper.abouSettingtData
//        tableView.register(WXAboutHeaderView.self, forHeaderFooterViewReuseIdentifier: "TLAboutHeaderView")
//        tableView.tableFooterView?.addSubview(cmpLabel)
////        cmpLabel().mas_makeConstraints({ make in
////            make.left.and().right().mas_equalTo(self.tableView.tableFooterView)
////            make.bottom.mas_equalTo(self.tableView.tableFooterView).mas_offset(-1)
////        })
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let footerHeight = Float(APPH - tableView.contentSize.height - CGFloat(TopHeight) - 15)
//        var rec: CGRect = tableView.tableFooterView?.frame ?? CGRect.zero
//        rec.size.height = CGFloat(footerHeight)
//        tableView.tableFooterView?.frame = rec
//    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLAboutHeaderView") as! WXAboutHeaderView
//            headerView.imagePath = "AppLogo"
//            let shortVersion = Bundle.main.infoDictionary["CFBundleShortVersionString"] as String
//            let buildID = Bundle.main.infoDictionary["CFBundleVersion"] as String
//            let version = "\(shortVersion) (\(buildID))"
//            headerView.title = "微信 TLChat \(version)"
//            return headerView
//        }
//        return nil
//    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 100
//        }
//        return 0
//    }
//}
