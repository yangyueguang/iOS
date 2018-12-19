//
//  WXMessageManager.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
//消息所有者类型

enum TLPartnerType : Int {
    case user // 用户
    case group // 群聊
}

//消息拥有者
enum TLMessageOwnerType : Int {
    case unknown // 未知的消息拥有者
    case system // 系统消息
    case self // 自己发送的消息
    case friend // 接收到的他人消息
}

//消息发送状态
enum TLMessageSendState : Int {
    case tlMessageSendSuccess // 消息发送成功
    case tlMessageSendFail // 消息发送失败
}

//消息读取状态
enum TLMessageReadState : Int {
    case tlMessageUnRead // 消息未读
    case tlMessageReaded // 消息已读
}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXConversation: NSObject {
    //会话类型（个人，讨论组，企业号）
    var convType: TLConversationType?
    //消息提醒类型
    var remindType: TLMessageRemindType?
    //用户ID
    var partnerID = ""
    //用户名
    var partnerName = ""
    //头像地址（网络）
    var avatarURL = ""
    //头像地址（本地）
    var avatarPath = ""
    //时间
    var date: Date?
    //消息展示内容
    var content = ""
    //提示红点类型
    private(set) var clueType: TLClueType?
    private(set) var isRead = false
    //未读数量
    var unreadCount: Int = 0


    func setConvType(_ convType: TLConversationType) {
        self.convType = convType
        switch convType {
        case TLConversationTypePersonal, TLConversationTypeGroup:
            clueType = TLClueTypePointWithNumber
        case TLConversationTypePublic, TLConversationTypeServerGroup:
            clueType = TLClueTypePoint
        default:
            break
        }
    }
    func isRead() -> Bool {
        return unreadCount == 0
    }

    func updateUserInfo(_ user: WXUser?) {
        partnerName = user?.showName
        avatarPath = user?.avatarPath
        avatarURL = user?.avatarURL
    }

    func updateGroupInfo(_ group: WXGroup?) {
        partnerName = group?.groupName
        avatarPath = group?.groupAvatarPath
    }


    
}
protocol WXMessageProtocol: NSObjectProtocol {
    func messageCopy() -> String?
    func conversationContent() -> String?
}

class WXMessageFrame: NSObject {
    var height: CGFloat = 0.0
    var contentSize = CGSize.zero
}

class WXMessage: NSObject, WXMessageProtocol {
    var kMessageFrame: WXMessageFrame?

    var messageID = ""
    /* 消息ID */    var userID = ""
    /* 发送者ID */    var friendID = ""
    /* 接收者ID */    var groupID = ""
    /* 讨论组ID（无则为nil） */    var date: Date?
    /* 发送时间 */    var fromUser: WXChatUserProtocol?
    /* 发送者 */    var showTime = false
    var showName = false
    var partnerType: TLPartnerType?
    /* 对方类型 */    var messageType: TLMessageType?
    /* 消息类型 */    var ownerTyper: TLMessageOwnerType?
    /* 发送者类型 */    var readState: TLMessageReadState?
    /* 读取状态 */    var sendState: TLMessageSendState?
    /* 发送状态 */    var content: [AnyHashable : Any] = [:]
    var messageFrame: WXMessageFrame?
    // 消息frame
    class func createMessage(by type: TLMessageType) -> WXMessage? {
        var className: String
        if type == TLMessageTypeText {
            className = "TLTextMessage"
        } else if type == TLMessageTypeImage {
            className = "TLImageMessage"
        } else if type == TLMessageTypeExpression {
            className = "TLExpressionMessage"
        }
        if className != "" {
            return NSClassFromString(className)()
        }
        return nil
    }

    init() {
        super.init()

        messageID = String(format: "%lld", Int64(Date().timeIntervalSince1970 * 10000))

    }
    func conversationContent() -> String? {
        return "子类未定义"
    }

    func messageCopy() -> String? {
        return "子类未定义"
    }

    // MARK: -
    func content() -> [AnyHashable : Any]? {
        if content == nil {
            content = [AnyHashable : Any]()
        }
        return content
    }

}
class WXImageMessage: WXMessage {
    var imageSize = CGSize.zero {
        let width = CGFloat(Double(content["w"] ?? 0.0))
        let height = CGFloat(Double(content["h"] ?? 0.0))
        return CGSize(width: width, height: height)
    }

