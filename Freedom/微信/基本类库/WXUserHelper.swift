//
//  WXUserHelper.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
enum TLChatUserType : Int {
    case user = 0
    case group
}
enum TLContactStatus : Int {
    case stranger
    case friend
    case wait
}
protocol WXChatUserProtocol: NSObjectProtocol {
    var chat_userID: String { get }
    var chat_username: String { get }
    var chat_avatarURL: String { get }
    var chat_avatarPath: String { get }
    var chat_userType: Int { get }
    func groupMember(byID userID: String) -> Any
    func groupMembers() -> [WXUser]
}
class WechatContact: NSObject {
    var name = ""
    var avatarPath = ""
    var avatarURL = ""
    var tel = ""
    var status = TLContactStatus.friend
    var recordID: Int = 0
    var email = ""
    lazy var pinyin = self.name.pinyin()
    lazy var pinyinInitial = self.name.pinyin()
}

class WXUserSetting: NSObject {
    var userID = ""
    var star = false
    var dismissTimeLine = false
    var prohibitTimeLine = false
    var blackList = false
}

class WXUserDetail: NSObject {
    var userID = ""
    var sex = ""
    var location = ""
    var phoneNumber = ""
    var qqNumber = ""
    var email = ""
    var albumArray: [Any] = []
    var motto = ""
    var momentsWallURL = ""/// 备注信息
    var remarkInfo = ""/// 备注图片（本地地址）
    var remarkImagePath = ""/// 备注图片 (URL)
    var remarkImageURL = ""/// 标签
    var tags: [AnyHashable] = []
}

class WXUserChatSetting: NSObject {
    var userID = ""
    var top = false
    var noDisturb = false
    var chatBGPath = ""
}
class WXUser: NSObject, WXChatUserProtocol {
    var userID = ""
    var username = "" {
        didSet {
            if remarkName.count == 0 && nikeName.count == 0 && self.username.count > 0 {
                pinyin = username.pinyin()
                pinyinInitial = username.pinyin()
            }
        }
    }
    var nikeName = "" {
        didSet {
            if remarkName.count == 0 && self.nikeName.count > 0 {
                pinyin = nikeName.pinyin()
                pinyinInitial = nikeName.pinyin()
            }
        }
    }
    var avatarURL = ""
    var avatarPath = ""
    var remarkName = "" {
        didSet {
            if self.remarkName.count > 0 {
                pinyin = remarkName.pinyin()
                pinyinInitial = remarkName.pinyin()
            }
        }
    }
    private var showName = ""
    var detailInfo = WXUserDetail()
    var userSetting: WXUserSetting
    var chatSetting: WXUserChatSetting
    var pinyin = ""
    var pinyinInitial = ""
    override init() {
        super.init()
        WXUser.mj_setupObjectClass(inArray: {
            return ["detailInfo": "TLUserDetail", "userSetting": "TLUserSetting", "chatSetting": "TLUserChatSetting"]
        })
    }
    func showName() -> String {
        return remarkName.count > 0 ? remarkName : (nikeName.count > 0 nikeName : username)
    }
    func chat_userID() -> String {
        return userID
    }

    func chat_username() -> String {
        return showName()
    }

    func chat_avatarURL() -> String {
        return avatarURL
    }
    func chat_avatarPath() -> String {
        return avatarPath
    }
    func chat_userType() -> Int {
        return Int(TLChatUserType.user)
    }
}

