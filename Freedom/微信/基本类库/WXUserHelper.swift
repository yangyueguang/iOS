//
//  WXUserHelper.swift
//  Freedom
import RealmSwift
import Realm
import Foundation
import Contacts
import XExtension
class WXFriendHelper: NSObject {
    static let shared = WXFriendHelper()
    lazy var defaultGroup: WXUserGroup = {
        let item_new = WXUser()
        item_new.userID = "-1"
        item_new.avatarPath = WXImage.addFriend.rawValue
        item_new.remarkName = "新的朋友"
        let item_group = WXUser()
        item_group.userID = "-2"
        item_group.avatarPath = "add_friend_icon_addgroup"
        item_group.remarkName = "群聊"
        let item_tag = WXUser()
        item_tag.userID = "-3"
        item_tag.avatarPath = "Contact_icon_ContactTag"
        item_tag.remarkName = "标签"
        let item_public = WXUser()
        item_public.userID = "-4"
        item_public.avatarPath = "add_friend_icon_offical"
        item_public.remarkName = "公共号"

        let defaultGroup = WXUserGroup()
        defaultGroup.groupName = ""
        defaultGroup.users.addObjects([item_new, item_group, item_tag, item_public] as NSFastEnumeration)
        return defaultGroup
    }()
    var friendsData: [WXUser] = []
    var data: [WXUserGroup] = []
    var sectionHeaders: [String] = []
    var friendCount: Int {
        return friendsData.count
    }
    var dataChangedBlock: ((_ friends: [WXUserGroup], _ headers: [String], _ friendCount: Int) -> Void)?
    var groupsData: [WXGroup] = []
    var tagsData: [WXUserGroup] = []
    override init() {
        super.init()
        let pre = NSPredicate(format: "userID = %@", WXUserHelper.shared.user.userID)
        try! realmWX.transaction {
            let results = WXUser.objects(in: realmWX, with: pre)
            for index in 0..<results.count {
                friendsData.append(results.object(at: index) as! WXUser)
            }
        }
        data = [defaultGroup]
        sectionHeaders = [UITableView.indexSearch]
        let results = WXGroup.allObjects(in: realmWX)
        groupsData = results.array().compactMap{ $0 as? WXGroup }
        p_initTestData()
    }

