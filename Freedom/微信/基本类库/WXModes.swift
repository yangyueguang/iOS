//
//  WXModes.swift
//  Freedom
import Realm
import RealmSwift
import Foundation
import XExtension
enum TLChatUserType : Int {
    case user = 0
    case group
}
enum TLContactStatus : Int {
    case stranger
    case friend
    case wait
}
func TLCreateSettingGroup(_ Header: String?,_ Footer: String?, _ Items: [WXSettingItem]) -> WXSettingGroup {
    return WXSettingGroup.createGroup(withHeaderTitle: Header ?? "", footerTitle: Footer ?? "", items: Items)
}
enum TLInfoType : Int {
    case defaultType
    case titleOnly
    case images
    case mutiRow
    case button
    case other
}

public enum TLSettingItemType : Int {
    case `default` = 0
    case titleButton
    case switchBtn
    case other
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
@objcMembers
class WXMomentFrame: RLMObject {
    dynamic var height: CGFloat = 0.0
    dynamic var heightDetail: CGFloat = 0.0
    dynamic var heightExtension: CGFloat = 0.0
}
@objcMembers
class WXMomentDetailFrame: RLMObject {
    dynamic var height: CGFloat = 0.0
    dynamic var heightText: CGFloat = 0.0
    dynamic var heightImages: CGFloat = 0.0
}
@objcMembers
class WXMomentDetail: RLMObject {
    dynamic var text = ""
    dynamic var images = List<String>()
    dynamic var detailFrame: WXMomentDetailFrame!
    func heightText() -> CGFloat {
        if text.count > 0 {
            let textHeight: CGFloat = text.boundingRect(with: CGSize(width: APPW - 70.0, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)], context: nil).size.height
            //: 浮点数会导致部分cell顶部多出来一条线，莫名其妙！！！
            return textHeight + 1.0
        }
        return 0.0
    }
    func heightImages() -> CGFloat {
        var height: CGFloat = 0.0
        if images.count > 0 {
            if text.count > 0 {
                height += 7.0
            } else {
                height += 3.0
            }
            let space: CGFloat = 4.0
            if images.count == 1 {
                height += APPW - 70.0 * 0.6 * 0.8
            } else {
                let row: Int = (images.count / 3) + (images.count % 3 == 0 ? 0 : 1)
                height += APPW - 70.0 * 0.31 * CGFloat(row) + space * CGFloat((row - 1))
            }
        }
        return height
    }
    override init() {
        super.init()
        detailFrame = WXMomentDetailFrame()
        detailFrame.height = 0.0
        detailFrame.heightText = heightText()
        detailFrame.height += detailFrame.heightText
        detailFrame.heightImages = heightImages()
        detailFrame.height += detailFrame.heightImages
    }
}
@objcMembers
class WXMomentExtensionFrame: RLMObject {
    dynamic var height: CGFloat = 0.0
    dynamic var heightLiked: CGFloat = 0.0
    dynamic var heightComments: CGFloat = 0.0
}
@objcMembers
class WXMomentExtension: RLMObject {
    dynamic var likedFriends = List<WXUser>()
    dynamic var comments = List<WXMomentComment>()
    dynamic var extensionFrame: WXMomentExtensionFrame!
    override static func ignoredProperties() -> [String] {
        return ["extensionFrame"]
    }
    override init() {
        super.init()
        extensionFrame = WXMomentExtensionFrame()
        extensionFrame.height = 0.0
        if likedFriends.count > 0 || comments.count > 0 {
            extensionFrame.height += 5
        }
        extensionFrame.heightLiked = heightLiked()
        extensionFrame.height += extensionFrame.heightLiked
        extensionFrame.heightComments = heightComments()
        extensionFrame.height += extensionFrame.heightComments
    }
    func heightLiked() -> CGFloat {
        var height: CGFloat = 0.0
        if likedFriends.count > 0 {
            height = 30.0
        }
        return height
    }

