//
//  WXModes.swift
//  Freedom
import Foundation
//import XExtension
enum TLInfoType: Int {
    case defaultType
    case titleOnly
    case images
    case mutiRow
    case button
    case other
}
enum TLSettingItemType: Int {
    case defalut1
    case titleButton
    case switchBtn
    case other
}
struct WXMenuItem {
    var icon = ""
    var title = ""
    var subTitle = ""
    var rightIconURL = ""
    var showRightRedPoint = false
    init() {
    }
    init(_ icon: String, _ title: String) {
        self.icon = icon
        self.title = title
    }
}
class WXSettingItem: NSObject {
    var title = ""
    var subTitle = ""
    var rightImagePath = ""
    var rightImageURL = ""
    var showDisclosureIndicator = false
    var disableHighlight = false
    var type = TLSettingItemType.defalut1
    override init() {
        super.init()
    }
    convenience init(_ title: String) {
        self.init()
        self.title = title
    }
  
}
class WXSettingGroup : NSObject {
    var headerTitle = ""
    var footerTitle = ""
    var items: [WXSettingItem] = []
    override init() {
        super.init()
    }
    convenience init(_ title: String?,_ foot: String?,_ items:[WXSettingItem]) {
        self.init()
        self.headerTitle = title ?? ""
        self.footerTitle = foot ?? ""
        self.items = items
    }
}

//FIXME: 本类🎄
struct WXAddMenuItem {
    var title = ""
    var iconPath = ""
    var className: UIViewController.Type?
}

//FIXME: 表情
enum TLGroupControlSendButtonStatus : Int {
    case gray
    case blue
    case none
}
enum TLEmojiGroupStatus : Int {
    case unDownload
    case downloaded
    case downloading
}
@objcMembers
class TLEmoji: NSObject {
    var type = TLEmojiType.emoji
    var groupID = ""
    var emojiID = ""
    var emojiName = ""
    var emojiURL = ""
    var size: CGFloat = 0.0
    class func replacedKeyFromPropertyName() -> [AnyHashable : Any] {
        return ["emojiID": "pId", "emojiURL": "Url", "emojiName": "credentialName", "emojiPath": "imageFile", "size": "size"]
    }
    var emojiPath: String {
        let groupPath = FileManager.pathExpression(forGroupID: groupID)
        return "\(groupPath)\(emojiID)"
    }
}
@objcMembers
class TLEmojiGroup: NSObject {
    var groupID = ""
    var groupName = ""
    var path: String {
        return FileManager.pathExpression(forGroupID: self.groupID)
    }
    var groupIconPath: String {
        return "\(path)icon_\(groupID)"
    }
    var groupIconURL = ""
    var bannerID = ""
    var bannerURL = ""/// 总数
    var count: Int = 0/// 详细信息
    var groupInfo = ""
    var groupDetailInfo = ""
    var date = Date()
    var status = TLEmojiGroupStatus.unDownload/// 作者
    var authName = ""
    var authID = ""/// 每页个数
    var pageItemCount: Int = 0/// 页数
    var pageNumber: Int = 0/// 行数
    var rowNumber: Int = 0/// 列数
    var colNumber: Int = 0
    var data: [Any] = []
    var type = TLEmojiType.imageWithTitle {
        didSet {
            switch type {
            case .other:
                return
            case .face, .emoji:
                rowNumber = 3
                colNumber = 7
            case .image, .favorite, .imageWithTitle:
                rowNumber = 2
                colNumber = 4
            }
            pageItemCount = rowNumber * colNumber
            pageNumber = count / pageItemCount + (count % pageItemCount == 0 ? 0 : 1)
        }
    }
    class func replacedKeyFromPropertyName() -> [AnyHashable : Any] {
        return ["groupID": "eId", "groupIconURL": "coverUrl", "groupName": "eName", "groupInfo": "memo", "groupDetailInfo": "memo1", "count": "picCount", "bannerID": "aId", "bannerURL": "URL"]
    }
    func pictureURL() -> String {
        return bannerURL
    }
}

//消息所有者类型
enum TLPartnerType : Int {
    case user // 用户
    case group // 群聊
}
//消息拥有者
enum TLMessageOwnerType : Int {
    case unknown // 未知的消息拥有者
    case system // 系统消息
    case own // 自己发送的消息
    case friend // 接收到的他人消息
}
//消息发送状态
enum TLMessageSendState : Int {
    case success // 消息发送成功
    case fail // 消息发送失败
}
//消息读取状态
enum TLMessageReadState : Int {
    case unRead // 消息未读
    case readed // 消息已读
}
@objcMembers
class WXConversation: NSObject {
    var remindType = TLMessageRemindType.normal//消息提醒类型
    var partnerID = ""//用户ID
    var partnerName = ""//用户名
    var avatarURL = ""//头像地址（网络）
    var avatarPath = ""//头像地址（本地）
    var date: Date = Date()//时间
    var content = ""//消息展示内容
    var clueType = TLClueType.none//提示红点类型
    var unreadCount: Int = 0//未读数
    var isRead: Bool {
        return unreadCount == 0
    }
    //会话类型（个人，讨论组，企业号）
    var convType = TLConversationType.personal {
        didSet {
            switch convType {
            case .personal, .group:
                clueType = .pointWithNumber
            case .public, .serverGroup:
                clueType = .point
            }
        }
    }
    func updateUserInfo(_ user: WXUser) {
        partnerName = user.showName
        avatarPath = user.avatarPath
        avatarURL = user.avatarURL
    }
    func updateGroupInfo(_ group: WXGroup) {
        partnerName = group.username
        avatarPath = group.userID
    }
}
@objcMembers
class WXMessage: NSObject {
    var WXMessageID = ""
    var userID = ""
    var friendID = "1"
    var groupID = ""
    var date = Date()
    var showTime = false
    var showName = false
    var partnerType = TLPartnerType.user
    var messageType = TLMessageType.text
    var ownerTyper = TLMessageOwnerType.own
    var readState = TLMessageReadState.unRead
    var sendState = TLMessageSendState.success
// messageContent
    var w: CGFloat = 0
    var h: CGFloat = 0
    var text = ""
    var url = ""
    var path = ""
    var emojiID = ""