class WXGroup: NSObject, WXChatUserProtocol {
    var groupName = ""
    var groupAvatarPath = groupID + (".png")
    var groupID = ""
    var users: [WXUser] = []
    var post = ""
    var myNikeName = WXUserHelper.shared).user.showName
    var pinyin = groupName.pinyin()
    var pinyinInitial = groupName.pinyin()
    private(set) var count: Int = 0
    var showNameInChat = false
    override init() {
        super.init()
//        [WXGroup mj_setupObjectClassInArray:^NSDictionary *{
//            return @{ @"users" : @"WXUser" };
//        }];
    }
    func count() -> Int {
        return users.count()
    }
    func add(_ anObject: WXUser) {
        users.append(anObject)
    }
    func object(at index: Int) -> WXUser {
        return users[index]
    }
    func member(byUserID uid: String) -> WXUser {
        for user: WXUser in users {
            if (user.userID == uid) {
                return user
            }
        }
        return nil
    }
    var groupName: INSpeakableString {
        if groupName == nil || groupName.length == 0 {
            for user: WXUser in users {
                if user.showName.count > 0 {
                    if groupName == nil || groupName.count <= 0 {
                        groupName = user.showName
                    } else {
                        if let aName = user.showName {
                            groupName = "\(groupName),\(aName)"
                        }
                    }
                }
            }
        }
        return groupName
    }
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
        return groupAvatarPath
    }
    var chat_userType: Int {
        return Int(TLChatUserTypeGroup)
    }
    func groupMember(byID userID: String) -> WXUser {
        return member(byUserID: userID)
    }
    func groupMembers() -> [WXUser] {
        return users
    }
}
class WXUserGroup: NSObject {
    var groupName = ""
    var users: [WXUser] = []
    private var count: Int {
        return users.count
    }
    init(groupName: String, users: [WXUser]) {
        super.init()
        self.groupName = groupName
        self.users = users
    }
    func add(_ anObject: WXUser) {
        users.append(anObject)
    }
    func object(at index: Int) -> WXUser {
        return users[index]
    }
}