    func setImageSize(_ imageSize: CGSize) {
        content["w"] = Double(imageSize.width)
        content["h"] = Double(imageSize.height)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func messageFrame() -> WXMessageFrame? {
        if kMessageFrame == nil {
            kMessageFrame = WXMessageFrame()
            kMessageFrame.height = 20 + (showTime ? 30 : 0) + (showName ? 15 : 0)
            let imageSize: CGSize = self.imageSize()
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
        return kMessageFrame
    }
    func conversationContent() -> String? {
        return "[图片]"
    }

    func messageCopy() -> String? {
        return content.mj_JSONString()
    }

}

protocol WXMessageManagerConvVCDelegate: NSObjectProtocol {
    func updateConversationData()
}

class WXMessageManager: NSObject {
    var messageDelegate: Any?
    weak var conversationDelegate: WXMessageManagerConvVCDelegate?
    private(set) var userID = ""
    var messageStore: WXDBMessageStore?
    var conversationStore: WXDBConversationStore?

    func send(_ message: WXMessage?, progress: @escaping (WXMessage?, CGFloat) -> Void, success: @escaping (WXMessage?) -> Void, failure: @escaping (WXMessage?) -> Void) {
        var ok = messageStore()?.add(message)
        if !(ok ?? false) {
            DLog("存储Message到DB失败")
        } else {
            // 存储到conversation
            ok = addConversation(by: message)
            if !(ok ?? false) {
                DLog("存储Conversation到DB失败")
            }
        }
    }

    // MARK: - Getter -
    func messageStore() -> WXDBMessageStore? {
        if messageStore == nil {
            messageStore = WXDBMessageStore()
        }
        return messageStore
    }
    func conversationStore() -> WXDBConversationStore? {
        if conversationStore == nil {
            conversationStore = WXDBConversationStore()
        }
        return conversationStore
    }

    func userID() -> String? {
        return WXUserHelper.shared().user.userID()
    }

    func addConversation(by message: WXMessage?) -> Bool {
        var partnerID = message?.friendID
        var type: Int = 0
        if message?.partnerType == TLPartnerTypeGroup {
            partnerID = message?.groupID
            type = 1
        }
        let ok = conversationStore()?.addConversation(byUid: message?.userID(), fid: partnerID, type: type, date: message?.date)

        return ok ?? false
    }
    func conversationRecord(_ complete: @escaping ([Any]?) -> Void) {
        let data = conversationStore.conversations(byUid: userID)
        complete(data)
    }

    func deleteConversation(byPartnerID partnerID: String?) -> Bool {
        var ok = deleteMessages(byPartnerID: partnerID)
        if ok {
            ok = conversationStore.deleteConversation(byUid: userID, fid: partnerID)
        }
        return ok
    }

    func messageRecord(forPartner partnerID: String?, from date: Date?, count: Int, complete: @escaping ([Any]?, Bool) -> Void) {
        messageStore.messages(byUserID: userID, partnerID: partnerID, from: date, count: count, complete: { data, hasMore in
            complete(data, hasMore)
        })
    }
    func chatFiles(forPartnerID partnerID: String?, completed: @escaping ([Any]?) -> Void) {
        let data = messageStore.chatFiles(byUserID: userID, partnerID: partnerID)
        completed(data)
    }

    func chatImagesAndVideos(forPartnerID partnerID: String?, completed: @escaping ([Any]?) -> Void) {
        let data = messageStore.chatImagesAndVideos(byUserID: userID, partnerID: partnerID)
        completed(data)
    }

    func deleteMessage(byMsgID msgID: String?) -> Bool {
        return messageStore.deleteMessage(byMessageID: msgID)
    }

    func deleteMessages(byPartnerID partnerID: String?) -> Bool {
        let ok = messageStore.deleteMessages(byUserID: userID, partnerID: partnerID)
        if ok {
            WXChatViewController.sharedChatVC().resetChatVC()
        }
        return ok
    }
    func deleteAllMessages() -> Bool {
        var ok = messageStore.deleteMessages(byUserID: userID)
        if ok {
            WXChatViewController.sharedChatVC().resetChatVC()
            ok = conversationStore.deleteConversations(byUid: userID)
        }
        return ok
    }

    func requestClientInitInfoSuccess(_ clientInitInfo: @escaping (Any?) -> Void, failure error: @escaping (String?) -> Void) {
        let HOST_URL = "http://127.0.0.1:8000/" // 本地测试服务器
        //    HOST_URL = @"http://121.42.29.15:8000/";        // 远程线上服务器
        let urlString = HOST_URL + ("client/getClientInitInfo/")
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            DLog("OK")
        }, failure: { task, error in
            DLog("OK")
        })
    }
    func chatDetailData(byUserInfo userInfo: WXUser?) -> [AnyHashable]? {
        let users = WXSettingItem.createItem(withTitle: "users")
        users.type = TLSettingItemTypeOther
        let group1: WXSettingGroup? = TLCreateSettingGroup(nil, nil, [users])

        let top = WXSettingItem.createItem(withTitle: ("置顶聊天"))
        top.type = TLSettingItemTypeSwitch
        let screen = WXSettingItem.createItem(withTitle: ("消息免打扰"))
        screen.type = TLSettingItemTypeSwitch
        let group2: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([top, screen]))