    func heightComments() -> CGFloat {
        var height: CGFloat = 0.0
        for comment: WXMomentComment in comments {
            height += comment.commentFrame.height
        }
        return height
    }
}
@objcMembers
class WXMoment: RLMObject {
    dynamic var momentID = ""
    dynamic var user: WXUser?
    dynamic var date = Date()
    dynamic var detail: WXMomentDetail?
    dynamic var `extension`: WXMomentExtension!
    dynamic var momentFrame: WXMomentFrame!
    override init() {
        super.init()
        self.extension = WXMomentExtension()
        momentFrame = WXMomentFrame()
        momentFrame.height = 76.0
        momentFrame.heightDetail = detail?.detailFrame.height ?? 0
        momentFrame.height += momentFrame.heightDetail // 正文高度
        momentFrame.heightExtension = self.extension.extensionFrame.height
        momentFrame.height += momentFrame.heightExtension // 拓展高度

    }
}
@objcMembers
class WXMomentCommentFrame: RLMObject {
    dynamic var height: CGFloat = 0.0
}
@objcMembers
class WXMomentComment: RLMObject,RealmCollectionValue {
    dynamic var user: WXUser?
    dynamic var toUser: WXUser?
    dynamic var content = ""
    dynamic var commentFrame: WXMomentCommentFrame!
    override init() {
        super.init()
        commentFrame = WXMomentCommentFrame()
        commentFrame.height = 35.0
    }
}
class WXAddMenuHelper: NSObject {
    private var menuItemTypes: [Int] = [0, 1, 2, 3]
    lazy var menuData: [WXAddMenuItem] = {
        var menuData: [WXAddMenuItem] = []
        for type in menuItemTypes {
            let item: WXAddMenuItem = p_getMenuItem(by: TLAddMneuType(rawValue: type)!)
            menuData.append(item)
        }
        return menuData
    }()
    override init() {
        super.init()
    }
    func p_getMenuItem(by type: TLAddMneuType) -> WXAddMenuItem {
        switch type {
        case .groupChat:
            return WXAddMenuItem.create(with: .groupChat, title: "发起群聊", iconPath: "nav_menu_groupchat", className: nil)
        case .addFriend:
            return WXAddMenuItem.create(with: .addFriend, title: "添加朋友", iconPath: "nav_menu_addfriend", className: WXAddFriendViewController.self)
        case .wallet:
            return WXAddMenuItem.create(with: .wallet, title: "收付款", iconPath: "nav_menu_wallet", className: nil)
        case .scan:
            return WXAddMenuItem.create(with: .scan, title: "扫一扫", iconPath: "nav_menu_scan", className: WXScanningViewController.self)
        }
    }
}
@objcMembers
class WXInfo: RLMObject {
    dynamic var type = TLInfoType.defaultType
    dynamic var title = ""
    dynamic var subTitle = ""
    dynamic var subImageArray = List<String>()
    dynamic var userInfo = List<String>()
    var titleColor: UIColor { return UIColor.black}
    var buttonColor: UIColor { return UIColor.green}
    var buttonHLColor: UIColor { return UIColor.green}
    var buttonBorderColor: UIColor { return UIColor.gray}
    //是否显示箭头（默认YES）
    var showDisclosureIndicator = true
    //停用高亮（默认NO）
    var disableHighlight = false
    class func createInfo(withTitle title: String, subTitle: String) -> WXInfo {
        let info = WXInfo()
        info.title = title
        info.subTitle = subTitle
        return info
    }
    override init() {
        super.init()
    }
    override static func ignoredProperties() -> [String] {
        return ["userInfo"]
    }
}
@objcMembers
class WXMenuItem: RLMObject {
    dynamic var iconPath = ""//左侧图标路径
    dynamic var title = ""//标题
    dynamic var subTitle = ""//副标题
    dynamic var rightIconURL = ""//副图片URL
    dynamic var showRightRedPoint = false//是否显示红点
    class func createMenu(withIconPath iconPath: String, title: String) -> WXMenuItem {
        let item = WXMenuItem()
        item.iconPath = iconPath
        item.title = title
        return item
    }
}

class WXSettingGroup: RLMObject {
    var headerTitle = ""
    var footerTitle = ""
    var items = List<WXSettingItem>()//setcion元素
    private(set) var headerHeight: CGFloat = 0.0
    private(set) var footerHeight: CGFloat = 0.0
    private var count: Int {
        return items.count
    }
    class func createGroup(withHeaderTitle headerTitle: String, footerTitle: String, items: [WXSettingItem]) -> WXSettingGroup {
        let group = WXSettingGroup()
        group.headerTitle = headerTitle
        group.footerTitle = footerTitle
        group.items.append(objectsIn: items)
        return group
    }
    func object(at index: Int) -> WXSettingItem {
        return items[index]
    }

