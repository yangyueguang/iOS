//
//  WXConversationViewController.swift
//  Freedom
import SnapKit
import Alamofire
import Foundation
protocol WXAddMenuViewDelegate: NSObjectProtocol {
    func addMenuView(_ addMenuView: WechatAddMenuView, didSelectedItem item: WXAddMenuItem)
}
class WechatAddMenuCell: WXTableViewCell {
    var item: WXAddMenuItem = WXAddMenuItem() {
        didSet {
            iconImageView.image = UIImage(named: item.iconPath)
            titleLabel.text = item.title
        }
    }
    var iconImageView = UIImageView()
    lazy var titleLabel: UILabel =  {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16.0)
        return titleLabel
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rightSeparatorSpace = 16
        backgroundColor = UIColor(71, 70, 73, 1.0)
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(65, 64, 67, 1.0)
        selectedBackgroundView = selectedView
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(32)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
            make.centerY.equalTo(self.iconImageView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class WechatAddMenuView: UIView, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: WXAddMenuViewDelegate?
    private var helper = WXAddMenuHelper()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(71, 70, 73, 1.0)
        tableView.separatorStyle = .none
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 3.0
        return tableView
    }()
    private var data: [WXAddMenuItem] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(tableView)
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(self.dismiss))
        addGestureRecognizer(panGR)
        tableView.register(WechatAddMenuCell.self, forCellReuseIdentifier: "TLAddMenuCell")
        data = helper.menuData
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show(in view: UIView) {
        view.addSubview(self)
        setNeedsDisplay()
        self.frame = view.bounds
        let rect = CGRect(x: Int(view.frame.size.width - 140 - 5), y: Int(TopHeight) + 20 + 10, width: 140, height: data.count * 45)
        tableView.frame = rect
    }
    func isShow() -> Bool {
        return superview != nil
    }
    @objc func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        }) { finished in
            if finished {
                self.removeFromSuperview()
                self.alpha = 1.0
            }
        }
    }
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        dismiss()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row] as WXAddMenuItem
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLAddMenuCell") as! WechatAddMenuCell
        cell.item = item
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row] as WXAddMenuItem
        delegate?.addMenuView(self, didSelectedItem: item)
        tableView.deselectRow(at: indexPath, animated: false)
        dismiss()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    override func draw(_ rect: CGRect) {
        let startX: CGFloat = frame.size.width - 27
        let startY: CGFloat = 20 + TopHeight + 3
        let endY: CGFloat = 20 + TopHeight + 10
        let width: CGFloat = 6
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.move(to: CGPoint(x: startX, y: startY))
        context.addLine(to: CGPoint(x: startX + width, y: endY))
        context.addLine(to: CGPoint(x: startX - width, y: endY))
        context.closePath()
        UIColor(71, 70, 73, 1.0).setFill()
        UIColor(71, 70, 73, 1.0).setStroke()
        context.drawPath(using: .fillStroke)
    }
}
class WechatConversationCell: WXTableViewCell {
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
            if conversation?.avatarPath.count ?? 0 > 0 {
                let path = FileManager.pathUserAvatar(conversation?.avatarPath ?? "")
                avatarImageView.image = UIImage(named: path)
            } else if conversation?.avatarURL.count ?? 0 > 0 {
                avatarImageView.sd_setImage(with: URL(string: conversation?.avatarURL ?? ""), placeholderImage: UIImage(named: PuserLogo))
            } else {
                avatarImageView.image = nil
            }
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftSeparatorSpace = 10
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(remindImageView)
        contentView.addSubview(redPointView)
//        p_addMasonry()
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
//    func p_addMasonry() {
//        avatarImageView.mas_makeConstraints({ make in
//            make.left.mas_equalTo(10)
//            make.top.mas_equalTo(9.5)
//            make.bottom.mas_equalTo(-9.5)
//            make.width.mas_equalTo(self.avatarImageView.mas_height)
//        })
//        usernameLabel.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
//        usernameLabel.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10)
//            make.top.mas_equalTo(self.avatarImageView).mas_offset(2.0)
//            make.right.mas_lessThanOrEqualTo(self.timeLabel.mas_left).mas_offset(-5)
//        })
//        detailLabel.setContentCompressionResistancePriority(UILayoutPriority(110), for: .horizontal)
//        detailLabel.mas_makeConstraints({ make in
//            make.bottom.mas_equalTo(self.avatarImageView).mas_offset(-2.0)
//            make.left.mas_equalTo(self.usernameLabel)
//            make.right.mas_lessThanOrEqualTo(self.remindImageView.mas_left)
//        })
//        timeLabel.setContentCompressionResistancePriority(UILayoutPriority(300), for: .horizontal)
//        timeLabel.mas_makeConstraints({ make in
//            make.top.mas_equalTo(self.usernameLabel)
//            make.right.mas_equalTo(self.contentView).mas_offset(-10)
//        })
//        remindImageView.setContentCompressionResistancePriority(UILayoutPriority(310), for: .horizontal)
//        remindImageView.mas_makeConstraints({ make in
//            make.right.mas_equalTo(self.timeLabel)
//            make.centerY.mas_equalTo(self.detailLabel)
//        })
//        redPointView.mas_makeConstraints({ make in
//            make.centerX.mas_equalTo(self.avatarImageView.mas_right).mas_offset(-2)
//            make.centerY.mas_equalTo(self.avatarImageView.mas_top).mas_offset(2)
//            make.width.and().height().mas_equalTo(10)
//        })
//    }
}
class WXConversationViewController: WXTableViewController, WXMessageManagerConvVCDelegate, UISearchBarDelegate, WXAddMenuViewDelegate {
//    var searchVC = WXFriendSearchViewController()
    var data: [WXConversation] = []
    private var scrollTopView = UIImageView(image: UIImage(named: "conv_wechat_icon"))
    private var addMenuView = WechatAddMenuView()
//    private var searchController: WXSearchController =  {
//        let searchController = WXSearchController(searchResultsController: searchVC)
//        searchController.searchResultsUpdater = searchVC
//        searchController.searchBar.placeholder = "搜索"
//        searchController.searchBar.delegate = self
//        searchController.showVoiceButton = true
//        return searchController
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "微信"
        addMenuView.delegate = self
        tableView.backgroundColor = UIColor.white
//        tableView.tableHeaderView = searchController.searchBar
        tableView.addSubview(scrollTopView)
        scrollTopView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.tableView)
            make.bottom.equalTo(self.tableView.snp.top).offset(-35)
        }
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_add"), style: .done, target: self, action: #selector(self.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        tableView.register(WechatConversationCell.self, forCellReuseIdentifier: "TLConversationCell")
        WXMessageManager.shared.conversationDelegate = (self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChange(_:)), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateConversationData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if addMenuView.isShow() {
            addMenuView.dismiss()
        }
    }

    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
        if addMenuView.isShow() {
            addMenuView.dismiss()
        } else {
            if let aView = navigationController?.view {
                addMenuView.show(in: aView)
            }
        }
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
                    let user: WXUser = WXFriendHelper.shared.getFriendInfo(byUserID: conversation.partnerID)!
                    conversation.updateUserInfo(user)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLConversationCell") as! WechatConversationCell
        cell.conversation = conversation
        cell.bottomLineStyle = (indexPath.row == data.count - 1) ? .fill : .default
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        let chatVC = WXChatViewController.shared
        let conversation = data[indexPath.row] as WXConversation
        if conversation.convType == .personal {
            let user = WXFriendHelper.shared.getFriendInfo(byUserID: conversation.partnerID)
            if user == nil {
                noticeError("您不存在此好友")
                return
            }
//            chatVC.partner = user
        } else if conversation.convType == .group {
            let group = WXFriendHelper.shared.getGroupInfo(byGroupID: conversation.partnerID)
            if group == nil {
                noticeError("您不存在该讨论组")
                return
            }
//            chatVC.partner = group
        }
        hidesBottomBarWhenPushed = true
