////
////  WXChatTableViewController.swift
////  Freedom
//
//import Foundation
//let PAGE_MESSAGE_COUNT = 15
//let MSG_SPACE_TOP = 14
//let MSG_SPACE_BTM = 20
//let MSG_SPACE_LEFT = 19
//let MSG_SPACE_RIGHT = 22
//let TIMELABEL_HEIGHT = 20.0
//let TIMELABEL_SPACE_Y = 10.0
//let NAMELABEL_HEIGHT = 14.0
//let NAMELABEL_SPACE_X = 12.0
//let NAMELABEL_SPACE_Y = 1.0
//let AVATAR_WIDTH = 40.0
//let AVATAR_SPACE_X = 8.0
//let AVATAR_SPACE_Y = 12.0
//let MSGBG_SPACE_X = 5.0
//let MSGBG_SPACE_Y = 1.0
//enum TLChatMenuItemType: Int {
//    case cancel
//    case copy
//    case delete
//}
//
//extension UITableView {
//    func scrollToBottom(withAnimation animation: Bool) {
//        var section = (dataSource?.numberOfSections(in: self) ?? 1) - 1
//        let row: Int = dataSource?.tableView(self, numberOfRowsInSection: section) ?? 0
//        if (row) > 0 {
//            scrollToRow(at: IndexPath(row: (row) - 1, section: section), at: .bottom, animated: animation)
//        }
//    }
//}
//protocol WXMessageCellDelegate: NSObjectProtocol {
//    func messageCellDidClickAvatar(forUser user: WXChatUserProtocol)
//    func messageCellTap(_ message: WXMessage)
//    func messageCellLongPress(_ message: WXMessage, rect: CGRect)
//    func messageCellDoubleClick(_ message: WXMessage)
//}
//protocol WXChatTableViewControllerDelegate: NSObjectProtocol {
//    func chatTableViewControllerDidTouched(_ chatTVC: WXChatTableViewController)
//    func chatTableViewController(_ chatTVC: WXChatTableViewController, getRecordsFrom date: Date, count: Int, completed: @escaping (Date, [Any], Bool) -> Void)
//    func chatTableViewController(_ chatTVC: WXChatTableViewController, delete message: WXMessage) -> Bool
//    func chatTableViewController(_ chatTVC: WXChatTableViewController, didClickUserAvatar user: WXUser)
//    func chatTableViewController(_ chatTVC: WXChatTableViewController, didClick message: WXMessage)
//    func chatTableViewController(_ chatTVC: WXChatTableViewController, didDoubleClick message: WXMessage)
//}
//class WXMessageBaseCell: UITableViewCell {
//    weak var delegate: WXMessageCellDelegate?
//    lazy var timeLabel: UILabel = {
//        let timeLabel = UILabel()
//        timeLabel.font = UIFont.systemFont(ofSize: 12.0)
//        timeLabel.textColor = UIColor.white
//        timeLabel.backgroundColor = UIColor.gray
//        timeLabel.alpha = 0.7
//        timeLabel.layer.masksToBounds = true
//        timeLabel.layer.cornerRadius = 5.0
//        return timeLabel
//    }()
//    lazy var avatarButton: UIButton = {
//           let avatarButton = UIButton()
//            avatarButton.layer.masksToBounds = true
//            avatarButton.layer.borderWidth = 1
//            avatarButton.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
//            avatarButton.addTarget(self, action: #selector(self.avatarButtonDown(_:)), for: .touchUpInside)
//        return avatarButton
//    }()
//    lazy var usernameLabel: UILabel = {
//        let usernameLabel = UILabel()
//        usernameLabel.textColor = UIColor.gray
//        usernameLabel.font = UIFont.systemFont(ofSize: 12.0)
//        return usernameLabel
//    }()
//
//    lazy var messageBackgroundView: UIImageView = {
//            let messageBackgroundView = UIImageView()
//            messageBackgroundView.isUserInteractionEnabled = true
//
//            let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressMsgBGView))
//            messageBackgroundView.addGestureRecognizer(longPressGR)
//
//            let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(self.doubleTabpMsgBGView))
//            doubleTapGR.numberOfTapsRequired = 2
//            messageBackgroundView.addGestureRecognizer(doubleTapGR)
//        return messageBackgroundView
//    }()
//    var message: WXMessage
//    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = UIColor.clear
//        selectionStyle = .none
//        contentView.addSubview(timeLabel)
//        contentView.addSubview(avatarButton)
//        contentView.addSubview(usernameLabel)
//        contentView.addSubview(messageBackgroundView)
////        p_addMasonry()
//    }
//    func setMessage(_ message: WXMessage) {
//        if self.message && (self.message.messageID == message.messageID) {
//            return
//        }
//        if let aNow = message.date.timeToNow {
//            timeLabel.text = "  \(aNow)  "
//        }
//        usernameLabel.text = message.fromUser.chat_username()
//        if message.fromUser.chat_avatarPath().length > 0 {
//            let path = FileManager.pathUserAvatar(message.fromUser.chat_avatarPath())
//            avatarButton.setImage(UIImage(named: path), for: .normal)
//        } else {
//            avatarButton.sd_setImage(with: URL(string: message.fromUser.chat_avatarURL()), for: UIControl.State.normal)
//        }
//        if !self.message || self.message.showTime != message.showTime {
//            timeLabel.mas_updateConstraints({ make in
//                make.height.mas_equalTo(message.showTime != nil  TIMELABEL_HEIGHT : 0)
//                make.top.mas_equalTo(self.contentView).mas_offset(message.showTime != nil  TIMELABEL_SPACE_Y : 0)
//            })
//        }
//
//        if message == nil || self.message.ownerTyper != message.ownerTyper {
//            // 头像
//            avatarButton.mas_remakeConstraints({ make in
//                make.width.and().height().mas_equalTo(AVATAR_WIDTH)
//                make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(AVATAR_SPACE_Y)
//                if message.ownerTyper == TLMessageOwnerTypeSelf {
//                    make.right.mas_equalTo(self.contentView).mas_offset(-AVATAR_SPACE_X)
//                } else {
//                    make.left.mas_equalTo(self.contentView).mas_offset(AVATAR_SPACE_X)
//                }
//            })
//
//            // 用户名
//            usernameLabel.mas_remakeConstraints({ make in
//                make.top.mas_equalTo(self.avatarButton).mas_equalTo(-NAMELABEL_SPACE_Y)
//                if message.ownerTyper == TLMessageOwnerTypeSelf {
//                    make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-NAMELABEL_SPACE_X)
//                } else {
//                    make.left.mas_equalTo(self.avatarButton.mas_right).mas_equalTo(NAMELABEL_SPACE_X)
//                }
//            })
//
//            // 背景
//            messageBackgroundView.mas_remakeConstraints({ make in
//                message.ownerTyper == TLMessageOwnerTypeSelf  make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-MSGBG_SPACE_X) : make.left.mas_equalTo(self.avatarButton.mas_right).mas_offset(MSGBG_SPACE_X)
//                make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(message.showName != nil  0 : -MSGBG_SPACE_Y)
//            })
//        }
//
//        usernameLabel.hidden = !message.showName
//        usernameLabel.mas_updateConstraints({ make in
//            make.height.mas_equalTo(message.showName != nil ? NAMELABEL_HEIGHT : 0)
//        })
//        self.message = message
//    }
////    func p_addMasonry() {
////        timeLabel.mas_makeConstraints({ make in
////            make.top.mas_equalTo(self.contentView).mas_offset(TIMELABEL_SPACE_Y)
////            make.centerX.mas_equalTo(self.contentView)
////        })
////        usernameLabel.mas_makeConstraints({ make in
////            make.top.mas_equalTo(self.avatarButton).mas_equalTo(-NAMELABEL_SPACE_Y)
////            make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-NAMELABEL_SPACE_X)
////        })
////        avatarButton.mas_makeConstraints({ make in
////            make.right.mas_equalTo(self.contentView).mas_offset(-AVATAR_SPACE_X)
////            make.width.and().height().mas_equalTo(AVATAR_WIDTH)
////            make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(AVATAR_SPACE_Y)
////        })
////        messageBackgroundView.mas_remakeConstraints({ make in
////            make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-MSGBG_SPACE_X)
////            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(-MSGBG_SPACE_Y)
////        })
////    }
//    func avatarButtonDown(_ sender: UIButton) {
//        delegate?.messageCellDidClickAvatar(forUser: message.fromUser)
//    }
//
//    func longPressMsgBGView() {
//        messageBackgroundView.highlighted = true
//        var rect: CGRect = messageBackgroundView.frame
//        rect.size.height -= 10 // 北京图片底部空白区域
//        delegate?.messageCellLongPress(message, rect: rect)
//    }
//
//    func doubleTabpMsgBGView() {
//        delegate?.messageCellDoubleClick(message)
//    }
//}
//
//class WXMessageImageView: UIImageView {
//    var backgroundImage: UIImage {
//        didSet {
//               maskLayer.contents = backgroundImage.cgImage
//        }
//    }
//    lazy var maskLayer: CAShapeLayer = {
//           let maskLayer = CAShapeLayer()
//            maskLayer.contentsCenter = CGRect(x: 0.5, y: 0.6, width: 0.1, height: 0.1)
//            maskLayer.contentsScale = UIScreen.main.scale //非常关键设置自动拉伸的效果且不变形
//        return maskLayer
//    }()
//    lazy var contentLayer: CALayer = {
//        let contentLayer = CALayer()
//        contentLayer.mask = self.maskLayer
//        return contentLayer
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        layer.addSublayer(contentLayer)
//
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//    }
//    func layoutSubviews() {
//        super.layoutSubviews()
//        maskLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
//        contentLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
//    }
//    func setThumbnailPath(_ imagePath: String, highDefinitionImageURL imageURL: String) {
//        if imagePath == nil {
//            contentLayer.contents = nil
//        } else {
//            contentLayer.contents = UIImage(named: imagePath).cgImage
//        }
//    }
//}
//class WXTextMessageCell: WXMessageBaseCell {
//    private var messageLabel: UILabel
//
//    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        if let aLabel = messageLabel {
//            contentView.addSubview(aLabel)
//        }
//
//    }
//    func setMessage(_ message: WXTextMessage) {
//        if self.message && (self.message.messageID == message.messageID) {
//            return
//        }
//        let lastOwnType = self.message  self.message.ownerTyper : -1 as TLMessageOwnerType
//        super.setMessage(message)
//        messageLabel.attributedText = message.attrText()
//
//        messageLabel.setContentCompressionResistancePriority(UILayoutPriority(500), for: .horizontal)
//        messageBackgroundView.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
//        if lastOwnType != message.ownerTyper {
//            if message.ownerTyper == TLMessageOwnerTypeSelf {
//                messageBackgroundView.image = UIImage(named: "message_sender_bg")
//                messageBackgroundView.highlightedImage = UIImage(named: "message_sender_bgHL")
//
//                messageLabel.mas_remakeConstraints({ make in
//                    make.right.mas_equalTo(self.messageBackgroundView).mas_offset(-MSG_SPACE_RIGHT)
//                    make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP)
//                })
//                messageBackgroundView.mas_updateConstraints({ make in
//                    make.left.mas_equalTo(self.messageLabel).mas_offset(-MSG_SPACE_LEFT)
//                    make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM)
//                })
//            } else if message.ownerTyper == TLMessageOwnerTypeFriend {
//                messageBackgroundView.image = UIImage(named: "message_receiver_bg")
//                messageBackgroundView.highlightedImage = UIImage(named: "message_receiver_bgHL")
//                messageLabel.mas_remakeConstraints({ make in
//                    make.left.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_LEFT)
//                    make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP)
//                })
//                messageBackgroundView.mas_updateConstraints({ make in
//                    make.right.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_RIGHT)
//                    make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM)
//                })
//            }
//        }
//
//        messageLabel.mas_updateConstraints({ make in
//            make.size.mas_equalTo(message.messageFrame.contentSize)
//        })
//    }
//    func messageLabel() -> UILabel {
//        if messageLabel == nil {
//            messageLabel = UILabel()
//            var size = CGFloat(UserDefaults.standard.double(forKey: "CHAT_FONT_SIZE"))
//            if size == 0 {
//                size = 16.0
//            }
//            messageLabel.font = UIFont.systemFont(ofSize: size)
//            messageLabel.numberOfLines = 0
//        }
//        return messageLabel
//    }
//}
//
//class WXImageMessageCell: WXMessageBaseCell {
//    private var msgImageView: WXMessageImageView
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        if let aView = msgImageView {
//            contentView.addSubview(aView)
//        }
//
//    }
//    func setMessage(_ message: WXImageMessage) {
//        msgImageView.alpha = 1.0 // 取消长按效果
//        if self.message && (self.message.messageID == message.messageID) {
//            return
//        }
//        let lastOwnType = self.message  self.message.ownerTyper : -1 as TLMessageOwnerType
//        super.setMessage(message)
//        let imagePath = message.content["path"]
//        if imagePath != nil {
//            let imagePatha = FileManager.pathUserChatImage(imagePath)
//            msgImageView.setThumbnailPath(imagePatha, highDefinitionImageURL: imagePatha)
//        } else {
//            msgImageView.setThumbnailPath(nil, highDefinitionImageURL: imagePath)
//        }
//
//        if lastOwnType != message.ownerTyper {
//            if message.ownerTyper == TLMessageOwnerTypeSelf {
//                msgImageView.backgroundImage = UIImage(named: "message_sender_bg")
//                msgImageView.mas_remakeConstraints({ make in
//                    make.top.mas_equalTo(self.messageBackgroundView)
//                    make.right.mas_equalTo(self.messageBackgroundView)
//                })
//            } else if message.ownerTyper == TLMessageOwnerTypeFriend {
//                msgImageView.backgroundImage = UIImage(named: "message_receiver_bg")
//                msgImageView.mas_remakeConstraints({ make in
//                    make.top.mas_equalTo(self.messageBackgroundView)
//                    make.left.mas_equalTo(self.messageBackgroundView)
//                })
//            }
//        }
//        msgImageView.mas_updateConstraints({ make in
//            make.size.mas_equalTo(message.messageFrame.contentSize)
//        })
//    }
//    func tapMessageView() {
//        delegate?.messageCellTap(message)
//    }
//
//    func longPressMsgBGView() {
//        msgImageView.alpha = 0.7 // 比较low的选中效果
//        let rect: CGRect = msgImageView.frame
//        rect.size.height -= 10 // 北京图片底部空白区域
//        delegate?.messageCellLongPress(message, rect: rect)
//    }
//
//    func doubleTabpMsgBGView() {
//        delegate?.messageCellDoubleClick(message)
//    }
//    func msgImageView() -> WXMessageImageView {
//        if msgImageView == nil {
//            msgImageView = WXMessageImageView()
//            msgImageView.isUserInteractionEnabled = true
//
//            let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tapMessageView))
//            msgImageView.addGestureRecognizer(tapGR)
//
//            let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressMsgBGView))
//            msgImageView.addGestureRecognizer(longPressGR)
//
//            let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(self.doubleTabpMsgBGView))
//            doubleTapGR.numberOfTapsRequired = 2
//            msgImageView.addGestureRecognizer(doubleTapGR)
//        }
//        return msgImageView
//    }
//
//
//    
//}
//class WXExpressionMessageCell: WXMessageBaseCell {
//    private lazy var msgImageView: UIImageView = {
//        let msgImageView = UIImageView()
//        msgImageView.isUserInteractionEnabled = true
//        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressMsgBGView))
//        msgImageView.addGestureRecognizer(longPressGR)
//        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(self.doubleTabpMsgBGView))
//        doubleTapGR.numberOfTapsRequired = 2
//        msgImageView.addGestureRecognizer(doubleTapGR)
//        return msgImageView
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(msgImageView)
//    }
//    func setMessage(_ message: WXExpressionMessage) {
//        msgImageView.alpha = 1.0 // 取消长按效果
//        let lastOwnType = self.message ? self.message.ownerTyper : TLMessageOwnerType.unknown
//        super.setMessage(message)
//        let data = NSData(contentsOfFile: message.path) as Data
//        if data != nil {
//            msgImageView.image = UIImage(named: message.path)
//            msgImageView.image = UIImage.sd_animatedGIF(with: data)
//        } else {
//            // 表情组被删掉，先从缓存目录中查找，没有的话在下载并存入缓存目录
//            var MycachePath = FileManager.cache(forFile: "\(message.emoji.groupID)_\(message.emoji.emojiID).gif")
//            let data = NSData(contentsOfFile: MycachePath) as Data
//            if data != nil {
//                msgImageView.image = UIImage(named: MycachePath)
//                msgImageView.image = UIImage.sd_animatedGIF(with: data)
//            } else {
//                weak var weakSelf = self
//                msgImageView.sd_setImage(with: URL(string: message.url), completed: { image, error, cacheType, imageURL in
//                    if (imageURL.description() == (weakSelf.message as WXExpressionMessage).url()) {
//                        DispatchQueue.global(qos: .default).async(execute: {
//                            var data = try Data(contentsOf: imageURL)
//                            data.write(toFile: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0], atomically: false) // 再写入到缓存中
//                            if (imageURL.description() == (weakSelf.message as WXExpressionMessage).url()) {
//                                DispatchQueue.main.async(execute: {
//                                    self.msgImageView.image = UIImage.sd_animatedGIF(withData: data)
//                                })
//                            }
//                        })
//                    }
//                })
//            }
//        }
//        if lastOwnType != message.ownerTyper {
//            if message.ownerTyper == .own {
//                msgImageView.mas_remakeConstraints({ make in
//                    make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(5)
//                    make.right.mas_equalTo(self.messageBackgroundView).mas_offset(-10)
//                })
//            } else if message.ownerTyper == .friend {
//                msgImageView.mas_remakeConstraints({ make in
//                    make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(5)
//                    make.left.mas_equalTo(self.messageBackgroundView).mas_offset(10)
//                })
//            }
//        }
//        msgImageView.mas_updateConstraints({ make in
//            make.size.mas_equalTo(message.messageFrame.contentSize)
//        })
//    }
//    override func longPressMsgBGView() {
//        msgImageView.alpha = 0.7 // 比较low的选中效果
//        delegate?.messageCellLongPress(message, rect: msgImageView.frame)
//    }
//    override func doubleTabpMsgBGView() {
//        delegate?.messageCellDoubleClick(message)
//    }
//
//}
//
//class WXChatCellMenuView: UIView {
//    static let shared = WXChatCellMenuView()
//    private(set) var isShow = false
//    var messageType = TLMessageType.text {
//        didSet {
//            let copy = UIMenuItem(title: "复制", action: #selector(self.copyButtonDown(_:)))
//            let transmit = UIMenuItem(title: "转发", action: #selector(self.transmitButtonDown(_:)))
//            let collect = UIMenuItem(title: "收藏", action: #selector(self.collectButtonDown(_:)))
//            let del = UIMenuItem(title: "删除", action: #selector(self.deleteButtonDown(_:)))
//            menuController.menuItems = [copy, transmit, collect, del]
//        }
//    }
//    var actionBlcok: (() -> Void)?
//    private var menuController: UIMenuController
//    static var menuView = WXChatCellMenuView()
//    init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.clear
//        menuController = UIMenuController.shared
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(WXChatCellMenuView.dismiss))
//        addGestureRecognizer(tapGR)
//    }
//    func show(in view: UIView, with messageType: TLMessageType, rect: CGRect, actionBlock: @escaping (TLChatMenuItemType) -> Void) {
//        if isShow { return }
//        isShow = true
//        self.frame = view.bounds
//        view.addSubview(self)
//        self.actionBlcok = actionBlock
//        self.messageType = messageType
//        menuController.setTargetRect(rect, in: self)
//        becomeFirstResponder()
//        menuController.setMenuVisible(true, animated: true)
//    }
//
//
//    func dismiss() {
//        isShow = false
//        actionBlcok?(TLChatMenuItemTypeCancel)
//        menuController.setMenuVisible(false, animated: true)
//        removeFromSuperview()
//    }
//    var canBecomeFirstResponder: Bool {
//        return true
//    }
//    func copyButtonDown(_ sender: UIMenuController) {
//        p_clickedMenuItemType(TLChatMenuItemTypeCopy)
//    }
//    func transmitButtonDown(_ sender: UIMenuController) {
//        p_clickedMenuItemType(TLChatMenuItemTypeCopy)
//    }
//    func collectButtonDown(_ sender: UIMenuController) {
//        p_clickedMenuItemType(TLChatMenuItemTypeCopy)
//    }
//    func deleteButtonDown(_ sender: UIMenuController) {
//        p_clickedMenuItemType(TLChatMenuItemTypeDelete)
//    }
//    func p_clickedMenuItemType(_ type: TLChatMenuItemType) {
//        isShow = false
//        removeFromSuperview()
//        actionBlcok?(type)
//    }
//}
//class WXChatTableViewController: UITableViewController, WXMessageCellDelegate {
//    weak var delegate: WXChatTableViewControllerDelegate?
//    var data: [WXMessage] = []/// 禁用下拉刷新
//    var disablePullToRefresh = false {
//        didSet {
//            if disablePullToRefresh {
//                tableView.setMj_header(nil)
//            } else {
//                tableView.setMj_header(refresHeader)
//            }
//        }
//    }
//    var disableLongPressMenu = false/// 用户决定新消息是否显示时间
//    private var curDate = Date()
//    private lazy var refresHeader: MJRefreshNormalHeader = {
//       let refresHeader = MJRefreshNormalHeader(refreshingBlock: {
//            self.p_try(toRefreshMoreRecord: { count, hasMore in
//                self.tableView.mj_header.endRefreshing()
//                if !hasMore {
//                    self.tableView.mj_header = nil
//                }
//                if count > 0 {
//                    self.tableView.reloadData()
//                    self.tableView.scrollToRow(at: IndexPath(row: count, section: 0), at: .top, animated: false)
//                }
//            })
//        })
//        refresHeader.lastUpdatedTimeLabel.hidden = true
//        refresHeader.stateLabel.hidden = true
//        return refresHeader
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = UIColor.clear
//        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 20))
//        if !disablePullToRefresh {
//            tableView.mj_header = refresHeader
//        }
//        registerCellClass()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(WXChatTableViewController.didTouchTableView))
//        tableView.addGestureRecognizer(tap)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if WXChatCellMenuView.shared().isShow() {
//            WXChatCellMenuView.shared().dismiss()
//        }
//    }
//    func reloadData() {
//        data.removeAll()
//        tableView.reloadData()
//        curDate = Date()
//        if !disablePullToRefresh {
//            tableView.setMj_header(refresHeader)
//        }
//        p_try(toRefreshMoreRecord: { count, hasMore in
//            if !hasMore {
//                self.tableView.mj_header = nil
//            }
//            if count > 0 {
//                self.tableView.reloadData()
//                self.tableView.scrollToBottom(withAnimation: false)
//            }
//        })
//    }
//    func add(_ message: WXMessage) {
//        data.append(message)
//        tableView.reloadData()
//    }
//
//    func delete(_ message: WXMessage) {
//        var index: Int = data.index(of: message)
//        let ok = delegate?.chatTableViewController(self, delete: message) ?? false
//        if ok {
//            data.removeAll(where: { element in element == message })
//            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//        } else {
//            noticeError("从数据库中删除消息失败。")
//        }
//    }
//    func scrollToBottom(withAnimation animation: Bool) {
//        tableView.scrollToBottom(withAnimation: animation)
//    }
//
//    func didTouchTableView() {
//        delegate?.chatTableViewControllerDidTouched(self)
//    }
//    //获取聊天历史记录
//    func p_try(toRefreshMoreRecord complete: @escaping (_ count: Int, _ hasMore: Bool) -> Void) {
//        delegate?.chatTableViewController(self, getRecordsFromDate: curDate, count: PAGE_MESSAGE_COUNT, completed: { date, array, hasMore in
//            if (array.count) > 0 && date.isEqual(to: self.curDate) {
//                self.curDate = array[0].date()
//                if let anArray = array {
//                    for (objectIndex, insertionIndex) in NSIndexSet(indexesIn: NSRange(location: 0, length: array.count)).enumerated() { self.data.insert((anArray)[objectIndex], at: insertionIndex) }
//                }
//                complete(array.count, hasMore)
//            } else {
//                complete(0, hasMore)
//            }
//        })
//    }
//
//    func registerCellClass() {
//        tableView.register(WXTextMessageCell.self, forCellReuseIdentifier: "TLTextMessageCell")
//        tableView.register(WXImageMessageCell.self, forCellReuseIdentifier: "TLImageMessageCell")
//        tableView.register(WXExpressionMessageCell.self, forCellReuseIdentifier: "TLExpressionMessageCell")
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCell")
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let message: WXMessage = data[indexPath.row]
//        if message.messageType == .text {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TLTextMessageCell") as WXTextMessageCell
//            cell.message = message
//            cell.delegate = self
//            return cell!
//        } else if message.messageType == .image {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TLImageMessageCell") as WXImageMessageCell
//            cell.message = message
//            cell.delegate = self
//            return cell!
//        } else if message.messageType == .expression {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TLExpressionMessageCell") as WXExpressionMessageCell
//            cell.message = message
//            cell.delegate = self
//            return cell!
//        }
//        return (tableView.dequeueReusableCell(withIdentifier: "EmptyCell"))!
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let message: WXMessage = data[indexPath.row]
//        return message.messageFrame.height
//    }
//
//    func messageCellDidClickAvatar(for user: WXUser) {
//        delegate?.chatTableViewController(self, didClickUserAvatar: user)
//    }
//
//    func messageCellTap(_ message: WXMessage) {
//        delegate?.chatTableViewController(self, didClick: message)
//    }
//    func messageCellLongPress(_ message: WXMessage, rect: CGRect) {
//        var row = data.index(of: message) ?? 0
//        let indexPath = IndexPath(row: row, section: 0)
//        if disableLongPressMenu {
//            tableView.reloadRows(at: [indexPath], with: .none)
//            return
//        }
//        if WXChatCellMenuView.shared.isShow() {
//            return
//        }
//        let cellRect: CGRect = tableView.rectForRow(at: indexPath)
//        rect.origin.y += cellRect.origin.y - tableView.contentOffset.y
//        weak var weakSelf = self
//        WXChatCellMenuView.shared().show(in: navigationController.view, withMessageType: message.messageType, rect: rect, actionBlock: { type in
//            weakSelf.tableView.reloadRows(at: [indexPath], with: .none)
//            if type == TLChatMenuItemTypeCopy {
//                let str = message.messageCopy()
//                UIPasteboard.general.string = str
//            } else if type == TLChatMenuItemTypeDelete {
//                self.showAlerWithtitle("是否删除该条消息", message: nil, style: UIAlertController.Style.actionSheet, ac1: {
//                    return UIAlertAction(title: "确定", style: .default, handler: { action in
//                        self.p_delete(message)
//                    })
//                }, ac2: {
//                    return UIAlertAction(title: "取消", style: .cancel, handler: { action in
//                    })
//                }, ac3: nil, completion: nil)
//            }
//        })
//    }
//    func messageCellDoubleClick(_ message: WXMessage) {
//        delegate?.chatTableViewController(self, didDoubleClick: message)
//    }
//    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        delegate?.chatTableViewControllerDidTouched(self)
//    }
//    func p_delete(_ message: WXMessage) {
//        var index = data.index(of: message) ?? 0
//        let ok = delegate?.chatTableViewController(self, delete: message) ?? false
//        if ok {
//            data.removeAll(where: { element in element == message })
//            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//        } else {
//            noticeError("从数据库中删除消息失败。")
//        }
//    }
//}
