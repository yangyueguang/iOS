//
//  WXChatTableViewController.swift
//  Freedom

import Foundation
let PAGE_MESSAGE_COUNT = 15
let MSG_SPACE_TOP = 14
let MSG_SPACE_BTM = 20
let MSG_SPACE_LEFT = 19
let MSG_SPACE_RIGHT = 22
let TIMELABEL_HEIGHT = 20.0
let TIMELABEL_SPACE_Y = 10.0
let NAMELABEL_HEIGHT = 14.0
let NAMELABEL_SPACE_X = 12.0
let NAMELABEL_SPACE_Y = 1.0
let AVATAR_WIDTH = 40.0
let AVATAR_SPACE_X = 8.0
let AVATAR_SPACE_Y = 12.0
let MSGBG_SPACE_X = 5.0
let MSGBG_SPACE_Y = 1.0
enum TLChatMenuItemType : Int {
    case cancel
    case copy
    case delete
}

class WXMessageBaseCell: UITableViewCell {
    weak var delegate: WXMessageCellDelegate
    var timeLabel: UILabel
    var avatarButton: UIButton
    var usernameLabel: UILabel
    var messageBackgroundView: UIImageView
    var message: WXMessage
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear
        selectionStyle = .none
        contentView.addSubview(timeLabel)
        contentView.addSubview(avatarButton)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(messageBackgroundView)
        p_addMasonry()

    }
    func setMessage(_ message: WXMessage) {
        if self.message && (self.message.messageID == message.messageID) {
            return
        }
        if let aNow = message.date.timeToNow {
            timeLabel.text = "  \(aNow)  "
        }
        usernameLabel.text = message.fromUser.chat_username()
        if message.fromUser.chat_avatarPath().length  0 > 0 {
            let path = FileManager.pathUserAvatar(message.fromUser.chat_avatarPath())
            avatarButton.setImage(UIImage(named: path), for: .normal)
        } else {
            avatarButton.sd_setImage(with: URL(string: message.fromUser.chat_avatarURL()  ""), for: UIControl.State.normal)
        }

        // 时间
        if !self.message || self.message.showTime != message.showTime {
            timeLabel.mas_updateConstraints({ make in
                make.height.mas_equalTo(message.showTime != nil  TIMELABEL_HEIGHT : 0)
                make.top.mas_equalTo(self.contentView).mas_offset(message.showTime != nil  TIMELABEL_SPACE_Y : 0)
            })
        }

        if message == nil || self.message.ownerTyper != message.ownerTyper {
            // 头像
            avatarButton.mas_remakeConstraints({ make in
                make.width.and().height().mas_equalTo(AVATAR_WIDTH)
                make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(AVATAR_SPACE_Y)
                if message.ownerTyper == TLMessageOwnerTypeSelf {
                    make.right.mas_equalTo(self.contentView).mas_offset(-AVATAR_SPACE_X)
                } else {
                    make.left.mas_equalTo(self.contentView).mas_offset(AVATAR_SPACE_X)
                }
            })

            // 用户名
            usernameLabel.mas_remakeConstraints({ make in
                make.top.mas_equalTo(self.avatarButton).mas_equalTo(-NAMELABEL_SPACE_Y)
                if message.ownerTyper == TLMessageOwnerTypeSelf {
                    make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-NAMELABEL_SPACE_X)
                } else {
                    make.left.mas_equalTo(self.avatarButton.mas_right).mas_equalTo(NAMELABEL_SPACE_X)
                }
            })

            // 背景
            messageBackgroundView.mas_remakeConstraints({ make in
                message.ownerTyper == TLMessageOwnerTypeSelf  make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-MSGBG_SPACE_X) : make.left.mas_equalTo(self.avatarButton.mas_right).mas_offset(MSGBG_SPACE_X)
                make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(message.showName != nil  0 : -MSGBG_SPACE_Y)
            })
        }

        usernameLabel.hidden = !message.showName
        usernameLabel.mas_updateConstraints({ make in
            make.height.mas_equalTo(message.showName != nil  NAMELABEL_HEIGHT : 0)
        })

        self.message = message
    }
    func p_addMasonry() {
        timeLabel.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.contentView).mas_offset(TIMELABEL_SPACE_Y)
            make.centerX.mas_equalTo(self.contentView)
        })

        usernameLabel.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.avatarButton).mas_equalTo(-NAMELABEL_SPACE_Y)
            make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-NAMELABEL_SPACE_X)
        })

        // Default - self
        avatarButton.mas_makeConstraints({ make in
            make.right.mas_equalTo(self.contentView).mas_offset(-AVATAR_SPACE_X)
            make.width.and().height().mas_equalTo(AVATAR_WIDTH)
            make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(AVATAR_SPACE_Y)
        })

        messageBackgroundView.mas_remakeConstraints({ make in
            make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-MSGBG_SPACE_X)
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(-MSGBG_SPACE_Y)
        })
    }
    func avatarButtonDown(_ sender: UIButton) {
        if delegate && delegate.responds(to: #selector(self.messageCellDidClickAvatar(forUser:))) {
            delegate.messageCellDidClickAvatar(forUser: message.fromUser)
        }
    }

    func longPressMsgBGView() {
        messageBackgroundView.highlighted = true
        if delegate && delegate.responds(to: #selector(self.messageCellLongPress(_:rect:))) {
            let rect: CGRect = messageBackgroundView.frame
            rect.size.height -= 10 // 北京图片底部空白区域
            delegate.messageCellLongPress(message, rect: rect)
        }
    }

    func doubleTabpMsgBGView() {
        if delegate && delegate.responds(to: #selector(self.messageCellDoubleClick(_:))) {
            delegate.messageCellDoubleClick(message)
        }
    }

    // MARK: - Getter -
    func timeLabel() -> UILabel {
        if timeLabel == nil {
            timeLabel = UILabel()
            timeLabel.font = UIFont.systemFont(ofSize: 12.0)
            timeLabel.textColor = UIColor.white
            timeLabel.backgroundColor = UIColor.gray
            timeLabel.alpha = 0.7
            timeLabel.layer.masksToBounds = true
            timeLabel.layer.cornerRadius = 5.0
        }
        return timeLabel
    }
    func avatarButton() -> UIButton {
        if avatarButton == nil {
            avatarButton = UIButton()
            avatarButton.layer.masksToBounds = true
            avatarButton.layer.borderWidth = 1
            avatarButton.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
            avatarButton.addTarget(self, action: #selector(self.avatarButtonDown(_:)), for: .touchUpInside)
        }
        return avatarButton
    }

    func usernameLabel() -> UILabel {
        if usernameLabel == nil {
            usernameLabel = UILabel()
            usernameLabel.textColor = UIColor.gray
            usernameLabel.font = UIFont.systemFont(ofSize: 12.0)
        }
        return usernameLabel
    }

    func messageBackgroundView() -> UIImageView {
        if messageBackgroundView == nil {
            messageBackgroundView = UIImageView()
            messageBackgroundView.isUserInteractionEnabled = true

            let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressMsgBGView))
            messageBackgroundView.addGestureRecognizer(longPressGR)

            let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(self.doubleTabpMsgBGView))
            doubleTapGR.numberOfTapsRequired = 2
            messageBackgroundView.addGestureRecognizer(doubleTapGR)
        }
        return messageBackgroundView
    }





    
}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXMessageImageView: UIImageView {
    var backgroundImage: UIImage

    /*设置消息图片（规则：收到消息时，先下载缩略图到本地，再添加到列表显示，并自动下载大图）
     *
     *  @param imagePath    缩略图Path
     *  @param imageURL     高清图URL*/
    func setThumbnailPath(_ imagePath: String, highDefinitionImageURL imageURL: String) {
    }

    var maskLayer: CAShapeLayer
    var contentLayer: CALayer

    override init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aLayer = contentLayer {
            layer.addSublayer(aLayer)
        }

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func layoutSubviews() {
        super.layoutSubviews()
        maskLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        contentLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }

    func setThumbnailPath(_ imagePath: String, highDefinitionImageURL imageURL: String) {
        if imagePath == nil {
            contentLayer.contents = nil
        } else {
            contentLayer.contents = UIImage(named: imagePath).cgImage
        }
    }

    var backgroundImage: UIImage {
        get {
            return super.backgroundImage
        }
        set(backgroundImage) {
            self.backgroundImage = backgroundImage
            maskLayer.contents = backgroundImage.cgImage
        }
    }
    func maskLayer() -> CAShapeLayer {
        if maskLayer == nil {
            maskLayer = CAShapeLayer()
            maskLayer.contentsCenter = CGRect(x: 0.5, y: 0.6, width: 0.1, height: 0.1)
            maskLayer.contentsScale = UIScreen.main.scale //非常关键设置自动拉伸的效果且不变形
        }
        return maskLayer
    }

    func contentLayer() -> CALayer {
        if contentLayer == nil {
            contentLayer = CALayer()
            contentLayer.mask = maskLayer()
        }
        return contentLayer
    }



    
}
class WXTextMessage: WXMessage {
    //@property (nonatomic, strong) NSString *text;                       // 文字信息
    var attrText: NSAttributedString
    // 格式化的文字信息（仅展示用）
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    init() {
        super.init()

        textLabel = UILabel()
        var size = CGFloat(UserDefaults.standard.double(forKey: "CHAT_FONT_SIZE"))
        if size == 0 {
            size = 16.0
        }
        textLabel.font = UIFont.systemFont(ofSize: size)
        textLabel.numberOfLines = 0

    }

