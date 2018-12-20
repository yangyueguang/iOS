//
//  WXDBManager.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/20.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
let MESSAGE_TABLE_NAME = "message"
let SQL_CREATE_MESSAGE_TABLE = "CREATE TABLE IF NOT EXISTS %@(msgid TEXT,uid TEXT,fid TEXT,subfid TEXT,date TEXT,partner_type INTEGER DEFAULT (0),own_type INTEGER DEFAULT (0),msg_type INTEGER DEFAULT (0),content TEXT,send_status INTEGER DEFAULT (0),received_status BOOLEAN DEFAULT (0),ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, msgid, fid, subfid))"
let SQL_ADD_MESSAGE = "REPLACE INTO %@ ( msgid, uid, fid, subfid, date, partner_type, own_type, msg_type, content, send_status, received_status, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
let SQL_SELECT_MESSAGES_PAGE = "SELECT * FROM %@ WHERE uid = '%@' and fid = '%@' and date < '%@' order by date desc LIMIT '%ld'"
let SQL_SELECT_CHAT_FILES = "SELECT * FROM %@ WHERE uid = '%@' and fid = '%@' and msg_type = '2'"
let SQL_SELECT_CHAT_MEDIA = "SELECT * FROM %@ WHERE uid = '%@' and fid = '%@' and msg_type = '2'"
let SQL_SELECT_LAST_MESSAGE = "SELECT * FROM %@ WHERE date = ( SELECT MAX(date) FROM %@ WHERE uid = '%@' and fid = '%@' )"
let SQL_DELETE_MESSAGE = "DELETE FROM %@ WHERE msgid = '%@'"
let SQL_DELETE_FRIEND_MESSAGES = "DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"
let SQL_DELETE_USER_MESSAGES = "DELETE FROM %@ WHERE uid = '%@'"
let CONV_TABLE_NAME = "conversation"
let SQL_CREATE_CONV_TABLE = "CREATE TABLE IF NOT EXISTS %@(uid TEXT,fid TEXT,conv_type INTEGER DEFAULT (0),date TEXT,unread_count INTEGER DEFAULT (0),ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, fid))"
let SQL_ADD_CONV = "REPLACE INTO %@ ( uid, fid, conv_type, date, unread_count, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
let SQL_SELECT_CONVS = "SELECT * FROM %@ WHERE uid = %@ ORDER BY date DESC"
let SQL_SELECT_CONV_UNREAD = "SELECT unread_count FROM %@ WHERE uid = '%@' and fid = '%@'"
let SQL_DELETE_CONV = "DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"
let SQL_DELETE_ALL_CONVS = "DELETE FROM %@ WHERE uid = '%@'"
// MARK: - 表情组
let EXP_GROUP_TABLE_NAME = "expression_group"
let SQL_CREATE_EXP_GROUP_TABLE = "CREATE TABLE IF NOT EXISTS %@(uid TEXT,gid TEXT,type INTEGER DEFAULT (0),name TEXT,desc TEXT,detail TEXT,count INTEGER DEFAULT (0),auth_id TEXT,auth_name TEXT,date TEXT,ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, gid))"
let SQL_ADD_EXP_GROUP = "REPLACE INTO %@ ( uid, gid, type, name, desc, detail, count, auth_id, auth_name, date, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"
let SQL_SELECT_EXP_GROUP = "SELECT * FROM %@ WHERE uid = '%@'"
let SQL_DELETE_EXP_GROUP = "DELETE FROM %@ WHERE uid = '%@' and gid = '%@'"
let SQL_SELECT_COUNT_EXP_GROUP_USERS = "SELECT count(uid) FROM %@ WHERE gid = '%@'"
// MARK: -  表情
let EXPS_TABLE_NAME = "expressions"
let SQL_CREATE_EXPS_TABLE = "CREATE TABLE IF NOT EXISTS %@(gid TEXT,eid TEXT,name TEXT,ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(gid, eid))"
let SQL_ADD_EXP = "REPLACE INTO %@ ( gid, eid, name, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )"
let SQL_SELECT_EXPS = "SELECT * FROM %@ WHERE gid = '%@'"
let FRIENDS_TABLE_NAME = "friends"
let SQL_CREATE_FRIENDS_TABLE = "CREATE TABLE IF NOT EXISTS %@(uid TEXT,fid TEXT,username TEXT,nikename TEXT,avatar TEXT,remark TEXT,ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, fid))"
let SQL_UPDATE_FRIEND = "REPLACE INTO %@ ( uid, fid, username, nikename, avatar, remark, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
let SQL_SELECT_FRIENDS = "SELECT * FROM %@ WHERE uid = %@"
let SQL_DELETE_FRIEND = "DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"
// MARK: - GROUPS
let GROUPS_TABLE_NAME = "groups"
let SQL_CREATE_GROUPS_TABLE = "CREATE TABLE IF NOT EXISTS %@(uid TEXT,gid TEXT,name TEXT,ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, gid))"
let SQL_UPDATE_GROUP = "REPLACE INTO %@ ( uid, gid, name, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )"
let SQL_SELECT_GROUPS = "SELECT * FROM %@ WHERE uid = %@"
let SQL_DELETE_GROUP = "DELETE FROM %@ WHERE uid = '%@' and gid = '%@'"
// MARK: - GROUP MEMBERS
let GROUP_MEMBER_TABLE_NAMGE = "group_members"
let SQL_CREATE_GROUP_MEMBERS_TABLE = "CREATE TABLE IF NOT EXISTS %@(uid TEXT,gid TEXT,fid TEXT,username TEXT,nikename TEXT,avatar TEXT,remark TEXT,ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, gid, fid))"
let SQL_UPDATE_GROUP_MEMBER = "REPLACE INTO %@ ( uid, gid, fid, username, nikename, avatar, remark, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
let SQL_SELECT_GROUP_MEMBERS = "SELECT * FROM %@ WHERE uid = %@"
let SQL_DELETE_GROUP_MEMBER = "DELETE FROM %@ WHERE uid = '%@' and gid = '%@' and fid = '%@'"
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
//  TLDBManager.h

