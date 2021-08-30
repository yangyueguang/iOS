//
//  WXChatDetailViewController.swift
//  Freedom

import MWPhotoBrowser
import Foundation
class WXChatDetailViewController: WXSettingViewController, WechatUserGroupCellDelegate {
    var user: WXUser = WXUser()
    var helper = WXMessageHelper.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "聊天详情"
        data = helper.chatDetailData(byUserInfo: user)
        tableView.register(WXUserGroupCell.self, forCellReuseIdentifier: WXUserGroupCell.identifier)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueCell(WXUserGroupCell.self)
            cell.users = [user]
            cell.delegate = self
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section].items[indexPath.row]
        if (item.title == "聊天文件") {
            let chatFileVC = WXChatFileViewController()
            chatFileVC.partnerID = user.userID
            navigationController?.pushViewController(chatFileVC, animated: true)
        } else if (item.title == "设置当前聊天背景") {
            let chatBGSettingVC = WXBgSettingViewController()
            chatBGSettingVC.partnerID = user.userID
            navigationController?.pushViewController(chatBGSettingVC, animated: true)
        } else if (item.title == "清空聊天记录") {
            let alertVC = UIAlertController("", "", T1: "清空聊天记录", T2: "取消", confirm1: {
                WXChatViewController.shared.resetChatVC()
            }, confirm2: {
            })
            self.present(alertVC, animated: true, completion: nil)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            let count: Int = 1
            return CGFloat(((count + 1) / 4 + ((((count + 1) % 4) == 0) ? 0 : 1)) * 90 + 15)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    func userGroupCellDidSelect(_ user: WXUser) {
        let detailVC = WXFriendDetailViewController.storyVC(.wechat)
        detailVC.user = user
        navigationController?.pushViewController(detailVC, animated: true)
    }
    func userGroupCellAddUserButtonDown() {
        noticeInfo("添加讨论组成员")
    }
}

class WXCGroupDetailViewController: WXSettingViewController, WechatUserGroupCellDelegate {
    var group: WXGroup = WXGroup()
    var helper = WXMessageHelper.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "聊天详情"
        data = helper.chatDetailData(byGroupInfo: group)
        tableView.register(WXUserGroupCell.self, forCellReuseIdentifier: WXUserGroupCell.identifier)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueCell(WXUserGroupCell.self)
            cell.users = []
            cell.delegate = self
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section].items[indexPath.row]
        if (item.title == "群二维码") {
            let gorupQRCodeVC = WXGroupQRCodeViewController()
            gorupQRCodeVC.group = group
            navigationController?.pushViewController(gorupQRCodeVC, animated: true)
        } else if (item.title == "设置当前聊天背景") {
            let chatBGSettingVC = WXBgSettingViewController()
            chatBGSettingVC.partnerID = group.userID
            navigationController?.pushViewController(chatBGSettingVC, animated: true)
        } else if (item.title == "聊天文件") {
            let chatFileVC = WXChatFileViewController()
            chatFileVC.partnerID = group.userID
            navigationController?.pushViewController(chatFileVC, animated: true)
        } else if (item.title == "清空聊天记录") {
            let alertVC = UIAlertController("", "", T1: "清空聊天记录", T2: "取消", confirm1: {
                WXMessageHelper.shared.deleteMessages(byPartnerID: self.group.userID)
                WXChatViewController.shared.resetChatVC()
            }, confirm2: {

            })
            self.present(alertVC, animated: true, completion: nil)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            let count = group.count
            return CGFloat(((count + 1) / 4 + ((((count + 1) % 4) == 0) ? 0 : 1)) * 90 + 15)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    func userGroupCellDidSelect(_ user: WXUser) {
        let detailVC = WXFriendDetailViewController.storyVC(.wechat)
        detailVC.user = user
        navigationController?.pushViewController(detailVC, animated: true)
    }
    func userGroupCellAddUserButtonDown() {
        noticeInfo("添加讨论组成员")
    }
}