    //- (NSString *)text{
    //    if (_text == nil) {
    //        _text = [self.content objectForKey:@"text"];
    //    }
    //    return _text;
    //}
    //- (void)setText:(NSString *)text{
    //    _text = text;
    //    [self.content setObject:text forKey:@"text"];
    //}
    func attrText() -> NSAttributedString {
        if attrText == nil {
            attrText = NSAttributedString(string: content["text"])
        }
        return attrText
    }
    func messageFrame() -> WXMessageFrame {
        if kMessageFrame == nil {
            kMessageFrame = WXMessageFrame()
            kMessageFrame.height = 20 + (showTime  30 : 0) + (showName  15 : 0)
            if messageType == TLMessageTypeText {
                kMessageFrame.height += 20
                textLabel.attributedText = attrText
                kMessageFrame.contentSize = textLabel.sizeThatFits(CGSize(width: APPW * 0.58, height: MAXFLOAT))
            }
            kMessageFrame.height += kMessageFrame.contentSize.height
        }
        return kMessageFrame
    }

    func conversationContent() -> String {
        return content["text"]
    }

    func messageCopy() -> String {
        return content["text"]
    }
}

class WXTextMessageCell: WXMessageBaseCell {
    private var messageLabel: UILabel

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        if let aLabel = messageLabel {
            contentView.addSubview(aLabel)
        }

    }
    func setMessage(_ message: WXTextMessage) {
        if self.message && (self.message.messageID == message.messageID) {
            return
        }
        let lastOwnType = self.message  self.message.ownerTyper : -1 as TLMessageOwnerType
        super.setMessage(message)
        messageLabel.attributedText = message.attrText()

        messageLabel.setContentCompressionResistancePriority(UILayoutPriority(500), for: .horizontal)
        messageBackgroundView.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
        if lastOwnType != message.ownerTyper {
            if message.ownerTyper == TLMessageOwnerTypeSelf {
                messageBackgroundView.image = UIImage(named: "message_sender_bg")
                messageBackgroundView.highlightedImage = UIImage(named: "message_sender_bgHL")

                messageLabel.mas_remakeConstraints({ make in
                    make.right.mas_equalTo(self.messageBackgroundView).mas_offset(-MSG_SPACE_RIGHT)
                    make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP)
                })
                messageBackgroundView.mas_updateConstraints({ make in
                    make.left.mas_equalTo(self.messageLabel).mas_offset(-MSG_SPACE_LEFT)
                    make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM)
                })
            } else if message.ownerTyper == TLMessageOwnerTypeFriend {
                messageBackgroundView.image = UIImage(named: "message_receiver_bg")
                messageBackgroundView.highlightedImage = UIImage(named: "message_receiver_bgHL")
                messageLabel.mas_remakeConstraints({ make in
                    make.left.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_LEFT)
                    make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP)
                })
                messageBackgroundView.mas_updateConstraints({ make in
                    make.right.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_RIGHT)
                    make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM)
                })
            }
        }

        messageLabel.mas_updateConstraints({ make in
            make.size.mas_equalTo(message.messageFrame.contentSize)
        })
    }
    func messageLabel() -> UILabel {
        if messageLabel == nil {
            messageLabel = UILabel()
            var size = CGFloat(UserDefaults.standard.double(forKey: "CHAT_FONT_SIZE"))
            if size == 0 {
                size = 16.0
            }
            messageLabel.font = UIFont.systemFont(ofSize: size)
            messageLabel.numberOfLines = 0
        }
        return messageLabel
    }




    
}