    var size: CGSize {
        return CGSize(width: 100, height: 50)
    }
    class func createMessage(by type: TLMessageType) -> WXMessage {
        if type == .text {
            return WXTextMessage()
        } else if type == .image {
            return WXImageMessage()
        } else if type == .expression {
            return WXExpressionMessage()
        }
        return WXMessage()
    }
    var fromUser: WXModel? {
        return WXModel()
    }
    func conversationContent() -> String {
        return "子类未定义"
    }
    func messageCopy() -> String {
        return "子类未定义"
    }
}
class WXTextMessage: WXMessage {
    let textLabel = UILabel()
    var attrText: NSAttributedString {return NSAttributedString(string:text)}
    override var size: CGSize {
        var height: CGFloat = 20 + (showTime ? 30 : 0) + (showName ? 15 : 0)
        if messageType == .text {
            height += 20
            textLabel.attributedText = attrText
            height += textLabel.sizeThatFits(CGSize(width: APPW * 0.58, height: CGFloat(MAXFLOAT))).height
        }
        return CGSize(width: 100, height: height)
    }
    override init() {
        super.init()
    }
    override func conversationContent() -> String {
        return text
    }
    override func messageCopy() -> String {
        return text
    }
}

class WXImageMessage: WXMessage {
    override var size: CGSize {
        var height: CGFloat = 20 + (showTime ? 30 : 0) + (showName ? 15 : 0)
        let imageSize: CGSize = self.imageSize
        var width: CGFloat = APPW * 0.45 * imageSize.width / imageSize.height
        if imageSize.equalTo(CGSize.zero) {
            width += 100
            height += 100
        } else if imageSize.width > imageSize.height {
            let temp: CGFloat = APPW * 0.45 * imageSize.height / imageSize.width
            height = temp < APPW * 0.25 ? APPW * 0.25 : temp
        } else {
            width = width < APPW * 0.25 ? APPW * 0.25 : width
        }
        return CGSize(width: width, height: height)
    }

    var imageSize: CGSize {
        set (newValue){
            w = imageSize.width
            h = imageSize.height
        }
        get {
            let width = w
            let height = h
            return CGSize(width: width, height: height)
        }
    }
    override init() {
        super.init()

    }
    override func conversationContent() -> String {
        return "[图片]"
    }
    override func messageCopy() -> String {
        return text
    }
}

class WXExpressionMessage: WXMessage {
    override var size: CGSize {
        var height: CGFloat = 20 + (showTime ? 30 : 0) + (showName ? 15 : 0)
        height += 5
        let emojiSize: CGSize = CGSize.zero
        var width: CGFloat = 0
        if emojiSize.equalTo(CGSize.zero) {
            width = 50
        } else if emojiSize.width > emojiSize.height {
            let temp: CGFloat = APPW * 0.35 * emojiSize.height / emojiSize.width
            height += temp < APPW * 0.2 ? APPW * 0.2 : temp
        } else {
            let temp: CGFloat = APPW * 0.35 * emojiSize.width / emojiSize.height
            width = temp < APPW * 0.2 ? APPW * 0.2 : temp
        }
        return CGSize(width: width, height: height)
    }
    var emoji: TLEmoji! {
        didSet {
//            content["groupID"] = emoji.groupID
//            content["emojiID"] = emoji.emojiID
//            let imageSize: CGSize = self.path.image.size
//            content["w"] = "\(imageSize.width)"
//            content["h"] = "\(imageSize.height)"
        }
    }
//    var path: String {
//        set {
//            //            emoji.emojiPath = path
//            print(path)
//        }
//        get {
//            return emoji.emojiPath
//        }
//    }
//    var url:String {
//        return "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(emoji.emojiID)"
//    }
    var emojiSize: CGSize {
        set {
            w = newValue.width
            h = newValue.height
        }
        get {
            return CGSize(width: w, height: h)
        }
    }
    override init() {
        super.init()
        emoji = TLEmoji()
//        emoji.groupID = content.groupID
//        emoji.emojiID = content.emojiID
    }
    override func conversationContent() -> String {
        return "[表情]"
    }
    override func messageCopy() -> String {
        return text
    }
}