    func p_resetFriendData() {
        let serializeArray: [WXUser] = friendsData.sorted { (a, b) -> Bool in
            return a.nikeName > b.nikeName
        }
        var ansData = [defaultGroup]
        var ansSectionHeaders = [UITableView.indexSearch]
        var tagsDic: [String : WXUserGroup] = [:]
        var lastC = "1"
        var curGroup = WXUserGroup()
        let othGroup = WXUserGroup()
        othGroup.groupName = "#"
        for user in serializeArray {
            if user.nikeName.pinyin().isEmpty {
                othGroup.users.add(user)
                continue
            }
            let c = user.nikeName.firstLetter()
            if c.isEmpty {
                othGroup.users.add(user)
            } else if c != lastC {
                if curGroup.users.count > 0 {
                    ansData.append(curGroup)
                    ansSectionHeaders.append(curGroup.groupName)
                }
                lastC = c
                curGroup = WXUserGroup()
                curGroup.groupName = "\(c)"
                curGroup.users.add(user)
            } else {
                curGroup.users.add(user)
            }
            if user.detailInfo.tags.count > 0 {
                for tag in user.detailInfo.tags.array() {
                    let tag = tag as! String
                    if let group = tagsDic[tag] {
                        group.users.add(user)
                    }else{
                        let group = WXUserGroup()
                        group.groupName = tag
                        tagsDic[tag] = group
                        tagsData.append(group)
                    }
                }
            }
        }
        if curGroup.users.count > 0 {
            ansData.append(curGroup)
            ansSectionHeaders.append(curGroup.groupName)
        }
        if othGroup.users.count > 0 {
            ansData.append(othGroup)
            ansSectionHeaders.append(othGroup.groupName)
        }
        data.removeAll()
        data.append(contentsOf: ansData)
        sectionHeaders.removeAll()
        sectionHeaders.append(contentsOf: ansSectionHeaders)
        DispatchQueue.main.async(execute: {
            self.dataChangedBlock?(self.data, self.sectionHeaders, self.friendCount)
        })
    }
    func p_initTestData() {
        var jsonArray = FileManager.readJson2Array(fileName: "FriendList")
        try! realmWX.transaction {
            for dict in jsonArray {
                WXUser.createOrUpdate(in: realmWX, withValue: dict)
            }
        }
        let arr = WXUser.allObjects(in: realmWX).array()
        friendsData.removeAll()
        friendsData.append(contentsOf: arr as! [WXUser])
        self.p_resetFriendData()
        jsonArray = FileManager.readJson2Array(fileName: "FriendGroupList")
        try! realmWX.transaction {
            for dict in jsonArray {
                let group = WXGroup.createOrUpdate(in: realmWX, withValue: dict)
                realmWX.addOrUpdate(group)
            }
        }
        groupsData = WXGroup.allObjects(in: realmWX).array().compactMap{ $0 as? WXGroup }
        for group in groupsData {
            createGroupAvatar(group, finished: { _ in
            })
        }
    }
    func createGroupAvatar(_ group: WXGroup, finished: @escaping (_ groupID: String) -> Void) {
        DispatchQueue.main.async {
            print(group.groupID)
            let usersCount: Int = group.users.count > 9 ? 9 : Int(group.users.count) 
            let viewWidth: CGFloat = 200
            let width: CGFloat = viewWidth / 3 * 0.85
            let space3: CGFloat = (viewWidth - width * 3) / 4
            let space2: CGFloat = (viewWidth - width * 2 + space3) / 2
            let space1: CGFloat = (viewWidth - width) / 2
            var y: CGFloat = (usersCount) > 6 ? space3 : ((usersCount) > 3 ? space2 : space1)
            var x: CGFloat = (usersCount) % 3 == 0 ? space3 : ((usersCount) % 3 == 2 ? space2 : space1)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth))
            view.backgroundColor = UIColor(white: 0.8, alpha: 0.6)
            var count: Int = 0 // 下载完成图片计数器
            var i = usersCount - 1
            while i >= 0 {
                let user: WXUser = group.users[UInt(i)]
                let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: width))
                view.addSubview(imageView)
                imageView.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: Image.logo.image, completed: { image, error, cacheType, imageURL in
                    count += 1
                    if count == usersCount {
                        // 图片全部下载完成
                        UIGraphicsBeginImageContextWithOptions(view.frame.size, _: false, _: 2.0)
                        if let aContext = UIGraphicsGetCurrentContext() {
                            view.layer.render(in: aContext)
                        }
                        let image = UIGraphicsGetImageFromCurrentImageContext()!
                        UIGraphicsEndImageContext()
                        let imageRef = image.cgImage
                        let imageRefRect = imageRef?.cropping(to: CGRect(x: 0, y: 0, width: view.frame.size.width * 2, height: view.frame.size.height * 2))!
                        let ansImage = UIImage(cgImage: imageRefRect!)
                        let imageViewData = ansImage.pngData()
                        let savedImagePath = FileManager.pathUserAvatar(group.groupID)
                        try! imageViewData?.write(to: URL(fileURLWithPath: savedImagePath), options: Data.WritingOptions.atomic)
                        DispatchQueue.main.async(execute: {
                            finished(group.groupID)
                        })
                    }
                })
                if i % 3 == 0 {
                    y += width + space3
                    x = space3
                } else if i == 2 && usersCount == 3 {
                    y += width + space3
                    x = space2
                } else {
                    x += width + space3
                }
                i -= 1
            }
        }
    }

    func friendDetailArray(byUserInfo userInfo: WXUser) -> [[WXInfo]] {
        var data: [[WXInfo]] = []
        var arr: [WXInfo] = []
        let user: WXInfo = WXInfo.createInfo("个人", nil)
        user.type = Int32(TLInfoType.other.rawValue)
//        user.userInfo = userInfo
        arr.append(user)
        data.append(arr)
        arr = []
        if userInfo.detailInfo.phoneNumber.count > 0 {
            let tel: WXInfo = WXInfo.createInfo("电话号码", userInfo.detailInfo.phoneNumber)
            tel.showDisclosureIndicator = false
            arr.append(tel)
        }
        if userInfo.detailInfo.tags.count == 0 {
            let remark: WXInfo = WXInfo.createInfo("设置备注和标签", nil)
            arr.insert(remark, at: 0)
        } else {
            let str = ""//userInfo.detailInfo.tags?.joined(separator: ",")
            let remark: WXInfo = WXInfo.createInfo("标签", str)
            arr.append(remark)
        }
        data.append(arr)
        arr = []
        if userInfo.detailInfo.location.count > 0 {
            let location: WXInfo = WXInfo.createInfo("地区", userInfo.detailInfo.location)
            location.showDisclosureIndicator = false
            location.disableHighlight = true
            arr.append(location)
        }
        let album: WXInfo = WXInfo.createInfo("个人相册", nil)
        album.userInfo = userInfo.detailInfo.albumArray
        album.type = Int32(TLInfoType.other.rawValue)
        arr.append(album)
        let more: WXInfo = WXInfo.createInfo("更多", nil)
        arr.append(more)
        data.append(arr)
        arr = []
        let sendMsg: WXInfo = WXInfo.createInfo("发消息", nil)
        sendMsg.type = Int32(TLInfoType.button.rawValue)
        arr.append(sendMsg)
        if !(userInfo.userID == WXUserHelper.shared.user.userID) {
            let video: WXInfo = WXInfo.createInfo("视频聊天", nil)
            video.type = Int32(TLInfoType.button.rawValue)
            arr.append(video)
        }
        data.append(arr)
        return data
    }
    func friendDetailSettingArray(byUserInfo userInfo: WXUser) -> [WXSettingGroup] {
        let remark = WXSettingItem("设置备注及标签")
        if userInfo.remarkName.count > 0 {
            remark.subTitle = userInfo.remarkName
        }
        let group1: WXSettingGroup = WXSettingGroup(nil, nil, [remark])
        let recommand = WXSettingItem("把他推荐给朋友")
        let group2: WXSettingGroup = WXSettingGroup(nil, nil, [recommand])
        let starFriend = WXSettingItem("设为星标朋友")
        starFriend.type = .switchBtn
        let group3: WXSettingGroup = WXSettingGroup(nil, nil, [starFriend])
        let prohibit = WXSettingItem("不让他看我的朋友圈")
        prohibit.type = .switchBtn
        let dismiss = WXSettingItem("不看他的朋友圈")
        dismiss.type = .switchBtn
        let group4: WXSettingGroup = WXSettingGroup(nil, nil, ([prohibit, dismiss]))
        let blackList = WXSettingItem("加入黑名单")
        blackList.type = .switchBtn
        let report = WXSettingItem("举报")
        let group5: WXSettingGroup = WXSettingGroup(nil, nil, ([blackList, report]))
        return [group1, group2, group3, group4, group5]
    }
    class func gotNextEvent(withWechatContacts data: [WechatContact], success: @escaping (_ data: [WechatContact], _ formatData: [WXUserGroup], _ headers: [String]) -> Void) {
        let serializeArray:[WechatContact] = data
        var data: [WXUserGroup] = []
        var headers = [UITableView.indexSearch]
        var lastC = "1"
        var curGroup = WXUserGroup()
        let othGroup = WXUserGroup()
        othGroup.groupName = "#"
        for contact in serializeArray {
            let user = WXUser()
            user.userID = contact.tel
            user.username = contact.name
            user.avatarPath = contact.avatarPath
            // 获取拼音失败
            if user.username.pinyin().isEmpty {
                othGroup.users.add(user)
                continue
            }
            if user.username.firstLetter().isEmpty {
                // #组
                othGroup.users.add(user)
            } else if user.username.firstLetter() != lastC {
                if curGroup.users.count > 0 {
                    data.append(curGroup)
                    headers.append(curGroup.groupName)
                    lastC = user.username.firstLetter()
                    curGroup = WXUserGroup()
                    curGroup.groupName = lastC
                    curGroup.users.add(user)
                } else {
                    curGroup.users.add(user)
                }
            }
            if curGroup.users.count > 0 {
                data.append(curGroup)
                headers.append(curGroup.groupName)
            }
            if othGroup.users.count > 0 {
                data.append(othGroup)
                headers.append(othGroup.groupName)
            }
            DispatchQueue.main.async(execute: {
                success(serializeArray, data, headers)
            })
        }
    }
    class func trytoGetAllContacts(success: @escaping (_ data: [WechatContact], _ formatData: [WXUserGroup], _ headers: [String]) -> Void, failed: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async(execute: {
            // 3、加载缓存
            let path = FileManager.pathContactsData()
            let dic = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [AnyHashable : Any]
            let data = dic["data"] as! [WechatContact]
            let formatData = dic["formatData"] as! [WXUserGroup]
            let headers = dic["headers"] as! [String]
            DispatchQueue.main.async(execute: {
                success(data, formatData, headers)
            })
            let status: CNAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
            if status != .authorized {
                return
            }
            let contactStore = CNContactStore()
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            try! contactStore.enumerateContacts(with: request, usingBlock: { contact,stop in
                let con = WechatContact()
                let lastname = contact.familyName
                let firstname = contact.givenName
                let phoneNums = contact.phoneNumbers
                for labeledValue: CNLabeledValue in phoneNums {
                    let phoneLabel = labeledValue.label
                    let phoneNumer = labeledValue.value as CNPhoneNumber
                    let phoneValue = phoneNumer.stringValue
                    print("\(String(describing: phoneLabel)) \(phoneValue)")
                    con.tel = phoneValue
                }
                let emails = contact.emailAddresses
                for labeldValue: CNLabeledValue in emails {
                    let email = labeldValue.label
//                    con.email = "\(String(describing: email))\(labeldValue.value)"
                }
                con.name = "\(lastname) \(firstname)"
//                con.recordID = contact.identifier
                let imageData = contact.imageData
                let imageName = String(format: "%.0lf.jpg", Date().timeIntervalSince1970 * 10000)
                let imagePath = FileManager.pathContactsAvatar(imageName)
                try! imageData?.write(to: URL(fileURLWithPath: imagePath))
                con.avatarPath = imageName
//                if stop {
                    self.gotNextEvent(withWechatContacts: data, success: success)
//                }
            })
            })
    }
}
class WXUserHelper: NSObject {
    static let shared = WXUserHelper()
    lazy var user: WXUser = {
        let user = WXUser()
        user.userID = "1" //我的二维码数据
        user.avatarURL = "https://p1.ssl.qhmsg.com/dm/110_110_100/t01fffa4efd00af1898.jpg"
        user.nikeName = "Super"
        user.username = "2829969299"
        user.detailInfo.qqNumber = "2829969299"
        user.detailInfo.email = "2829969299@qq.com"
        user.detailInfo.location = "上海市 浦东新区"
        user.detailInfo.sex = "男"
        user.detailInfo.motto = "失败与挫折相伴，成功与掌声共存!"
        user.detailInfo.momentsWallURL = "https://p1.ssl.qhmsg.com/dm/110_110_100/t01fffa4efd00af1898.jpg"
        return user
    }()
    private lazy var systemEmojiGroups: [TLEmojiGroup] = {
        let editGroup = TLEmojiGroup()
        editGroup.type = .other
        return [editGroup]
    }()
    private var complete: (([TLEmojiGroup]) -> Void)?
    override init() {
        super.init()
    }
    func updateEmojiGroupData() {
        if !user.userID.isEmpty {
            emojiGroupDataComplete(complete!)
        }
    }
    func emojiGroupDataComplete(_ complete: @escaping ([TLEmojiGroup]) -> Void) {
        self.complete = complete
        var emojiGroupData: [TLEmojiGroup] = []
        let defaultEmojiGroups = [WXExpressionHelper.shared.defaultFaceGroup, WXExpressionHelper.shared.defaultSystemEmojiGroup]
        emojiGroupData.append(contentsOf: defaultEmojiGroups)
        let preferEmojiGroup: TLEmojiGroup = WXExpressionHelper.shared.userPreferEmojiGroup
        if preferEmojiGroup.count > 0 {
            emojiGroupData.append(preferEmojiGroup)
        }
        let userGroups = WXExpressionHelper.shared.userEmojiGroups
        if userGroups.count > 0 {
            emojiGroupData.append(contentsOf:userGroups)
        }
        emojiGroupData.append(contentsOf:self.systemEmojiGroups)
        complete(emojiGroupData)
    }