class WXImageMessageCell: WXMessageBaseCell {
    private var msgImageView: WXMessageImageView

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        if let aView = msgImageView {
            contentView.addSubview(aView)
        }

    }
    func setMessage(_ message: WXImageMessage) {
        msgImageView.alpha = 1.0 // 取消长按效果
        if self.message && (self.message.messageID == message.messageID) {
            return
        }
        let lastOwnType = self.message  self.message.ownerTyper : -1 as TLMessageOwnerType
        super.setMessage(message)
        let imagePath = message.content["path"]
        if imagePath != nil {
            let imagePatha = FileManager.pathUserChatImage(imagePath)
            msgImageView.setThumbnailPath(imagePatha, highDefinitionImageURL: imagePatha)
        } else {
            msgImageView.setThumbnailPath(nil, highDefinitionImageURL: imagePath)
        }

        if lastOwnType != message.ownerTyper {
            if message.ownerTyper == TLMessageOwnerTypeSelf {
                msgImageView.backgroundImage = UIImage(named: "message_sender_bg")
                msgImageView.mas_remakeConstraints({ make in
                    make.top.mas_equalTo(self.messageBackgroundView)
                    make.right.mas_equalTo(self.messageBackgroundView)
                })
            } else if message.ownerTyper == TLMessageOwnerTypeFriend {
                msgImageView.backgroundImage = UIImage(named: "message_receiver_bg")
                msgImageView.mas_remakeConstraints({ make in
                    make.top.mas_equalTo(self.messageBackgroundView)
                    make.left.mas_equalTo(self.messageBackgroundView)
                })
            }
        }
        msgImageView.mas_updateConstraints({ make in
            make.size.mas_equalTo(message.messageFrame.contentSize)
        })
    }
    func tapMessageView() {
        if delegate && delegate.responds(to: #selector(self.messageCellTap(_:))) {
            delegate.messageCellTap(message)
        }
    }

    func longPressMsgBGView() {
        msgImageView.alpha = 0.7 // 比较low的选中效果
        if delegate && delegate.responds(to: #selector(self.messageCellLongPress(_:rect:))) {
            let rect: CGRect = msgImageView.frame
            rect.size.height -= 10 // 北京图片底部空白区域
            delegate.messageCellLongPress(message, rect: rect)
        }
    }

    func doubleTabpMsgBGView() {
        if delegate && delegate.responds(to: #selector(self.messageCellDoubleClick(_:))) {
            delegate.messageCellDoubleClick(message)
        }
    }
    func msgImageView() -> WXMessageImageView {
        if msgImageView == nil {
            msgImageView = WXMessageImageView()
            msgImageView.isUserInteractionEnabled = true

            let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tapMessageView))
            msgImageView.addGestureRecognizer(tapGR)

            let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressMsgBGView))
            msgImageView.addGestureRecognizer(longPressGR)

            let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(self.doubleTabpMsgBGView))
            doubleTapGR.numberOfTapsRequired = 2
            msgImageView.addGestureRecognizer(doubleTapGR)
        }
        return msgImageView
    }


    
}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXExpressionMessage: WXMessage {
    var emoji: TLEmoji
    private(set) var path = ""
    private(set) var url = ""
    private(set) var emojiSize = CGSize.zero
    func setEmoji(_ emoji: TLEmoji) {
        self.emoji = emoji
        content["groupID"] = emoji.groupID
        content["emojiID"] = emoji.emojiID
        let imageSize: CGSize = UIImage(named: path()  "").size
        content["w"] = Double(imageSize.width  0.0)
        content["h"] = Double(imageSize.height  0.0)
    }

    func emoji() -> TLEmoji {
        if emoji == nil {
            emoji = TLEmoji()
            emoji.groupID = content["groupID"]
            emoji.emojiID = content["emojiID"]
        }
        return emoji
    }

    func path() -> String {
        return emoji().emojiPath
    }
    func url() -> String {
        return "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(emoji.emojiID)"
    }

    func emojiSize() -> CGSize {
        let width = CGFloat(content["w"])
        let height = CGFloat(content["h"])
        return CGSize(width: width, height: height)
    }

    func messageFrame() -> WXMessageFrame {
        if kMessageFrame == nil {
            kMessageFrame = WXMessageFrame()
            kMessageFrame.height = 20 + (showTime  30 : 0) + (showName  15 : 0)

            kMessageFrame.height += 5

            let emojiSize: CGSize = self.emojiSize
            if emojiSize.equalTo(CGSize.zero) {
                kMessageFrame.contentSize = CGSize(width: 80, height: 80)
            } else if emojiSize.width > emojiSize.height {
                var height: CGFloat = APPW * 0.35 * emojiSize.height / emojiSize.width
                height = height < APPW * 0.2  APPW * 0.2 : height
                kMessageFrame.contentSize = CGSize(width: APPW * 0.35, height: height)
            } else {
                var width: CGFloat = APPW * 0.35 * emojiSize.width / emojiSize.height
                width = width < APPW * 0.2  APPW * 0.2 : width
                kMessageFrame.contentSize = CGSize(width: width, height: APPW * 0.35)
            }

            kMessageFrame.height += kMessageFrame.contentSize.height
        }
        return kMessageFrame
    }
    func conversationContent() -> String {
        return "[表情]"
    }

    func messageCopy() -> String {
        return content.mj_JSONString()
    }


}

