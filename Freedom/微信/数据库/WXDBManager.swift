//
//  WXDBManager.swift
//  Freedom
import FMDB
import Foundation
let MESSAGE_TABLE_NAME = "message"
let SQL_CREATE_MESSAGE_TABLE = "CREATE TABLE IF NOT EXISTS %@(msgid TEXT,uid TEXT,fid TEXT,subfid TEXT,date TEXT,partner_type INTEGER DEFAULT (0),own_type INTEGER DEFAULT (0),msg_type INTEGER DEFAULT (0),content TEXT,send_status INTEGER DEFAULT (0),received_status BOOLEAN DEFAULT (0),ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, msgid, fid, subfid))"
let SQL_ADD_MESSAGE = "REPLACE INTO %@ ( msgid, uid, fid, subfid, date, partner_type, own_type, msg_type, content, send_status, received_status, ext1, ext2, ext3, ext4, ext5) VALUES ( , , , , , , , , , , , , , , , )"
let SQL_SELECT_MESSAGES_PAGE = "SELECT * FROM %@ WHERE uid = '%@' and fid = '%@' and date < '%@' order by date desc LIMIT '%ld'"
let SQL_SELECT_CHAT_FILES = "SELECT * FROM %@ WHERE uid = '%@' and fid = '%@' and msg_type = '2'"
let SQL_SELECT_CHAT_MEDIA = "SELECT * FROM %@ WHERE uid = '%@' and fid = '%@' and msg_type = '2'"
let SQL_SELECT_LAST_MESSAGE = "SELECT * FROM %@ WHERE date = ( SELECT MAX(date) FROM %@ WHERE uid = '%@' and fid = '%@' )"
let SQL_DELETE_MESSAGE = "DELETE FROM %@ WHERE msgid = '%@'"
let SQL_DELETE_FRIEND_MESSAGES = "DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"
let SQL_DELETE_USER_MESSAGES = "DELETE FROM %@ WHERE uid = '%@'"
let CONV_TABLE_NAME = "conversation"
let SQL_CREATE_CONV_TABLE = "CREATE TABLE IF NOT EXISTS %@(uid TEXT,fid TEXT,conv_type INTEGER DEFAULT (0),date TEXT,unread_count INTEGER DEFAULT (0),ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, fid))"
let SQL_ADD_CONV = "REPLACE INTO %@ ( uid, fid, conv_type, date, unread_count, ext1, ext2, ext3, ext4, ext5) VALUES ( , , , , , , , , , )"
let SQL_SELECT_CONVS = "SELECT * FROM %@ WHERE uid = %@ ORDER BY date DESC"
let SQL_SELECT_CONV_UNREAD = "SELECT unread_count FROM %@ WHERE uid = '%@' and fid = '%@'"
let SQL_DELETE_CONV = "DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"
let SQL_DELETE_ALL_CONVS = "DELETE FROM %@ WHERE uid = '%@'"
// MARK: - 表情组
let EXP_GROUP_TABLE_NAME = "expression_group"
let SQL_CREATE_EXP_GROUP_TABLE = "CREATE TABLE IF NOT EXISTS %@(uid TEXT,gid TEXT,type INTEGER DEFAULT (0),name TEXT,desc TEXT,detail TEXT,count INTEGER DEFAULT (0),auth_id TEXT,auth_name TEXT,date TEXT,ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, gid))"
let SQL_ADD_EXP_GROUP = "REPLACE INTO %@ ( uid, gid, type, name, desc, detail, count, auth_id, auth_name, date, ext1, ext2, ext3, ext4, ext5) VALUES ( , , , , , , , , , , , , , ,  )"
let SQL_SELECT_EXP_GROUP = "SELECT * FROM %@ WHERE uid = '%@'"
let SQL_DELETE_EXP_GROUP = "DELETE FROM %@ WHERE uid = '%@' and gid = '%@'"
let SQL_SELECT_COUNT_EXP_GROUP_USERS = "SELECT count(uid) FROM %@ WHERE gid = '%@'"
// MARK: -  表情
let EXPS_TABLE_NAME = "expressions"
let SQL_CREATE_EXPS_TABLE = "CREATE TABLE IF NOT EXISTS %@(gid TEXT,eid TEXT,name TEXT,ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(gid, eid))"
let SQL_ADD_EXP = "REPLACE INTO %@ ( gid, eid, name, ext1, ext2, ext3, ext4, ext5) VALUES ( , , , , , , ,  )"
let SQL_SELECT_EXPS = "SELECT * FROM %@ WHERE gid = '%@'"
let FRIENDS_TABLE_NAME = "friends"
let SQL_CREATE_FRIENDS_TABLE = "CREATE TABLE IF NOT EXISTS %@(uid TEXT,fid TEXT,username TEXT,nikename TEXT,avatar TEXT,remark TEXT,ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, fid))"
let SQL_UPDATE_FRIEND = "REPLACE INTO %@ ( uid, fid, username, nikename, avatar, remark, ext1, ext2, ext3, ext4, ext5) VALUES ( , , , , , , , , , , )"
let SQL_SELECT_FRIENDS = "SELECT * FROM %@ WHERE uid = %@"
let SQL_DELETE_FRIEND = "DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"
// MARK: - GROUPS
let GROUPS_TABLE_NAME = "groups"
let SQL_CREATE_GROUPS_TABLE = "CREATE TABLE IF NOT EXISTS %@(uid TEXT,gid TEXT,name TEXT,ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, gid))"
let SQL_UPDATE_GROUP = "REPLACE INTO %@ ( uid, gid, name, ext1, ext2, ext3, ext4, ext5) VALUES ( , , , , , , ,  )"
let SQL_SELECT_GROUPS = "SELECT * FROM %@ WHERE uid = %@"
let SQL_DELETE_GROUP = "DELETE FROM %@ WHERE uid = '%@' and gid = '%@'"
// MARK: - GROUP MEMBERS
let GROUP_MEMBER_TABLE_NAMGE = "group_members"
let SQL_CREATE_GROUP_MEMBERS_TABLE = "CREATE TABLE IF NOT EXISTS %@(uid TEXT,gid TEXT,fid TEXT,username TEXT,nikename TEXT,avatar TEXT,remark TEXT,ext1 TEXT,ext2 TEXT,ext3 TEXT,ext4 TEXT,ext5 TEXT,PRIMARY KEY(uid, gid, fid))"
let SQL_UPDATE_GROUP_MEMBER = "REPLACE INTO %@ ( uid, gid, fid, username, nikename, avatar, remark, ext1, ext2, ext3, ext4, ext5) VALUES ( , , , , , , , , , , , )"
let SQL_SELECT_GROUP_MEMBERS = "SELECT * FROM %@ WHERE uid = %@"
let SQL_DELETE_GROUP_MEMBER = "DELETE FROM %@ WHERE uid = '%@' and gid = '%@' and fid = '%@'"

