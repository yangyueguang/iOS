//
//  WXConversationViewController.swift
//  Freedom
import SnapKit
import Alamofire
import Foundation
class WechatAddMenuCell: BaseTableViewCell {
    var item: WXAddMenuItem = WXAddMenuItem() {
        didSet {
            icon.image = UIImage(named: item.iconPath)
            title.text = item.title
        }
    }
    override func initUI() {
        super.initUI()
        backgroundColor = UIColor.darkGray
        icon.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        title.frame = CGRect(x: icon.right + 10, y: 15, width: 100, height: 20)
        addSubviews([icon,title])
    }
}
class WechatConversationCell: BaseTableViewCell {
    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 3.0
        return avatarImageView
    }()
    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont.systemFont(ofSize: 17.0)
        return usernameLabel
    }()
    lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = UIFont.systemFont(ofSize: 14.0)
        detailLabel.textColor = UIColor.gray
        return detailLabel
    }()
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12.5)
        timeLabel.textColor = UIColor(160, 160, 160, 1.0)
        return timeLabel
    }()
    lazy var remindImageView: UIImageView = {
        let remindImageView = UIImageView()
        remindImageView.alpha = 0.4
        return remindImageView
    }()
    lazy var redPointView: UIView = {
        let redPointView = UIView()
        redPointView.backgroundColor = UIColor.red
        redPointView.layer.masksToBounds = true
        redPointView.layer.cornerRadius = 10 / 2.0
        redPointView.isHidden = true
        return redPointView
    }()
    var conversation: WXConversation? {
        didSet {
//            if conversation?.avatarPath.count ?? 0 > 0 {
//                let path = FileManager.pathUserAvatar(conversation?.avatarPath ?? "")
//                avatarImageView.image = UIImage(named: path)
//            } else if conversation?.avatarURL.count ?? 0 > 0 {
//                avatarImageView.sd_setImage(with: URL(string: conversation?.avatarURL ?? ""), placeholderImage: UIImage(named: PuserLogo))
//            } else {
//                avatarImageView.image = nil
//            }
            usernameLabel.text = conversation?.partnerName
            detailLabel.text = conversation?.content
            timeLabel.text = conversation?.date.timeToNow()
            switch conversation?.remindType {
            case .normal?:self.remindImageView.isHidden = (true)
            case .closed?:
                self.remindImageView.isHidden = (false)
                self.remindImageView.image = (UIImage(named: "conv_remind_close"))
            case .notLook?:
                self.remindImageView.isHidden = (false)
                self.remindImageView.image = (UIImage(named: "conv_remind_notlock"))
            case .unlike?:
                self.remindImageView.isHidden = (false)
                self.remindImageView.image = (UIImage(named: "conv_remind_unlike"))
            default:break
            }
            markAsRead(self.conversation?.isRead ?? false)
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(remindImageView)
        contentView.addSubview(redPointView)
        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //标记为已读/未读
    func markAsRead(_ isRead: Bool) {
        if conversation != nil {
            switch conversation?.clueType {
            case .pointWithNumber?:break
            case .point?:redPointView.isHidden = (isRead)
            case .none:break
            default:break
            }
        }
    }
    func p_addMasonry() {
        usernameLabel.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
        detailLabel.setContentCompressionResistancePriority(UILayoutPriority(110), for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(UILayoutPriority(300), for: .horizontal)
        remindImageView.setContentCompressionResistancePriority(UILayoutPriority(310), for: .horizontal)
        avatarImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(9.5)
            make.bottom.equalTo(-9.5)
            make.width.equalTo(self.avatarImageView.snp.height)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10)
            make.top.equalTo(self.avatarImageView).offset(2)
            make.right.lessThanOrEqualTo(self.timeLabel.snp.left).offset(-5)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.avatarImageView).offset(-2)
            make.left.equalTo(self.usernameLabel)
            make.right.lessThanOrEqualTo(self.remindImageView.snp.left)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.usernameLabel)
            make.right.equalTo(self.contentView).offset(-10)
        }
        remindImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.timeLabel)
            make.centerY.equalTo(self.detailLabel)
        }
        redPointView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.avatarImageView.snp.right).offset(-2)
            make.centerY.equalTo(self.avatarImageView.snp.top).offset(2)
            make.width.height.equalTo(10)
        }
    }
}



