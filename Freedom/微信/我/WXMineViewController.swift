//
//  WXMineViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/20.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXMineHeaderCell: UITableViewCell {
    var user: WXUser?
    var avatarImageView: UIImageView?
    var nikenameLabel: UILabel?
    var usernameLabel: UILabel?
    var qrImageView: UIImageView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator

        if let aView = avatarImageView {
            contentView.addSubview(aView)
        }
        if let aLabel = nikenameLabel {
            contentView.addSubview(aLabel)
        }
        if let aLabel = usernameLabel {
            contentView.addSubview(aLabel)
        }
        if let aView = qrImageView {
            contentView.addSubview(aView)
        }

        addMasonry()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addMasonry() {
        avatarImageView.mas_makeConstraints({ make in
            make?.left.mas_equalTo(14)
            make?.top.mas_equalTo(12)
            make?.bottom.mas_equalTo(-12)
            make?.width.mas_equalTo(self.avatarImageView.mas_height)
        })

        nikenameLabel.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
        nikenameLabel.mas_makeConstraints({ make in
            make?.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10)
            make?.bottom.mas_equalTo(self.avatarImageView.mas_centerY).mas_offset(-3.5)
        })

        usernameLabel.mas_makeConstraints({ make in
            make?.left.mas_equalTo(self.nikenameLabel)
            make?.top.mas_equalTo(self.avatarImageView.mas_centerY).mas_offset(5.0)
        })

        qrImageView.mas_makeConstraints({ make in
            make?.centerY.mas_equalTo(self.contentView).mas_offset(-0.5)
            make?.right.mas_equalTo(self.contentView)
            make?.height.and().width().mas_equalTo(18)
        })
    }

    func setUser(_ user: WXUser?) {
        self.user = user
        if user?.avatarPath != nil {
            avatarImageView.image = UIImage(named: user?.avatarPath ?? "")
        } else {
            avatarImageView.sd_setImage(with: URL(string: user?.avatarURL ?? ""), placeholderImage: UIImage(named: "userLogo"))
        }
        nikenameLabel.text = user?.nikeName
        usernameLabel.text = user?.username != nil ? "微信号：" + (user?.username ?? "") : ""
    }
    func avatarImageView() -> UIImageView? {
        if avatarImageView == nil {
            avatarImageView = UIImageView()
            avatarImageView.layer.masksToBounds = true
            avatarImageView.layer.cornerRadius = 5.0
        }
        return avatarImageView
    }

    func nikenameLabel() -> UILabel? {
        if nikenameLabel == nil {
            nikenameLabel = UILabel()
            nikenameLabel.font = UIFont.systemFont(ofSize: 17.0)
        }
        return nikenameLabel
    }
    func usernameLabel() -> UILabel? {
        if usernameLabel == nil {
            usernameLabel = UILabel()
            usernameLabel.font = UIFont.systemFont(ofSize: 14.0)
        }
        return usernameLabel
    }

    func qrImageView() -> UIImageView? {
        if QRImageView == nil {
            QRImageView = UIImageView()
            QRImageView.image = UIImage(named: PQRCode)
        }
        return QRImageView
    }




}
class WXMineHelper: NSObject {
    var mineMenuData: [AnyHashable] = []

    override init() {
        //if super.init()

        mineMenuData = [AnyHashable]()
        p_initTestData()

    }

    func tlCreateMenuItem(_ IconPath: String?, Title: String?) -> WXMenuItem? {
        return WXMenuItem.createMenu(withIconPath: IconPath, title: Title)
    }

    func p_initTestData() {
        let item0: WXMenuItem? = tlCreateMenuItem(nil, Title: nil)
        let item1: WXMenuItem? = tlCreateMenuItem("u_album_b", Title: "相册")
        let item2: WXMenuItem? = tlCreateMenuItem("u_favorites", Title: "收藏")
        let item3: WXMenuItem? = tlCreateMenuItem("MoreMyBankCard", Title: "钱包")
        let item4: WXMenuItem? = tlCreateMenuItem("MyCardPackageIcon", Title: "优惠券")
        let item5: WXMenuItem? = tlCreateMenuItem("MoreExpressionShops", Title: "表情")
        var item6: WXMenuItem? = tlCreateMenuItem("setingHL", "设置")
        mineMenuData.append(contentsOf: [[item0], [item1, item2, item3, item4], [item5], [item6]])
    }


    
}
class WXMineInfoHelper: NSObject {
    func mineInfoData(byUserInfo userInfo: WXUser?) -> [AnyHashable]? {
    }

    var mineInfoData: [AnyHashable] = []

    override init() {
        //if super.init()

        mineInfoData = [AnyHashable]()

    }
    func mineInfoData(byUserInfo userInfo: WXUser?) -> [AnyHashable]? {
        let avatar = WXSettingItem.createItem(withTitle: ("头像"))
        avatar.rightImageURL = userInfo?.avatarURL
        let nikename = WXSettingItem.createItem(withTitle: ("名字"))
        nikename.subTitle = userInfo?.nikeName.length ?? 0 > 0 ? userInfo?.nikeName : "未设置"
        let username = WXSettingItem.createItem(withTitle: ("微信号"))
        if userInfo?.username.length ?? 0 > 0 {
            username.subTitle = userInfo?.username
            username.showDisclosureIndicator = false
            username.disableHighlight = true
        } else {
            username.subTitle = "未设置"
        }

        let qrCode = WXSettingItem.createItem(withTitle: ("我的二维码"))
        qrCode.rightImagePath = PQRCode
        let location = WXSettingItem.createItem(withTitle: ("我的地址"))
        let group1: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([avatar, nikename, username, qrCode, location]))
        let sex = WXSettingItem.createItem(withTitle: ("性别"))
        sex.subTitle = userInfo?.detailInfo.sex
        let city = WXSettingItem.createItem(withTitle: ("地区"))
        city.subTitle = userInfo?.detailInfo.location
        let motto = WXSettingItem.createItem(withTitle: ("个性签名"))
        motto.subTitle = userInfo?.detailInfo.motto.length ?? 0 > 0 ? userInfo?.detailInfo.motto : "未填写"
        let group2: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([sex, city, motto]))

        mineInfoData.removeAll()
        mineInfoData.append(contentsOf: [group1, group2])
        return mineInfoData
    }




}
class WXMineViewController: WXMenuViewController {
    var mineHelper: WXMineHelper?

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我"
        mineHelper = WXMineHelper()
        data = mineHelper?.mineMenuData

        tableView.register(WXMineHeaderCell.self, forCellReuseIdentifier: "TLMineHeaderCell")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMineHeaderCell") as? WXMineHeaderCell
            cell?.user = WXUserHelper.shared().user
            return cell!
        }
        return super.tableView(tableView, cellForRowAt: IndexPath(row: indexPath.row, section: indexPath.section))
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        }
        return super.tableView(tableView, heightForRowAt: IndexPath(row: indexPath.row, section: indexPath.section))
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let mineInfoVC = WXMineInfoViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(mineInfoVC, animated: true)
            hidesBottomBarWhenPushed = false
            super.tableView(tableView, didSelectRowAt: indexPath)
            return
        }
        let item = data[indexPath.section][indexPath.row] as? WXMenuItem
        if (item?.title == "表情") {
            let expressionVC = WXExpressionViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(expressionVC, animated: true)
            hidesBottomBarWhenPushed = false
        } else if (item?.title == "设置") {
            let settingVC = WXMineSettingViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(settingVC, animated: true)
            hidesBottomBarWhenPushed = false
        }
        super.tableView(tableView, didSelectRowAt: indexPath)
    }



    
}
