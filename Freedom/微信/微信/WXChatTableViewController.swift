//
//  WXChatTableViewController.swift
//  Freedom
import SnapKit
import MJRefresh
import XExtension
import Foundation

enum TLChatMenuItemType: Int {
    case cancel
    case copy
    case delete
}

protocol WXMessageCellDelegate: NSObjectProtocol {
    func messageCellDidClickAvatar(forUser user: WXChatUserProtocol)
    func messageCellTap(_ message: WXMessage)
    func messageCellLongPress(_ message: WXMessage, rect: CGRect)
    func messageCellDoubleClick(_ message: WXMessage)
}
protocol WXChatTableViewControllerDelegate: NSObjectProtocol {
    func chatTableViewControllerDidTouched(_ chatTVC: WXChatTableViewController)
    func chatTableViewController(_ chatTVC: WXChatTableViewController, getRecordsFrom date: Date, count: Int, completed: @escaping (Date, [WXMessage], Bool) -> Void)
    func chatTableViewController(_ chatTVC: WXChatTableViewController, delete message: WXMessage) -> Bool
    func chatTableViewController(_ chatTVC: WXChatTableViewController, didClickUserAvatar user: WXUser)
    func chatTableViewController(_ chatTVC: WXChatTableViewController, didClick message: WXMessage)
    func chatTableViewController(_ chatTVC: WXChatTableViewController, didDoubleClick message: WXMessage)
}
class WXMessageBaseCell: BaseTableViewCell<WXMessage> {
    weak var delegate: WXMessageCellDelegate?
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.small
        timeLabel.textColor = UIColor.whitex
        timeLabel.backgroundColor = UIColor.grayx
        timeLabel.alpha = 0.7
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 5.0
        return timeLabel
    }()
    lazy var avatarButton: UIButton = {
           let avatarButton = UIButton()
            avatarButton.layer.masksToBounds = true
            avatarButton.layer.borderWidth = 1
            avatarButton.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
            avatarButton.addTarget(self, action: #selector(self.avatarButtonDown(_:)), for: .touchUpInside)
        return avatarButton
    }()
    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.textColor = UIColor.grayx
        usernameLabel.font = UIFont.small
        return usernameLabel
    }()
    lazy var messageBackgroundView: UIImageView = {
            let messageBackgroundView = UIImageView()
            messageBackgroundView.isUserInteractionEnabled = true
            let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressMsgBGView))
            messageBackgroundView.addGestureRecognizer(longPressGR)
            let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(self.doubleTabpMsgBGView))
            doubleTapGR.numberOfTapsRequired = 2
            messageBackgroundView.addGestureRecognizer(doubleTapGR)
        return messageBackgroundView
    }()
    var message: WXMessage = WXMessage() {
        didSet {
            timeLabel.text = "  \(message.date.timeToNow)  "
            usernameLabel.text = message.fromUser?.chat_username
            if message.fromUser?.chat_avatarPath.count ?? 0 > 0 {
                let path = FileManager.pathUserAvatar(message.fromUser?.chat_avatarPath ?? "")
                avatarButton.setImage(UIImage(named: path), for: .normal)
            } else {
                avatarButton.sd_setImage(with: URL(string: message.fromUser?.chat_avatarURL ?? ""), for: UIControl.State.normal)
            }
            if self.message.showTime != message.showTime {
                timeLabel.snp.updateConstraints { (make) in
                    make.height.equalTo(message.showTime ? 20 : 0)
                    make.top.equalTo(self.contentView).offset(message.showTime ? 10 : 0)
                }
            }
            if self.message.ownerTyper != message.ownerTyper {
                avatarButton.snp.remakeConstraints { (make) in
                    make.width.height.equalTo(40)
                    make.top.equalTo(self.timeLabel.snp.bottom).offset(12)
                    if message.ownerTyper == .own {
                        make.right.equalTo(self.contentView).offset(-8)
                    }else{
                        make.left.equalTo(self.contentView).offset(8)
                    }
                }
                // 用户名
                usernameLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.avatarButton).offset(-1)
                    if message.ownerTyper == .own {
                        make.right.equalTo(self.avatarButton.snp.left).offset(-12)
                    }else{
                        make.left.equalTo(self.avatarButton.snp.right).offset(12)
                    }
                }
                // 背景
                messageBackgroundView.snp.remakeConstraints { (make) in
                    if message.ownerTyper == .own {
                        make.right.equalTo(self.avatarButton.snp.left).offset(-5)
                    }else{
                        make.left.equalTo(self.avatarButton.snp.right).offset(5)
                    }
                    make.top.equalTo(self.usernameLabel.snp.bottom).offset(message.showName ? 0: -1)
                }
            }
            usernameLabel.isHidden = !message.showName
            usernameLabel.snp.updateConstraints { (make) in
                make.height.equalTo(message.showName ? 14 : 0)
            }
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        contentView.addSubview(timeLabel)
        contentView.addSubview(avatarButton)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(messageBackgroundView)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.centerX.equalTo(self.contentView)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatarButton).offset(-1)
            make.right.equalTo(self.avatarButton.snp.left).offset(-12)
        }
        avatarButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-8)
            make.width.height.equalTo(40)
            make.top.equalTo(self.timeLabel.snp.bottom).offset(12)
        }
        messageBackgroundView.snp.makeConstraints { (make) in
            make.right.equalTo(self.avatarButton.snp.left).offset(-5)
            make.top.lastBaseline.equalTo(self.usernameLabel.snp.bottom).offset(-1)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func avatarButtonDown(_ sender: UIButton) {
        delegate?.messageCellDidClickAvatar(forUser: message.fromUser!)
    }
    @objc func longPressMsgBGView() {
        messageBackgroundView.isHighlighted = true
        var rect: CGRect = messageBackgroundView.frame
        rect.size.height -= 10 // 北京图片底部空白区域
        delegate?.messageCellLongPress(message, rect: rect)
    }
    @objc func doubleTabpMsgBGView() {
        delegate?.messageCellDoubleClick(message)
    }
}

