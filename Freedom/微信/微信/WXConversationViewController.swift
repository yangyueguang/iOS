//
//  WXConversationViewController.swift
//  Freedom

import Foundation
protocol WXAddMenuViewDelegate: NSObjectProtocol {
    func addMenuView(_ addMenuView: WechatAddMenuView, didSelectedItem item: WXAddMenuItem)
}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WechatAddMenuCell: WXTableViewCell {
    var item: WXAddMenuItem
    var iconImageView: UIImageView
    var titleLabel: UILabel

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        rightSeparatorSpace = 16
        backgroundColor = UIColor(71, 70, 73, 1.0)
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(65, 64, 67, 1.0)
        selectedBackgroundView = selectedView

        if let aView = iconImageView {
            contentView.addSubview(aView)
        }
        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }

        p_addMasonry()

    }
    func setItem(_ item: WXAddMenuItem) {
        self.item = item
        iconImageView.image = UIImage(named: item.iconPath  "")
        titleLabel.text = item.title
    }

    // MARK: - Private Methods -
    func p_addMasonry() {
        iconImageView.mas_makeConstraints({ make in
            make.left.mas_equalTo(self).mas_offset(15.0)
            make.centerY.mas_equalTo(self)
            make.height.and().width().mas_equalTo(32)
        })
        titleLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10.0)
            make.centerY.mas_equalTo(self.iconImageView)
        })
    }
    func iconImageView() -> UIImageView {
        if iconImageView == nil {
            iconImageView = UIImageView()
        }
        return iconImageView
    }

    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.systemFont(ofSize: 16.0)
        }
        return titleLabel
    }



    
}
class WechatAddMenuView: UIView, UITableViewDataSource, UITableViewDelegate {
        weak var delegate: WXAddMenuViewDelegate
        private var helper: WXAddMenuHelper
        private var tableView: UITableView
        private var data: [AnyHashable] = []
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    init() {
        super.init()

        backgroundColor = UIColor.clear
        addSubview(tableView)

        let panGR = UIPanGestureRecognizer(target: self, action: #selector(self.dismiss))
        addGestureRecognizer(panGR)

        tableView.register(WechatAddMenuCell.self, forCellReuseIdentifier: "TLAddMenuCell")
        data = helper.menuData

    }

    func show(in view: UIView) {
        view.addSubview(self)
        setNeedsDisplay()
        self.frame = view.bounds

        let rect = CGRect(x: view.frame.size.width - 140 - 5, y: Int(TopHeight) + 20 + 10, width: 140, height: data.count * 45)
        tableView.frame = rect
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func isShow() -> Bool {
        return superview != nil
    }

    func dismiss() {
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

    // MARK: - Delegate -
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row] as WXAddMenuItem
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLAddMenuCell") as WechatAddMenuCell
        cell.item = item
        return cell!
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row] as WXAddMenuItem
        if delegate && delegate.responds(to: #selector(self.addMenuView(_:didSelectedItem:))) {
            delegate.addMenuView(self, didSelectedItem: item)
        }
        tableView.deselectRow(at: indexPath, animated: false)
        dismiss()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func draw(_ rect: CGRect) {
        let startX: CGFloat = frame.size.width - 27
        let startY: CGFloat = 20 + Int(TopHeight) + 3
        let endY: CGFloat = 20 + Int(TopHeight) + 10
        let width: CGFloat = 6
        let context = UIGraphicsGetCurrentContext()
        context.move(to: CGPoint(x: startX, y: startY))
        context.addLine(to: CGPoint(x: startX + width, y: endY))
        context.addLine(to: CGPoint(x: startX - width, y: endY))
        context.closePath()
        UIColor(71, 70, 73, 1.0).setFill()
        UIColor(71, 70, 73, 1.0).setStroke()
        context.drawPath(using: .fillStroke)
    }

    var tableView: UITableView! {
        if tableView == nil {
            tableView = UITableView()
            tableView.isScrollEnabled = false
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor(71, 70, 73, 1.0)
            tableView.separatorStyle = .none
            tableView.layer.masksToBounds = true
            tableView.layer.cornerRadius = 3.0
        }
        return tableView
    }

    func helper() -> WXAddMenuHelper {
        if helper == nil {
            helper = WXAddMenuHelper()
        }
        return helper
    }
    
}
class WechatConversationCell: WXTableViewCell {
    /// 会话Model
    var conversation: WXConversation
    var avatarImageView: UIImageView
    var usernameLabel: UILabel
    var detailLabel: UILabel
    var timeLabel: UILabel
    var remindImageView: UIImageView
    var redPointView: UIView
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        leftSeparatorSpace = 10

        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(remindImageView)
        contentView.addSubview(redPointView)

