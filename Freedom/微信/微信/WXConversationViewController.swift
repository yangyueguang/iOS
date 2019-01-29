//
//  WXConversationViewController.swift
//  Freedom
import SnapKit
import Alamofire
import Foundation
class WechatAddMenuCell: BaseTableViewCell<WXAddMenuItem> {
    override func initUI() {
        super.initUI()
        backgroundColor = UIColor.darkGray
        icon.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        title.frame = CGRect(x: icon.right + 10, y: 15, width: 100, height: 20)
        addSubviews([icon,title])
        viewModel.subscribe(onNext: {[weak self] (item) in
            guard let `self` = self else { return }
            self.icon.image = UIImage(named: item.iconPath)
            self.title.text = item.title
        }).disposed(by: disposeBag)
    }
}
class WechatConversationCell: BaseTableViewCell<WXConversation> {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var remindImageView: UIImageView!
    @IBOutlet weak var redPointView: UIView!
    override func initUI() {
        viewModel.subscribe(onNext: {[weak self] (con) in
            guard let `self` = self else { return }
            self.model = con
            if !con.avatarPath.isEmpty {
                let path = FileManager.pathUserAvatar(con.avatarPath)
                self.iconView.image = UIImage(named: path)
            } else if !con.avatarURL.isEmpty {
                self.iconView.sd_setImage(with: URL(string: con.avatarURL), placeholderImage: Image.logo.image)
            } else {
                self.iconView.image = nil
            }
            self.nameLabel.text = con.partnerName
            self.detailLabel.text = con.content
            self.timeLabel.text = con.date.timeToNow()
            switch con.remindType {
            case .normal:self.remindImageView.image = nil
            case .closed:self.remindImageView.image = Image.default.image
            case .notLook:self.remindImageView.image = Image.default.image
            case .unlike:self.remindImageView.image = Image.default.image
            }
            self.markAsRead(con.isRead)
        }).disposed(by: disposeBag)
    }
    //标记为已读/未读
    func markAsRead(_ isRead: Bool) {
        switch self.model.clueType {
        case .pointWithNumber:break
        case .point:redPointView.isHidden = (isRead)
        case .none:break
        }
    }
}
final class WXConversationViewController: BaseTableViewController {
    var searchVC = WXFriendSearchViewController()
    var data: [WXConversation] = []
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChange(_:)), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
        addRightItem()
    }
    private func addRightItem() {
        let item1 = WXAddMenuItem(title: "发起群聊", iconPath: WXImage.addFriend.rawValue, className: nil)
        let item2 = WXAddMenuItem(title: "添加朋友", iconPath: WXImage.addFriend.rawValue, className: WXAddFriendViewController.self)
        let item3 = WXAddMenuItem(title: "收付款", iconPath: WXImage.addFriend.rawValue, className: nil)
        let item4 = WXAddMenuItem(title: "扫一扫", iconPath: WXImage.addFriend.rawValue, className: WXScanningViewController.self)

        addMenuView = XPopMenu(frame: CGRect(x: APPW - 150, y: 0, width: 140, height: 0), items: [item1, item2, item3, item4], cellHeight: 50)
        addMenuView.cellClosure = {(table, item) in
            let cell = table.dequeueCell(WechatAddMenuCell.self)
            cell.viewModel.onNext(item)
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateConversationData()
    }
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
    private func updateConversationData() {
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
}
extension WXConversationViewController: UISearchBarDelegate {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = data[indexPath.row]
        let cell = tableView.dequeueCell(WechatConversationCell.self)
        cell.viewModel.onNext(conversation)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let chatVC = WXChatViewController.shared
        let conversation = data[indexPath.row]
        if conversation.convType == .personal {
            let user = WXFriendHelper.shared.getFriendInfo(byUserID: conversation.partnerID)
            chatVC.partner = user
        } else if conversation.convType == .group {
            let group = WXFriendHelper.shared.getGroupInfo(byGroupID: conversation.partnerID)
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
        })
        let moreAction = UITableViewRowAction(style: .default, title: conversation.isRead ? "标为未读" : "标为已读", handler: { action, indexPath in
            let cell = tableView.cellForRow(at: indexPath) as! WechatConversationCell
            cell.markAsRead(!conversation.isRead)
            tableView.setEditing(false, animated: true)
        })
        moreAction.backgroundColor = UIColor(hex: 0xdddddd)
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