    func index(of obj: WXSettingItem) -> Int {
        return items.index(of: obj) ?? 0
    }

    func remove(_ obj: WXSettingItem) {
        var array = items.array()
        items.removeAll()
        array.removeAll(where: { element in element == obj })
        items.append(objectsIn: array)
    }
    func setHeaderTitle(_ headerTitle: String) {
        self.headerTitle = headerTitle
        headerHeight = getTextHeightOfText(headerTitle, font: UIFont.systemFont(ofSize: 14.0), width: APPW - 30)
    }
    func setFooterTitle(_ footerTitle: String) {
        self.footerTitle = footerTitle
        footerHeight = getTextHeightOfText(footerTitle, font: UIFont.systemFont(ofSize: 14.0), width: APPW - 30)
    }
    func getTextHeightOfText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let hLabel = UILabel(frame: UIScreen.main.bounds)
        hLabel.numberOfLines = 0
        hLabel.frame = CGRect(x: hLabel.frame.origin.x, y: hLabel.frame.origin.y, width: width, height: hLabel.frame.size.height)
        hLabel.font = font
        hLabel.text = text
        return hLabel.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT))).height
    }
}
@objcMembers
public class WXSettingItem: RLMObject,RealmCollectionValue {
    dynamic var title = ""
    dynamic var subTitle = ""
    dynamic var rightImagePath = ""
    dynamic var rightImageURL = ""
    dynamic var showDisclosureIndicator = true
    dynamic var disableHighlight = false
    dynamic var type = TLSettingItemType.default
    class func createItem(withTitle title: String) -> WXSettingItem {
        let item = WXSettingItem()
        item.title = title
        return item
    }
    override init() {
        super.init()
    }