class WXDBManager: NSObject {
    //DB队列（除IM相关）
    var commonQueue: FMDatabaseQueue?
    //与IM相关的DB队列
    var messageQueue: FMDatabaseQueue?
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    class var sharedInstance: CXCallDirectoryManager {


            let userID = WXUserHelper.shared().user.userID
            manager = WXDBManager(userID: userID)

        return manager
    }

    init(userID: String?) {
        super.init()

        let commonQueuePath = FileManager.pathDBCommon()
        commonQueue = FMDatabaseQueue(path: commonQueuePath)
        let messageQueuePath = FileManager.pathDBMessage()
        messageQueue = FMDatabaseQueue(path: messageQueuePath)

    }

    convenience init() {
        DLog("TLDBManager：请使用 initWithUserID: 方法初始化")
        return nil
    }

}

class WXDBBaseStore: NSObject {
    /// 数据库操作队列(从TLDBManager中获取，默认使用commonQueue)
    weak var dbQueue: FMDatabaseQueue?
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    init() {
        super.init()

        dbQueue = WXDBManager.sharedInstance().commonQueue

    }

    func createTable(_ tableName: String?, withSQL sqlString: String?) -> Bool {
        var ok = true
        dbQueue.inDatabase({ db in
            if db?.tableExists(tableName) == nil {
                ok = db?.executeUpdate(sqlString, withArgumentsInArray: []) ?? false
            }
        })
        return ok
    }

