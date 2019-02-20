//
//  WXModes.swift
//  Freedom
import Realm
import RealmSwift
import Foundation
import XExtension

extension WXMomentDetail {
    func initValue() {
        height = 0.0
        heightText = 0
        if text.count > 0 {
            let textHeight: CGFloat = text.boundingRect(with: CGSize(width: APPW - 70.0, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.normal], context: nil).size.height
            //: 浮点数会导致部分cell顶部多出来一条线，莫名其妙！！！
            heightText = textHeight + 1.0
        }
        height += heightText
        heightImages = 0.0
        if images.count > 0 {
            if text.count > 0 {
                heightImages += 7.0
            } else {
                heightImages += 3.0
            }
            let space: CGFloat = 4.0
            if images.count == 1 {
                heightImages += APPW - 70.0 * 0.6 * 0.8
            } else {
                let row: Int = Int((images.count / 3) + (images.count % 3 == 0 ? 0 : 1))
                heightImages += APPW - 70.0 * 0.31 * CGFloat(row) + space * CGFloat((row - 1))
            }
        }
        height += heightImages
    }
}


protocol WXChatUserProtocol: NSObjectProtocol {
    var chat_userID: String { get }
    var chat_username: String { get }
    var chat_avatarURL: String { get }
    var chat_avatarPath: String { get }
    var chat_userType: Int { get }
    func groupMember(byID userID: String) -> WXUser?
    func groupMembers() -> [WXUser]
}
enum TLChatUserType: Int {
    case user
    case group
}
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
extension WXInfo {
    var titleColor: UIColor { return UIColor.black}
    var buttonColor: UIColor { return UIColor.green}
    var buttonHLColor: UIColor { return UIColor.green}
    var buttonBorderColor: UIColor { return UIColor.gray}
    class func createInfo(_ title: String?,_ subTitle: String?) -> WXInfo {
        let info = WXInfo()
        info.title = title ?? ""
        info.subTitle = subTitle ?? ""
        return info
    }
}