//        navigationController.pushViewController(chatVC, animated: true)
        hidesBottomBarWhenPushed = false
        (self.tableView.cellForRow(at: indexPath) as! WechatConversationCell).markAsRead(true)
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction] {
        let conversation = data[indexPath.row]
        let delAction = UITableViewRowAction(style: .default, title: "删除", handler: { action, indexPath in
            self.data.remove(at: indexPath.row)
            let ok = WXMessageManager.shared.deleteConversation(byPartnerID: conversation.partnerID)
            if !ok {
                self.noticeError("从数据库中删除会话信息失败")
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            if self.data.count > 0 && indexPath.row == self.data.count {
                let lastIndexPath = IndexPath(row: (indexPath.row) - 1, section: indexPath.section)
                let cell = self.tableView.cellForRow(at: lastIndexPath) as! WechatConversationCell
                cell.bottomLineStyle = .fill
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
//        searchVC.friendsData = WXFriendHelper.shared.friendsData
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
    func addMenuView(_ addMenuView: WechatAddMenuView, didSelectedItem item: WXAddMenuItem) {
        if item.className.count > 0 {
//            let vc = (NSClassFromString(item.className))()
//            hidesBottomBarWhenPushed = true
//            if let aVc = vc {
//                navigationController.pushViewController(aVc, animated: true)
//            }
//            hidesBottomBarWhenPushed = false
        } else {
            noticeError("\(item.title) 功能暂未实现")
        }
    }
}