final class WXConversationViewController: BaseTableViewController, WXMessageManagerConvVCDelegate, UISearchBarDelegate {
    var searchVC = WXFriendSearchViewController()
    var data: [WXConversation] = []
    private var scrollTopView = UIImageView(image: UIImage(named: "conv_wechat_icon"))
    private var addMenuView: XPopMenu<WXAddMenuItem>!
    private lazy var searchController: WXSearchController =  {
        let searchController = WXSearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.delegate = self
        searchController.showVoiceButton = true
        return searchController
    }()
    @IBAction func rightAction(_ sender: Any) {
        addMenuView.show()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        navigationItem.title = "微信"
        tableView.backgroundColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        tableView.addSubview(scrollTopView)
        let item1 = WXAddMenuItem(type: .groupChat, title: "发起群聊", iconPath: "u_white_addfriend", className: nil)
        let item2 = WXAddMenuItem(type: .addFriend, title: "添加朋友", iconPath: "u_white_addfriend", className: WXAddFriendViewController.self)
        let item3 = WXAddMenuItem(type: .wallet, title: "收付款", iconPath: "u_white_addfriend", className: nil)
        let item4 = WXAddMenuItem(type: .scan, title: "扫一扫", iconPath: "u_white_addfriend", className: WXScanningViewController.self)

        addMenuView = XPopMenu(frame: CGRect(x: APPW - 150, y: 0, width: 140, height: 0), items: [item1, item2, item3, item4], cellHeight: 50)
        addMenuView.cellClosure = {(table, item) in
            let cell = table.dequeueCell(WechatAddMenuCell.self)
            cell.item = item
            return cell
        }
        addMenuView.actionClosure = {[weak self] item in
            guard let `self` = self else { return }
            if let cls = item.className {
                let vc = cls.init()
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
            } else {
                self.noticeError("\(item.title) 功能暂未实现")
            }
        }
        scrollTopView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.tableView)
            make.bottom.equalTo(self.tableView.snp.top).offset(-35)
        }
        tableView.register(WechatConversationCell.self, forCellReuseIdentifier: WechatConversationCell.identifier)
        WXMessageManager.shared.conversationDelegate = (self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChange(_:)), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateConversationData()
    }

    // 网络情况改变
    @objc func networkStatusChange(_ noti: Notification) {
        let net = NetworkReachabilityManager()
        net?.listener = { status in
            switch status {
            case .notReachable:self.navigationItem.title = "微信(未连接)"
            default:self.navigationItem.title = "微信"
            }
        }
        net?.startListening()
    }
    func updateConversationData() {
        WXMessageManager.shared.conversationRecord({ data in
            for conversation: WXConversation in data {
                if conversation.convType == .personal {
                    let user = WXFriendHelper.shared.getFriendInfo(byUserID: conversation.partnerID)
                    if let user = user {
                        conversation.updateUserInfo(user)
                    }
                } else if conversation.convType == .group {
                    let group: WXGroup = WXFriendHelper.shared.getGroupInfo(byGroupID: conversation.partnerID)!
                    conversation.updateGroupInfo(group)
                }
            }
            self.data = data
            self.tableView.reloadData()
        })
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = data[indexPath.row]
        let cell = tableView.dequeueCell(WechatConversationCell.self)
        cell.conversation = conversation
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let chatVC = WXChatViewController.shared
        let conversation = data[indexPath.row] as WXConversation
        if conversation.convType == .personal {
            let user = WXFriendHelper.shared.getFriendInfo(byUserID: conversation.partnerID)
            if user == nil {
                noticeError("您不存在此好友")
                return
            }
            chatVC.partner = user
        } else if conversation.convType == .group {
            let group = WXFriendHelper.shared.getGroupInfo(byGroupID: conversation.partnerID)
            if group == nil {
                noticeError("您不存在该讨论组")
                return
            }
            chatVC.partner = group
        }
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
        hidesBottomBarWhenPushed = false
        (self.tableView.cellForRow(at: indexPath) as! WechatConversationCell).markAsRead(true)
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction] {
        let conversation = data[indexPath.row]
        let delAction = UITableViewRowAction(style: .default, title: "删除", handler: { action, indexPath in
            self.data.remove(at: indexPath.row)
            WXMessageManager.shared.deleteConversation(byPartnerID: conversation.partnerID)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            if self.data.count > 0 && indexPath.row == self.data.count {
                let lastIndexPath = IndexPath(row: (indexPath.row) - 1, section: indexPath.section)
                let cell = self.tableView.cellForRow(at: lastIndexPath) as! WechatConversationCell
            }
        })
        let moreAction = UITableViewRowAction(style: .default, title: conversation.isRead ? "标为未读" : "标为已读", handler: { action, indexPath in
            var cell = tableView.cellForRow(at: indexPath) as! WechatConversationCell
            cell.markAsRead(!conversation.isRead)
            tableView.setEditing(false, animated: true)
        })
        moreAction.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        return [delAction, moreAction]
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchVC.friendsData = WXFriendHelper.shared.friendsData
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tabBarController?.tabBar.isHidden = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tabBarController?.tabBar.isHidden = false
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        noticeInfo("语音搜索按钮")
    }
}