class WXDBManager: NSObject {
    static let shared = WXDBManager(userID: WXUserHelper.shared.user.userID)
    var commonQueue = FMDatabaseQueue(path: FileManager.pathDBCommon())
    var messageQueue = FMDatabaseQueue(path: FileManager.pathDBMessage())
    convenience init(userID: String) {
        self.init()
    }
    override init() {
        super.init()
    }
}

class WXDBBaseStore: NSObject {
    /// 数据库操作队列(从TLDBManager中获取，默认使用commonQueue)
    var dbQueue: FMDatabaseQueue? = WXDBManager.shared.commonQueue
    override init() {
        super.init()
    }

    func createTable(_ tableName: String, withSQL sqlString: String) -> Bool {
        var ok = true
        dbQueue?.inDatabase({ db in
            if !db.tableExists(tableName) {
                ok = db.executeUpdate(sqlString, withArgumentsIn: [])
            }
        })
        return ok
    }

    func excuteSQL(_ sqlString: String, withArrParameter arrParameter: [Any]?) -> Bool {
        var ok = false
        dbQueue?.inDatabase({ db in
            ok = db.executeUpdate(sqlString, withArgumentsIn: arrParameter ?? [])
        })
        return ok
    }

    func excuteSQL(_ sqlString: String, withDicParameter dicParameter: [AnyHashable : Any]?) -> Bool {
        var ok = false
        dbQueue?.inDatabase({ db in
            ok = db.executeUpdate(sqlString, withParameterDictionary: dicParameter ?? [:])
        })
        return ok
    }