    func excuteSQL(_ sqlString: String?, withArrParameter arrParameter: [Any]?) -> Bool {
        var ok = false
        if dbQueue {
            dbQueue.inDatabase({ db in
                ok = db?.executeUpdate(sqlString, withArgumentsInArray: arrParameter) ?? false
            })
        }
        return ok
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func excuteSQL(_ sqlString: String?, withDicParameter dicParameter: [AnyHashable : Any]?) -> Bool {
        var ok = false
        if dbQueue {
            dbQueue.inDatabase({ db in
                ok = db?.executeUpdate(sqlString, withParameterDictionary: dicParameter) ?? false
            })
        }
        return ok
    }

    func excuteSQL(_ sqlString: String?) -> Bool {
        var ok = false
        if dbQueue {
            var args: va_list
            var p_args: va_list?
            p_args = args
            va_start(args, sqlString)
            dbQueue.inDatabase({ db in
                ok = db?.executeUpdate(sqlString, withVAList: p_args) ?? false
            })
            va_end(args)
        }
        return ok
    }
    func excuteQuerySQL(_ sqlStr: String?, resultBlock: @escaping (_ rsSet: FMResultSet?) -> Void) {
        if dbQueue {
            dbQueue.inDatabase({ db in
                let retSet: FMResultSet? = db?.execute(sqlStr ?? "")
                //if resultBlock

                resultBlock(retSet)

            })
        }
    }




    
}

class WXDBMessageStore: WXDBBaseStore {
    init() {
        super.init()

        dbQueue = WXDBManager.sharedInstance().messageQueue
        let ok: Bool = createTable()
        if !ok {
            DLog("DB: 聊天记录表创建失败")
        }

    }

    func createTable() -> Bool {
        let sqlString = String(format: SQL_CREATE_MESSAGE_TABLE, MESSAGE_TABLE_NAME)
        return createTable(MESSAGE_TABLE_NAME, withSQL: sqlString)
    }
    func add(_ message: WXMessage?) -> Bool {
        if message == nil || message?.messageID == nil || message?.userID == nil || (message?.friendID == nil && message?.groupID == nil) {
            return false
        }

        var fid = ""
        var subfid: String
        if message?.partnerType == TLPartnerTypeUser {
            fid = message?.friendID ?? ""
        } else {
            fid = message?.groupID ?? ""
            subfid = message?.friendID ?? ""
        }

        let sqlString = String(format: SQL_ADD_MESSAGE, MESSAGE_TABLE_NAME)
        let arrPara = [message?.messageID, message?.userID, fid, (subfid), String(format: "%lf", message?.date.timeIntervalSince1970 ?? 0.0), message?.partnerType ?? 0, message?.ownerTyper ?? 0, message?.messageType ?? 0, message?.content.mj_JSONString(), message?.sendState ?? 0, message?.readState ?? 0, "", "", "", "", ""]
        let ok = excuteSQL(sqlString, withArrParameter: arrPara)
        return ok
    }

    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func messages(byUserID userID: String?, partnerID: String?, from date: Date?, count: Int, complete: @escaping ([Any]?, Bool) -> Void) {
        var data: [AnyHashable] = []
        let sqlString = String(format: SQL_SELECT_MESSAGES_PAGE, MESSAGE_TABLE_NAME, userID ?? "", partnerID ?? "", String(format: "%lf", date?.timeIntervalSince1970 ?? 0.0), count + 1)
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet?.next() {
                let message: WXMessage? = self.p_createDBMessage(by: retSet)
                if let aMessage = message {
                    data.insert(aMessage, at: 0)
                }
            }
            retSet?.close()
        })