    func messages(byUserID userID: String, partnerID: String, from date: Date, count: Int, complete: @escaping ([WXMessage], Bool) -> Void) {
        var data: [WXMessage] = []
        let pre = NSPredicate(format: "userID = %@", userID)
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
                if message.date.distanceWithDate(Date()).day ?? 0 < 1 {
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

    func addConversation(byUid uid: String, fid: String, type: Int, date: Date) {
        realmWX.write {
            let conversation = WXConversation()
            conversation.partnerID = fid
            let pre = NSPredicate(format: "partnerID = %@", fid)
            conversation.unreadCount = Int(WXConversation.objects(in: realmWX, with: pre).count) + 1
            conversation.convType = TLConversationType.personal
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
                let pre = NSPredicate(format: "userID = %@ and friendID = %@", uid, conversation.partnerID ?? "")
                let message = WXMessage.objects(in: realmWX, with: pre).lastObject() as? WXMessage
                if message != nil {
                    conversation.content = message?.conversationContent() ?? ""
                    conversation.date = message?.date ?? Date()
                }
                data.append(conversation)
            }
        }
        return data
    }
}
//FIXME: 表情数据管理类
class WXExpressionHelper: NSObject {/// 默认表情（Face）
    static let shared = WXExpressionHelper()
    lazy var defaultFaceGroup: TLEmojiGroup = {
        let defaultFaceGroup = TLEmojiGroup()
        defaultFaceGroup.type = .face
        let path = Bundle.main.path(forResource: "FaceEmoji", ofType: "json")
        let data = try? NSData(contentsOfFile: path ?? "")
        //        defaultFaceGroup.data = TLEmoji.parses(data) as! [TLEmoji]
        return defaultFaceGroup
    }()
    lazy var defaultSystemEmojiGroup: TLEmojiGroup = {
        let defaultSystemEmojiGroup = TLEmojiGroup()
        defaultSystemEmojiGroup.type = .emoji
        let path = Bundle.main.path(forResource: "SystemEmoji", ofType: "json")
        let data = try! NSData(contentsOfFile: path ?? "")
        //        defaultSystemEmojiGroup.data = TLEmoji.mj_objectArray(withKeyValuesArray: data)
        return defaultSystemEmojiGroup
    }()
    var userEmojiGroups: [TLEmojiGroup] {
        return WXExpressionHelper.shared.expressionGroups(byUid: WXUserHelper.shared.user.userID)
    }
    var userPreferEmojiGroup = TLEmojiGroup()
 
