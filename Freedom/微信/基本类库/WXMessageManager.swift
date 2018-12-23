//
//  WXMessageManager.swift
//  Freedom
import Foundation
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
protocol WXMessageManagerConvVCDelegate: NSObjectProtocol {
    func updateConversationData()
}
class WXConversation: NSObject {
    var convType = TLConversationType.personal//会话类型（个人，讨论组，企业号）
    var remindType = TLMessageRemindType.normal//消息提醒类型
    var partnerID = ""//用户ID
    var partnerName = ""//用户名
    var avatarURL = ""//头像地址（网络）
    var avatarPath = ""//头像地址（本地）
    var date: Date = Date()//时间
    var content = ""//消息展示内容
    private var clueType = TLClueType.none//提示红点类型
    private var isRead: Bool {
        return unreadCount == 0
    }
    var unreadCount: Int = 0//未读数
    func setConvType(_ convType: TLConversationType) {
        self.convType = convType
        switch convType {
        case .personal, .group:
            clueType = .pointWithNumber
        case .public, .serverGroup:
            clueType = .point
        default:
            break
        }
    }
    func updateUserInfo(_ user: WXUser) {
        partnerName = user.showName
        avatarPath = user.avatarPath
        avatarURL = user.avatarURL
    }
    func updateGroupInfo(_ group: WXGroup) {
        partnerName = group.groupName
        avatarPath = group.groupAvatarPath
    }
}
class WXMessageFrame: NSObject {
    var height: CGFloat = 0.0
    var contentSize = CGSize.zero
}
class WXMessage: NSObject, WXMessageProtocol {
    var kMessageFrame = WXMessageFrame()
    var fromUser: WXChatUserProtocol?
    var messageFrame = WXMessageFrame()
    var messageID = ""
    var userID = ""
    var friendID = ""
    var groupID = ""
    var date = Date()
    var showTime = false
    var showName = false
    var partnerType = TLPartnerType.user
    var messageType = TLMessageType.text
    var ownerTyper = TLMessageOwnerType.own
    var readState = TLMessageReadState.unRead
    var sendState = TLMessageSendState.success
    var content: [String : String] = [:]
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
    lazy var attrText: NSAttributedString = NSAttributedString(string: content["text"] ?? "")
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
        return content["text"] ?? ""
    }
    override func messageCopy() -> String {
        return content["text"] ?? ""
    }
}

class WXImageMessage: WXMessage {
    var imageSize: CGSize {
        set (newValue){
            content["w"] = "\(imageSize.width)"
            content["h"] = "\(imageSize.height)"
        }
        get {
            let width = CGFloat(Double(content["w"] ?? "") ?? 0)
            let height = CGFloat(Double(content["h"] ?? "") ?? 0)
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
        return content.jsonString()
    }
}

class WXExpressionMessage: WXMessage {
    var emoji: TLEmoji = TLEmoji() {
        didSet {
            content["groupID"] = emoji.groupID
            content["emojiID"] = emoji.emojiID
            let imageSize: CGSize = UIImage(named: self.path)?.size ?? CGSize.zero
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
            content["w"] = "\(newValue.width)"
            content["h"] = "\(newValue.height)"
        }
        get {
            return CGSize(width: CGFloat(Double(content["w"] ?? "") ?? 0), height: CGFloat(Double(content["h"] ?? "") ?? 0))
        }
    }
    override init() {
        super.init()
        emoji.groupID = content["groupID"] ?? ""
        emoji.emojiID = content["emojiID"] ?? ""
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
        return content.jsonString()
    }
}

class WXMessageManager: NSObject {
    static let shared = WXMessageManager()
    var messageDelegate: Any?
    weak var conversationDelegate: WXMessageManagerConvVCDelegate?
    private var userID: String {
        return WXUserHelper.shared.user.userID
    }
    var messageStore = WXDBMessageStore()
    var conversationStore = WXDBConversationStore()
    func send(_ message: WXMessage, progress: @escaping (WXMessage, CGFloat) -> Void, success: @escaping (WXMessage) -> Void, failure: @escaping (WXMessage) -> Void) {
        var ok = messageStore.add(message)
        if !(ok) {
            Dlog("存储Message到DB失败")
        } else {
            ok = addConversation(by: message)
            if !(ok) {
                Dlog("存储Conversation到DB失败")
            }
        }
    }
    func addConversation(by message: WXMessage) -> Bool {
        var partnerID = message.friendID
        var type: Int = 0
        if message.partnerType == .group {
            partnerID = message.groupID
            type = 1
        }
        return conversationStore.addConversation(byUid: message.userID, fid: partnerID, type: type, date: message.date)
    }
    func conversationRecord(_ complete: @escaping ([Any]) -> Void) {
        let data = conversationStore.conversations(byUid: userID)
        complete(data)
    }

    func deleteConversation(byPartnerID partnerID: String) -> Bool {
        var ok = deleteMessages(byPartnerID: partnerID)
        if ok {
            ok = conversationStore.deleteConversation(byUid: userID, fid: partnerID)
        }
        return ok
    }

    func messageRecord(forPartner partnerID: String, from date: Date, count: Int, complete: @escaping ([Any], Bool) -> Void) {
        messageStore.messages(byUserID: userID, partnerID: partnerID, from: date, count: count, complete: { data, hasMore in
            complete(data, hasMore)
        })
    }
    func chatFiles(forPartnerID partnerID: String, completed: @escaping ([Any]) -> Void) {
        let data = messageStore.chatFiles(byUserID: userID, partnerID: partnerID)
        completed(data)
    }

