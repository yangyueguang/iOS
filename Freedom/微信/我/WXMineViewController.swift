//
//  WXMineViewController.swift
//  Freedom
import SnapKit
import XExtension
import Foundation
class WXMineHeaderCell: BaseTableViewCell<WXUser> {
    var user: WXUser = WXUser() {
        didSet {
            if !user.avatarPath.isEmpty {
                avatarImageView.image = UIImage(named: user.avatarPath)
            } else {
                avatarImageView.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: UIImage(named: "userLogo"))
            }
            nikenameLabel.text = user.nikeName
            usernameLabel.text = user.username.isEmpty ? "": "微信号：" + user.username
        }
    }
    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 5.0
        return avatarImageView
    }()
    lazy var nikenameLabel: UILabel = {
        let nikenameLabel = UILabel()
        nikenameLabel.font = UIFont.systemFont(ofSize: 17.0)
        return nikenameLabel
    }()
    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont.systemFont(ofSize: 14.0)
        return usernameLabel
    }()
    lazy var qrImageView: UIImageView = {
        let QRImageView = UIImageView()
        QRImageView.image = Image.code.image
        return QRImageView
    }()
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.addSubview(self.avatarImageView)
        contentView.addSubview(self.nikenameLabel)
        contentView.addSubview(self.usernameLabel)
        contentView.addSubview(self.qrImageView)
//        addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func addMasonry() {
        avatarImageView.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
            make.width.equalTo(self.avatarImageView.height)
        }
        nikenameLabel.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
        nikenameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.avatarImageView.right).offset(10)
            make.bottom.equalTo(self.avatarImageView.snp.centerY).offset(-3.5)
        }
        usernameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.nikenameLabel)
            make.top.equalTo(self.avatarImageView.snp.centerY).offset(5.0)
        }
        qrImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView).offset(-0.5)
            make.right.equalTo(self.contentView)
            make.height.width.equalTo(18)
        }
    }
}
class WXMineHelper: NSObject {
    var mineMenuData: [[WXMenuItem]] = []
    override init() {
        super.init()
        let item0 = WXMenuItem("", "")
        let item1 = WXMenuItem("u_album_b", "相册")
        let item2 = WXMenuItem("u_favorites", "收藏")
        let item3 = WXMenuItem("MoreMyBankCard", "钱包")
        let item4 = WXMenuItem("MyCardPackageIcon", "优惠券")
        let item5 = WXMenuItem("MoreExpressionShops", "表情")
        let item6 = WXMenuItem("setingHL", "设置")
        mineMenuData.append(contentsOf:[[item0], [item1, item2, item3, item4], [item5], [item6]])
    }
}
class WXMineInfoHelper: NSObject {
    var mineInfoData: [WXSettingGroup] = []
    override init() {
        super.init()
    }
    func mineInfoData(byUserInfo userInfo: WXUser) -> [WXSettingGroup] {
        let avatar = WXSettingItem("头像")
        avatar.rightImageURL = userInfo.avatarURL
        let nikename = WXSettingItem("名字")
        nikename.subTitle = userInfo.nikeName.count > 0 ? userInfo.nikeName : "未设置"
        let username = WXSettingItem("微信号")
        if userInfo.username.count > 0 {
            username.subTitle = userInfo.username
            username.showDisclosureIndicator = false
            username.disableHighlight = true
        } else {
            username.subTitle = "未设置"
        }
        let qrCode = WXSettingItem("我的二维码")
        qrCode.rightImagePath = Image.code.rawValue
        let location = WXSettingItem("我的地址")
        let group1: WXSettingGroup = WXSettingGroup(nil, nil, ([avatar, nikename, username, qrCode, location]))
        let sex = WXSettingItem("性别")
        sex.subTitle = userInfo.detailInfo.sex
        let city = WXSettingItem("地区")
        city.subTitle = userInfo.detailInfo.location
        let motto = WXSettingItem("个性签名")
        motto.subTitle = userInfo.detailInfo.motto.count > 0 ? userInfo.detailInfo.motto : "未填写"
        let group2: WXSettingGroup = WXSettingGroup(nil, nil, ([sex, city, motto]))
        mineInfoData.removeAll()
        mineInfoData.append(contentsOf: [group1, group2])
        return mineInfoData
    }
}
final class WXMineViewController: BaseTableViewController {
    var mineHelper = WXMineHelper()
    var data: [[WXMenuItem]] = []
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.lightGray
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.gray
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 20))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        navigationItem.title = "我"
        data = mineHelper.mineMenuData
        tableView.register(WXMineHeaderCell.self, forCellReuseIdentifier: WXMineHeaderCell.identifier)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueCell(WXMineHeaderCell.self) 
            cell.user = WXUserHelper.shared.user
            return cell
        }
        return super.tableView(tableView, cellForRowAt: IndexPath(row: indexPath.row, section: indexPath.section))
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        }
        return super.tableView(tableView, heightForRowAt: IndexPath(row: indexPath.row, section: indexPath.section))
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            let mineInfoVC = WXMineInfoViewController()
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(mineInfoVC, animated: true)
//            hidesBottomBarWhenPushed = false
//            super.tableView(tableView, didSelectRowAt: indexPath)
//            return
//        }
//        let item = data[indexPath.section][indexPath.row] as WXMenuItem
//        if (item.title == "表情") {
//            let expressionVC = WXExpressionViewController()
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(expressionVC, animated: true)
//            hidesBottomBarWhenPushed = false
//        } else if (item.title == "设置") {
//            let settingVC = WXMineSettingViewController()
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(settingVC, animated: true)
//            hidesBottomBarWhenPushed = false
//        }
//        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}