class WXFriendHelper: NSObject {
    static let shared = WXFriendHelper()
    var defaultGroup: WXUserGroup
    var friendsData: [WXUser] = []
    var data: [WXUserGroup] = []
    var sectionHeaders: [String] = []
    private(set) var friendCount: Int = 0
    var dataChangedBlock: ((_ friends: [AnyHashable], _ headers: [AnyHashable], _ friendCount: Int) -> Void)
    var groupsData: [WXGroup] = []
    var tagsData: [WXUserGroup] = []
    private var friendStore = WXDBFriendStore()
    private var groupStore = WXDBGroupStore()
    override init() {
        super.init()
        friendsData = friendStore.friendsData(byUid: WXUserHelper.shared.user.userID)
        data = [defaultGroup]
        sectionHeaders = [UITableView.indexSearch]
        groupsData = groupStore.groupsData(byUid: WXUserHelper.shared.user.userID)
        p_initTestData()
    }
    func getFriendInfo(byUserID userID: String) -> WXUser? {
        for user in friendsData where user.userID == userID {
            return user
        }
        return nil
    }
    func getGroupInfo(byGroupID groupID: String) -> WXGroup? {
        for group in groupsData where group.groupID == groupID {
            return group
        }
        return nil
    }
    func p_resetFriendData() {
        let serializeArray = friendsData.sortedArray(comparator: { obj1, obj2 in
            var i: Int
            let strA = (obj1 as WXUser).pinyin
            let strB = (obj2 as WXUser).pinyin
            for i in 0..<(strA.count) {
                let a = toupper(strA[strA.index(strA.startIndex, offsetBy: UInt(i))])
                let b = toupper(strB[strB.index(strB.startIndex, offsetBy: UInt(i))])
                if a > b {
                    return .orderedDescending
                } else if a < b {
                    return .orderedAscending
                }
            }
            if (strA.count) > (strB.count) {
                return .orderedDescending
            } else if (strA.count) < (strB.count) {
                return .orderedAscending
            }
            return .orderedSame
        })
        var ansData = [defaultGroup]
        var ansSectionHeaders = [UITableView.indexSearch]
        var tagsDic: [String : Any] = [:]
        var lastC = "1"
        var curGroup: WXUserGroup
        let othGroup = WXUserGroup()
        othGroup.groupName = "#"
        for user in serializeArray {
            if user.pinyin == nil || user.pinyin.length == 0 {
                othGroup.append(user)
                continue
            }

            let c = toupper(user.pinyin[user.pinyin.index(user.pinyin.startIndex, offsetBy: 0)])
            if !isalpha(c) {
                othGroup.append(user)
            } else if c != lastC {
                if curGroup && curGroup.count > 0 {
                    ansData.append(curGroup)
                    if let aName = curGroup.groupName {
                        ansSectionHeaders.append(aName)
                    }
                }
                lastC = c
                curGroup = WXUserGroup()
                curGroup.groupName = "\(c)"
                curGroup.append(user)
            } else {
                curGroup.append(user)
            }
            if user.detailInfo.tags.count > 0 {
                for tag: String in (user.detailInfo.tags)! {
                    var group = tagsDic[tag] as WXUserGroup
                    if group == nil {
                        group = WXUserGroup()
                        group.groupName = tag
                        tagsDic[tag] = group
                        tagsData.append(group)
                    }
                    group.users.append(user)
                }
            }
        }
        if curGroup && curGroup.count > 0 {
            ansData.append(curGroup)
            ansSectionHeaders.append(curGroup.groupName)
        }
        if othGroup.count > 0 {
            ansData.append(othGroup)
            ansSectionHeaders.append(othGroup.groupName)
        }

        data.removeAll()
        data.append(contentsOf: ansData)
        sectionHeaders.removeAll()
        sectionHeaders.append(contentsOf: ansSectionHeaders)
        if dataChangedBlock {
            DispatchQueue.main.async(execute: {
                self.dataChangedBlock(self.data, self.sectionHeaders, self.friendCount)
            })
        }
    }
    func p_initTestData() {
        var path = Bundle.main.path(forResource: "FriendList", ofType: "json")
        var jsonData = NSData(contentsOfFile: path) as Data
        var jsonArray: [Any] = nil
        if let aData = jsonData {
            jsonArray = try JSONSerialization.jsonObject(with: aData, options: .allowFragments) as [Any]
        }
        var arr = WXUser.mj_objectArray(withKeyValuesArray: jsonArray)
        friendsData.removeAll()
        friendsData.append(contentsOf: arr)
        // 更新好友数据到数据库
        var ok = friendStore.updateFriendsData(friendsData, forUid: WXUserHelper.shared().user.userID)
        if !ok {
            Dlog("保存好友数据到数据库失败!")
        }
        DispatchQueue.global(qos: .default).async(execute: {
            self.p_resetFriendData()
        })
        path = Bundle.main.path(forResource: "FriendGroupList", ofType: "json")
        jsonData = NSData(contentsOfFile: path)
        jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
        arr = WXGroup.mj_objectArray(withKeyValuesArray: jsonArray)
        groupsData.removeAll()
        groupsData.append(contentsOf: arr)
        ok = groupStore.updateGroupsData(groupsData, forUid: WXUserHelper.shared().user.userID)
        if !ok {
            Dlog("保存群数据到数据库失败!")
        }
        for group: WXGroup in groupsData {
            createGroupAvatar(group, finished: nil)
        }
    }
    func createGroupAvatar(_ group: WXGroup, finished: @escaping (_ groupID: String) -> Void) {
        DispatchQueue.global(qos: .default).async(execute: {
            let usersCount: Int = group.users.count > 9 ? 9 : group.users.count
            let viewWidth: CGFloat = 200
            let width: CGFloat = viewWidth / 3 * 0.85
            let space3: CGFloat = (viewWidth - width * 3) / 4 // 三张图时的边距（图与图之间的边距）
            let space2: CGFloat = (viewWidth - width * 2 + space3) / 2 // 两张图时的边距
            let space1: CGFloat = (viewWidth - width) / 2 // 一张图时的边距
            var y: CGFloat = (usersCount) > 6 ? space3 : ((usersCount) > 3 ? space2 : space1)
            var x: CGFloat = (usersCount) % 3 == 0 ? space3 : ((usersCount) % 3 == 2 ? space2 : space1)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth))
            view.backgroundColor = UIColor(white: 0.8, alpha: 0.6)
            let count: Int = 0 // 下载完成图片计数器
            var i = usersCount - 1
            while i >= 0 {
                let user: WXUser = group.users[i]
                let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: width))
                view.addSubview(imageView)
                imageView.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: UIImage(named: PuserLogo), completed: { image, error, cacheType, imageURL in
                    count += 1
                    if count == usersCount {
                        // 图片全部下载完成
                        UIGraphicsBeginImageContextWithOptions(view.frame.size, _: false, _: 2.0)
                        if let aContext = UIGraphicsGetCurrentContext() {
                            view.layer.render(in: aContext)
                        }
                        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        let imageRef = image.cgImage
                        let imageRefRect = imageRef.cropping(to: CGRect(x: 0, y: 0, width: view.frame.size.width * 2, height: view.frame.size.height * 2)) as CGImage
                        var ansImage = UIImage(cgImage: imageRefRect)
                        let imageViewData: Data = UIImagePNGRepresentation(ansImage)
                        let savedImagePath = FileManager.pathUserAvatar(group.groupAvatarPath)
                        imageViewData.write(toFile: savedImagePath, atomically: true)
                        CGImageRelease(imageRefRect)
                        DispatchQueue.main.async(execute: {
                            finished(group.groupID)
                        })
                    }
                }
                if i % 3 == 0 {
                    // 换行
                    y += width + space3
                    x = space3
                } else if i == 2 && usersCount == 3 {
                    // 换行，只有三个时
                    y += width + space3
                    x = space2
                } else {
                    x += width + space3
                }
                i -= 1
            }
        }
    }
    func defaultGroup() -> WXUserGroup {
        if defaultGroup == nil {
            let item_new = WXUser()
            item_new.userID = "-1"
            item_new.avatarPath = "u_personAddHL"
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
            defaultGroup = WXUserGroup(groupName: nil, users: [item_new, item_group, item_tag, item_public])
        }
        return defaultGroup
    }
    func friendCount() -> Int {
        return friendsData.count
    }

    func tlCreateInfo(_ t: String, st: String) -> WXInfo {
        return WXInfo.createInfo(withTitle: t, subTitle: st)
    }
    func friendDetailArray(byUserInfo userInfo: WXUser) -> [[WXInfo]] {
        var data: [[WXInfo]] = []
        var arr: [WXInfo] = []
        let user: WXInfo = tlCreateInfo("个人", nil)
        user.type = .other
        user.userInfo = userInfo
        arr.append(user)
        data.append(arr)
        arr = []
        if userInfo.detailInfo.phoneNumber.count > 0 {
            let tel: WXInfo = tlCreateInfo("电话号码", userInfo.detailInfo.phoneNumber)
            tel.showDisclosureIndicator = false
            arr.append(tel)
        }
        if userInfo.detailInfo.tags.count == 0 {
            let remark: WXInfo = tlCreateInfo("设置备注和标签", nil)
            arr.insert(remark, at: 0)
        } else {
            let str = userInfo.detailInfo.tags.joined(separator: ",")
            let remark: WXInfo = tlCreateInfo("标签", str)
            arr.append(remark)
        }
        data.append(arr)
        arr = []
        if userInfo.detailInfo.location.length > 0 {
            let location: WXInfo = tlCreateInfo("地区", userInfo.detailInfo.location)
            location.showDisclosureIndicator = false
            location.disableHighlight = true
            arr.append(location)
        }
        let album: WXInfo = tlCreateInfo("个人相册", nil)
        album.userInfo = userInfo.detailInfo.albumArray
        album.type = TLInfoTypeOther
        if let anAlbum = album {
            arr.append(anAlbum)
        }
        let more: WXInfo = tlCreateInfo("更多", nil)
        arr.append(more)
        data.append(arr)
        arr = []
        let sendMsg: WXInfo = tlCreateInfo("发消息", nil)
        sendMsg.type = TLInfoTypeButton
        sendMsg.titleColor = UIColor.white
        sendMsg.buttonBorderColor = UIColor.gray
        arr.append(sendMsg)
        if !(userInfo.userID == WXUserHelper.shared().user.userID) {
            let video: WXInfo = tlCreateInfo("视频聊天", nil)
            video.type = .button
            video.buttonBorderColor = UIColor.gray
            video.buttonColor = UIColor.white
            arr.append(video)
        }
        data.append(arr)
        return data
    }
    func friendDetailSettingArray(byUserInfo userInfo: WXUser) -> [WXSettingGroup] {
        let remark = WXSettingItem.createItem(withTitle: ("设置备注及标签"))
        if userInfo.remarkName.count > 0 {
            remark.subTitle = userInfo.remarkName
        }
        let group1: WXSettingGroup = TLCreateSettingGroup(nil, nil, [remark])
        let recommand = WXSettingItem.createItem(withTitle: ("把他推荐给朋友"))
        let group2: WXSettingGroup = TLCreateSettingGroup(nil, nil, [recommand])
        let starFriend = WXSettingItem.createItem(withTitle: ("设为星标朋友"))
        starFriend.type = .swtchBtn
        let group3: WXSettingGroup = TLCreateSettingGroup(nil, nil, [starFriend])
        let prohibit = WXSettingItem.createItem(withTitle: ("不让他看我的朋友圈"))
        prohibit.type = .swtchBtn
        let dismiss = WXSettingItem.createItem(withTitle: ("不看他的朋友圈"))
        dismiss.type = .swtchBtn
        let group4: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([prohibit, dismiss]))
        let blackList = WXSettingItem.createItem(withTitle: ("加入黑名单"))
        blackList.type = .swtchBtn
        let report = WXSettingItem.createItem(withTitle: ("举报"))
        let group5: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([blackList, report]))
        return [group1, group2, group3, group4, group5]
    }
    class func gotNextEvent(withWechatContacts data: [AnyHashable], success: @escaping (_ data: [Any], _ formatData: [Any], _ headers: [Any]) -> Void) {
        let serializeArray = data.sortedArray(comparator: { obj1, obj2 in
            var i: Int
            let strA = (obj1 as WechatContact).pinyin
            let strB = (obj2 as WechatContact).pinyin
            for i in 0..<(strA.count) {
                let a = toupper(strA[strA.index(strA.startIndex, offsetBy: UInt(i))])
                let b = toupper(strB[strB.index(strB.startIndex, offsetBy: UInt(i))])
                if a > b {
                    return .orderedDescending
                } else if a < b {
                    return .orderedAscending
                }
            }
            if (strA.count) > (strB.count) {
                return .orderedDescending
            } else if strA.length < strB.length {
                return .orderedAscending
            }
            return .orderedSame
        })
        data: [TLEmojiGroup] = []
        var headers = [UITableView.indexSearch]
        var lastC = "1"
        var curGroup: WXUserGroup
        let othGroup = WXUserGroup()
        othGroup.groupName = "#"
        for contact: WechatContact in serializeArray {
            // 获取拼音失败
            if contact.pinyin == nil || contact.pinyin.length == 0 {
                if let aContact = contact {
                    othGroup.append(aContact)
                }
                continue
            }
            let c = toupper(contact.pinyin[contact.pinyin.index(contact.pinyin.startIndex, offsetBy: 0)])
            if !isalpha(c) {
                // #组
                othGroup.append(contact)
            } else if c != lastC {
                if curGroup && curGroup.count > 0 {
                    data.append(curGroup)
                    headers.append(curGroup.groupName)
                    lastC = c
                    curGroup = WXUserGroup()
                    curGroup.groupName = "\(c)"
                    curGroup.append(contact)
                } else {
                    curGroup.append(contact)
                }
            }
            if curGroup && curGroup.count > 0 {
                data.append(curGroup)
                headers.append(curGroup.groupName)
            }
            if othGroup.count > 0 {
                data.append(othGroup)
                headers.append(othGroup.groupName)
            }
            DispatchQueue.main.async(execute: {
                success(serializeArray, data, headers)
            })
            var dic: [StringLiteralConvertible : Any] = nil
            if let aData = data, let aHeaders = headers {
                dic = ["data": serializeArray, "formatData": aData, "headers": aHeaders]
            }
            let path = FileManager.pathContactsData()
            if let aDic = dic {
                if !NSKeyedArchiver.archiveRootObject(aDic, toFile: path) {
                    Dlog("缓存联系人数据失败")
                }
            }
        }
    }
    class func try(toGetAllContactsSuccess success: @escaping (_ data: [Any], _ formatData: [Any], _ headers: [Any]) -> Void, failed: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async(execute: {
            // 3、加载缓存
            let path = FileManager.pathContactsData()
            let dic = NSKeyedUnarchiver.unarchiveObject(withFile: path) as [AnyHashable : Any]
            if dic != nil {
                let data = dic["data"] as [Any]
                let formatData = dic["formatData"] as [Any]
                let headers = dic["headers"] as [Any]
                DispatchQueue.main.async(execute: {
                    success(data, formatData, headers)
                })
            }
            let status: CNAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
            if status != .authorized {
                return
            }
            let contactStore = CNContactStore()
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
            let request = CNContactFetchRequest(keysToFetch: keys)
            var data: [WechatContact] = []
            try contactStore.enumerateContacts(with: request, usingBlock: { _,_ in
                let con = WechatContact()
                let lastname = contact.familyName
                let firstname = contact.givenName
                let phoneNums = contact.phoneNumbers
                for labeledValue: CNLabeledValue in phoneNums {
                    let phoneLabel = labeledValue.label
                    let phoneNumer = labeledValue.value as CNPhoneNumber
                    let phoneValue = phoneNumer.stringValue
                    print("\(phoneLabel) \(phoneValue)")
                    con.tel = phoneValue
                }
                let emails = contact.emailAddresses as [CNLabeledValue<String>]
                for labeldValue: CNLabeledValue in emails {
                    let email = labeldValue.label
                    con.email = "\(email)\(labeldValue.value)"
                }
                con.name = "\(lastname) \(firstname)"
                con.recordID = contact.identifier
                let imageData: Data = contact.imageData
                let imageName = String(format: "%.0lf.jpg", Date().timeIntervalSince1970 * 10000)
                let imagePath = FileManager.pathContactsAvatar(imageName)
                imageData.write(toFile: imagePath, atomically: true)
                con.avatarPath = imageName
                if stop {
                    self.gotNextEvent(withWechatContacts: data, success: success)
                }
            })
        }
    }
}
class WXUserHelper: NSObject {
    static let shared = WXUserHelper()
    lazy var user: WXUser = {
        let user = WXUser()
        user.userID = "这是我的二维码：2829969299 \n没错，我爱你。" //我的二维码数据
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
        editGroup.groupIconPath = "emojiKB_settingBtn"
        return [editGroup]
    }()
    private var complete: (([TLEmojiGroup]) -> Void)
    init() {
        super.init()
    }
    func updateEmojiGroupData() {
        if !user.userID.isEmpty && complete {
            emojiGroupDataComplete(complete)
        }
    }
    func emojiGroupDataComplete(_ complete: @escaping ([TLEmojiGroup]) -> Void) {
        self.complete = complete
        DispatchQueue.global(qos: .default).async(execute: {
            var emojiGroupData: [TLEmojiGroup] = []
            let defaultEmojiGroups = [WXExpressionHelper.shared.defaultFaceGroup, WXExpressionHelper.shared.defaultSystemEmojiGroup]
            emojiGroupData.append(defaultEmojiGroups)
            let preferEmojiGroup: TLEmojiGroup = WXExpressionHelper.shared.userPreferEmojiGroup
            if preferEmojiGroup != nil && preferEmojiGroup.count > 0 {
                emojiGroupData.append([preferEmojiGroup])
            }
            let userGroups = WXExpressionHelper.shared.userEmojiGroups
            if userGroups.count > 0 {
                emojiGroupData.append(userGroups)
            }
            emojiGroupData.append(self.systemEmojiGroups)
            DispatchQueue.main.async(execute: {
                complete(emojiGroupData)
            })
        })
    }
}
