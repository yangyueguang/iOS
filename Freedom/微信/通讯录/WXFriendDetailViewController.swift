//
//  WXFriendDetailViewController.swift
//  Freedom
import MWPhotoBrowser
import Foundation
protocol WXFriendDetailUserCellDelegate: NSObjectProtocol {
    func friendDetailUserCellDidClickAvatar(_ info: WXInfo)
}
class WechatFriendDetailAlbumCell: BaseTableViewCell {
    var imageViewsArray: [UIImageView] = []
    var info: WXInfo = WXInfo() {
        didSet {
            textLabel?.text = info.title
            let arr = info.userInfo as! [String]
            let spaceY: CGFloat = 12
            var count = Int((APPW - APPW * 0.28 - 28) / (80 - spaceY * 2 + 3))
            count = arr.count <= count ? arr.count : count
            var spaceX = (APPW - APPW * 0.28 - 28 - CGFloat(count) * (80 - spaceY * 2)) / CGFloat(count)
            spaceX = spaceX > 7 ? 7 : spaceX
            for i in 0..<count {
                let imageURL = arr[i] as String
                var imageView: UIImageView
                if imageViewsArray.count <= i {
                    imageView = UIImageView()
                    imageViewsArray.append(imageView)
                } else {
                    imageView = imageViewsArray[i]
                }
                contentView.addSubview(imageView)
                imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: PuserLogo))
                imageView.snp.makeConstraints { (make) in
                    make.top.equalTo(self.contentView).offset(spaceY)
                    make.bottom.equalTo(self.contentView).offset(-spaceY)
                    make.width.equalTo(imageView.snp.height)
                    if i == 0 {
                        make.left.equalTo(APPW * 0.28)
                    }else{
                        make.left.equalTo(self.imageViewsArray[i - 1].snp.right).offset(spaceX)
                    }
                }
            }
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        accessoryType = .disclosureIndicator
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class WechatFriendDetailUserCell: BaseTableViewCell {
    weak var delegate: WXFriendDetailUserCellDelegate?
    var info: WXInfo = WXInfo() {
        didSet {
            let user: WXUser = info.userInfo as! WXUser
            if !user.avatarPath.isEmpty {
                avatarView.setImage(UIImage(named: user.avatarPath), for: .normal)
            } else {
                avatarView.sd_setImage(with: URL(string: user.avatarURL), for: UIControl.State.normal, placeholderImage: UIImage(named: PuserLogo))
            }
            shownameLabel.text = user.showName
            if user.username.count > 0 {
                usernameLabel.text = "微信号：" + (user.username)
                if user.nikeName.count > 0 {
                    nikenameLabel.text = "昵称：" + (user.nikeName)
                }
            } else if user.nikeName.count > 0 {
                nikenameLabel.text = "昵称：" + (user.nikeName)
            }
        }
    }
    private lazy var avatarView: UIButton = {
        let avatarView = UIButton()
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 5.0
        avatarView.addTarget(self, action: #selector(self.avatarViewButtonDown(_:)), for: .touchUpInside)
        return avatarView
    }()
    private var shownameLabel = UILabel()
    private var usernameLabel = UILabel()
    private var nikenameLabel = UILabel()
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        shownameLabel.font = UIFont.systemFont(ofSize: 17.0)
        usernameLabel.font = UIFont.systemFont(ofSize: 14.0)
        usernameLabel.textColor = UIColor.gray
        nikenameLabel.textColor = UIColor.gray
        nikenameLabel.font = UIFont.systemFont(ofSize: 14.0)
        selectionStyle = .none
        contentView.addSubview(avatarView)
        contentView.addSubview(shownameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(nikenameLabel)
        shownameLabel.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
        avatarView.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
            make.width.equalTo(self.avatarView.snp.height)
        }
        shownameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarView.snp.right).offset(12)
            make.top.equalTo(self.avatarView.snp.top).offset(3)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.shownameLabel)
            make.top.equalTo(self.shownameLabel.snp.bottom).offset(5)
        }
        nikenameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.shownameLabel)
            make.top.equalTo(self.usernameLabel.snp.bottom).offset(3)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func avatarViewButtonDown(_ sender: UIButton) {
        delegate?.friendDetailUserCellDidClickAvatar(info)
    }

}
class WechatFriendDetailSettingViewController: WXSettingViewController {
    var user: WXUser = WXUser()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "资料设置"
        data = WXFriendHelper.shared.friendDetailSettingArray(byUserInfo: user)
    }
}
class WXFriendDetailViewController: BaseTableViewController, WXFriendDetailUserCellDelegate {
    var data:[[WXInfo]] = []
    var user: WXUser = WXUser() {
        didSet {
            let array = WXFriendHelper.shared.friendDetailArray(byUserInfo: self.user)
            data = array
            tableView.reloadData()
        }
    }
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 15.0))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 12.0))
        tableView.backgroundColor = UIColor.lightGray
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "详细资料"
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_more"), style: .plain, target: self, action: #selector(self.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton

        tableView.register(WechatFriendDetailUserCell.self, forCellReuseIdentifier: WechatFriendDetailUserCell.identifier)
        tableView.register(WechatFriendDetailAlbumCell.self, forCellReuseIdentifier: WechatFriendDetailAlbumCell.identifier)
    }

    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
        let detailSetiingVC = WechatFriendDetailSettingViewController()
        detailSetiingVC.user = user
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailSetiingVC, animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = data[indexPath.section][indexPath.row] as WXInfo
        if info.type == TLInfoType.other.rawValue {
            if indexPath.section == 0 {
                let cell = tableView.dequeueCell(WechatFriendDetailUserCell.self)
                cell.delegate = self
                cell.info = info
                return cell
            } else {
                let cell = tableView.dequeueCell(WechatFriendDetailAlbumCell.self)
                cell.info = info
                return cell
            }
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let info = data[indexPath.section][indexPath.row] as WXInfo
        if info.type == Int32(TLInfoType.other.rawValue) {
            if indexPath.section == 0 {
                return 90
            }
            return 80
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    func infoButtonCellClicked(_ info: WXInfo) {
        if (info.title == "发消息") {
            let chatVC = WXChatViewController.shared
            var wxChatVC: WXChatViewController?
            navigationController?.children.forEach(where: { (vc) -> Bool in
                return NSStringFromClass(object_getClass(vc) ?? NSObject.self) == "WXChatViewController"
            }, body: { (vc) in
                wxChatVC = vc as? WXChatViewController
            })
            if let cvc = wxChatVC {
                if (chatVC.partner?.chat_userID == user.userID) {
                    navigationController?.popToViewController(cvc, animated: true)
                } else {
                    chatVC.partner = user
                    let navController = navigationController
                    navigationController?.popToRootViewController(animated: true)
                    navController?.pushViewController(chatVC, animated: true)
                }
            } else {
                chatVC.partner = user
                let vc: UIViewController = WXTabBarController.shared.children[0]
                WXTabBarController.shared.selectedIndex = 0
                vc.hidesBottomBarWhenPushed = true
                vc.navigationController?.pushViewController(chatVC, animated: true)
                navigationController?.popViewController(animated: false)
                vc.hidesBottomBarWhenPushed = false
            }
        } else {
            
        }
    }
    func friendDetailUserCellDidClickAvatar(_ info: WXInfo) {
        var url: URL?
        if !user.avatarPath.isEmpty {
            let imagePath = FileManager.pathUserAvatar(user.avatarPath)
            url = URL(fileURLWithPath: imagePath)
        } else {
            url = URL(string: user.avatarURL)
        }
        let photo = MWPhoto(url: url)
        let browser = MWPhotoBrowser(photos: [photo!])
        let broserNavC = WXNavigationController(rootViewController: browser!)
        present(broserNavC, animated: false)
    }
}
