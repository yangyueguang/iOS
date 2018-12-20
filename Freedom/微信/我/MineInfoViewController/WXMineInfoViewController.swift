//
//  WXMineInfoViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/20.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXMineInfoAvatarCell: UITableViewCell {
    var item: WXSettingItem?
    var titleLabel: UILabel?
    var avatarImageView: UIImageView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator
        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        if let aView = avatarImageView {
            contentView.addSubview(aView)
        }
        p_addMasonry()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setItem(_ item: WXSettingItem?) {
        self.item = item
        titleLabel?.text = item?.title
        if item?.rightImagePath != nil {
            avatarImageView.image = UIImage(named: item?.rightImagePath ?? "")
        } else if item?.rightImageURL != nil {
            avatarImageView.sd_setImage(with: URL(string: item?.rightImageURL ?? ""), placeholderImage: UIImage(named: PuserLogo))
        } else {
            avatarImageView.image = nil
        }
    }
    func p_addMasonry() {
        titleLabel?.mas_makeConstraints({ make in
            make?.centerY.mas_equalTo(self.contentView)
            make?.left.mas_equalTo(self.contentView).mas_offset(15)
            make?.right.mas_lessThanOrEqualTo(self.avatarImageView.mas_left).mas_offset(-15)
        })

        avatarImageView.mas_makeConstraints({ make in
            make?.right.mas_equalTo(self.contentView)
            make?.top.mas_equalTo(self.contentView).mas_offset(9)
            make?.bottom.mas_equalTo(self.contentView).mas_offset(-9)
            make?.width.mas_equalTo(self.avatarImageView.mas_height)
        })
    }
    var titleLabel: UILabel? {
        if titleLabel == nil {
            titleLabel = UILabel()
        }
        return titleLabel
    }

    func avatarImageView() -> UIImageView? {
        if avatarImageView == nil {
            avatarImageView = UIImageView()
            avatarImageView.layer.masksToBounds = true
            avatarImageView.layer.cornerRadius = 4.0
        }
        return avatarImageView
    }



    
}
class WXMineInfoViewController: WXSettingViewController {
    var helper: WXMineInfoHelper?

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人信息"

        tableView.register(WXMineInfoAvatarCell.self, forCellReuseIdentifier: "TLMineInfoAvatarCell")

        helper = WXMineInfoHelper()
        data = helper?.mineInfoData(byUserInfo: WXUserHelper.shared().user)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.section][indexPath.row] as? WXSettingItem
        if (item?.title == "头像") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMineInfoAvatarCell") as? WXMineInfoAvatarCell
            cell?.item = item
            return cell!
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row] as? WXSettingItem
        if (item?.title == "我的二维码") {
            let myQRCodeVC = WXMyQRCodeViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myQRCodeVC, animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data[indexPath.section][indexPath.row] as? WXSettingItem
        if (item?.title == "头像") {
            return 85.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }


    
}
