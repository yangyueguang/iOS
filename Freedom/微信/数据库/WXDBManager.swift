//
//  WXDBManager.swift
//  Freedom
import Realm
import XExtension
import Foundation
var realmWX: RLMRealm {
    let path = "\(FileManager.documentsPath())/User/2829969299/Setting/DB/WX.realm"
    if !FileManager.default.fileExists(atPath: path) {
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    return RLMRealm(url: URL(fileURLWithPath: path))
}

class WXDBMessageStore: NSObject {
    override init() {
        super.init()
        try! realmWX.transaction {
            WXMessage.createOrUpdate(in: realmWX, withValue: WXMessage())
        }
    }
    func add(_ message: WXMessage?) {
        guard let message = message else { return }
        try! realmWX.transaction {
            realmWX.addOrUpdate(message)
        }
    }

    func messages(byUserID userID: String, partnerID: String, from date: Date, count: Int, complete: @escaping ([WXMessage], Bool) -> Void) {
        var data: [WXMessage] = []
        let pre = NSPredicate(format: "userID = %@ and friendID = %@ and date < %@ order by date desc LIMIT %ld", userID, partnerID, String(format: "%lf", date.timeIntervalSince1970), count + 1)
        try! realmWX.transaction {
            let results = WXMessage.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                let message = results.object(at: index) as! WXMessage
                data.insert(message, at: 0)
            }
        }
        var hasMore = false
        if data.count == count + 1 {
            hasMore = true
            data.remove(at: 0)
        }
        complete(data, hasMore)
    }
    func chatFiles(byUserID userID: String, partnerID: String) -> [[WXMessage]] {
        var data: [[WXMessage]] = []
        let pre = NSPredicate(format:"userID = %@ and friendID = %@ and messageType = 2", userID, partnerID)
        var array: [WXMessage] = []
        try! realmWX.transaction {
            let results = WXMessage.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                let message = results.object(at: index) as! WXMessage
                if message.date.isToday() {
                    array.append(message)
                } else {
                    if array.count > 0 {
                        data.append(array)
                    }
                    array = [message]
                }
            }
            if array.count > 0 {
                data.append(array)
            }
        }
        return data
    }

    func chatImagesAndVideos(byUserID userID: String, partnerID: String) -> [WXImageMessage] {
        var data: [WXImageMessage] = []
        let pre = NSPredicate(format: "userID = %@ and friendID = %@ and messageType = 2", userID, partnerID)
        try! realmWX.transaction {
            let results = WXImageMessage.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                let message = results.object(at: index) as! WXImageMessage
                data.append(message)
            }
        }
        return data
    }
    func lastMessage(byUserID userID: String, partnerID: String) -> WXMessage? {
        let pre = NSPredicate(format: "userID = %@ and friendID = %@", userID, partnerID)
        return WXMessage.objects(in: realmWX, with: pre).lastObject() as? WXMessage
    }

    func deleteMessage(byMessageID messageID: String) {
        try! realmWX.transaction {
            let results = WXMessage.objects(in: realmWX, with: NSPredicate(format: "messageID = %@", messageID))
            realmWX.deleteObjects(results)
        }
    }
    func deleteMessages(byUserID userID: String, partnerID: String) {
        try! realmWX.transaction {
            let pre = NSPredicate(format: "userID = %@ and friendID = %@", userID, partnerID)
            let results = WXMessage.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }

    func deleteMessages(byUserID userID: String) {
        try! realmWX.transaction {
            let predicate = NSPredicate(format: "userID = %@", userID)
            let results = WXMessage.objects(in: realmWX, with: predicate)
            realmWX.deleteObjects(results)
        }
    }
}