    func excuteSQL(_ sqlString: String) -> Bool {
        var ok = false
//        var args: va_list
//        var p_args: va_list
//        p_args = args
//        va_start(args, sqlString)
//        dbQueue.inDatabase({ db in
//            ok = db.executeUpdate(sqlString, withVAList: p_args)
//        })
//        va_end(args)
        return ok
    }
    func excuteQuerySQL(_ sqlStr: String, resultBlock: @escaping (_ rsSet: FMResultSet) -> Void) {
        dbQueue?.inDatabase({ db in
            let retSet: FMResultSet = db.executeQuery(sqlStr, withParameterDictionary: nil)!
            resultBlock(retSet)
        })
    }

}

class WXDBMessageStore: WXDBBaseStore {
    override init() {
        super.init()
        dbQueue = WXDBManager.shared.messageQueue
        let ok: Bool = createTable()
        if !ok {
            Dlog("DB: 聊天记录表创建失败")
        }
    }

    func createTable() -> Bool {
        let sqlString = String(format: SQL_CREATE_MESSAGE_TABLE, MESSAGE_TABLE_NAME)
        return createTable(MESSAGE_TABLE_NAME, withSQL: sqlString)
    }
    func add(_ message: WXMessage?) -> Bool {
        guard let message = message else {
            return false
        }
        var fid = ""
        var subfid: String = ""
        if message.partnerType == .user {
            fid = message.friendID
        } else {
            fid = message.groupID
            subfid = message.friendID
        }
        let sqlString = String(format: SQL_ADD_MESSAGE, MESSAGE_TABLE_NAME)
        let arrPara = [message.messageID, message.userID, fid,subfid, String(format: "%lf", message.date.timeIntervalSince1970), message.partnerType, message.ownerTyper, message.messageType, message.content.jsonString(), message.sendState, message.readState, "", "", "", "", ""] as [Any]
        let ok = excuteSQL(sqlString, withArrParameter: arrPara)
        return ok
    }

    func messages(byUserID userID: String, partnerID: String, from date: Date, count: Int, complete: @escaping ([WXMessage], Bool) -> Void) {
        var data: [WXMessage] = []
        let sqlString = String(format: SQL_SELECT_MESSAGES_PAGE, MESSAGE_TABLE_NAME, userID, partnerID, String(format: "%lf", date.timeIntervalSince1970), count + 1)
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet.next() {
                let message: WXMessage = self.p_createDBMessage(by: retSet)
                data.insert(message, at: 0)
            }
            retSet.close()
        })
        var hasMore = false
        if data.count == count + 1 {
            hasMore = true
            data.remove(at: 0)
        }
        complete(data, hasMore)
    }
    func chatFiles(byUserID userID: String, partnerID: String) -> [[WXMessage]] {
        var data: [[WXMessage]] = []
        let sqlString = String(format: SQL_SELECT_CHAT_FILES, MESSAGE_TABLE_NAME, userID, partnerID)
        var lastDate = Date()
        var array: [WXMessage] = []
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet.next() {
                let message: WXMessage = self.p_createDBMessage(by: retSet)
                if self.isToday(message.date) {
                    array.append(message)
                } else {
                    lastDate = message.date
                    if array.count > 0 {
                        data.append(array)
                    }
                    array = [message]
                }
            }
            if array.count > 0 {
                data.append(array)
            }
            retSet.close()
        })
        return data
    }
    func isToday(_ date: Date) -> Bool {
        let components1: DateComponents = date.components
        let components2: DateComponents = Date().components
        return (components1.year == components2.year) && (components1.month == components2.month) && (components1.day == components2.day)
    }

    func chatImagesAndVideos(byUserID userID: String, partnerID: String) -> [WXImageMessage] {
        var data: [WXImageMessage] = []
        let sqlString = String(format: SQL_SELECT_CHAT_MEDIA, MESSAGE_TABLE_NAME, userID, partnerID)
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet.next() {
                let message: WXImageMessage = self.p_createDBMessage(by: retSet) as! WXImageMessage
                data.append(message)
            }
            retSet.close()
        })
        return data
    }
    func lastMessage(byUserID userID: String, partnerID: String) -> WXMessage? {
        let sqlString = String(format: SQL_SELECT_LAST_MESSAGE, MESSAGE_TABLE_NAME, MESSAGE_TABLE_NAME, userID, partnerID)
        var message: WXMessage?
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet.next() {
                message = self.p_createDBMessage(by: retSet)
            }
            retSet.close()
        })
        return message
    }

    func deleteMessage(byMessageID messageID: String) -> Bool {
        let sqlString = String(format: SQL_DELETE_MESSAGE, MESSAGE_TABLE_NAME, messageID)
        let ok = excuteSQL(sqlString)
        return ok
    }
    func deleteMessages(byUserID userID: String, partnerID: String) -> Bool {
        let sqlString = String(format: SQL_DELETE_FRIEND_MESSAGES, MESSAGE_TABLE_NAME, userID, partnerID)
        let ok = excuteSQL(sqlString)
        return ok
    }

    func deleteMessages(byUserID userID: String) -> Bool {
        let sqlString = String(format: SQL_DELETE_USER_MESSAGES, MESSAGE_TABLE_NAME, userID)
        let ok = excuteSQL(sqlString)
        return ok
    }
    func p_createDBMessage(by retSet: FMResultSet) -> WXMessage {
        let type: TLMessageType = TLMessageType(rawValue: Int(retSet.int(forColumn: "msg_type"))) ?? .other
        let message = WXMessage.createMessage(by: type)
        message.messageID = retSet.string(forColumn: "msgid") ?? ""
        message.userID = retSet.string(forColumn: "uid") ?? ""
        message.partnerType = TLPartnerType(rawValue: Int(retSet.int(forColumn: "partner_type"))) ?? .group
        if message.partnerType == .group {
            message.groupID = retSet.string(forColumn: "fid") ?? ""
            message.friendID = retSet.string(forColumn: "subfid") ?? ""
        } else {
            message.friendID = retSet.string(forColumn: "fid") ?? ""
            message.groupID = retSet.string(forColumn: "subfid") ?? ""
        }
        let dateString = retSet.string(forColumn: "date") ?? ""
        message.date = Date(timeIntervalSince1970: TimeInterval(Double(dateString) ?? 0))
        message.ownerTyper = TLMessageOwnerType(rawValue: Int(retSet.int(forColumn: "own_type"))) ?? .own
        message.messageType = TLMessageType(rawValue: Int(retSet.int(forColumn: "msg_type"))) ?? TLMessageType.other
        let content = retSet.string(forColumn: "content")
        message.content = content?.mj_JSONObject() as! [String : String]
        message.sendState = TLMessageSendState(rawValue: Int(retSet.int(forColumn: "send_status"))) ?? .fail
        message.readState = TLMessageReadState(rawValue: Int(retSet.int(forColumn: "received_status"))) ?? .readed
        return message
    }
}