extension WXUser: WXChatUserProtocol, RealmCollectionValue {
    private func initValue(){
        detailInfo = WXUserDetail()
        userSetting = WXUserSetting()
        chatSetting = WXUserChatSetting()
    }
    //FIXME: delegate
    var chat_userID: String {
        return userID
    }
    var chat_username: String {
          return showName
    }
    var chat_avatarURL: String {
        return avatarURL
    }
    var chat_avatarPath: String {
        return avatarPath
    }
    var chat_userType: Int {
        return TLChatUserType.user.rawValue
    }
    func groupMember(byID userID: String) -> WXUser? {
        return nil
    }
    func groupMembers() -> [WXUser] {
        return []
    }
}
extension WXGroup: WXChatUserProtocol, RealmCollectionValue {
    //FIXME: delegate
    var chat_userID: String {
        return groupID
    }
    var chat_username: String {
        return groupName
    }
    var chat_avatarURL: String {
        return ""
    }
    var chat_avatarPath: String {
        return groupID
    }
    var chat_userType: Int {
        return TLChatUserType.group.rawValue
    }
    func groupMember(byID userID: String) -> WXUser? {
        for user in (users.array() as! [WXUser]) where user.userID == userID {
            return user
        }
        return nil
    }
    func groupMembers() -> [WXUser] {
        return users.array() as! [WXUser]
    }
    var user: WXUser {
        let us = WXUser()
        us.userID = groupID
        us.username = groupName
        return us
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
protocol WXPictureCarouselProtocol: NSObjectProtocol {
    func pictureURL() -> String
}
@objcMembers
class TLEmoji: RLMObject, RealmCollectionValue {
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
    override static func primaryKey() -> String {
        return "groupID"
    }
}
@objcMembers
class TLEmojiGroup: RLMObject, WXPictureCarouselProtocol {
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
    var data = List<TLEmoji>() {
        didSet {
            count = data.count
            pageItemCount = rowNumber * colNumber
            pageNumber = count / pageItemCount + (count % pageItemCount == 0 ? 0 : 1)
        }
    }
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
    override static func primaryKey() -> String {
        return "groupID"
    }
    class func replacedKeyFromPropertyName() -> [AnyHashable : Any] {
        return ["groupID": "eId", "groupIconURL": "coverUrl", "groupName": "eName", "groupInfo": "memo", "groupDetailInfo": "memo1", "count": "picCount", "bannerID": "aId", "bannerURL": "URL"]
    }
    override init() {
        super.init()

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
protocol WXMessageProtocol: NSObjectProtocol {
    func messageCopy() -> String
    func conversationContent() -> String
}

@objcMembers
class WXConversation: RLMObject {
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
    override static func primaryKey() -> String {
        return "partnerID"
    }
    func updateUserInfo(_ user: WXUser) {
        partnerName = user.showName
        avatarPath = user.avatarPath
        avatarURL = user.avatarURL
    }
    func updateGroupInfo(_ group: WXGroup) {
        partnerName = group.groupName
        avatarPath = group.groupID
    }
}
@objcMembers
class WXMessageFrame: RLMObject {
    var height: CGFloat = 0
    var width: CGFloat = 0
    var contentSize: CGSize {
        set{
            height = contentSize.height
            width = contentSize.width
        }
        get{
            return CGSize(width: width, height: height)
        }
    }

    override static func ignoredProperties() -> [String] {
        return ["contentSize"]
    }
}
@objcMembers
class WXMessageContent: RLMObject {
    var w: CGFloat = 0
    var h: CGFloat = 0
    var text = ""
    var url = ""
    var path = ""
    var groupID = ""
    var emojiID = ""
    override static func ignoredProperties() -> [String] {
        return ["w","h","text","url","path","groupID","emojiID"]
    }
}
@objcMembers
class WXMessage: RLMObject, WXMessageProtocol {
    var kMessageFrame: WXMessageFrame!
    var fromUser: WXChatUserProtocol?
    var messageFrame: WXMessageFrame!
    var messageID = ""
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
    var content: WXMessageContent!
    override static func primaryKey() -> String {
        return "messageID"
    }
    override static func ignoredProperties() -> [String] {
        return ["content"]
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
    override init() {
        super.init()
        kMessageFrame = WXMessageFrame()
        messageFrame = WXMessageFrame()
        content = WXMessageContent()
        messageID = String(format: "%lld", Int64(Date().timeIntervalSince1970 * 10000))
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
    var attrText: NSAttributedString {return NSAttributedString(string: content.text)}
    override init() {
        super.init()
        kMessageFrame.height = 20 + (showTime ? 30 : 0) + (showName ? 15 : 0)
        if messageType == .text {
            kMessageFrame.height += 20
            textLabel.attributedText = attrText
            kMessageFrame.contentSize = textLabel.sizeThatFits(CGSize(width: APPW * 0.58, height: CGFloat(MAXFLOAT)))
        }
        kMessageFrame.height += kMessageFrame.contentSize.height

        var size = CGFloat(UserDefaults.standard.double(forKey: "CHAT_FONT_SIZE"))
        if size == 0 {
            size = 16.0
        }
        textLabel.font = UIFont.systemFont(ofSize: size)
        textLabel.numberOfLines = 0
    }
    override func conversationContent() -> String {
        return content.text
    }
    override func messageCopy() -> String {
        return content.text
    }
}

class WXImageMessage: WXMessage {
    var imageSize: CGSize {
        set (newValue){
            content.w = imageSize.width
            content.h = imageSize.height
        }
        get {
            let width = content.w
            let height = content.h
            return CGSize(width: width, height: height)
        }
    }
    override init() {
        super.init()
        kMessageFrame.height = 20 + (showTime ? 30 : 0) + (showName ? 15 : 0)
        let imageSize: CGSize = self.imageSize
        if imageSize.equalTo(CGSize.zero) {
            kMessageFrame.contentSize = CGSize(width: 100, height: 100)
        } else if imageSize.width > imageSize.height {
            var height: CGFloat = APPW * 0.45 * imageSize.height / imageSize.width
            height = height < APPW * 0.25 ? APPW * 0.25 : height
            kMessageFrame.contentSize = CGSize(width: APPW * 0.45, height: height)
        } else {
            var width: CGFloat = APPW * 0.45 * imageSize.width / imageSize.height
            width = width < APPW * 0.25 ? APPW * 0.25 : width
            kMessageFrame.contentSize = CGSize(width: width, height: APPW * 0.45)
        }
        kMessageFrame.height += kMessageFrame.contentSize.height

    }
    override func conversationContent() -> String {
        return "[图片]"
    }
    override func messageCopy() -> String {
        return content.text
    }
}

class WXExpressionMessage: WXMessage {
    var emoji: TLEmoji! {
        didSet {
            content["groupID"] = emoji.groupID
            content["emojiID"] = emoji.emojiID
            let imageSize: CGSize = self.path.image.size ?? CGSize.zero
            content["w"] = "\(imageSize.width)"
            content["h"] = "\(imageSize.height)"
        }
    }
    var path: String {
        set {
            //            emoji.emojiPath = path
            print(path)
        }
        get {
            return emoji.emojiPath
        }
    }
    var url:String {
        return "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(emoji.emojiID)"
    }
    var emojiSize: CGSize {
        set {
            content.w = newValue.width
            content.h = newValue.height
        }
        get {
            return CGSize(width: content.w, height: content.h)
        }
    }
    override init() {
        super.init()
        emoji = TLEmoji()
        emoji.groupID = content.groupID
        emoji.emojiID = content.emojiID
        kMessageFrame.height = 20 + (showTime ? 30 : 0) + (showName ? 15 : 0)
        kMessageFrame.height += 5
        let emojiSize: CGSize = CGSize.zero
        if emojiSize.equalTo(CGSize.zero) {
            kMessageFrame.contentSize = CGSize(width: 80, height: 80)
        } else if emojiSize.width > emojiSize.height {
            var height: CGFloat = APPW * 0.35 * emojiSize.height / emojiSize.width
            height = height < APPW * 0.2 ? APPW * 0.2 : height
            kMessageFrame.contentSize = CGSize(width: APPW * 0.35, height: height)
        } else {
            var width: CGFloat = APPW * 0.35 * emojiSize.width / emojiSize.height
            width = width < APPW * 0.2 ? APPW * 0.2 : width
            kMessageFrame.contentSize = CGSize(width: width, height: APPW * 0.35)
        }
        kMessageFrame.height += kMessageFrame.contentSize.height
    }
    override func conversationContent() -> String {
        return "[表情]"
    }
    override func messageCopy() -> String {
        return content.text
    }
}