protocol WechatUserGroupCellDelegate: NSObjectProtocol {
    func userGroupCellDidSelect(_ user: WXUser)
    func userGroupCellAddUserButtonDown()
}

class WXUserGroupCell: BaseTableViewCell<[WXUser]>, UICollectionViewDataSource, UICollectionViewDelegate {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 57, height: 75)
        layout.minimumInteritemSpacing = (APPW - 57 * 4) / 5
        layout.sectionInset = UIEdgeInsets(top: 15, left: (APPW - 57 * 4) / 5 * 0.9, bottom: 15, right: 15 * 0.9)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whitex
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        return collectionView
    }()
    weak var delegate: WechatUserGroupCellDelegate?
    var users: [WXUser] = []
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(collectionView)
        collectionView.register(WXUserGroupItemCell.self, forCellWithReuseIdentifier: WXUserGroupItemCell.identifier)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(WXUserGroupItemCell.self, for: indexPath)
        if indexPath.row < users.count {
            cell.user = users[indexPath.row]
        } else {
            cell.user = nil
        }
        cell.clickBlock = { user in
            if self.delegate != nil {
                self.delegate?.userGroupCellDidSelect(user)
            } else {
                self.delegate?.userGroupCellAddUserButtonDown()
            }
        }
        return cell
    }
}

class WXUserGroupItemCell: UICollectionViewCell {
    var user: WXUser? {
        didSet {
            if user != nil {
                avatarView.sd_setImage(with: URL(string: user?.avatarURL ?? ""), for: UIControl.State.normal, placeholderImage: Image.logo.image)
                usernameLabel.text = user?.showName
            } else {
                avatarView.setImage(WXImage.chatDetailAdd.image, for: .normal)
                avatarView.setImage(WXImage.chatDetailAdd.image, for: .highlighted)
                usernameLabel.text = nil
            }
        }
    }
    var clickBlock: ((_ user: WXUser) -> Void)?
    lazy var avatarView: UIButton = {
        let avatarView = UIButton()
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 5.0
        avatarView.addTarget(self, action: #selector(self.avatarButtonDown), for: .touchUpInside)
        return avatarView
    }()
    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont.small
        usernameLabel.textAlignment = .center
        return usernameLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(avatarView)
        contentView.addSubview(usernameLabel)
        avatarView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentView)
            make.height.equalTo(self.avatarView.snp.width)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalTo(self.contentView)
            make.left.right.lessThanOrEqualTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc func avatarButtonDown() {
        clickBlock?(user!)
    }
}

class WXGroupQRCodeViewController: WXBaseViewController {
    var qrCodeVC = WXQRCodeViewController.storyVC(.wechat)
    var group: WXGroup = WXGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.back
        navigationItem.title = "群二维码名片"
        addChild(qrCodeVC)
        view.addSubview(qrCodeVC.view)

        qrCodeVC.user = group.user()
        let date = Date()
        qrCodeVC.introduceLabel.text = String(format: "该二维码7天内(%lu月%lu日前)有效，重新进入将更新", date.components.month ?? 0, date.components.day ?? 0)

        let rightBarButtonItem = UIBarButtonItem(image: Image.more.image, style: .done, target: self, action: #selector(WXGroupQRCodeViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        let alert = UIAlertController("", "", T1: "用邮件发送", T2: "保存图片", confirm1: {
            self.noticeError("正在开发")
        }) {
            self.qrCodeVC.saveQRCodeToSystemAlbum()
        }
        let act = UIAlertAction(title: "取消", style: .cancel, handler: { _ in
        })
        alert.addAction(act)
        self.present(alert, animated: true) {

        }
    }
}

