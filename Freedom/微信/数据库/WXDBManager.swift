//
//  WXDBManager.swift
//  Freedom
import Realm
import XExtension
import Foundation
class WXDBStore: NSObject {
    static let shared = WXDBStore()
    override init() {
        super.init()
    }
}
//WXDBMessageStore
extension WXDBStore {
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
        let pre = NSPredicate(format: "userID = %@ and friendID = %@", userID, partnerID ?? "")
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
//WXDBConversationStore
extension WXDBStore {
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
        print(uid)
        let pre = NSPredicate(format: "partnerID != \"\"")
        try! realmWX.transaction {
            let results = WXConversation.objects(in: realmWX, with: pre).sortedResults(usingKeyPath: "date", ascending: true)
            for index in 0..<results.count {
                let conversation = results.object(at: index) as! WXConversation
                let message = self.lastMessage(byUserID: uid, partnerID: conversation.partnerID)
                if message != nil {
                    conversation.content = message?.conversationContent() ?? ""
                    conversation.date = message?.date ?? Date()
                }
                data.append(conversation)
            }
        }
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
//WXDBExpressionStore
extension WXDBStore {
    func addExpressionGroup(_ group: TLEmojiGroup, forUid uid: String) {
        // 添加表情包
        try! realmWX.transaction {
            realmWX.addOrUpdate(group)
        }
        // 添加表情包里的所有表情
        addExpressions(group.data.array(), toGroupID: group.groupID)
    }
    func expressionGroups(byUid uid: String) -> [TLEmojiGroup] {
        var data: [TLEmojiGroup] = []
        let pre = NSPredicate(format: "authID = %@", uid)
        // 读取表情包信息
        try! realmWX.transaction {
            let results = TLEmojiGroup.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                let group = results.object(at: index) as! TLEmojiGroup
                group.data.removeAll()
                group.data.append(objectsIn: expressions(forGroupID: group.groupID))
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
//WXDBFriendStore
extension WXDBStore {
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
// WXDBGroupStore
extension WXDBStore {
    func add(_ group: WXGroup, forUid uid: String) {
        try! realmWX.transaction {
            realmWX.addOrUpdate(group)
        }
    }
    func deleteGroup(byGid gid: String, forUid uid: String) {
        try! realmWX.transaction {
            let pre = NSPredicate(format: "chat_userID = %@ and groupID = %@", uid, gid)
            let results = WXGroup.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }

    func addGroupMembers(_ users: [WXUser], forUid uid: String, andGid gid: String) {
        try! realmWX.transaction {
            realmWX.addOrUpdateObjects(users as NSFastEnumeration)
        }
    }
    func deleteGroupMember(forUid uid: String, gid: String, andFid fid: String) {
        try! realmWX.transaction {
            let pre = NSPredicate(format: "userID = %@ and groupID = %@ and friendID = %@", uid, gid, fid)
            let results = WXUser.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }
}