class WXDBConversationStore: WXDBBaseStore {
    private var messageStore = WXDBMessageStore()
    override init() {
        super.init()
        dbQueue = WXDBManager.shared.messageQueue
        let ok: Bool = createTable()
        if !ok {
            Dlog("DB: 聊天记录表创建失败")
        }
    }
    func createTable() -> Bool {
        let sqlString = String(format: SQL_CREATE_CONV_TABLE, CONV_TABLE_NAME)
        return createTable(CONV_TABLE_NAME, withSQL: sqlString)
    }
    func addConversation(byUid uid: String, fid: String, type: Int, date: Date) -> Bool {
        let unreadCount: Int = unreadMessage(byUid: uid, fid: fid) + 1
        let sqlString = String(format: SQL_ADD_CONV, CONV_TABLE_NAME)
        let arrPara = [uid, fid, type, String(format: "%lf", date.timeIntervalSince1970), unreadCount, "", "", "", "", ""] as [Any]
        let ok = excuteSQL(sqlString, withArrParameter: arrPara)
        return ok
    }
    func conversations(byUid uid: String) -> [WXConversation] {
        var data: [WXConversation] = []
        let sqlString = String(format: SQL_SELECT_CONVS, CONV_TABLE_NAME, uid)
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet.next() {
                let conversation = WXConversation()
                conversation.partnerID = retSet.string(forColumn: "fid") ?? ""
                conversation.convType = TLConversationType(rawValue: Int(retSet.int(forColumn: "conv_type"))) ?? TLConversationType.group
                let dateString = retSet.string(forColumn: "date") ?? ""
                conversation.date = Date(timeIntervalSince1970: TimeInterval(Double(dateString) ?? 0))
                conversation.unreadCount = Int(retSet.int(forColumn: "unread_count"))
                data.append(conversation)
            }
            retSet.close()
        })
        for conversation: WXConversation in data {
            let message = messageStore.lastMessage(byUserID: uid, partnerID: conversation.partnerID)
            if message != nil {
                conversation.content = message?.conversationContent() ?? ""
                conversation.date = message?.date ?? Date()
            }
        }
        return data
    }
    //更新会话状态（已读）
    func updateConversation(byUid uid: String, fid: String) {
    }

    //查询所有会话
    func unreadMessage(byUid uid: String, fid: String) -> Int {
        var unreadCount: Int = 0
        let sqlString = String(format: SQL_SELECT_CONV_UNREAD, CONV_TABLE_NAME, uid, fid)
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            if retSet.next() != nil {
                unreadCount = Int(retSet.int(forColumn: "unread_count"))
            }
            retSet.close()
        })
        return unreadCount
    }
    //删除单条会话
    func deleteConversation(byUid uid: String, fid: String) -> Bool {
        let sqlString = String(format: SQL_DELETE_CONV, CONV_TABLE_NAME, uid, fid)
        let ok = excuteSQL(sqlString)
        return ok
    }
    //删除用户的所有会话
    func deleteConversations(byUid uid: String) -> Bool {
        let sqlString = String(format: SQL_DELETE_ALL_CONVS, CONV_TABLE_NAME, uid)
        let ok = excuteSQL(sqlString)
        return ok
    }

}

