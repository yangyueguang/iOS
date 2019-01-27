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
            let textHeight: CGFloat = text.boundingRect(with: CGSize(width: APPW - 70.0, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)], context: nil).size.height
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
    class func createInfo(withTitle title: String, subTitle: String) -> WXInfo {
        let info = WXInfo()
        info.title = title
        info.subTitle = subTitle
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
}

//FIXME: 本类🎄
class WXAddMenuItem: NSObject {
    var type = TLAddMneuType.groupChat
    var title = ""
    var iconPath = ""
    var className: UIViewController.Type?
    override init() {
        super.init()
    }
    convenience init(type: TLAddMneuType, title: String, iconPath: String, className: UIViewController.Type?) {
        self.init()
        self.type = type
        self.title = title
        self.iconPath = iconPath
        self.className = className
    }
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