        var hasMore = false
        if data.count == count + 1 {
            hasMore = true
            data.remove(at: 0)
        }
        complete(data, hasMore)
    }
    func chatFiles(byUserID userID: String?, partnerID: String?) -> [Any]? {
        var data: [AnyHashable] = []
        let sqlString = String(format: SQL_SELECT_CHAT_FILES, MESSAGE_TABLE_NAME, userID ?? "", partnerID ?? "")

        var lastDate = Date()
        var array: [AnyHashable] = []
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet?.next() {
                let message: WXMessage? = self.p_createDBMessage(by: retSet)
                if self.isToday(message?.date) {
                    if let aMessage = message {
                        array.append(aMessage)
                    }
                } else {
                    if let aDate = message?.date {
                        lastDate = aDate
                    }
                    if array.count > 0 {
                        data.append(array)
                    }
                    array = [message]
                }
            }
            if array.count > 0 {
                data.append(array)
            }
            retSet?.close()
        })
        return data
    }
    func isToday(_ date: Date?) -> Bool {
        let components1: DateComponents? = date?.ymdComponents()
        let components2: DateComponents? = Date().ymdComponents()
        return (components1?.year == components2?.year) && (components1?.month == components2?.month) && (components1?.day == components2?.day)
    }

    func chatImagesAndVideos(byUserID userID: String?, partnerID: String?) -> [Any]? {
        var data: [AnyHashable] = []
        let sqlString = String(format: SQL_SELECT_CHAT_MEDIA, MESSAGE_TABLE_NAME, userID ?? "", partnerID ?? "")

        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet?.next() {
                let message: WXMessage? = self.p_createDBMessage(by: retSet)
                if let aMessage = message {
                    data.append(aMessage)
                }
            }
            retSet?.close()
        })
        return data
    }
    func lastMessage(byUserID userID: String?, partnerID: String?) -> WXMessage? {
        let sqlString = String(format: SQL_SELECT_LAST_MESSAGE, MESSAGE_TABLE_NAME, MESSAGE_TABLE_NAME, userID ?? "", partnerID ?? "")
        var message: WXMessage?
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet?.next() {
                message = self.p_createDBMessage(by: retSet)
            }
            retSet?.close()
        })
        return message
    }

    func deleteMessage(byMessageID messageID: String?) -> Bool {
        let sqlString = String(format: SQL_DELETE_MESSAGE, MESSAGE_TABLE_NAME, messageID ?? "")
        let ok = excuteSQL(sqlString, nil)
        return ok
    }
    func deleteMessages(byUserID userID: String?, partnerID: String?) -> Bool {
        let sqlString = String(format: SQL_DELETE_FRIEND_MESSAGES, MESSAGE_TABLE_NAME, userID ?? "", partnerID ?? "")
        let ok = excuteSQL(sqlString, nil)
        return ok
    }

    func deleteMessages(byUserID userID: String?) -> Bool {
        let sqlString = String(format: SQL_DELETE_USER_MESSAGES, MESSAGE_TABLE_NAME, userID ?? "")
        let ok = excuteSQL(sqlString, nil)
        return ok
    }
    func p_createDBMessage(by retSet: FMResultSet?) -> WXMessage? {
        let type: TLMessageType? = retSet?.int(forColumn: "msg_type")
        let message = WXMessage.createMessage(by: type)
        message.messageID = retSet?.string(forColumn: "msgid")
        message.userID = retSet?.string(forColumn: "uid")
        message.partnerType = retSet?.int(forColumn: "partner_type")
        if message.partnerType == TLPartnerTypeGroup {
            message.groupID = retSet?.string(forColumn: "fid")
            message.friendID = retSet?.string(forColumn: "subfid")
        } else {
            message.friendID = retSet?.string(forColumn: "fid")
            message.groupID = retSet?.string(forColumn: "subfid")
        }
        let dateString = retSet?.string(forColumn: "date")
        message.date = Date(timeIntervalSince1970: TimeInterval(Double(dateString ?? "") ?? 0.0))
        message.ownerTyper = retSet?.int(forColumn: "own_type")
        if let aColumn = retSet?.int(forColumn: "msg_type") {
            message.messageType = aColumn
        }
        let content = retSet?.string(forColumn: "content")
        message.content = content?.mj_JSONObject()
        message.sendState = retSet?.int(forColumn: "send_status")
        message.readState = retSet?.int(forColumn: "received_status")
        return message
    }


    
}

class WXDBConversationStore: WXDBBaseStore {
    private var messageStore: WXDBMessageStore?

    init() {
        //if super.init()

        dbQueue = WXDBManager.sharedInstance().messageQueue
        let ok: Bool = createTable()
        if !ok {
            DLog("DB: 聊天记录表创建失败")
        }

    }

