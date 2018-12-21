//
//  WXFriendDetailViewController.swift
//  Freedom

import Foundation
protocol WXFriendDetailUserCellDelegate: NSObjectProtocol {
    func friendDetailUserCellDidClickAvatar(_ info: WXInfo)
}
class WechatFriendDetailAlbumCell: WXTableViewCell {
    var info: WXInfo
    var imageViewsArray: [AnyHashable] = []

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        imageViewsArray = [AnyHashable]()
        textLabel.font = UIFont.systemFont(ofSize: 15.0)
        accessoryType = .disclosureIndicator

    }
    func setInfo(_ info: WXInfo) {
        self.info = info
        textLabel.text = info.title
        let arr = info.userInfo

        let spaceY: CGFloat = 12
        var count = Int((APPW - APPW * 0.28 - 28) / (80 - spaceY * 2 + 3))
        count = (arr.count) <= count ? arr.count : count
        var spaceX = (APPW - APPW * 0.28 - 28 - CGFloat(count) * (80 - spaceY * 2)) / CGFloat(count)
        spaceX = spaceX > 7 ? 7 : spaceX
        for i in 0..<count {
            let imageURL = arr[i] as String
            var imageView: UIImageView
            if imageViewsArray.count <= i {
                imageView = UIImageView()
                if let aView = imageView {
                    imageViewsArray.append(aView)
                }
            } else {
                imageView = imageViewsArray[i]
            }
            contentView.addSubview(imageView)
            imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: PuserLogo))
            imageView.mas_makeConstraints({ make in
                make.top.mas_equalTo(self.contentView).mas_offset(spaceY)
                make.bottom.mas_equalTo(self.contentView).mas_offset(-spaceY)
                make.width.mas_equalTo(imageView.mas_height)
                if i == 0 {
                    make.left.mas_equalTo(APPW * 0.28)
                } else {
                    make.left.mas_equalTo((self.imageViewsArray[i - 1]).mas_right()).mas_offset(spaceX)
                }
            })
        }
    }


}
class WechatFriendDetailUserCell: WXTableViewCell {
    weak var delegate: WXFriendDetailUserCellDelegate
    var info: WXInfo
    private var avatarView: UIButton
    private var shownameLabel: UILabel
    private var usernameLabel: UILabel
    private var nikenameLabel: UILabel

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        leftSeparatorSpace = 15.0

        if let aView = avatarView {
            contentView.addSubview(aView)
        }
        if let aLabel = shownameLabel {
            contentView.addSubview(aLabel)
        }
        if let aLabel = usernameLabel {
            contentView.addSubview(aLabel)
        }
        if let aLabel = nikenameLabel {
            contentView.addSubview(aLabel)
        }

        addMasonry()

    }
    func addMasonry() {
        avatarView.mas_makeConstraints({ make in
            make.left.mas_equalTo(14)
            make.top.mas_equalTo(12)
            make.bottom.mas_equalTo(-12)
            make.width.mas_equalTo(self.avatarView.mas_height)
        })

        shownameLabel.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
        shownameLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(12)
            make.top.mas_equalTo(self.avatarView.mas_top).mas_offset(3)
        })

        usernameLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.shownameLabel)
            make.top.mas_equalTo(self.shownameLabel.mas_bottom).mas_offset(5)
        })

        nikenameLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.shownameLabel)
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(3)
        })
    }
    func setInfo(_ info: WXInfo) {
        self.info = info
        let user: WXUser = info.userInfo
        if user.avatarPath != nil {
            avatarView.setImage(UIImage(named: user.avatarPath), for: .normal)
        } else {
            avatarView.sd_setImage(with: URL(string: user.avatarURL), for: UIControl.State.normal, placeholderImage: UIImage(named: PuserLogo))
        }
        shownameLabel.text = user.showName
        if user.username.length > 0 {
            usernameLabel.text = "微信号：" + (user.username)
            if user.nikeName.length > 0 {
                nikenameLabel.text = "昵称：" + (user.nikeName)
            }
        } else if user.nikeName.length > 0 {
            nikenameLabel.text = "昵称：" + (user.nikeName)
        }
    }

    
    @objc func avatarViewButtonDown(_ sender: UIButton) {
        if delegate && delegate.responds(to: #selector(self.friendDetailUserCellDidClickAvatar(_:))) {
            delegate.friendDetailUserCellDidClickAvatar(info)
        }
    }

    // MARK: - Getter
    func avatarView() -> UIButton {
        if avatarView == nil {
            avatarView = UIButton()
            avatarView.layer.masksToBounds = true
            avatarView.layer.cornerRadius = 5.0
            avatarView.addTarget(self, action: #selector(self.avatarViewButtonDown(_:)), for: .touchUpInside)
        }
        return avatarView
    }

    func shownameLabel() -> UILabel {
        if shownameLabel == nil {
            shownameLabel = UILabel()
            shownameLabel.font = UIFont.systemFont(ofSize: 17.0)
        }
        return shownameLabel
    }
    func usernameLabel() -> UILabel {
        if usernameLabel == nil {
            usernameLabel = UILabel()
            usernameLabel.font = UIFont.systemFont(ofSize: 14.0)
            usernameLabel.textColor = UIColor.gray
        }
        return usernameLabel
    }

    func nikenameLabel() -> UILabel {
        if nikenameLabel == nil {
            nikenameLabel = UILabel()
            nikenameLabel.textColor = UIColor.gray
            nikenameLabel.font = UIFont.systemFont(ofSize: 14.0)
        }
        return nikenameLabel
    }


}
class WechatFriendDetailSettingViewController: WXSettingViewController {
    var user: WXUser

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "资料设置"