        p_addMasonry()

    }
    func setConversation(_ conversation: WXConversation) {
        self.conversation = conversation

        if conversation.avatarPath.length  0 > 0 {
            let path = FileManager.pathUserAvatar(conversation.avatarPath)
            avatarImageView.image = UIImage(named: path)
        } else if conversation.avatarURL.length  0 > 0 {
            avatarImageView.sd_setImage(with: URL(string: conversation.avatarURL  ""), placeholderImage: UIImage(named: PuserLogo))
        } else {
            avatarImageView.image = nil
        }
        usernameLabel.text = conversation.partnerName
        detailLabel.text = conversation.content
        timeLabel.text = conversation.date.timeToNow
        switch conversation.remindType {
        case TLMessageRemindTypeNormal:
            remindImageView.setHidden(true)
        case TLMessageRemindTypeClosed:
            remindImageView.setHidden(false)
            remindImageView.setImage(UIImage(named: "conv_remind_close"))
        case TLMessageRemindTypeNotLook:
            remindImageView.setHidden(false)
            remindImageView.setImage(UIImage(named: "conv_remind_notlock"))
        case TLMessageRemindTypeUnlike:
            remindImageView.setHidden(false)
            remindImageView.setImage(UIImage(named: "conv_remind_unlike"))
        default:
            break
        }

        self.conversation.isRead  markAsRead() : markAsUnread()
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func markAsUnread() {
        if conversation {
            switch conversation.clueType {
            case TLClueTypePointWithNumber:
                break
            case TLClueTypePoint:
                redPointView.setHidden(false)
            case TLClueTypeNone:
                break
            default:
                break
            }
        }
    }

    //标记为已读
    func markAsRead() {
        if conversation {
            switch conversation.clueType {
            case TLClueTypePointWithNumber:
                break
            case TLClueTypePoint:
                redPointView.setHidden(true)
            case TLClueTypeNone:
                break
            default:
                break
            }
        }
    }
    func p_addMasonry() {
        avatarImageView.mas_makeConstraints({ make in
            make.left.mas_equalTo(10)
            make.top.mas_equalTo(9.5)
            make.bottom.mas_equalTo(-9.5)
            make.width.mas_equalTo(self.avatarImageView.mas_height)
        })

        usernameLabel.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
        usernameLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10)
            make.top.mas_equalTo(self.avatarImageView).mas_offset(2.0)
            make.right.mas_lessThanOrEqualTo(self.timeLabel.mas_left).mas_offset(-5)
        })

        detailLabel.setContentCompressionResistancePriority(UILayoutPriority(110), for: .horizontal)
        detailLabel.mas_makeConstraints({ make in
            make.bottom.mas_equalTo(self.avatarImageView).mas_offset(-2.0)
            make.left.mas_equalTo(self.usernameLabel)
            make.right.mas_lessThanOrEqualTo(self.remindImageView.mas_left)
        })

        timeLabel.setContentCompressionResistancePriority(UILayoutPriority(300), for: .horizontal)
        timeLabel.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.usernameLabel)
            make.right.mas_equalTo(self.contentView).mas_offset(-10)
        })

        remindImageView.setContentCompressionResistancePriority(UILayoutPriority(310), for: .horizontal)
        remindImageView.mas_makeConstraints({ make in
            make.right.mas_equalTo(self.timeLabel)
            make.centerY.mas_equalTo(self.detailLabel)
        })

        redPointView.mas_makeConstraints({ make in
            make.centerX.mas_equalTo(self.avatarImageView.mas_right).mas_offset(-2)
            make.centerY.mas_equalTo(self.avatarImageView.mas_top).mas_offset(2)
            make.width.and().height().mas_equalTo(10)
        })
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func avatarImageView() -> UIImageView {
        if avatarImageView == nil {
            avatarImageView = UIImageView()
            avatarImageView.layer.masksToBounds = true
            avatarImageView.layer.cornerRadius = 3.0
        }
        return avatarImageView
    }

    func usernameLabel() -> UILabel {
        if usernameLabel == nil {
            usernameLabel = UILabel()
            usernameLabel.font = UIFont.systemFont(ofSize: 17.0)
        }
        return usernameLabel
    }

    func detailLabel() -> UILabel {
        if detailLabel == nil {
            detailLabel = UILabel()
            detailLabel.font = UIFont.systemFont(ofSize: 14.0)
            detailLabel.textColor = UIColor.gray
        }
        return detailLabel
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func timeLabel() -> UILabel {
        if timeLabel == nil {
            timeLabel = UILabel()
            timeLabel.font = UIFont.systemFont(ofSize: 12.5)
            timeLabel.textColor = UIColor(160, 160, 160, 1.0)
        }
        return timeLabel
    }

    func remindImageView() -> UIImageView {
        if remindImageView == nil {
            remindImageView = UIImageView()
            remindImageView.alpha = 0.4
        }
        return remindImageView
    }

    func redPointView() -> UIView {
        if redPointView == nil {
            redPointView = UIView()
            redPointView.backgroundColor = UIColor.red

            redPointView.layer.masksToBounds = true
            redPointView.layer.cornerRadius = 10 / 2.0
            redPointView.hidden = true
        }
        return redPointView
    }




    
}
class WXConversationViewController: WXTableViewController, WXMessageManagerConvVCDelegate, UISearchBarDelegate, WXAddMenuViewDelegate {
    var searchVC: WXFriendSearchViewController
    var data: [AnyHashable] = []