    func createTable() -> Bool {
        let sqlString = String(format: SQL_CREATE_CONV_TABLE, CONV_TABLE_NAME)
        return createTable(CONV_TABLE_NAME, withSQL: sqlString)
    }
    func addConversation(byUid uid: String?, fid: String?, type: Int, date: Date?) -> Bool {
        let unreadCount: Int = unreadMessage(byUid: uid, fid: fid) + 1
        let sqlString = String(format: SQL_ADD_CONV, CONV_TABLE_NAME)
        let arrPara = [uid, fid, type, String(format: "%lf", date?.timeIntervalSince1970 ?? 0.0), unreadCount, "", "", "", "", ""]
        let ok = excuteSQL(sqlString, withArrParameter: arrPara)
        return ok
    }
    func conversations(byUid uid: String?) -> [Any]? {
        var data: [AnyHashable] = []
        let sqlString = String(format: SQL_SELECT_CONVS, CONV_TABLE_NAME, uid ?? "")

        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet?.next() {
                let conversation = WXConversation()
                conversation.partnerID = retSet?.string(forColumn: "fid")
                conversation.convType = retSet?.int(forColumn: "conv_type")
                let dateString = retSet?.string(forColumn: "date")
                conversation.date = Date(timeIntervalSince1970: TimeInterval(Double(dateString ?? "") ?? 0.0))
                conversation.unreadCount = retSet?.int(forColumn: "unread_count")
                data.append(conversation)
            }
            retSet?.close()
        })

        // 获取conv对应的msg
        for conversation: WXConversation in data as? [WXConversation] ?? [] {
            let message: WXMessage? = messageStore.lastMessage(byUserID: uid, partnerID: conversation?.partnerID)
            if message != nil {
                conversation?.content = message?.conversationContent()
                conversation?.date = message?.date
            }
        }

        return data
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    //更新会话状态（已读）

    func updateConversation(byUid uid: String?, fid: String?) {
    }

    //查询所有会话
    func unreadMessage(byUid uid: String?, fid: String?) -> Int {
        var unreadCount: Int = 0
        let sqlString = String(format: SQL_SELECT_CONV_UNREAD, CONV_TABLE_NAME, uid ?? "", fid ?? "")
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            if retSet?.next() != nil {
                unreadCount = retSet?.int(forColumn: "unread_count") ?? 0
            }
            retSet?.close()
        })
        return unreadCount
    }

    //删除单条会话
    func deleteConversation(byUid uid: String?, fid: String?) -> Bool {
        let sqlString = String(format: SQL_DELETE_CONV, CONV_TABLE_NAME, uid ?? "", fid ?? "")
        let ok = excuteSQL(sqlString, nil)
        return ok
    }

    //删除用户的所有会话

    func deleteConversations(byUid uid: String?) -> Bool {
        let sqlString = String(format: SQL_DELETE_ALL_CONVS, CONV_TABLE_NAME, uid ?? "")
        let ok = excuteSQL(sqlString, nil)
        return ok
    }

    // MARK: - Getter -
    func messageStore() -> WXDBMessageStore? {
        if messageStore == nil {
            messageStore = WXDBMessageStore()
        }
        return messageStore
    }

    
    
}

class WXDBExpressionStore: WXDBBaseStore {
    init() {
        super.init()

        dbQueue = WXDBManager.sharedInstance().commonQueue
        let ok: Bool = createTable()
        if !ok {
            DLog("DB: 聊天记录表创建失败")
        }

    }