class WXDBConversationStore: NSObject {
    private var messageStore = WXDBMessageStore()
    override init() {
        super.init()
        try! realmWX.transaction {
            WXConversation.createOrUpdate(in: realmWX, withValue: WXConversation())
        }
    }
    func addConversation(byUid uid: String, fid: String, type: Int, date: Date) {
        try! realmWX.transaction {
            let conversation = WXConversation()
            conversation.partnerID = fid
            conversation.unreadCount = unreadMessage(byUid: uid, fid: fid) + 1
            conversation.convType = TLConversationType(rawValue: type) ?? TLConversationType.personal
            conversation.date = date
            realmWX.addOrUpdate(conversation)
        }
    }
    func conversations(byUid uid: String) -> [WXConversation] {
        var data: [WXConversation] = []
        let pre = NSPredicate(format: "partnerID = %@", uid)
        try! realmWX.transaction {
            let results = WXConversation.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                let conversation = results.object(at: index) as! WXConversation
                let message = messageStore.lastMessage(byUserID: uid, partnerID: conversation.partnerID)
                if message != nil {
                    conversation.content = message?.conversationContent() ?? ""
                    conversation.date = message?.date ?? Date()
                }
                data.append(conversation)
            }
        }
//        data.sorted(by: WXConversation.date, ascending: true)
        return data
    }
    //更新会话状态（已读）
    func updateConversation(byUid uid: String, fid: String) {
    }

    //查询所有会话
    func unreadMessage(byUid uid: String, fid: String) -> Int {
        let pre = NSPredicate(format: "userID = %@ and friendID = %@", uid, fid)
        return Int(WXConversation.objects(in: realmWX, with: pre).count)
    }
    //删除单条会话
    func deleteConversation(byUid uid: String, fid: String) {
        try! realmWX.transaction {
            let pre = NSPredicate(format: "userID = %@ and friendID = %@", uid, fid)
            let results = WXConversation.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }
    //删除用户的所有会话
    func deleteConversations(byUid uid: String) {
        try! realmWX.transaction {
            let pre = NSPredicate(format: "partnerID = %@", uid)
            let results = WXConversation.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }
}

class WXDBExpressionStore: NSObject {
    override init() {
        super.init()
        try! realmWX.transaction {
            TLEmojiGroup.createOrUpdate(in: realmWX, withValue: TLEmojiGroup())
            TLEmoji.createOrUpdate(in: realmWX, withValue: TLEmoji())
        }
    }
    func addExpressionGroup(_ group: TLEmojiGroup, forUid uid: String) {
        // 添加表情包
        try! realmWX.transaction {
            realmWX.addOrUpdate(group)
        }
        // 添加表情包里的所有表情
        addExpressions(group.data, toGroupID: group.groupID)
    }
    func expressionGroups(byUid uid: String) -> [TLEmojiGroup] {
        var data: [TLEmojiGroup] = []
        let pre = NSPredicate(format: "authID = %@", uid)
        // 读取表情包信息
        try! realmWX.transaction {
            let results = TLEmojiGroup.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                let group = results.object(at: index) as! TLEmojiGroup
                group.data = expressions(forGroupID: group.groupID)
                data.append(group)
            }
        }
        return data
    }
    func deleteExpressionGroup(byID gid: String, forUid uid: String) {
        try! realmWX.transaction {
            let pre = NSPredicate(format: "authID = %@ and groupID = %@", uid, gid)
            let results = TLEmojiGroup.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }

    func countOfUserWhoHasExpressionGroup(_ gid: String) -> Int {
        let pre = NSPredicate(format: "groupID = %@", gid)
        let results = TLEmojiGroup.objects(in: realmWX, with: pre)
        return Int(results.count)
    }
    // 表情
    func addExpressions(_ expressions: [TLEmoji], toGroupID groupID: String) {
        try! realmWX.transaction {
            realmWX.addObjects(expressions as NSFastEnumeration)
        }
    }
    func expressions(forGroupID groupID: String) -> [TLEmoji] {
        var data: [TLEmoji] = []
        let pre = NSPredicate(format: "groupID = %@", groupID)
        try! realmWX.transaction {
            let results = TLEmoji.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                data.append(results.object(at: index) as! TLEmoji)
            }
        }
        return data
    }
}

class WXDBFriendStore: NSObject {
    override init() {
        super.init()
        try! realmWX.transaction {
            WXUser.createOrUpdate(in: realmWX, withValue: WXUser())
        }
    }
    func addFriend(_ user: WXUser, forUid uid: String) {
        try! realmWX.transaction {
            realmWX.addOrUpdate(user)
        }
    }

