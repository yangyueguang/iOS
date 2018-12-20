//
//  WXAboutViewController.swift
//  Freedom

import Foundation
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXAboutHelper: NSObject {
    var abouSettingtData: [AnyHashable] = []

    override init() {
        //if super.init()

        abouSettingtData = [AnyHashable]()
        p_initTestData()

    }

    func p_initTestData() {
        let item1 = WXSettingItem.createItem(withTitle: ("去评分"))
        let item2 = WXSettingItem.createItem(withTitle: ("欢迎页"))
        let item3 = WXSettingItem.createItem(withTitle: ("功能介绍"))
        let item4 = WXSettingItem.createItem(withTitle: ("系统通知"))
        let item5 = WXSettingItem.createItem(withTitle: ("举报与投诉"))
        let group1: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([item1, item2, item3, item4, item5]))
        abouSettingtData.append(contentsOf: [group1])
    }
}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXAboutHeaderView: UITableViewHeaderFooterView {
    var title = ""
    var imagePath = ""
    var imageView: UIImageView
    var titleLabel: UILabel

    override init(reuseIdentifier: String) {
        //if super.init(reuseIdentifier: reuseIdentifier)

        if let aView = imageView {
            contentView.addSubview(aView)
        }
        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        p_addMasonry()

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func setTitle(_ title: String) {
        self.title = title
        titleLabel.text = title
    }

    func setImagePath(_ imagePath: String) {
        self.imagePath = imagePath
        imageView.image = UIImage(named: imagePath  "")
    }

    func p_addMasonry() {
        imageView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.contentView).mas_offset(4)
            make.centerX.mas_equalTo(self.contentView)
            make.bottom.mas_equalTo(self.titleLabel.mas_top).mas_equalTo(1)
            make.width.mas_equalTo(self.imageView.mas_height).multipliedBy(1.13)
        })
        titleLabel.mas_makeConstraints({ make in
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10)
            make.left.and().right().mas_equalTo(self.contentView)
            make.height.mas_equalTo(25)
        })
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    var imageView: UIImageView {
        if imageView == nil {
            imageView = UIImageView()
        }
        return imageView
    }

    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 17.0)
            titleLabel.textColor = UIColor.gray
            titleLabel.textAlignment = .center
        }
        return titleLabel
    }

}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXAboutViewController: WXSettingViewController {
    var helper: WXAboutHelper
    var cmpLabel: UILabel

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "关于微信"

        helper = WXAboutHelper()
        data = helper.abouSettingtData

        tableView.register(WXAboutHeaderView.self, forHeaderFooterViewReuseIdentifier: "TLAboutHeaderView")
        if let aLabel = cmpLabel {
            tableView.tableFooterView.addSubview(aLabel)
        }
        p_addMasonry()
    }
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let footerHeight = Float(APPH - tableView.contentSize.height - CGFloat(TopHeight) - 15)
        let rec: CGRect = tableView.tableFooterView.frame
        rec.size.height = CGFloat(footerHeight)
        tableView.tableFooterView.frame = rec  CGRect.zero
    }

    // MARK: - Delegate -
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLAboutHeaderView") as WXAboutHeaderView
            headerView.imagePath = "AppLogo"
            let shortVersion = Bundle.main.infoDictionary["CFBundleShortVersionString"] as String
            let buildID = Bundle.main.infoDictionary["CFBundleVersion"] as String
            let version = "\(shortVersion  "") (\(buildID  ""))"
            headerView.title = "微信 TLChat \(version)"
            return headerView
        }
        return nil
    }

    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    //MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100
        }
        return 0
    }

    // MARK: - Private Methods -
    func p_addMasonry() {
        cmpLabel().mas_makeConstraints({ make in
            make.left.and().right().mas_equalTo(self.tableView.tableFooterView)
            make.bottom.mas_equalTo(self.tableView.tableFooterView).mas_offset(-1)
        })
    }

    // MARK: - Getter -
    func cmpLabel() -> UILabel {
        if cmpLabel == nil {
            cmpLabel = UILabel()
            cmpLabel.text = "高仿微信 仅供学习\nhttps://github.com/tbl00c/TLChat"
            cmpLabel.textAlignment = .center
            cmpLabel.textColor = UIColor.gray
            cmpLabel.font = UIFont.systemFont(ofSize: 12.0)
            cmpLabel.numberOfLines = 2
        }
        return cmpLabel
    }

}