class WXExpressionMessageCell: WXMessageBaseCell {
    private var msgImageView: UIImageView

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        if let aView = msgImageView {
            contentView.addSubview(aView)
        }

    }
    func setMessage(_ message: WXExpressionMessage) {
        msgImageView.alpha = 1.0 // 取消长按效果
        let lastOwnType = self.message  self.message.ownerTyper : -1 as TLMessageOwnerType
        super.setMessage(message)

        let data = NSData(contentsOfFile: message.path  "") as Data
        if data != nil {
            msgImageView.image = UIImage(named: message.path  "")
            msgImageView.image = UIImage.sd_animatedGIF(with: data)
        } else {
            // 表情组被删掉，先从缓存目录中查找，没有的话在下载并存入缓存目录
            var MycachePath: String = nil
            if let anID = message.emoji.emojiID {
                MycachePath = FileManager.cache(forFile: "\(message.emoji.groupID  0)_\(anID).gif")
            }
            let data = NSData(contentsOfFile: MycachePath  "") as Data
            if data != nil {
                msgImageView.image = UIImage(named: MycachePath  "")
                msgImageView.image = UIImage.sd_animatedGIF(with: data)
            } else {
                weak var weakSelf = self
                msgImageView.sd_setImage(with: URL(string: message.url  ""), completed: { image, error, cacheType, imageURL in
                    if (imageURL.description() == (weakSelf.message as WXExpressionMessage).url()) {
                        DispatchQueue.global(qos: .default).async(execute: {
                            var data: Data = nil
                            if let anURL = imageURL {
                                data = Data(contentsOf: anURL)
                            }
                            data.write(toFile: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0], atomically: false) // 再写入到缓存中
                            if (imageURL.description() == (weakSelf.message as WXExpressionMessage).url()) {
                                DispatchQueue.main.async(execute: {
                                    self.msgImageView.image = UIImage.sd_animatedGIF(withData: data)
                                })
                            }
                        })
                    }
                })
            }
        }
        if lastOwnType != message.ownerTyper {
            if message.ownerTyper == TLMessageOwnerTypeSelf {
                msgImageView.mas_remakeConstraints({ make in
                    make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(5)
                    make.right.mas_equalTo(self.messageBackgroundView).mas_offset(-10)
                })
            } else if message.ownerTyper == TLMessageOwnerTypeFriend {
                msgImageView.mas_remakeConstraints({ make in
                    make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(5)
                    make.left.mas_equalTo(self.messageBackgroundView).mas_offset(10)
                })
            }
        }
        msgImageView.mas_updateConstraints({ make in
            make.size.mas_equalTo(message.messageFrame.contentSize)
        })
    }
    func longPressMsgBGView() {
        msgImageView.alpha = 0.7 // 比较low的选中效果
        if delegate && delegate.responds(to: #selector(self.messageCellLongPress(_:rect:))) {
            let rect: CGRect = msgImageView.frame
            delegate.messageCellLongPress(message, rect: rect)
        }
    }

    func doubleTabpMsgBGView() {
        if delegate && delegate.responds(to: #selector(self.messageCellDoubleClick(_:))) {
            delegate.messageCellDoubleClick(message)
        }
    }
    func msgImageView() -> UIImageView {
        if msgImageView == nil {
            msgImageView = UIImageView()
            msgImageView.isUserInteractionEnabled = true

            let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressMsgBGView))
            msgImageView.addGestureRecognizer(longPressGR)

            let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(self.doubleTabpMsgBGView))
            doubleTapGR.numberOfTapsRequired = 2
            msgImageView.addGestureRecognizer(doubleTapGR)
        }
        return msgImageView
    }




    
}