    func createTable() -> Bool {
        var sqlString = String(format: SQL_CREATE_EXP_GROUP_TABLE, EXP_GROUP_TABLE_NAME)
        var ok = createTable(EXP_GROUP_TABLE_NAME, withSQL: sqlString)
        if !ok {
            return false
        }
        sqlString = String(format: SQL_CREATE_EXPS_TABLE, EXPS_TABLE_NAME)
        ok = createTable(EXPS_TABLE_NAME, withSQL: sqlString)
        return ok
    }
    func addExpressionGroup(_ group: TLEmojiGroup?, forUid uid: String?) -> Bool {
        // 添加表情包
        let sqlString = String(format: SQL_ADD_EXP_GROUP, EXP_GROUP_TABLE_NAME)
        let arr = [uid, group?.groupID, group?.type ?? 0, (group?.groupName), (group?.groupInfo), (group?.groupDetailInfo), group?.count ?? 0, (group?.authID), (group?.authName), String(format: "%lf", group?.date.timeIntervalSince1970 ?? 0.0), "", "", "", "", ""]
        var ok = excuteSQL(sqlString, withArrParameter: arr)
        if !ok {
            return false
        }
        // 添加表情包里的所有表情
        ok = addExpressions(group?.data, toGroupID: group?.groupID)
        return ok
    }
    func expressionGroups(byUid uid: String?) -> [Any]? {
        var data: [AnyHashable] = []
        let sqlString = String(format: SQL_SELECT_EXP_GROUP, EXP_GROUP_TABLE_NAME, uid ?? "")

        // 读取表情包信息
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet?.next() {
                let group = TLEmojiGroup()
                group.groupID = retSet?.string(forColumn: "gid")
                group.type = retSet?.int(forColumn: "type")
                group.groupName = retSet?.string(forColumn: "name")
                group.groupInfo = retSet?.string(forColumn: "desc")
                group.groupDetailInfo = retSet?.string(forColumn: "detail")
                group.count = retSet?.int(forColumn: "count")
                group.authID = retSet?.string(forColumn: "auth_id")
                group.authName = retSet?.string(forColumn: "auth_name")
                group.status = TLEmojiGroupStatusDownloaded
                data.append(group)
            }
            retSet?.close()
        })

        // 读取表情包的所有表情信息
        for group: TLEmojiGroup in data as? [TLEmojiGroup] ?? [] {
            group.data = expressions(forGroupID: group.groupID)
        }

        return data
    }
    func deleteExpressionGroup(byID gid: String?, forUid uid: String?) -> Bool {
        let sqlString = String(format: SQL_DELETE_EXP_GROUP, EXP_GROUP_TABLE_NAME, uid ?? "", gid ?? "")
        return excuteSQL(sqlString, nil)
    }

    func countOfUserWhoHasExpressionGroup(_ gid: String?) -> Int {
        let sqlString = String(format: SQL_SELECT_COUNT_EXP_GROUP_USERS, EXP_GROUP_TABLE_NAME, gid ?? "")
        var count: Int = 0
        dbQueue.inDatabase({ db in
            count = db?.int(forQuery: sqlString) ?? 0
        })
        return count
    }

    // MARK: - 表情
    func addExpressions(_ expressions: [Any]?, toGroupID groupID: String?) -> Bool {
        for emoji: TLEmoji? in expressions as? [TLEmoji?] ?? [] {
            let sqlString = String(format: SQL_ADD_EXP, EXPS_TABLE_NAME)
            let arr = [groupID, emoji?.emojiID, (emoji?.emojiName), "", "", "", "", ""]
            let ok = excuteSQL(sqlString, withArrParameter: arr)
            if !ok {
                return false
            }
        }
        return true
    }
    func expressions(forGroupID groupID: String?) -> [AnyHashable]? {
        var data: [AnyHashable] = []
        let sqlString = String(format: SQL_SELECT_EXPS, EXPS_TABLE_NAME, groupID ?? "")

        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet?.next() {
                let emoji = TLEmoji()
                emoji.groupID = retSet?.string(forColumn: "gid")
                emoji.emojiID = retSet?.string(forColumn: "eid")
                emoji.emojiName = retSet?.string(forColumn: "name")
                data.append(emoji)
            }
            retSet?.close()
        })

        return data
    }



}

class WXDBFriendStore: WXDBBaseStore {
    init() {
        super.init()

        dbQueue = WXDBManager.sharedInstance().commonQueue
        let ok: Bool = createTable()
        if !ok {
            DLog("DB: 好友表创建失败")
        }

    }