    func chatImagesAndVideos(forPartnerID partnerID: String, completed: @escaping ([WXMessage]) -> Void) {
        let data = messageStore.chatImagesAndVideos(byUserID: userID, partnerID: partnerID)
        completed(data)
    }

    func deleteMessage(byMsgID msgID: String) -> Bool {
        return messageStore.deleteMessage(byMessageID: msgID)
    }

    func deleteMessages(byPartnerID partnerID: String) -> Bool {
        let ok = messageStore.deleteMessages(byUserID: userID, partnerID: partnerID)
        if ok {
//            WXChatViewController.shared.resetChatVC()
        }
        return ok
    }
    func deleteAllMessages() -> Bool {
        var ok = messageStore.deleteMessages(byUserID: userID)
        if ok {
//            WXChatViewController.shared.resetChatVC()
//            ok = conversationStore.deleteConversations(byUid: userID)
        }
        return ok
    }

    func requestClientInitInfoSuccess(_ clientInitInfo: @escaping (Any) -> Void, failure error: @escaping (String) -> Void) {
        let HOST_URL = "http://127.0.0.1:8000/" // 本地测试服务器
        //    HOST_URL = @"http://121.42.29.15:8000/";        // 远程线上服务器
        let urlString = HOST_URL + ("client/getClientInitInfo/")
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            Dlog("OK")
        }, failure: { task, error in
            Dlog("OK")
        })
    }
    func chatDetailData(byUserInfo userInfo: WXUser) -> [WXSettingGroup] {
        let users = WXSettingItem.createItem(withTitle: "users")
        users.type = .other
        let group1: WXSettingGroup = TLCreateSettingGroup(nil, nil, [users])
        let top = WXSettingItem.createItem(withTitle: ("置顶聊天"))
        top.type = .switchBtn
        let screen = WXSettingItem.createItem(withTitle: ("消息免打扰"))
        screen.type = .switchBtn
        let group2: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([top, screen]))
        let chatFile = WXSettingItem.createItem(withTitle: ("聊天文件"))
        let group3: WXSettingGroup = TLCreateSettingGroup(nil, nil, [chatFile])
        let chatBG = WXSettingItem.createItem(withTitle: ("设置当前聊天背景"))
        let chatHistory = WXSettingItem.createItem(withTitle: ("查找聊天内容"))
        let group4: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([chatBG, chatHistory]))
        let clear = WXSettingItem.createItem(withTitle: ("清空聊天记录"))
        clear.showDisclosureIndicator = false
        let group5: WXSettingGroup = TLCreateSettingGroup(nil, nil, [clear])
        let report = WXSettingItem.createItem(withTitle: ("举报"))
        let group6: WXSettingGroup = TLCreateSettingGroup(nil, nil, [report])
        return [group1, group2, group3, group4, group5, group6]
    }

    func chatDetailData(byGroupInfo groupInfo: WXGroup) -> [WXSettingGroup] {
        let users = WXSettingItem.createItem(withTitle: ("users"))
        users.type = .other
        let allUsers = WXSettingItem.createItem(withTitle: (String(format: "全部群成员(%ld)", Int(groupInfo.count))))
        let group1: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([users, allUsers]))
        let groupName = WXSettingItem.createItem(withTitle: ("群聊名称"))
        groupName.subTitle = groupInfo.groupName
        let groupQR = WXSettingItem.createItem(withTitle: ("群二维码"))
        groupQR.rightImagePath = PQRCode
        let groupPost = WXSettingItem.createItem(withTitle: ("群公告"))
        if groupInfo.post.count > 0 {
            groupPost.subTitle = groupInfo.post
        } else {
            groupPost.subTitle = "未设置"
        }
        let group2: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([groupName, groupQR, groupPost]))
        let screen = WXSettingItem.createItem(withTitle: ("消息免打扰"))
        screen.type = .switchBtn
        let top = WXSettingItem.createItem(withTitle: ("置顶聊天"))
        top.type = .switchBtn
        let save = WXSettingItem.createItem(withTitle: ("保存到通讯录"))
        save.type = .switchBtn
        let group3: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([screen, top, save]))
        let myNikeName = WXSettingItem.createItem(withTitle: ("我在本群的昵称"))
        myNikeName.subTitle = groupInfo.myNikeName
        let showOtherNikeName = WXSettingItem.createItem(withTitle: ("显示群成员昵称"))
        showOtherNikeName.type = .switchBtn
        let group4: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([myNikeName, showOtherNikeName]))
        let chatFile = WXSettingItem.createItem(withTitle: ("聊天文件"))
        let chatHistory = WXSettingItem.createItem(withTitle: ("查找聊天内容"))
        let chatBG = WXSettingItem.createItem(withTitle: ("设置当前聊天背景"))
        let report = WXSettingItem.createItem(withTitle: ("举报"))
        let group5: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([chatFile, chatHistory, chatBG, report]))
        let clear = WXSettingItem.createItem(withTitle: ("清空聊天记录"))
        clear.showDisclosureIndicator = false
        let group6: WXSettingGroup = TLCreateSettingGroup(nil, nil, [clear])
        return [group1, group2, group3, group4, group5, group6]
    }
}