class WXChatCellMenuView: UIView {
    private(set) var isShow = false
    var messageType: TLMessageType
    var actionBlcok: (() -> Void)

    private var menuController: UIMenuController

    static var menuView: WXChatCellMenuView = {
        var menuView = WXChatCellMenuView()
        return menuView
    }()

    class func shared() -> WXChatCellMenuView {
        // `dispatch_once()` call was converted to a static variable initializer
        return menuView
    }

    init(frame: CGRect) {
        //if super.init(frame: frame)

        backgroundColor = UIColor.clear
        menuController = UIMenuController.shared

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(WXChatCellMenuView.dismiss))
        addGestureRecognizer(tapGR)

    }
    func show(in view: UIView, with messageType: TLMessageType, rect: CGRect, actionBlock: @escaping (TLChatMenuItemType) -> Void) {
        if isShow {
            return
        }
        isShow = true
        self.frame = view.bounds
        view.addSubview(self)
        self.actionBlcok = actionBlock
        self.messageType = messageType

        menuController.setTargetRect(rect, in: self)
        becomeFirstResponder()
        menuController.setMenuVisible(true, animated: true)
    }
    var messageType: natural_t {
        get {
            return super.messageType
        }
        set(messageType) {
            let copy = UIMenuItem(title: "复制", action: #selector(self.copyButtonDown(_:)))
            let transmit = UIMenuItem(title: "转发", action: #selector(self.transmitButtonDown(_:)))
            let collect = UIMenuItem(title: "收藏", action: #selector(self.collectButtonDown(_:)))
            let del = UIMenuItem(title: "删除", action: #selector(self.deleteButtonDown(_:)))
            menuController.menuItems = [copy, transmit, collect, del]
        }
    }

    func dismiss() {
        isShow = false
        if actionBlcok {
            actionBlcok(TLChatMenuItemTypeCancel)
        }
        menuController.setMenuVisible(false, animated: true)
        removeFromSuperview()
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    var canBecomeFirstResponder: Bool {
        return true
    }

    // MARK: - Event Response -
    func copyButtonDown(_ sender: UIMenuController) {
        p_clickedMenuItemType(TLChatMenuItemTypeCopy)
    }

    func transmitButtonDown(_ sender: UIMenuController) {
        p_clickedMenuItemType(TLChatMenuItemTypeCopy)
    }

    func collectButtonDown(_ sender: UIMenuController) {
        p_clickedMenuItemType(TLChatMenuItemTypeCopy)
    }

    func deleteButtonDown(_ sender: UIMenuController) {
        p_clickedMenuItemType(TLChatMenuItemTypeDelete)
    }

    // MARK: - Private Methods -
    func p_clickedMenuItemType(_ type: TLChatMenuItemType) {
        isShow = false
        removeFromSuperview()
        if actionBlcok {
            actionBlcok(type)
        }
    }



    
}
extension UITableView {
    func scrollToBottom(withAnimation animation: Bool) {
        var section: Int = 0
        if dataSource != nil && dataSource.responds(to: #selector(UITableViewDataSource.numberOfSections(in:)))  false {
            section = (dataSource.numberOfSections(in: self)  0) - 1
        }
        if dataSource.responds(to: #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:)))  false {
            let row: Int = dataSource.tableView(self, numberOfRowsInSection: section)
            if (row  0) > 0 {
                scrollToRow(at: IndexPath(row: (row  0) - 1, section: section), at: .bottom, animated: animation)
            }
        }
    }
}
protocol WXMessageCellDelegate: NSObjectProtocol {
    func messageCellDidClickAvatar(forUser user: WXChatUserProtocol)
    func messageCellTap(_ message: WXMessage)
    func messageCellLongPress(_ message: WXMessage, rect: CGRect)
    func messageCellDoubleClick(_ message: WXMessage)
}
@objc protocol WXChatTableViewControllerDelegate: NSObjectProtocol {
    //聊天界面点击事件，用于收键盘
    func chatTableViewControllerDidTouched(_ chatTVC: WXChatTableViewController)
    func chatTableViewController(_ chatTVC: WXChatTableViewController, getRecordsFrom date: Date, count: Int, completed: @escaping (Date, [Any], Bool) -> Void)

    /*消息长按删除
     *
     *  @return 删除是否成功*/
    @objc optional func chatTableViewController(_ chatTVC: WXChatTableViewController, delete message: WXMessage) -> Bool
    //用户头像点击事件
    @objc optional func chatTableViewController(_ chatTVC: WXChatTableViewController, didClickUserAvatar user: WXUser)
    //Message点击事件
    @objc optional func chatTableViewController(_ chatTVC: WXChatTableViewController, didClick message: WXMessage)
    //Message双击事件
    @objc optional func chatTableViewController(_ chatTVC: WXChatTableViewController, didDoubleClick message: WXMessage)
}
class WXChatTableViewController: UITableViewController, WXMessageCellDelegate {
    func registerCellClass() {
    }

    weak var delegate: WXChatTableViewControllerDelegate
    var data: [AnyHashable] = []
    /// 禁用下拉刷新
    var disablePullToRefresh = false
    /// 禁用长按菜单
    var disableLongPressMenu = false
    private var refresHeader: MJRefreshNormalHeader
    /// 用户决定新消息是否显示时间
    private var curDate: Date

    func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 20))
        if !disablePullToRefresh {
            tableView.mj_header = refresHeader
        }
        registerCellClass()

        let tap = UITapGestureRecognizer(target: self, action: #selector(WXChatTableViewController.didTouchTableView))
        tableView.addGestureRecognizer(tap)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if WXChatCellMenuView.shared().isShow() {
            WXChatCellMenuView.shared().dismiss()
        }
    }

    // MARK: - Public Methods -
    func reloadData() {
        data.removeAll()
        tableView.reloadData()
        curDate = Date()
        if !disablePullToRefresh {
            tableView.setMj_header(refresHeader)
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
        if let aMessage = message {
            data.append(aMessage)
        }
        tableView.reloadData()
    }

    func delete(_ message: WXMessage) {
        var index: Int = nil
        if let aMessage = message {
            index = data.index(of: aMessage)
        }
        if delegate && delegate.responds(to: #selector(self.chatTableViewController(_:deleteMessage:))) {
            let ok = delegate.chatTableViewController(self, delete: message)
            if ok {
                data.removeAll(where: { element in element == message })
                tableView.deleteRows(at: [IndexPath(row: index  0, section: 0)], with: .automatic)
                MobClick.event("e_delete_message")
            } else {
                SVProgressHUD.showError(withStatus: "从数据库中删除消息失败。")
            }
        }
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func scrollToBottom(withAnimation animation: Bool) {
        tableView.scrollToBottom(withAnimation: animation)
    }

    func setDisablePullToRefresh(_ disablePullToRefresh: Bool) {
        if disablePullToRefresh {
            tableView.setMj_header(nil)
        } else {
            tableView.setMj_header(refresHeader)
        }
    }

    // MARK: - Event Response -
    func didTouchTableView() {
        if delegate && delegate.responds(to: #selector(self.chatTableViewControllerDidTouched(_:))) {
            delegate.chatTableViewControllerDidTouched(self)
        }
    }
    //获取聊天历史记录

    func p_try(toRefreshMoreRecord complete: @escaping (_ count: Int, _ hasMore: Bool) -> Void) {
        if delegate && delegate.responds(to: #selector(self.chatTableViewController(_:getRecordsFromDate:count:completed:))) {
            delegate.chatTableViewController(self, getRecordsFromDate: curDate, count: PAGE_MESSAGE_COUNT, completed: { date, array, hasMore in
                if (array.count  0) > 0 && date.isEqual(to: self.curDate)  false {
                    self.curDate = array[0].date()
                    if let anArray = array {
                        for (objectIndex, insertionIndex) in NSIndexSet(indexesIn: NSRange(location: 0, length: array.count  0)).enumerated() { self.data.insert((anArray)[objectIndex], at: insertionIndex) }
                    }
                    complete(array.count, hasMore)
                } else {
                    complete(0, hasMore)
                }
            })
        }
    }
    func refresHeader() -> MJRefreshNormalHeader {
        if refresHeader == nil {
            refresHeader = MJRefreshNormalHeader(refreshingBlock: {
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
            refresHeader.lastUpdatedTimeLabel.hidden = true
            refresHeader.stateLabel.hidden = true
        }
        return refresHeader
    }
    func registerCellClass() {
        tableView.register(WXTextMessageCell.self, forCellReuseIdentifier: "TLTextMessageCell")
        tableView.register(WXImageMessageCell.self, forCellReuseIdentifier: "TLImageMessageCell")
        tableView.register(WXExpressionMessageCell.self, forCellReuseIdentifier: "TLExpressionMessageCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCell")
    }

    // MARK: - Delegate -
    //MARK: UITableViewDataSouce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message: WXMessage = data[indexPath.row]
        if message.messageType == TLMessageTypeText {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLTextMessageCell") as WXTextMessageCell
            cell.message = message
            cell.delegate = self
            return cell!
        } else if message.messageType == TLMessageTypeImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLImageMessageCell") as WXImageMessageCell
            cell.message = message
            cell.delegate = self
            return cell!
        } else if message.messageType == TLMessageTypeExpression {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLExpressionMessageCell") as WXExpressionMessageCell
            cell.message = message
            cell.delegate = self
            return cell!
        }
        return (tableView.dequeueReusableCell(withIdentifier: "EmptyCell"))!
    }
    //MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= data.count {
            return 0.0
        }
        let message: WXMessage = data[indexPath.row]
        return message.messageFrame.height  0.0
    }

    //MARK: TLMessageCellDelegate
    func messageCellDidClickAvatar(for user: WXUser) {
        if delegate && delegate.responds(to: #selector(self.chatTableViewController(_:didClickUserAvatar:))) {
            delegate.chatTableViewController(self, didClickUserAvatar: user)
        }
    }

    func messageCellTap(_ message: WXMessage) {
        if delegate && delegate.responds(to: #selector(self.chatTableViewController(_:didClickMessage:))) {
            delegate.chatTableViewController(self, didClick: message)
        }
    }
    func messageCellLongPress(_ message: WXMessage, rect: CGRect) {
        var row: Int = nil
        if let aMessage = message {
            row = data.index(of: aMessage)
        }
        let indexPath = IndexPath(row: row  0, section: 0)
        if disableLongPressMenu {
            tableView.reloadRows(at: [indexPath], with: .none)
            return
        }
        if WXChatCellMenuView.shared().isShow() {
            return
        }

        let cellRect: CGRect = tableView.rectForRow(at: indexPath)
        rect.origin.y += cellRect.origin.y - tableView.contentOffset.y
        weak var weakSelf = self
        WXChatCellMenuView.shared().show(in: navigationController.view, withMessageType: message.messageType, rect: rect, actionBlock: { type in
            weakSelf.tableView.reloadRows(at: [indexPath], with: .none)
            if type == TLChatMenuItemTypeCopy {
                let str = message.messageCopy()
                UIPasteboard.general.string = str
            } else if type == TLChatMenuItemTypeDelete {
                self.showAlerWithtitle("是否删除该条消息", message: nil, style: UIAlertController.Style.actionSheet, ac1: {
                    return UIAlertAction(title: "确定", style: .default, handler: { action in
                        self.p_delete(message)
                    })
                }, ac2: {
                    return UIAlertAction(title: "取消", style: .cancel, handler: { action in
                    })
                }, ac3: nil, completion: nil)
            }
        })
    }
    //双击Message Cell

    func messageCellDoubleClick(_ message: WXMessage) {
        if delegate && delegate.responds(to: #selector(self.chatTableViewController(_:didDoubleClickMessage:))) {
            delegate.chatTableViewController(self, didDoubleClick: message)
        }
    }

    //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if delegate && delegate.responds(to: #selector(self.chatTableViewControllerDidTouched(_:))) {
            delegate.chatTableViewControllerDidTouched(self)
        }
    }

    func p_delete(_ message: WXMessage) {
        var index: Int = nil
        if let aMessage = message {
            index = data.index(of: aMessage)
        }
        if delegate && delegate.responds(to: #selector(self.chatTableViewController(_:deleteMessage:))) {
            let ok = delegate.chatTableViewController(self, delete: message)
            if ok {
                data.removeAll(where: { element in element == message })
                tableView.deleteRows(at: [IndexPath(row: index  0, section: 0)], with: .automatic)
                MobClick.event("e_delete_message")
            } else {
                SVProgressHUD.showError(withStatus: "从数据库中删除消息失败。")
            }
        }
    }


    

}