    func addExpressionGroup(_ emojiGroup: TLEmojiGroup) {
        try! realmWX.transaction {
            realmWX.addOrUpdate(emojiGroup)
        }
        try! realmWX.transaction {
            realmWX.addObjects(emojiGroup.data.array() as NSFastEnumeration)
        }
        WXUserHelper.shared.updateEmojiGroupData()
    }
    func deleteExpressionGroup(byID groupID: String) {
        try! realmWX.transaction {
            let pre = NSPredicate(format: "groupID = %@", groupID)
            let results = TLEmojiGroup.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }

        WXUserHelper.shared.updateEmojiGroupData()
    }
    func didExpressionGroupAlways(inUsed groupID: String) -> Bool {
        let pre = NSPredicate(format: "groupID = %@", groupID)
        let results = TLEmojiGroup.objects(in: realmWX, with: pre)
        return Int(results.count) > 0
    }
    func emojiGroup(byID groupID: String) -> TLEmojiGroup? {
        for group: TLEmojiGroup in userEmojiGroups {
            if (group.groupID == groupID) {
                return group
            }
        }
        return nil
    }

    func myExpressionListData() -> [TLEmojiGroup] {
        var data: [TLEmojiGroup] = []
        var myEmojiGroups = WXExpressionHelper.shared.expressionGroups(byUid: WXUserHelper.shared.user.userID)
        if (myEmojiGroups.count) > 0 {
//            let group1 = WXSettingGroup("聊天面板中的表情", nil, myEmojiGroups)
//            data.append(group1)
        }
        let userEmojis = WXSettingItem("添加的表情")
        let buyedEmojis = WXSettingItem("购买的表情")
//        let group2: TLEmojiGroup = WXSettingGroup(nil, nil, ([userEmojis, buyedEmojis]))
//        data.append(group2)
        data.append(contentsOf: myEmojiGroups)
        return data
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

                var emojis: [TLEmoji] = []
                let pre = NSPredicate(format: "groupID = %@", group.groupID)
                try! realmWX.transaction {
                    let results = TLEmoji.objects(in: realmWX, with: pre)
                    for index in 0..<results.count {
                        emojis.append(results.object(at: index) as! TLEmoji)
                    }
                }
                group.data.append(objectsIn: emojis)
                data.append(group)
            }
        }
        return data
    }
}