class WXMessageImageView: UIImageView {
    var backgroundImage: UIImage? {
        didSet {
            maskLayer.contents = backgroundImage?.cgImage
        }
    }
    lazy var maskLayer: CAShapeLayer = {
           let maskLayer = CAShapeLayer()
            maskLayer.contentsCenter = CGRect(x: 0.5, y: 0.6, width: 0.1, height: 0.1)
            maskLayer.contentsScale = UIScreen.main.scale //非常关键设置自动拉伸的效果且不变形
        return maskLayer
    }()
    lazy var contentLayer: CALayer = {
        let contentLayer = CALayer()
        contentLayer.mask = self.maskLayer
        return contentLayer
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(contentLayer)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        maskLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        contentLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    func setThumbnailPath(_ imagePath: String?, highDefinitionImageURL imageURL: String) {
        if imagePath == nil {
            contentLayer.contents = nil
        } else {
            contentLayer.contents = UIImage(named: imagePath ?? "")?.cgImage
        }
    }
}
class WXTextMessageCell: WXMessageBaseCell {
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        var size = CGFloat(UserDefaults.standard.double(forKey: "CHAT_FONT_SIZE"))
        if size == 0 {
            size = 16.0
        }
        messageLabel.font = UIFont.systemFont(ofSize: size)
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    override var message: WXMessage {
        didSet {
            let lastOwnType = self.message.ownerTyper
//            messageLabel.attributedText = message.attrText()
            messageLabel.setContentCompressionResistancePriority(UILayoutPriority(500), for: .horizontal)
            messageBackgroundView.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
            if lastOwnType != message.ownerTyper {
                if message.ownerTyper == .own {
                    messageBackgroundView.image = UIImage(named: "message_sender_bg")
                    messageBackgroundView.highlightedImage = UIImage(named: "message_sender_bgHL")
                    messageLabel.snp.remakeConstraints { (make) in
                        make.right.equalTo(self.messageBackgroundView).offset(-22)
                        make.top.equalTo(self.messageBackgroundView).offset(15)
                    }
                    messageBackgroundView.snp.updateConstraints { (make) in
                        make.left.equalTo(self.messageLabel).offset(-20)
                        make.bottom.equalTo(self.messageLabel).offset(20)
                    }
                } else if message.ownerTyper == .friend {
                    messageBackgroundView.image = UIImage(named: "message_receiver_bg")
                    messageBackgroundView.highlightedImage = UIImage(named: "message_receiver_bgHL")
                    messageLabel.snp.remakeConstraints { (make) in
                        make.left.equalTo(self.messageBackgroundView).offset(20)
                        make.top.equalTo(self.messageBackgroundView).offset(15)
                    }
                    messageBackgroundView.snp.updateConstraints { (make) in
                        make.right.equalTo(self.messageLabel).offset(22)
                        make.bottom.equalTo(self.messageLabel).offset(20)
                    }
                }
            }
            messageLabel.snp.updateConstraints { (make) in
                make.size.equalTo(message.messageFrame.contentSize)
            }
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(messageLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WXImageMessageCell: WXMessageBaseCell {
    private lazy var msgImageView: WXMessageImageView = {
        let msgImageView = WXMessageImageView(frame: CGRect.zero)
        msgImageView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tapMessageView))
        msgImageView.addGestureRecognizer(tapGR)
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressMsgBGView))
        msgImageView.addGestureRecognizer(longPressGR)
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(self.doubleTabpMsgBGView))
        doubleTapGR.numberOfTapsRequired = 2
        msgImageView.addGestureRecognizer(doubleTapGR)
        return msgImageView
    }()
    override var message: WXMessage {
        didSet {
            msgImageView.alpha = 1.0 // 取消长按效果
            let lastOwnType = self.message.ownerTyper
            let imagePath = message.content.path
            if !imagePath.isEmpty {
                let imagePatha = FileManager.pathUserChatImage(imagePath)
                msgImageView.setThumbnailPath(imagePatha, highDefinitionImageURL: imagePatha)
            } else {
                msgImageView.setThumbnailPath(nil, highDefinitionImageURL: imagePath)
            }

            if lastOwnType != message.ownerTyper {
                if message.ownerTyper == .own {
                    msgImageView.backgroundImage = UIImage(named: "message_sender_bg")
                    msgImageView.snp.remakeConstraints { (make) in
                        make.top.equalTo(self.messageBackgroundView)
                        make.right.equalTo(self.messageBackgroundView)
                    }
                } else if message.ownerTyper == .friend {
                    msgImageView.backgroundImage = UIImage(named: "message_receiver_bg")
                    msgImageView.snp.remakeConstraints { (make) in
                        make.top.equalTo(self.messageBackgroundView)
                        make.left.equalTo(self.messageBackgroundView)
                    }
                }
            }
            msgImageView.snp.updateConstraints { (make) in
                make.size.equalTo(message.messageFrame.contentSize)
            }
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(msgImageView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func tapMessageView() {
        delegate?.messageCellTap(message)
    }
    override func longPressMsgBGView() {
        msgImageView.alpha = 0.7 // 比较low的选中效果
        var rect: CGRect = msgImageView.frame
        rect.size.height -= 10 // 北京图片底部空白区域
        delegate?.messageCellLongPress(message, rect: rect)
    }
    override func doubleTabpMsgBGView() {
        delegate?.messageCellDoubleClick(message)
    }
}
class WXExpressionMessageCell: WXMessageBaseCell {
    private lazy var msgImageView: UIImageView = {
        let msgImageView = UIImageView()
        msgImageView.isUserInteractionEnabled = true
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressMsgBGView))
        msgImageView.addGestureRecognizer(longPressGR)
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(self.doubleTabpMsgBGView))
        doubleTapGR.numberOfTapsRequired = 2
        msgImageView.addGestureRecognizer(doubleTapGR)
        return msgImageView
    }()
    override var message: WXMessage {
        didSet {
            let message = WXExpressionMessage()//message
            msgImageView.alpha = 1.0 // 取消长按效果
            let lastOwnType = self.message.ownerTyper
            let data = NSData(contentsOfFile: message.path)
            if data != nil {
                msgImageView.image = UIImage(named: message.path)
                msgImageView.image = UIImage.sd_animatedGIF(with: data! as Data)
            } else {
                // 表情组被删掉，先从缓存目录中查找，没有的话在下载并存入缓存目录
                let MycachePath = FileManager.cache(forFile: "\(message.emoji.groupID)_\(message.emoji.emojiID).gif")
                let data = NSData(contentsOfFile: MycachePath)
                if data != nil {
                    msgImageView.image = UIImage(named: MycachePath)
                    msgImageView.image = UIImage.sd_animatedGIF(with: data! as Data)
                } else {
                    msgImageView.sd_setImage(with: URL(string: message.url), completed: { image, error, cacheType, imageURL in
                        if (imageURL?.absoluteString == (self.message as! WXExpressionMessage).url) {
                            DispatchQueue.global(qos: .default).async(execute: {
                                let data = try! Data(contentsOf: imageURL!)
                                let pa = NSSearchPathForDirectoriesInDomains(
                                    .cachesDirectory, .userDomainMask, true)[0]
                                try! data.write(to: URL(fileURLWithPath: pa), options: NSData.WritingOptions.atomic) // 再写入到缓存中
                                DispatchQueue.main.async(execute: {
                                    self.msgImageView.image = UIImage.sd_animatedGIF(with: data)
                                })
                            })
                        }
                    })
                }
            }
            if lastOwnType != message.ownerTyper {
                if message.ownerTyper == .own {
                    msgImageView.snp.remakeConstraints { (make) in
                        make.top.equalTo(self.usernameLabel.snp.bottom).offset(5)
                        make.right.equalTo(self.messageBackgroundView).offset(-10)
                    }
                } else if message.ownerTyper == .friend {
                    msgImageView.snp.remakeConstraints { (make) in
                        make.top.equalTo(self.usernameLabel.snp.bottom).offset(5)
                        make.left.equalTo(self.messageBackgroundView).offset(10)
                    }
                }
            }
            msgImageView.snp.updateConstraints { (make) in
                make.size.equalTo(message.messageFrame.contentSize)
            }
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(msgImageView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func longPressMsgBGView() {
        msgImageView.alpha = 0.7 // 比较low的选中效果
        delegate?.messageCellLongPress(message, rect: msgImageView.frame)
    }
    override func doubleTabpMsgBGView() {
        delegate?.messageCellDoubleClick(message)
    }

}
class WXChatCellMenuView: UIView {
    static let shared = WXChatCellMenuView(frame: CGRect.zero)
    private(set) var isShow = false
    var messageType = TLMessageType.text {
        didSet {
            let copy = UIMenuItem(title: "复制", action: #selector(self.copyButtonDown(_:)))
            let transmit = UIMenuItem(title: "转发", action: #selector(self.transmitButtonDown(_:)))
            let collect = UIMenuItem(title: "收藏", action: #selector(self.collectButtonDown(_:)))
            let del = UIMenuItem(title: "删除", action: #selector(self.deleteButtonDown(_:)))
            menuController.menuItems = [copy, transmit, collect, del]
        }
    }
    var actionBlcok: ((TLChatMenuItemType) -> Void)?
    private var menuController = UIMenuController.shared
    static var menuView = WXChatCellMenuView(frame: CGRect.zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(WXChatCellMenuView.dismiss))
        addGestureRecognizer(tapGR)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show(in view: UIView, with messageType: TLMessageType, rect: CGRect, actionBlock: @escaping (TLChatMenuItemType) -> Void) {
        if isShow { return }
        isShow = true
        self.frame = view.bounds
        view.addSubview(self)
        self.actionBlcok = actionBlock
        self.messageType = messageType
        menuController.setTargetRect(rect, in: self)
        becomeFirstResponder()
        menuController.setMenuVisible(true, animated: true)
    }
    @objc  func dismiss() {
        isShow = false
        actionBlcok?(.cancel)
        menuController.setMenuVisible(false, animated: true)
        removeFromSuperview()
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    @objc  func copyButtonDown(_ sender: UIMenuController) {
        p_clickedMenuItemType(.copy)
    }
    @objc  func transmitButtonDown(_ sender: UIMenuController) {
        p_clickedMenuItemType(.copy)
    }
    @objc  func collectButtonDown(_ sender: UIMenuController) {
        p_clickedMenuItemType(.copy)
    }
    @objc  func deleteButtonDown(_ sender: UIMenuController) {
        p_clickedMenuItemType(.delete)
    }
    func p_clickedMenuItemType(_ type: TLChatMenuItemType) {
        isShow = false
        removeFromSuperview()
        actionBlcok?(type)
    }
}
@objcMembers
class WXChatTableViewController: BaseTableViewController, WXMessageCellDelegate {
    weak var delegate: WXChatTableViewControllerDelegate?
    var data: [WXMessage] = []/// 禁用下拉刷新
    var disablePullToRefresh = false {
        didSet {
            if disablePullToRefresh {
                tableView.mj_header = nil
            } else {
                tableView.mj_header = refresHeader
            }
        }
    }
    var disableLongPressMenu = false/// 用户决定新消息是否显示时间
    private var curDate = Date()
    private lazy var refresHeader: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: {
        self.p_try(toRefreshMoreRecord: { count, hasMore in
                self.tableView.mj_header.endRefreshing()
                if !hasMore {
                    self.tableView.mj_header = nil
                }
                if count > 0 {
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: count, section: 0), at: .top, animated: false)
                }
            })
        })
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 20))
        refresHeader.lastUpdatedTimeLabel.isHidden = true
        refresHeader.stateLabel.isHidden = true
        if !disablePullToRefresh {
            tableView.mj_header = refresHeader
        }
        registerCellClass()
        let tap = UITapGestureRecognizer(target: self, action: #selector(WXChatTableViewController.didTouchTableView))
        tableView.addGestureRecognizer(tap)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if WXChatCellMenuView.shared.isShow {
            WXChatCellMenuView.shared.dismiss()
        }
    }
    func reloadData() {
        data.removeAll()
        tableView.reloadData()
        curDate = Date()
        if !disablePullToRefresh {
            tableView.mj_header = refresHeader
        }
        p_try(toRefreshMoreRecord: { count, hasMore in
            if !hasMore {
                self.tableView.mj_header = nil
            }
            if count > 0 {
                self.tableView.reloadData()
                self.tableView.scrollToBottom(withAnimation: false)
            }
        })
    }
    func add(_ message: WXMessage) {
        data.append(message)
        tableView.reloadData()
    }

    func scrollToBottom(withAnimation animation: Bool) {
        tableView.scrollToBottom(withAnimation: animation)
    }
    @objc func didTouchTableView() {
        delegate?.chatTableViewControllerDidTouched(self)
    }
    //获取聊天历史记录
    func p_try(toRefreshMoreRecord complete: @escaping (_ count: Int, _ hasMore: Bool) -> Void) {
        delegate?.chatTableViewController(self, getRecordsFrom: curDate, count: 15, completed: { date, array, hasMore in
            if array.count > 0 {
                self.curDate = array[0].date
                for (objectIndex, insertionIndex) in NSIndexSet(indexesIn: NSRange(location: 0, length: array.count)).enumerated() {
                    self.data.insert(array[objectIndex], at: insertionIndex)
                }
                complete(array.count, hasMore)
            } else {
                complete(0, hasMore)
            }
        })
    }

    func registerCellClass() {
        tableView.register(WXTextMessageCell.self, forCellReuseIdentifier: WXTextMessageCell.identifier)
        tableView.register(WXImageMessageCell.self, forCellReuseIdentifier: WXImageMessageCell.identifier)
        tableView.register(WXExpressionMessageCell.self, forCellReuseIdentifier: WXExpressionMessageCell.identifier)
        tableView.register(BaseTableViewCell<Any>.self, forCellReuseIdentifier: BaseTableViewCell<Any>.identifier)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message: WXMessage = data[indexPath.row]
        if message.messageType == .text {
            let cell = tableView.dequeueCell(WXTextMessageCell.self)
            cell.message = message
            cell.delegate = self
            return cell
        } else if message.messageType == .image {
            let cell = tableView.dequeueCell(WXImageMessageCell.self)
            cell.message = message
            cell.delegate = self
            return cell
        } else if message.messageType == .expression {
            let cell = tableView.dequeueCell(WXExpressionMessageCell.self)
            cell.message = message
            cell.delegate = self
            return cell
        }
        return tableView.dequeueCell(BaseTableViewCell<Any>.self)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message: WXMessage = data[indexPath.row]
        return message.messageFrame.height
    }

    func messageCellDidClickAvatar(for user: WXUser) {
        delegate?.chatTableViewController(self, didClickUserAvatar: user)
    }

    func messageCellTap(_ message: WXMessage) {
        delegate?.chatTableViewController(self, didClick: message)
    }
    func messageCellLongPress(_ message: WXMessage, rect: CGRect) {
        let row = data.index(of: message) ?? 0
        let indexPath = IndexPath(row: row, section: 0)
        if disableLongPressMenu {
            tableView.reloadRows(at: [indexPath], with: .none)
            return
        }
        if WXChatCellMenuView.shared.isShow {
            return
        }
        var rect = rect
        let cellRect: CGRect = tableView.rectForRow(at: indexPath)
        rect.origin.y += cellRect.origin.y - tableView.contentOffset.y
        WXChatCellMenuView.shared.show(in: navigationController?.view ?? self.view, with: message.messageType, rect: rect, actionBlock: { type in
            self.tableView.reloadRows(at: [indexPath], with: .none)
            if type == .copy {
                let str = message.messageCopy()
                UIPasteboard.general.string = str
            } else if type == .delete {
                let alert = UIAlertController("是否删除该条消息", "", T1: "确定", T2: "取消", confirm1: {
                    self.p_delete(message)
                }, confirm2: {

                })
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    func messageCellDoubleClick(_ message: WXMessage) {
        delegate?.chatTableViewController(self, didDoubleClick: message)
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.chatTableViewControllerDidTouched(self)
    }
    func p_delete(_ message: WXMessage) {
        let index = data.index(of: message) ?? 0
        let ok = delegate?.chatTableViewController(self, delete: message) ?? false
        if ok {
            data.removeAll(where: { element in element == message })
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        } else {
            noticeError("从数据库中删除消息失败。")
        }
    }
    func messageCellDidClickAvatar(forUser user: WXChatUserProtocol) {
    }
}