    private var scrollTopView: UIImageView
    private var searchController: WXSearchController
    private var addMenuView: WechatAddMenuView
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "微信"

        p_initUI() // 初始化界面UI
        registerCellClass()

        WXMessageManager.sharedInstance().setConversationDelegate(self)

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChange(_:)), name: AFNetworkingReachabilityDidChangeNotification, object: nil)
    }

    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //TODO: 临时写法
        updateConversationData()
    }

    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if addMenuView.isShow {
            addMenuView.dismiss()
        }
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        if addMenuView.isShow {
            addMenuView.dismiss()
        } else {
            if let aView = navigationController.view {
                addMenuView.show(in: aView)
            }
        }
    }

    // 网络情况改变
    func networkStatusChange(_ noti: Notification) {
        let status = Int(noti.userInfo["AFNetworkingReachabilityNotificationStatusItem"]  0) as AFNetworkReachabilityStatus
        switch status {
        case AFNetworkReachabilityStatusReachableViaWiFi, AFNetworkReachabilityStatusReachableViaWWAN, AFNetworkReachabilityStatusUnknown:
            navigationItem.title = "微信"
        case AFNetworkReachabilityStatusNotReachable:
            navigationItem.title = "微信(未连接)"
        default:
            break
        }
    }
    func p_initUI() {
        tableView.backgroundColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        tableView.addSubview(scrollTopView)
        scrollTopView.mas_makeConstraints({ make in
            make.centerX.mas_equalTo(self.tableView)
            make.bottom.mas_equalTo(self.tableView.mas_top).mas_offset(-35)
        })

        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_add"), style: .done, target: self, action: #selector(self.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    var searchController: UISearchController {
        if searchController == nil {
            searchController = WXSearchController(searchResultsController: searchVC())
            searchController.searchResultsUpdater = searchVC()
            searchController.searchBar.placeholder = "搜索"
            searchController.searchBar.delegate = self
            searchController.showVoiceButton = true
        }
        return searchController
    }

    func searchVC() -> WXFriendSearchViewController {
        if searchVC == nil {
            searchVC = WXFriendSearchViewController()
        }
        return searchVC
    }

    func scrollTopView() -> UIImageView {
        if scrollTopView == nil {
            scrollTopView = UIImageView(image: UIImage(named: "conv_wechat_icon"))
        }
        return scrollTopView
    }

    func addMenuView() -> WechatAddMenuView {
        if addMenuView == nil {
            addMenuView = WechatAddMenuView()
            addMenuView.delegate = self
        }
        return addMenuView
    }

    // MARK: - Public Methods -
    func registerCellClass() {
        tableView.register(WechatConversationCell.self, forCellReuseIdentifier: "TLConversationCell")
    }

    func updateConversationData() {
        WXMessageManager.sharedInstance().conversationRecord({ data in
            for conversation: WXConversation in data as [WXConversation]  [] {
                if conversation.convType == TLConversationTypePersonal {
                    let user: WXUser = WXFriendHelper.shared().getFriendInfo(byUserID: conversation.partnerID)
                    conversation.updateUserInfo(user)
                } else if conversation.convType == TLConversationTypeGroup {
                    let group: WXGroup = WXFriendHelper.shared().getGroupInfo(byGroupID: conversation.partnerID)
                    conversation.updateGroupInfo(group)
                }
            }
            if let aData = data {
                self.data = aData
            }
            self.tableView.reloadData()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = data[indexPath.row] as WXConversation
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLConversationCell") as WechatConversationCell
        cell.conversation = conversation
        cell.bottomLineStyle = indexPath.row == data.count - 1  TLCellLineStyleFill : TLCellLineStyleDefault

        return cell!
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let chatVC = WXChatViewController.sharedChatVC()

        let conversation = data[indexPath.row] as WXConversation
        if conversation.convType == TLConversationTypePersonal {
            let user: WXUser = WXFriendHelper.shared().getFriendInfo(byUserID: conversation.partnerID)
            if user == nil {
                SVProgressHUD.showError(withStatus: "您不存在此好友")
                return
            }
            chatVC.partner = user
        } else if conversation.convType == TLConversationTypeGroup {
            let group: WXGroup = WXFriendHelper.shared().getGroupInfo(byGroupID: conversation.partnerID)
            if group == nil {
                SVProgressHUD.showError(withStatus: "您不存在该讨论组")
                return
            }
            chatVC.partner = group
        }
        hidesBottomBarWhenPushed = true
        navigationController.pushViewController(chatVC, animated: true)
        hidesBottomBarWhenPushed = false

        // 标为已读
        (self.tableView.cellForRow(at: indexPath) as WechatConversationCell).markAsRead()
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction] {
        let conversation = data[indexPath.row] as WXConversation
        weak var weakSelf = self
        let delAction = UITableViewRowAction(style: .default, title: "删除", handler: { action, indexPath in
            weakSelf.data.remove(at: indexPath.row  0)
            let ok = WXMessageManager.sharedInstance().deleteConversation(byPartnerID: conversation.partnerID)
            if !ok {
                SVProgressHUD.showError(withStatus: "从数据库中删除会话信息失败")
            }
            weakSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
            if self.data.count > 0 && indexPath.row == self.data.count {
                let lastIndexPath = IndexPath(row: (indexPath.row  0) - 1, section: indexPath.section  0)
                let cell = self.tableView.cellForRow(at: lastIndexPath) as WechatConversationCell
                cell.bottomLineStyle = TLCellLineStyleFill
            }
        })
        let moreAction = UITableViewRowAction(style: .default, title: conversation.isRead  "标为未读" : "标为已读", handler: { action, indexPath in
            var cell: WechatConversationCell = nil
            if let aPath = indexPath {
                cell = tableView.cellForRow(at: aPath) as WechatConversationCell
            }
            conversation.isRead  cell.markAsUnread() : cell.markAsRead()
            tableView.setEditing(false, animated: true)
        })
        moreAction.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        return [delAction, moreAction]
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchVC.friendsData = WXFriendHelper.shared().friendsData
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tabBarController.tabBar.isHidden = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tabBarController.tabBar.isHidden = false
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        SVProgressHUD.showInfo(withStatus: "语音搜索按钮")
    }
    //MARK: TLAddMenuViewDelegate
    // 选中了addMenu的某个菜单项

    func addMenuView(_ addMenuView: WechatAddMenuView, didSelectedItem item: WXAddMenuItem) {
        if item.className.length  0 > 0 {
            let vc = (NSClassFromString(item.className  ""))()
            hidesBottomBarWhenPushed = true
            if let aVc = vc {
                navigationController.pushViewController(aVc, animated: true)
            }
            hidesBottomBarWhenPushed = false
        } else {
            if let aTitle = item.title {
                SVProgressHUD.showError(withStatus: "\(aTitle) 功能暂未实现")
            }
        }
    }



    
}