class WXMessageHelper: NSObject {
    static let shared = WXMessageHelper()
    var messageDelegate: Any?
    private var userID: String {
        return WXUserHelper.shared.user.userID
    }
    func send(_ message: WXMessage, progress: @escaping (WXMessage, CGFloat) -> Void, success: @escaping (WXMessage) -> Void, failure: @escaping (WXMessage) -> Void) {
        realmWX.add(message)
        addConversation(by: message)
    }
    func addConversation(by message: WXMessage) {
        var partnerID = message.friendID
        var type: Int = 0
        if message.partnerType == .group {
            partnerID = message.groupID
            type = 1
        }
        WXUserHelper.shared.addConversation(byUid: message.userID, fid: partnerID, type: type, date: message.date)
    }
    func conversationRecord(_ complete: @escaping ([WXConversation]) -> Void) {
        let data = WXUserHelper.shared.conversations(byUid: userID)
        complete(data)
    }

    func deleteConversation(byPartnerID partnerID: String) {
        deleteMessages(byPartnerID: partnerID)
        try! realmWX.transaction {
            let pre = NSPredicate(format: "userID = %@ and friendID = %@", userID, partnerID)
            let results = WXConversation.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }

    func messageRecord(forPartner partnerID: String, from date: Date, count: Int, complete: @escaping ([WXMessage], Bool) -> Void) {
        WXUserHelper.shared.messages(byUserID: userID, partnerID: partnerID, from: date, count: count, complete: { data, hasMore in
            complete(data, hasMore)
        })
    }
    func chatFiles(forPartnerID partnerID: String, completed: @escaping ([[WXMessage]]) -> Void) {
        let data = WXUserHelper.shared.chatFiles(byUserID: userID, partnerID: partnerID)
        completed(data)
    }

    func chatImagesAndVideos(forPartnerID partnerID: String, completed: @escaping ([WXImageMessage]) -> Void) {
        let data = WXUserHelper.shared.chatImagesAndVideos(byUserID: userID, partnerID: partnerID)
        completed(data)
    }

    func deleteMessage(byMsgID msgID: String) {
        realmWX.write {
            let results = WXMessage.objects(in: realmWX, with: NSPredicate(format: "messageID = %@", msgID))
            realmWX.deleteObjects(results)
        }

    }

    func deleteMessages(byPartnerID partnerID: String) {
        realmWX.write {
            let pre = NSPredicate(format: "userID = %@ and friendID = %@", self.userID, partnerID)
            let results = WXMessage.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }

        WXChatViewController.shared.resetChatVC()
    }
    func deleteAllMessages() {
        try! realmWX.transaction {
            let predicate = NSPredicate(format: "userID = %@", self.userID)
            let results = WXMessage.objects(in: realmWX, with: predicate)
            realmWX.deleteObjects(results)
        }
        WXChatViewController.shared.resetChatVC()
        try! realmWX.transaction {
            let pre = NSPredicate(format: "partnerID = %@", self.userID)
            let results = WXConversation.objects(in: realmWX, with: pre)
            realmWX.deleteObjects(results)
        }
    }
    
    func chatDetailData(byUserInfo userInfo: WXUser) -> [WXSettingGroup] {
        let users = WXSettingItem("users")
        users.type = .other
        let group1: WXSettingGroup = WXSettingGroup(nil, nil, [users])
        let top = WXSettingItem("置顶聊天")
        top.type = .switchBtn
        let screen = WXSettingItem("消息免打扰")
        screen.type = .switchBtn
        let group2: WXSettingGroup = WXSettingGroup(nil, nil, ([top, screen]))
        let chatFile = WXSettingItem("聊天文件")
        let group3: WXSettingGroup = WXSettingGroup(nil, nil, [chatFile])
        let chatBG = WXSettingItem("设置当前聊天背景")
        let chatHistory = WXSettingItem("查找聊天内容")
        let group4: WXSettingGroup = WXSettingGroup(nil, nil, ([chatBG, chatHistory]))
        let clear = WXSettingItem("清空聊天记录")
        clear.showDisclosureIndicator = false
        let group5: WXSettingGroup = WXSettingGroup(nil, nil, [clear])
        let report = WXSettingItem("举报")
        let group6: WXSettingGroup = WXSettingGroup(nil, nil, [report])
        return [group1, group2, group3, group4, group5, group6]
    }

    func chatDetailData(byGroupInfo groupInfo: WXGroup) -> [WXSettingGroup] {
        let users = WXSettingItem("users")
        users.type = .other
        let allUsers = WXSettingItem(String(format: "全部群成员(%ld)", groupInfo.count))
        let group1: WXSettingGroup = WXSettingGroup(nil, nil, ([users, allUsers]))
        let groupName = WXSettingItem("群聊名称")
        groupName.subTitle = groupInfo.groupName
        let groupQR = WXSettingItem("群二维码")
        groupQR.rightImagePath = Image.logo.rawValue
        let groupPost = WXSettingItem("群公告")
        if groupInfo.post.count > 0 {
            groupPost.subTitle = groupInfo.post
        } else {
            groupPost.subTitle = "未设置"
        }
        let group2 = WXSettingGroup(nil, nil, ([groupName, groupQR, groupPost]))
        let screen = WXSettingItem("消息免打扰")
        screen.type = .switchBtn
        let top = WXSettingItem("置顶聊天")
        top.type = .switchBtn
        let save = WXSettingItem("保存到通讯录")
        save.type = .switchBtn
        let group3: WXSettingGroup = WXSettingGroup(nil, nil, ([screen, top, save]))
        let myNikeName = WXSettingItem("我在本群的昵称")
        myNikeName.subTitle = groupInfo.myNikeName
        let showOtherNikeName = WXSettingItem("显示群成员昵称")
        showOtherNikeName.type = .switchBtn
        let group4: WXSettingGroup = WXSettingGroup(nil, nil, ([myNikeName, showOtherNikeName]))
        let chatFile = WXSettingItem("聊天文件")
        let chatHistory = WXSettingItem("查找聊天内容")
        let chatBG = WXSettingItem("设置当前聊天背景")
        let report = WXSettingItem("举报")
        let group5: WXSettingGroup = WXSettingGroup(nil, nil, ([chatFile, chatHistory, chatBG, report]))
        let clear = WXSettingItem("清空聊天记录")
        clear.showDisclosureIndicator = false
        let group6: WXSettingGroup = WXSettingGroup(nil, nil, [clear])
        return [group1, group2, group3, group4, group5, group6]
    }
}