class WXDBExpressionStore: WXDBBaseStore {
    override init() {
        super.init()
        dbQueue = WXDBManager.shared.commonQueue
        let ok: Bool = createTable()
        if !ok {
            Dlog("DB: 聊天记录表创建失败")
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
    func addExpressionGroup(_ group: TLEmojiGroup, forUid uid: String) -> Bool {
        // 添加表情包
        let sqlString = String(format: SQL_ADD_EXP_GROUP, EXP_GROUP_TABLE_NAME)
        let arr = [uid, group.groupID, group.type, (group.groupName), (group.groupInfo), (group.groupDetailInfo), group.count, (group.authID), (group.authName), String(format: "%lf", group.date.timeIntervalSince1970), "", "", "", "", ""] as [Any]
        var ok = excuteSQL(sqlString, withArrParameter: arr)
        if !ok {
            return false
        }
        // 添加表情包里的所有表情
        ok = addExpressions(group.data as! [TLEmoji], toGroupID: group.groupID)
        return ok
    }
    func expressionGroups(byUid uid: String) -> [TLEmojiGroup] {
        var data: [TLEmojiGroup] = []
        let sqlString = String(format: SQL_SELECT_EXP_GROUP, EXP_GROUP_TABLE_NAME, uid)

        // 读取表情包信息
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet.next() {
                let group = TLEmojiGroup()
                group.groupID = retSet.string(forColumn: "gid") ?? ""
                group.type = TLEmojiType(rawValue: Int(retSet.int(forColumn: "type"))) ?? TLEmojiType.emoji
                group.groupName = retSet.string(forColumn: "name") ?? ""
                group.groupInfo = retSet.string(forColumn: "desc") ?? ""
                group.groupDetailInfo = retSet.string(forColumn: "detail") ?? ""
                group.count = Int(retSet.int(forColumn: "count") ?? 0)
                group.authID = retSet.string(forColumn: "auth_id") ?? ""
                group.authName = retSet.string(forColumn: "auth_name") ?? ""
                group.status = .downloaded
                data.append(group)
            }
            retSet.close()
        })
        // 读取表情包的所有表情信息
        for group: TLEmojiGroup in data {
            group.data = expressions(forGroupID: group.groupID)
        }
        return data
    }
    func deleteExpressionGroup(byID gid: String, forUid uid: String) -> Bool {
        let sqlString = String(format: SQL_DELETE_EXP_GROUP, EXP_GROUP_TABLE_NAME, uid, gid)
        return excuteSQL(sqlString)
    }