    func cellClassName() -> String {
        switch type {
        case .default:return "TLSettingCell"
        case .titleButton:return "TLSettingButtonCell"
        case .switchBtn:return "TLSettingSwitchCell"
        default:break
        }
        return ""
    }
}
class WXAddMenuItem: NSObject {
    var type = TLAddMneuType.groupChat
    var title = ""
    var iconPath = ""
    var className: UIViewController.Type?
    class func create(with type: TLAddMneuType, title: String, iconPath: String, className: UIViewController.Type?) -> WXAddMenuItem {
        let item = WXAddMenuItem()
        item.type = type
        item.title = title
        item.iconPath = iconPath
        item.className = className
        return item
    }
}
@objcMembers
class WechatContact: RLMObject {
    dynamic var name = ""
    dynamic var avatarPath = ""
    dynamic var avatarURL = ""
    dynamic var tel = ""
    dynamic var status = TLContactStatus.friend
    dynamic var recordID: String = ""
    dynamic var email = ""
    var pinyin: String { return self.name.pinyin() }
    var pinyinInitial: String { return self.name.pinyin() }
}
@objcMembers
class WXUserSetting: RLMObject {
    dynamic var userID = ""
    dynamic var star = false
    dynamic var dismissTimeLine = false
    dynamic var prohibitTimeLine = false
    dynamic var blackList = false
}
@objcMembers
class WXUserDetail: RLMObject {
    dynamic var userID = ""
    dynamic var sex = ""
    dynamic var location = ""
    dynamic var phoneNumber = ""
    dynamic var qqNumber = ""
    dynamic var email = ""
    dynamic var albumArray = List<String>()
    dynamic var motto = ""
    dynamic var momentsWallURL = ""/// 备注信息
    dynamic var remarkInfo = ""/// 备注图片（本地地址）
    dynamic var remarkImagePath = ""/// 备注图片 (URL)
    dynamic var remarkImageURL = ""/// 标签
    dynamic var tags = List<String>()
}
@objcMembers
class WXUserChatSetting: RLMObject {
    dynamic var userID = ""
    dynamic var top = false
    dynamic var noDisturb = false
    dynamic var chatBGPath = ""
}
@objcMembers
class WXUser: RLMObject, WXChatUserProtocol, RealmCollectionValue {
    dynamic var userID: String = ""
    dynamic var avatarURL: String = ""
    dynamic var avatarPath: String = ""
    dynamic var pinyin: String = ""
    dynamic var pinyinInitial: String = ""
    dynamic var detailInfo: WXUserDetail!
    dynamic var userSetting: WXUserSetting!
    dynamic var chatSetting: WXUserChatSetting!
//    let owner = LinkingObjects(fromType: WXGroup.self, property: "users")
    dynamic var username: String = "" {
        didSet {
            if remarkName.count == 0 && nikeName.count == 0 && self.username.count > 0 {
                pinyin = username.pinyin()
                pinyinInitial = username.pinyin()
            }
        }
    }
    dynamic var nikeName: String = "" {
        didSet {
            if remarkName.count == 0 && self.nikeName.count > 0 {
                pinyin = nikeName.pinyin()
                pinyinInitial = nikeName.pinyin()
            }
        }
    }
    dynamic var remarkName: String = "" {
        didSet {
            if self.remarkName.count > 0 {
                pinyin = remarkName.pinyin()
                pinyinInitial = remarkName.pinyin()
            }
        }
    }
    dynamic var showName: String {
        return remarkName.count > 0 ? remarkName : (nikeName.count > 0 ? nikeName : username)
    }
    override init() {
        super.init()
        detailInfo = WXUserDetail()
        userSetting = WXUserSetting()
        chatSetting = WXUserChatSetting()
    }
    override static func primaryKey() -> String {
        return "userID"
    }
    static func _rlmArray() -> RLMArray<AnyObject> {
        return RLMArray(objectClassName: "WXUser")
//        return RLMArray(objectType: RLMPropertyType.any, optional: false)
    }
//    static func _nilValue() -> Self {
//        fatalError("unexpected NSNull for non-Optional type")
//    }
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
@objcMembers
class WXUserGroup: RLMObject {
    dynamic var groupName = ""
    dynamic var users = List<WXUser>()
    var count: Int {
        return users.count
    }
    override init() {
        super.init()
    }
    convenience init(groupName: String, users: [WXUser]) {
        self.init()
        self.groupName = groupName
        self.users.append(objectsIn: users)
    }
    func add(_ anObject: WXUser) {
        users.append(anObject)
    }
    func object(at index: Int) -> WXUser {
        return users[index]
    }
    override static func primaryKey() -> String {
        return "groupName"
    }
}
@objcMembers
class WXGroup: RLMObject, WXChatUserProtocol, RealmCollectionValue {
    var groupAvatarPath: String {
        return self.groupID + ".png"
    }
    dynamic var groupID = ""
    dynamic var users = List<WXUser>()
    dynamic var tags = List<String>()
    dynamic var post = ""
    dynamic var myNikeName = ""// WXUserHelper.shared.user.showName
    var pinyin: String {return groupName.pinyin()}
    var pinyinInitial: String {return groupName.pinyin()}
    dynamic var showNameInChat = false
    var count: Int {
        return users.count
    }
    var groupName: String {
        get {
            if groupName.isEmpty {
                for user: WXUser in users where !user.showName.isEmpty {
                    return user.showName
                }
                return ""
            }else{
                return groupName
            }
        }
        set {
            groupName = newValue
        }
    }
    override init() {
        super.init()
    }

    static func _rlmArray() -> RLMArray<AnyObject> {
        return RLMArray(objectClassName: "WXGroup")
    }
    func add(_ anObject: WXUser) {
        users.append(anObject)
    }
    func object(at index: Int) -> WXUser {
        return users[index]
    }
    func member(byUserID uid: String) -> WXUser? {
        for user in users where user.userID == uid {
            return user
        }
        return nil
    }
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
        return groupAvatarPath
    }
    var chat_userType: Int {
        return TLChatUserType.group.rawValue
    }
    func groupMember(byID userID: String) -> WXUser? {
        return member(byUserID: userID)
    }
    func groupMembers() -> [WXUser] {
        return users.array()
    }

    override static func primaryKey() -> String {
        return "groupID"
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