        data = WXFriendHelper.shared().friendDetailSettingArray(byUserInfo: user)
    }
}
class WXFriendDetailViewController: WXInfoViewController, WXFriendDetailUserCellDelegate {
    func registerCellClass() {
    }

    var user: WXUser
    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "详细资料"

        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_more"), style: .plain, target: self, action: #selector(self.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        registerCellClass()
    }

    func setUser(_ user: WXUser) {
        self.user = user
        let array = WXFriendHelper.shared().friendDetailArray(byUserInfo: self.user)
        data = array
        tableView.reloadData()
    }
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        let detailSetiingVC = WechatFriendDetailSettingViewController()
        detailSetiingVC.user = user
        hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailSetiingVC, animated: true)
    }

    // MARK: - Private Methods -
    func registerCellClass() {
        tableView.register(WechatFriendDetailUserCell.self, forCellReuseIdentifier: "TLFriendDetailUserCell")
        tableView.register(WechatFriendDetailAlbumCell.self, forCellReuseIdentifier: "TLFriendDetailAlbumCell")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = data[indexPath.section][indexPath.row] as WXInfo
        if info.type == TLInfoTypeOther {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TLFriendDetailUserCell") as WechatFriendDetailUserCell
                cell.delegate = self
                cell.info = info
                cell.topLineStyle = TLCellLineStyleFill
                cell.bottomLineStyle = TLCellLineStyleFill
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TLFriendDetailAlbumCell") as WechatFriendDetailAlbumCell
                cell.info = info
                return cell!
            }
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let info = data[indexPath.section][indexPath.row] as WXInfo
        if info.type == TLInfoTypeOther {
            if indexPath.section == 0 {
                return 90
            }
            return 80
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    func infoButtonCellClicked(_ info: WXInfo) {
        if (info.title == "发消息") {
            let chatVC = WXChatViewController.sharedChatVC()
            if navigationController.findViewController("WXChatViewController") != nil {
                if (chatVC.partner.chat_userID() == user.userID) {
                    let vc: UIViewController = navigationController.findViewController("WXChatViewController")
                    if let aVc = vc {
                        navigationController.popToViewController(aVc, animated: true)
                    }
                } else {
                    chatVC.partner = user
                    let navController = navigationController
                    navigationController.popToRootViewController(animated: true) { finished in
                        if finished {
                            navController.pushViewController(chatVC, animated: true)
                        }
                    }
                }
            } else {
                chatVC.partner = user
                let vc: UIViewController = WXTabBarController.sharedRootView().childViewController(atIndex: 0)
                WXTabBarController.sharedRootView().selectedIndex = 0
                vc.hidesBottomBarWhenPushed = true
                vc.navigationController.pushViewController(chatVC, animated: true) { finished in
                    self.navigationController.popViewController(animated: false)
                }
                vc.hidesBottomBarWhenPushed = false
            }
        } else {
            super.infoButtonCellClicked(info)
        }
    }
    func friendDetailUserCellDidClickAvatar(_ info: WXInfo) {
        var url: URL
        if user.avatarPath {
            let imagePath = FileManager.pathUserAvatar(user.avatarPath)
            url = URL(fileURLWithPath: imagePath)
        } else {
            url = URL(string: user.avatarURL)
        }

        let photo = MWPhoto(url: url)
        let browser = MWPhotoBrowser(photos: [photo])
        let broserNavC = WXNavigationController(rootViewController: browser)
        present(broserNavC, animated: false)
    }

    
}