    func countOfUserWhoHasExpressionGroup(_ gid: String) -> Int {
        let sqlString = String(format: SQL_SELECT_COUNT_EXP_GROUP_USERS, EXP_GROUP_TABLE_NAME, gid)
        var count: Int = 0
        dbQueue?.inDatabase({ db in
//            count = db.executeQuery(sqlString, withArgumentsIn: [])
        })
        return count
    }
    // MARK: - 表情
    func addExpressions(_ expressions: [TLEmoji], toGroupID groupID: String) -> Bool {
        for emoji: TLEmoji in expressions {
            let sqlString = String(format: SQL_ADD_EXP, EXPS_TABLE_NAME)
            let arr = [groupID, emoji.emojiID, (emoji.emojiName), "", "", "", "", ""]
            let ok = excuteSQL(sqlString, withArrParameter: arr)
            if !ok {
                return false
            }
        }
        return true
    }
    func expressions(forGroupID groupID: String) -> [TLEmoji] {
        var data: [TLEmoji] = []
        let sqlString = String(format: SQL_SELECT_EXPS, EXPS_TABLE_NAME, groupID)
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet.next() {
                let emoji = TLEmoji()
                emoji.groupID = retSet.string(forColumn: "gid") ?? ""
                emoji.emojiID = retSet.string(forColumn: "eid") ?? ""
                emoji.emojiName = retSet.string(forColumn: "name") ?? ""
                data.append(emoji)
            }
            retSet.close()
        })
        return data
    }
}

class WXDBFriendStore: WXDBBaseStore {
    override init() {
        super.init()
        dbQueue = WXDBManager.shared.commonQueue
        let ok: Bool = createTable()
        if !ok {
            Dlog("DB: 好友表创建失败")
        }

    }

    func createTable() -> Bool {
        let sqlString = String(format: SQL_CREATE_FRIENDS_TABLE, FRIENDS_TABLE_NAME)
        return createTable(FRIENDS_TABLE_NAME, withSQL: sqlString)
    }
    func addFriend(_ user: WXUser, forUid uid: String) -> Bool {
        let sqlString = String(format: SQL_UPDATE_FRIEND, FRIENDS_TABLE_NAME)
        let arrPara = [(uid), (user.userID), (user.username), (user.nikeName), (user.avatarURL), (user.remarkName), "", "", "", "", ""]
        let ok = excuteSQL(sqlString, withArrParameter: arrPara)
        return ok
    }

    func updateFriendsData(_ friendData: [WXUser], forUid uid: String) -> Bool {
        let oldData = friendsData(byUid: uid)
        if oldData.count > 0 {
            var newDataHash: [AnyHashable : Any] = [:]
            for user: WXUser in friendData {
                newDataHash[user.userID] = "YES"
            }
            for user: WXUser in oldData {
                if newDataHash[user.userID] == nil {
                    let ok = deleteFriend(byFid: user.userID, forUid: uid)
                    if !ok {
                        Dlog("DBError: 删除过期好友失败")
                    }
                }
            }
        }
        for user: WXUser in friendData {
            let ok = addFriend(user, forUid: uid)
            if !ok {
                return ok
            }
        }
        return true
    }
    func friendsData(byUid uid: String) -> [WXUser] {
        var data: [WXUser] = []
        let sqlString = String(format: SQL_SELECT_FRIENDS, FRIENDS_TABLE_NAME, uid)
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet.next() {
                let user = WXUser()
                user.userID = retSet.string(forColumn: "uid") ?? ""
                user.username = retSet.string(forColumn: "username") ?? ""
                user.nikeName = retSet.string(forColumn: "nikename") ?? ""
                user.avatarURL = retSet.string(forColumn: "avatar") ?? ""
                user.remarkName = retSet.string(forColumn: "remark") ?? ""
                data.append(user)
            }
            retSet.close()
        })
        return data
    }

    func deleteFriend(byFid fid: String, forUid uid: String) -> Bool {
        let sqlString = String(format: SQL_DELETE_FRIEND, FRIENDS_TABLE_NAME, uid, fid)
        let ok = excuteSQL(sqlString)
        return ok
    }
}