class WXChatFileCell: UICollectionViewCell {
    var message: WXMessage = WXMessage() {
        didSet {
            if message.messageType == .image {
                let me = message as! WXImageMessage
                let imagePath = me.path
                let imageURL = me.url
                if !imagePath.isEmpty {
                    let imagePatha = FileManager.pathUserChatImage(imagePath)
                    imageView.image = imagePatha.image
                } else if !imageURL.isEmpty {
                    imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: Image.logo.image)
                } else {
                    imageView.image = nil
                }
            }
        }
    }
    private var imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class WXChatFileHeaderView: UICollectionReusableView {
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.back
        bgView.alpha = 0.8
        return bgView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whitex
        titleLabel.font = UIFont.middle
        return titleLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(bgView)
        addSubview(titleLabel)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class WXChatFileViewController: WXBaseViewController {
    var collectionView: BaseCollectionView!
    var partnerID = "" {
        didSet {
            WXMessageHelper.shared.chatFiles(forPartnerID: partnerID, completed: { data in
                self.data.removeAll()
                self.mediaData = []
                self.data.append(contentsOf: data)
                self.collectionView.reloadData()
            })
        }
    }
    var data: [[WXMessage]] = []
    lazy var mediaData: [WXMessage] = {
        var mediaData: [WXMessage] = []
        for array in data {
            for message: WXMessage in array {
                if message.messageType == .image {
                    mediaData.append(message)
                    var url: URL?
                    let me = message as! WXImageMessage
                    let path = me.path
                    if !path.isEmpty {
                        let imagePath = FileManager.pathUserChatImage(path)
                        url = URL(fileURLWithPath: imagePath)
                    } else {
                        url = URL(string: me.url)
                    }
                    let photo = MWPhoto(url: url)
                    browserData.append(photo!)
                }
            }
        }
        return mediaData
    }()
    lazy var browserData: [MWPhoto] = {
        var browserData = [MWPhoto]()
        for message: WXMessage in mediaData {
            if message.messageType == .image {
                var url: URL?
                let imagePath = message.path
                if !imagePath.isEmpty {
                    let imagePatha = FileManager.pathUserChatImage(imagePath)
                    url = URL(fileURLWithPath: imagePatha)
                } else {
                    url = URL(string: message.url)
                }
                let photo = MWPhoto(url: url)
                browserData.append(photo!)
            }
        }
        return browserData
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "聊天文件"
        view.backgroundColor = UIColor.back
        let layout = UICollectionViewFlowLayout()
        if Float(UIDevice.current.systemVersion) ?? 0 >= 9.0 {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        layout.itemSize = CGSize(width: APPW / 4 * 0.98, height: APPW / 4 * 0.98)
        layout.minimumInteritemSpacing = (APPW - APPW / 4 * 0.98 * 4) / 3
        layout.minimumLineSpacing = (APPW - APPW / 4 * 0.98 * 4) / 3
        layout.headerReferenceSize = CGSize(width: APPW, height: 28)
        layout.footerReferenceSize = CGSize(width: APPW, height: 0)
        collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        let rightBarButton = UIBarButtonItem(title: "选择", action: {

        })
        navigationItem.rightBarButtonItem = rightBarButton
        collectionView.register(WXChatFileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WXChatFileHeaderView.identifier)
        collectionView.register(WXChatFileCell.self, forCellWithReuseIdentifier: WXChatFileCell.identifier)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
}
extension WXChatFileViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsIncollectionView(_ collectionView: UICollectionView) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let temp = data[section]
        return temp.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let message = data[indexPath.section][indexPath.row] as WXMessage
        let headerView = collectionView.dequeueHeadFoot(WXChatFileHeaderView.self, kind: kind, for: indexPath)
        headerView.title = message.date.timeToNow()
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = data[indexPath.section][indexPath.row] as WXMessage
        let cell = collectionView.dequeueCell(WXChatFileCell.self, for: indexPath)
        cell.message = message
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = data[indexPath.section][indexPath.row] as WXMessage
        if message.messageType == .image {
            var index: Int = -1
            for i in 0..<mediaData.count {
                if (message.WXMessageID == mediaData[i].WXMessageID) {
                    index = i
                    break
                }
            }
            if index >= 0 {
                let browser = MWPhotoBrowser(photos: browserData)
                browser?.displayNavArrows = true
                browser?.setCurrentPhotoIndex(UInt(index))
                let broserNavC = WXNavigationController(rootViewController: browser!)
                present(broserNavC, animated: false)
            }
        }
    }
}