    func updateFriendsData(_ friendData: [WXUser], forUid uid: String) {
        let oldData = friendsData(byUid: uid)
        if oldData.count > 0 {
            var newDataHash: [AnyHashable : Any] = [:]
            for user: WXUser in friendData {
                newDataHash[user.userID] = "YES"
            }
            for user: WXUser in oldData {
                if newDataHash[user.userID] == nil {
                    deleteFriend(byFid: user.userID, forUid: uid)
                }
            }
        }
        for user: WXUser in friendData {
            addFriend(user, forUid: uid)
        }
    }
    func friendsData(byUid uid: String) -> [WXUser] {
        var data: [WXUser] = []
        let pre = NSPredicate(format: "userID = %@", uid)
        try! realmWX.transaction {
            let results = WXUser.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                data.append(results.object(at: index) as! WXUser)
            }
        }
        return data
    }

    func deleteFriend(byFid fid: String, forUid uid: String) {
        try! realmWX.transaction {
            let pre = NSPredicate(format: "userID = %@ and friendID = %@", uid, fid)
            let results = WXUser.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }
}

class WXDBGroupStore: NSObject {
    override init() {
        super.init()
        try! realmWX.transaction {
            WXGroup.createOrUpdate(in: realmWX, withValue: WXGroup())
            WXUserGroup.createOrUpdate(in: realmWX, withValue: WXUserGroup())
        }
    }
    func add(_ group: WXGroup, forUid uid: String) {
        try! realmWX.transaction {
            realmWX.addOrUpdate(group)
        }
    }

    func updateGroupsData(_ groupData: [WXGroup], forUid uid: String) {
        let oldData = groupsData(byUid: uid)
        if oldData.count > 0 {
            var newDataHash: [String : Any] = [:]
            for group: WXGroup in groupData {
                newDataHash[group.groupID] = "YES"
            }
            for group: WXGroup in oldData {
                if newDataHash[group.groupID] == nil {
                    deleteGroup(byGid: group.groupID, forUid: uid)
                }
            }
        }
        // 将数据插入数据库
        for group: WXGroup in groupData {
            add(group, forUid: uid)
        }
    }
    func groupsData(byUid uid: String) -> [WXGroup] {
        var data: [WXGroup] = []
        let pre = NSPredicate(format: "groupID = %@", uid)

        try! realmWX.transaction {
            let results = WXGroup.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                let group = results.object(at: index) as! WXGroup
                data.append(group)
            }
        }
        // 获取讨论组成员
        for group: WXGroup in data {
            group.users = groupMembers(forUid: uid, andGid: group.groupID)
        }
        return data
    }
    func deleteGroup(byGid gid: String, forUid uid: String) {
        try! realmWX.transaction {
            let pre = NSPredicate(format: "chat_userID = %@ and groupID = %@", uid, gid)
            let results = WXGroup.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }

    /// Group Members
    func addGroupMember(_ user: WXUser, forUid uid: String, andGid gid: String) {
        try! realmWX.transaction {
            realmWX.addOrUpdate(user)
        }
    }

    func addGroupMembers(_ users: [WXUser], forUid uid: String, andGid gid: String) {
        let oldData = groupMembers(forUid: uid, andGid: gid)
        if oldData.count > 0 {
            // 建立新数据的hash表，用于删除数据库中的过时数据
            var newDataHash: [String : Any] = [:]
            for user: WXUser in users {
                newDataHash[user.userID] = "YES"
            }
            for user: WXUser in oldData {
                if newDataHash[user.userID] == nil {
                    deleteGroupMember(forUid: uid, gid: gid, andFid: user.userID)
                }
            }
        }
        for user: WXUser in users{
            addGroupMember(user, forUid: uid, andGid: gid)
        }
    }
    func groupMembers(forUid uid: String, andGid gid: String) -> [WXUser] {
        var data: [WXUser] = []
        let pre = NSPredicate(format: "userID = %@", uid)
        try! realmWX.transaction {
            let results = WXUser.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                let user = results.object(at: index) as! WXUser
                data.append(user)
            }
        }
        return data
    }
    func deleteGroupMember(forUid uid: String, gid: String, andFid fid: String) {
        try! realmWX.transaction {
            let pre = NSPredicate(format: "userID = %@ and groupID = %@ and friendID = %@", uid, gid, fid)
            let results = WXUser.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }
}