class WXDBGroupStore: WXDBBaseStore {
    override init() {
        super.init()
        dbQueue = WXDBManager.shared.commonQueue
        let ok: Bool = createTable()
        if !ok {
            Dlog("DB: 讨论组表创建失败")
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
    func add(_ group: WXGroup, forUid uid: String) -> Bool {
        let sqlString = String(format: SQL_UPDATE_GROUP, GROUPS_TABLE_NAME)
        let arrPara = [(uid), (group.groupID), (group.groupName), "", "", "", "", ""]
        var ok = excuteSQL(sqlString, withArrParameter: arrPara)
        if ok {
            ok = addGroupMembers(group.users, forUid: uid, andGid: group.groupID)
        }
        return ok
    }

    func updateGroupsData(_ groupData: [WXGroup], forUid uid: String) -> Bool {
        let oldData = groupsData(byUid: uid)
        if oldData.count > 0 {
            var newDataHash: [String : Any] = [:]
            for group: WXGroup in groupData {
                newDataHash[group.groupID] = "YES"
            }
            for group: WXGroup in oldData {
                if newDataHash[group.groupID] == nil {
                    let ok = deleteGroup(byGid: group.groupID, forUid: uid)
                    if !ok {
                        Dlog("DBError: 删除过期讨论组失败！")
                    }
                }
            }
        }
        // 将数据插入数据库
        for group: WXGroup in groupData {
            let ok = add(group, forUid: uid)
            if !ok {
                return ok
            }
        }

        return true
    }
    func groupsData(byUid uid: String) -> [WXGroup] {
        var data: [WXGroup] = []
        let sqlString = String(format: SQL_SELECT_GROUPS, GROUPS_TABLE_NAME, uid)
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet.next() {
                let group = WXGroup()
                group.groupID = retSet.string(forColumn: "gid") ?? ""
                group.groupName = retSet.string(forColumn: "name") ?? ""
                data.append(group)
            }
            retSet.close()
        })
        // 获取讨论组成员
        for group: WXGroup in data {
            group.users = groupMembers(forUid: uid, andGid: group.groupID)
        }
        return data
    }
    func deleteGroup(byGid gid: String, forUid uid: String) -> Bool {
        let sqlString = String(format: SQL_DELETE_GROUP, GROUPS_TABLE_NAME, uid, gid)
        let ok = excuteSQL(sqlString)
        return ok
    }

    // MARK: - Group Members
    func addGroupMember(_ user: WXUser, forUid uid: String, andGid gid: String) -> Bool {
        let sqlString = String(format: SQL_UPDATE_GROUP_MEMBER, GROUP_MEMBER_TABLE_NAMGE)
        let arrPara = [(uid), (gid), (user.userID), (user.username), (user.nikeName), (user.avatarURL), (user.remarkName), "", "", "", "", ""]
        let ok = excuteSQL(sqlString, withArrParameter: arrPara)
        return ok
    }

    func addGroupMembers(_ users: [WXUser], forUid uid: String, andGid gid: String) -> Bool {
        let oldData = groupMembers(forUid: uid, andGid: gid)
        if oldData.count > 0 {
            // 建立新数据的hash表，用于删除数据库中的过时数据
            var newDataHash: [String : Any] = [:]
            for user: WXUser in users {
                newDataHash[user.userID] = "YES"
            }
            for user: WXUser in oldData {
                if newDataHash[user.userID] == nil {
                    let ok = deleteGroupMember(forUid: uid, gid: gid, andFid: user.userID)
                    if !ok {
                        Dlog("DBError: 删除过期好友失败")
                    }
                }
            }
        }
        for user: WXUser in users{
            let ok = addGroupMember(user, forUid: uid, andGid: gid)
            if !ok {
                return false
            }
        }
        return true
    }
    func groupMembers(forUid uid: String, andGid gid: String) -> [WXUser] {
        var data: [WXUser] = []
        let sqlString = String(format: SQL_SELECT_GROUP_MEMBERS, GROUP_MEMBER_TABLE_NAMGE, uid)
        excuteQuerySQL(sqlString, resultBlock: { retSet in
            while retSet.next() {
                let user = WXUser()
                user.userID = retSet.string(forColumn: "uid") ?? ""
                user.username = retSet.string(forColumn: "username") ?? ""
                user.nikeName = retSet.string(forColumn: "nikename") ?? ""
                user.avatarURL = retSet.string(forColumn: "avatar") ?? ""
                user.remarkName = retSet.string(forColumn: "remark") ?? ""
                data.append(user)
            }
            retSet.close()
        })
        return data
    }
    func deleteGroupMember(forUid uid: String, gid: String, andFid fid: String) -> Bool {
        let sqlString = String(format: SQL_DELETE_GROUP_MEMBER, GROUP_MEMBER_TABLE_NAMGE, uid, gid, fid)
        let ok = excuteSQL(sqlString)
        return ok
    }
}