    func createTable() -> Bool {
        let sqlString = String(format: SQL_CREATE_FRIENDS_TABLE, FRIENDS_TABLE_NAME)
        return createTable(FRIENDS_TABLE_NAME, withSQL: sqlString)
    }
    func addFriend(_ user: WXUser?, forUid uid: String?) -> Bool {
        let sqlString = String(format: SQL_UPDATE_FRIEND, FRIENDS_TABLE_NAME)
        let arrPara = [(uid), (user?.userID), (user?.username), (user?.nikeName), (user?.avatarURL), (user?.remarkName), "", "", "", "", ""]
        let ok = excuteSQL(sqlString, withArrParameter: arrPara)
        return ok
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func updateFriendsData(_ friendData: [Any]?, forUid uid: String?) -> Bool {
        let oldData = friendsData(byUid: uid)
        if oldData.count > 0 {
            // 建立新数据的hash表，用于删除数据库中的过时数据
            var newDataHash: [AnyHashable : Any] = [:]
            for user: WXUser? in friendData as? [WXUser?] ?? [] {
                if let anID = user?.userID {
                    newDataHash[anID] = "YES"
                }
            }
            for user: WXUser in oldData as? [WXUser] ?? [] {
                if newDataHash[user.userID] == nil {
                    let ok = deleteFriend(byFid: user.userID, forUid: uid)
                    if !ok {
                        DLog("DBError: 删除过期好友失败")
                    }
                }
            }
        }

        for user: WXUser? in friendData as? [WXUser?] ?? [] {
            let ok = addFriend(user, forUid: uid)
            if !ok {
                return ok
            }
        }

        return true
    }
    func friendsData(byUid uid: String?) -> [AnyHashable]? {
        var data: [AnyHashable] = []
        let sqlString = String(format: SQL_SELECT_FRIENDS, FRIENDS_TABLE_NAME, uid ?? "")

        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet?.next() {
                let user = WXUser()
                user.userID = retSet?.string(forColumn: "uid")
                user.username = retSet?.string(forColumn: "username")
                user.nikeName = retSet?.string(forColumn: "nikename")
                user.avatarURL = retSet?.string(forColumn: "avatar")
                user.remarkName = retSet?.string(forColumn: "remark")
                data.append(user)
            }
            retSet?.close()
        })

        return data
    }

    func deleteFriend(byFid fid: String?, forUid uid: String?) -> Bool {
        let sqlString = String(format: SQL_DELETE_FRIEND, FRIENDS_TABLE_NAME, uid ?? "", fid ?? "")
        let ok = excuteSQL(sqlString, nil)
        return ok
    }


    
}

class WXDBGroupStore: WXDBBaseStore {
    init() {
        super.init()

        dbQueue = WXDBManager.sharedInstance().commonQueue
        let ok: Bool = createTable()
        if !ok {
            DLog("DB: 讨论组表创建失败")
        }

    }

    func createTable() -> Bool {
        var sqlString = String(format: SQL_CREATE_GROUPS_TABLE, GROUPS_TABLE_NAME)
        var ok = createTable(GROUPS_TABLE_NAME, withSQL: sqlString)
        if ok {
            sqlString = String(format: SQL_CREATE_GROUP_MEMBERS_TABLE, GROUP_MEMBER_TABLE_NAMGE)
            ok = createTable(GROUP_MEMBER_TABLE_NAMGE, withSQL: sqlString)
        }
        return ok
    }
    func add(_ group: WXGroup?, forUid uid: String?) -> Bool {
        let sqlString = String(format: SQL_UPDATE_GROUP, GROUPS_TABLE_NAME)
        let arrPara = [(uid), (group?.groupID), (group?.groupName), "", "", "", "", ""]
        var ok = excuteSQL(sqlString, withArrParameter: arrPara)
        if ok {
            // 将通讯录成员插入数据库
            ok = addGroupMembers(group?.users, forUid: uid, andGid: group?.groupID)
        }
        return ok
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func updateGroupsData(_ groupData: [Any]?, forUid uid: String?) -> Bool {
        let oldData = groupsData(byUid: uid)
        if oldData.count > 0 {
            // 建立新数据的hash表，用于删除数据库中的过时数据
            var newDataHash: [AnyHashable : Any] = [:]
            for group: WXGroup? in groupData as? [WXGroup?] ?? [] {
                if let anID = group?.groupID {
                    newDataHash[anID] = "YES"
                }
            }
            for group: WXGroup in oldData as? [WXGroup] ?? [] {
                if newDataHash[group.groupID] == nil {
                    let ok = deleteGroup(byGid: group.groupID, forUid: uid)
                    if !ok {
                        DLog("DBError: 删除过期讨论组失败！")
                    }
                }
            }
        }

        // 将数据插入数据库
        for group: WXGroup? in groupData as? [WXGroup?] ?? [] {
            let ok = add(group, forUid: uid)
            if !ok {
                return ok
            }
        }

        return true
    }
    func groupsData(byUid uid: String?) -> [AnyHashable]? {
        var data: [AnyHashable] = []
        let sqlString = String(format: SQL_SELECT_GROUPS, GROUPS_TABLE_NAME, uid ?? "")

        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet?.next() {
                let group = WXGroup()
                group.groupID = retSet?.string(forColumn: "gid")
                group.groupName = retSet?.string(forColumn: "name")
                data.append(group)
            }
            retSet?.close()
        })

