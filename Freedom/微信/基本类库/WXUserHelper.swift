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
        friendsData = WXDBStore.shared.friendsData(byUid: WXUserHelper.shared.user.userID)
        data = [defaultGroup]
        sectionHeaders = [UITableView.indexSearch]
        let results = WXGroup.allObjects(in: realmWX)
        groupsData = results.array().compactMap{ $0 as? WXGroup }
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
                if curGroup.count > 0 {
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
        if curGroup.count > 0 {
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
        DispatchQueue.main.async(execute: {
            self.dataChangedBlock?(self.data, self.sectionHeaders, self.friendCount)
        })
    }
    func p_initTestData() {
        var path = Bundle.main.path(forResource: "FriendList", ofType: "json")
        var jsonData = try! NSData(contentsOfFile: path ?? "")
        var jsonArray: [Any] = []
        if let aData = jsonData {
            jsonArray = [try! JSONSerialization.jsonObject(with: aData as Data, options: JSONSerialization.ReadingOptions.allowFragments)]
        }
        try! realmWX.transaction {
            for array in jsonArray {
                let array = array as! [Any]
                for dict in array {
                WXUser.createOrUpdate(in: realmWX, withValue: dict)
                }
            }
        }
        let arr = WXUser.allObjects(in: realmWX).array()
        friendsData.removeAll()
        friendsData.append(contentsOf: arr as! [WXUser])
        self.p_resetFriendData()
        path = Bundle.main.path(forResource: "FriendGroupList", ofType: "json")
        jsonData = try! NSData(contentsOfFile: path ?? "")
        jsonArray = [try! JSONSerialization.jsonObject(with: jsonData! as Data, options: .allowFragments)]
        try! realmWX.transaction {
            for array in jsonArray {
                let array = array as! [Any]
                for dict in array {
                    let group = WXGroup.createOrUpdate(in: realmWX, withValue: dict)
                    realmWX.addOrUpdate(group)
                }
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
            let space3: CGFloat = (viewWidth - width * 3) / 4 // 三张图时的边距（图与图之间的边距）
            let space2: CGFloat = (viewWidth - width * 2 + space3) / 2 // 两张图时的边距
            let space1: CGFloat = (viewWidth - width) / 2 // 一张图时的边距
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
                imageView.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: UIImage(named: PuserLogo), completed: { image, error, cacheType, imageURL in
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

    func tlCreateInfo(_ t: String?,_ st: String?) -> WXInfo {
        return WXInfo.createInfo(withTitle: t ?? "", subTitle: st ?? "")
    }
    func friendDetailArray(byUserInfo userInfo: WXUser) -> [[WXInfo]] {
        var data: [[WXInfo]] = []
        var arr: [WXInfo] = []
        let user: WXInfo = tlCreateInfo("个人", nil)
        user.type = Int32(TLInfoType.other.rawValue)
//        user.userInfo = userInfo
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
            let str = ""//userInfo.detailInfo.tags?.joined(separator: ",")
            let remark: WXInfo = tlCreateInfo("标签", str)
            arr.append(remark)
        }
        data.append(arr)
        arr = []
        if userInfo.detailInfo.location.count > 0 {
            let location: WXInfo = tlCreateInfo("地区", userInfo.detailInfo.location)
            location.showDisclosureIndicator = false
            location.disableHighlight = true
            arr.append(location)
        }
        let album: WXInfo = tlCreateInfo("个人相册", nil)
        album.userInfo = userInfo.detailInfo.albumArray
        album.type = Int32(TLInfoType.other.rawValue)
        arr.append(album)
        let more: WXInfo = tlCreateInfo("更多", nil)
        arr.append(more)
        data.append(arr)
        arr = []
        let sendMsg: WXInfo = tlCreateInfo("发消息", nil)
        sendMsg.type = Int32(TLInfoType.button.rawValue)
//        sendMsg.titleColor = UIColor.white
//        sendMsg.buttonBorderColor = UIColor.gray
        arr.append(sendMsg)
        if !(userInfo.userID == WXUserHelper.shared.user.userID) {
            let video: WXInfo = tlCreateInfo("视频聊天", nil)
            video.type = Int32(TLInfoType.button.rawValue)
//            video.buttonBorderColor = UIColor.gray
//            video.buttonColor = UIColor.white
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
        var data: [TLEmojiGroup] = []
        var headers = [UITableView.indexSearch]
        var lastC = "1"
        var curGroup = WXUserGroup()
        let othGroup = WXUserGroup()
        othGroup.groupName = "#"
        for contact in serializeArray {
//            let contact = contact as! WXUser
//            // 获取拼音失败
//            if contact.pinyin.isEmpty {
//                othGroup.users.add(contact)
//                continue
//            }
//            if contact.pinyinInitial.isEmpty {
//                // #组
//                othGroup.users.add(contact)
//            } else if contact.pinyinInitial != lastC {
//                if curGroup.count > 0 {
//                    data.append(curGroup)
//                    headers.append(curGroup.groupName)
//                    lastC = contact.pinyinInitial
//                    curGroup = WXUserGroup()
//                    curGroup.groupName = "\(contact.pinyinInitial)"
//                    curGroup.users.add(contact)
//                } else {
//                    curGroup.users.add(contact)
//                }
//            }
//            if curGroup.count > 0 {
//                data.append(curGroup)
//                headers.append(curGroup.groupName)
//            }
//            if othGroup.count > 0 {
//                data.append(othGroup)
//                headers.append(othGroup.groupName)
//            }
//            DispatchQueue.main.async(execute: {
//                success(serializeArray, data, headers)
//            })
//            var dic: [StringLiteralConvertible : Any] = nil
//            if let aData = data, let aHeaders = headers {
//                dic = ["data": serializeArray, "formatData": aData, "headers": aHeaders]
//            }
//            let path = FileManager.pathContactsData()
//            if let aDic = dic {
//                if !NSKeyedArchiver.archiveRootObject(aDic, toFile: path) {
//                    Dlog("缓存联系人数据失败")
//                }
//            }
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
        DispatchQueue.global(qos: .default).async(execute: {
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
            DispatchQueue.main.async(execute: {
                complete(emojiGroupData)
            })
        })
    }
}
//FIXME: 表情数据管理类
class WXExpressionHelper: NSObject {/// 默认表情（Face）
    static let shared = WXExpressionHelper()
    private var store = WXDBStore.shared
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
        return store.expressionGroups(byUid: WXUserHelper.shared.user.userID)
    }
    var userPreferEmojiGroup = TLEmojiGroup()
    let IEXPRESSION_HOST_URL = "http://123.57.155.230:8080/ibiaoqing/admin/"
    var IEXPRESSION_NEW_URL:String {
        return IEXPRESSION_HOST_URL + ("expre/listBy.dopageNumber=%ld&status=Y&status1=B")
    }
    var IEXPRESSION_BANNER_URL: String {
        return IEXPRESSION_HOST_URL + ("advertisement/getAll.dostatus=on")
    }
    var IEXPRESSION_PUBLIC_URL: String {
        return IEXPRESSION_HOST_URL + ("expre/listBy.dopageNumber=%ld&status=Y&status1=B&count=yes")
    }
    var IEXPRESSION_SEARCH_URL: String {
        return IEXPRESSION_HOST_URL + ("expre/listBy.dopageNumber=1&status=Y&eName=%@&seach=yes")
    }
    var IEXPRESSION_DETAIL_URL: String {
        return IEXPRESSION_HOST_URL + ("expre/getByeId.dopageNumber=%ld&eId=%@")
    }
    func addExpressionGroup(_ emojiGroup: TLEmojiGroup) {
        store.addExpressionGroup(emojiGroup, forUid: WXUserHelper.shared.user.userID)
        WXUserHelper.shared.updateEmojiGroupData()
    }
    func deleteExpressionGroup(byID groupID: String) {
        store.deleteExpressionGroup(byID: groupID, forUid: WXUserHelper.shared.user.userID)
        WXUserHelper.shared.updateEmojiGroupData()
    }
    func didExpressionGroupAlways(inUsed groupID: String) -> Bool {
        let count = store.countOfUserWhoHasExpressionGroup(groupID)
        return count > 0
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
        var myEmojiGroups = store.expressionGroups(byUid: WXUserHelper.shared.user.userID)
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
    func downloadExpressions(withGroupInfo group: TLEmojiGroup, progress: @escaping (CGFloat) -> Void, success: @escaping (TLEmojiGroup) -> Void, failure: @escaping (TLEmojiGroup, String) -> Void) {
        let downloadQueue = DispatchQueue(label: group.groupID)
        let downloadGroup = DispatchGroup()
        for i in 0...group.data.count {
            downloadQueue.async(group: downloadGroup) {
                let groupPath = FileManager.pathExpression(forGroupID: group.groupID)
                var emojiPath: String
                var data: Data?
                if i == group.data.count {
                    emojiPath = "\(groupPath)icon_\(group.groupID)"
                    if let anURL = URL(string: group.groupIconURL) {
                        data = try! Data(contentsOf: anURL)
                    }
                } else {
                    let emoji: TLEmoji = group.data[i]
                    var urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(emoji.emojiID)"
                    if let aString = URL(string: urlString) {
                        data = try! Data(contentsOf: aString)
                    }
                    if data == nil {
                        urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.dopId=\(emoji.emojiID)"
                        if let aString = URL(string: urlString) {
                            data = try! Data(contentsOf: aString)
                        }
                    }
                    emojiPath = "\(groupPath)\(emoji.emojiID)"
                }
                try! data?.write(to: URL(fileURLWithPath: emojiPath))
            }
        }
        downloadGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
        success(group)
        }))
    }
    func requestExpressionChosenList(byPageIndex pageIndex: Int, success: @escaping (_ data: [TLEmojiGroup]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: IEXPRESSION_NEW_URL, pageIndex)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            //            let respArray = (responseObject as! NSArray).mj_JSONObject()!
            //            let status = respArray[0] as String
            //            if (status == "OK") {
            //                let infoArray = respArray[2] as [Any]
            //                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
            //                success(data)
            //            } else {
            //                failure(status)
            //            }
        }, failure: { task, error in
            failure(error.localizedDescription)
        })
    }
    func requestExpressionChosenBannerSuccess(_ success: @escaping ([TLEmojiGroup]) -> Void, failure: @escaping (String) -> Void) {
        let urlString = IEXPRESSION_BANNER_URL
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            //            let respArray = responseObject.mj_JSONObject()
            //            let status = respArray[0] as String
            //            if (status == "OK") {
            //                let infoArray = respArray[2] as [Any]
            //                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
            //                success(data)
            //            } else {
            //                failure(status)
            //            }
        }, failure: { task, error in
            failure(error.localizedDescription)
        })
    }
    func requestExpressionPublicList(byPageIndex pageIndex: Int, success: @escaping (_ data: [TLEmojiGroup]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: IEXPRESSION_PUBLIC_URL, pageIndex)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            //            let respArray = responseObject.mj_JSONObject()
            //            let status = respArray[0] as String
            //            if (status == "OK") {
            //                let infoArray = respArray[2] as [Any]
            //                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
            //                success(data)
            //            } else {
            //                failure(status)
            //            }
        }, failure: { task, error in
            failure(error.localizedDescription)
        })
    }
    func requestExpressionSearch(byKeyword keyword: String, success: @escaping (_ data: [TLEmojiGroup]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: IEXPRESSION_SEARCH_URL, keyword)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            //            let respArray = responseObject.mj_json()
            //            let status = respArray[0] as String
            //            if (status == "OK") {
            //                let infoArray = respArray[2] as [Any]
            //                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
            //                success(data)
            //            } else {
            //                failure(status)
            //            }
        }, failure: { task, error in
            failure(error.localizedDescription)
        })
    }
    func requestExpressionGroupDetail(byGroupID groupID: String, pageIndex: Int, success: @escaping (_ data: [TLEmoji]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: IEXPRESSION_DETAIL_URL, pageIndex, groupID)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            //            let respArray = responseObject.mj_JSONObject()
            //            let status = respArray[0] as String
            //            if (status == "OK") {
            //                let infoArray = respArray[2] as [Any]
            //                var data = TLEmoji.mj_objectArray(withKeyValuesArray: infoArray)
            //                success(data)
            //            } else {
            //                failure(status)
            //            }
        }, failure: { task, error in
            failure(error.localizedDescription)
        })
    }
}