        let chatFile = WXSettingItem.createItem(withTitle: ("聊天文件"))
        let group3: WXSettingGroup? = TLCreateSettingGroup(nil, nil, [chatFile])

        let chatBG = WXSettingItem.createItem(withTitle: ("设置当前聊天背景"))
        let chatHistory = WXSettingItem.createItem(withTitle: ("查找聊天内容"))
        let group4: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([chatBG, chatHistory]))
        let clear = WXSettingItem.createItem(withTitle: ("清空聊天记录"))
        clear.showDisclosureIndicator = false
        let group5: WXSettingGroup? = TLCreateSettingGroup(nil, nil, [clear])

        let report = WXSettingItem.createItem(withTitle: ("举报"))
        let group6: WXSettingGroup? = TLCreateSettingGroup(nil, nil, [report])

        var data: [AnyHashable] = []
        data.append(contentsOf: [group1, group2, group3, group4, group5, group6])
        return data
    }

    func chatDetailData(byGroupInfo groupInfo: WXGroup?) -> [AnyHashable]? {
        let users = WXSettingItem.createItem(withTitle: ("users"))
        users.type = TLSettingItemTypeOther
        let allUsers = WXSettingItem.createItem(withTitle: (String(format: "全部群成员(%ld)", Int(groupInfo?.count ?? 0))))
        let group1: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([users, allUsers]))

        let groupName = WXSettingItem.createItem(withTitle: ("群聊名称"))
        groupName.subTitle = groupInfo?.groupName
        let groupQR = WXSettingItem.createItem(withTitle: ("群二维码"))
        groupQR.rightImagePath = PQRCode
        let groupPost = WXSettingItem.createItem(withTitle: ("群公告"))
        if groupInfo?.post.length ?? 0 > 0 {
            groupPost.subTitle = groupInfo?.post
        } else {
            groupPost.subTitle = "未设置"
        }
        let group2: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([groupName, groupQR, groupPost]))
        let screen = WXSettingItem.createItem(withTitle: ("消息免打扰"))
        screen.type = TLSettingItemTypeSwitch
        let top = WXSettingItem.createItem(withTitle: ("置顶聊天"))
        top.type = TLSettingItemTypeSwitch
        let save = WXSettingItem.createItem(withTitle: ("保存到通讯录"))
        save.type = TLSettingItemTypeSwitch
        let group3: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([screen, top, save]))

        let myNikeName = WXSettingItem.createItem(withTitle: ("我在本群的昵称"))
        myNikeName.subTitle = groupInfo?.myNikeName
        let showOtherNikeName = WXSettingItem.createItem(withTitle: ("显示群成员昵称"))
        showOtherNikeName.type = TLSettingItemTypeSwitch
        let group4: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([myNikeName, showOtherNikeName]))

        let chatFile = WXSettingItem.createItem(withTitle: ("聊天文件"))
        let chatHistory = WXSettingItem.createItem(withTitle: ("查找聊天内容"))
        let chatBG = WXSettingItem.createItem(withTitle: ("设置当前聊天背景"))
        let report = WXSettingItem.createItem(withTitle: ("举报"))
        let group5: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([chatFile, chatHistory, chatBG, report]))

        let clear = WXSettingItem.createItem(withTitle: ("清空聊天记录"))
        clear.showDisclosureIndicator = false
        let group6: WXSettingGroup? = TLCreateSettingGroup(nil, nil, [clear])

        var data: [AnyHashable] = []
        data.append(contentsOf: [group1, group2, group3, group4, group5, group6])
        return data
    }


    
}