        // 获取讨论组成员
        for group: WXGroup in data as? [WXGroup] ?? [] {
            group.users = groupMembers(forUid: uid, andGid: group.groupID)
        }

        return data
    }
    func deleteGroup(byGid gid: String?, forUid uid: String?) -> Bool {
        let sqlString = String(format: SQL_DELETE_GROUP, GROUPS_TABLE_NAME, uid ?? "", gid ?? "")
        let ok = excuteSQL(sqlString, nil)
        return ok
    }

    // MARK: - Group Members
    func addGroupMember(_ user: WXUser?, forUid uid: String?, andGid gid: String?) -> Bool {
        let sqlString = String(format: SQL_UPDATE_GROUP_MEMBER, GROUP_MEMBER_TABLE_NAMGE)
        let arrPara = [(uid), (gid), (user?.userID), (user?.username), (user?.nikeName), (user?.avatarURL), (user?.remarkName), "", "", "", "", ""]
        let ok = excuteSQL(sqlString, withArrParameter: arrPara)
        return ok
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func addGroupMembers(_ users: [Any]?, forUid uid: String?, andGid gid: String?) -> Bool {
        let oldData = groupMembers(forUid: uid, andGid: gid)
        if oldData.count > 0 {
            // 建立新数据的hash表，用于删除数据库中的过时数据
            var newDataHash: [AnyHashable : Any] = [:]
            for user: WXUser? in users as? [WXUser?] ?? [] {
                if let anID = user?.userID {
                    newDataHash[anID] = "YES"
                }
            }
            for user: WXUser in oldData as? [WXUser] ?? [] {
                if newDataHash[user.userID] == nil {
                    let ok = deleteGroupMember(forUid: uid, gid: gid, andFid: user.userID)
                    if !ok {
                        DLog("DBError: 删除过期好友失败")
                    }
                }
            }
        }
        for user: WXUser? in users as? [WXUser?] ?? [] {
            let ok = addGroupMember(user, forUid: uid, andGid: gid)
            if !ok {
                return false
            }
        }
        return true
    }
    func groupMembers(forUid uid: String?, andGid gid: String?) -> [AnyHashable]? {
        var data: [AnyHashable] = []
        let sqlString = String(format: SQL_SELECT_GROUP_MEMBERS, GROUP_MEMBER_TABLE_NAMGE, uid ?? "")

        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet?.next() {
                let user = WXUser()
                user.userID = retSet?.string(forColumn: "uid")
                user.username = retSet?.string(forColumn: "username")
                user.nikeName = retSet?.string(forColumn: "nikename")
                user.avatarURL = retSet?.string(forColumn: "avatar")
                user.remarkName = retSet?.string(forColumn: "remark")
                data.append(user)
            }
            retSet?.close()
        })

        return data
    }
    func deleteGroupMember(forUid uid: String?, gid: String?, andFid fid: String?) -> Bool {
        let sqlString = String(format: SQL_DELETE_GROUP_MEMBER, GROUP_MEMBER_TABLE_NAMGE, uid ?? "", gid ?? "", fid ?? "")
        let ok = excuteSQL(sqlString, nil)
        return ok
    }


    
}
