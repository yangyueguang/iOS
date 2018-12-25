//
//  WXModes.swift
//  Freedom

import Foundation
import MJExtension
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

class WXMomentFrame: NSObject {
    var height: CGFloat = 0.0
    var heightDetail: CGFloat = 0.0
    var heightExtension: CGFloat = 0.0
}

class WXMomentDetailFrame: NSObject {
    var height: CGFloat = 0.0
    var heightText: CGFloat = 0.0
    var heightImages: CGFloat = 0.0
}

class WXMomentDetail: NSObject {
    var text = ""
    var images: [String] = []
    lazy var detailFrame: WXMomentDetailFrame = {
        let detailFrame = WXMomentDetailFrame()
        detailFrame.height = 0.0
        detailFrame.heightText = heightText()
        detailFrame.height += detailFrame.heightText
        detailFrame.heightImages = heightImages()
        detailFrame.height += detailFrame.heightImages
        return detailFrame
    }()
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
}

class WXMomentExtensionFrame: NSObject {
    var height: CGFloat = 0.0
    var heightLiked: CGFloat = 0.0
    var heightComments: CGFloat = 0.0
}

class WXMomentExtension: NSObject {
    var likedFriends: [WXUser] = []
    var comments: [WXMomentComment] = []
    lazy var extensionFrame: WXMomentExtensionFrame = {
        let extensionFrame = WXMomentExtensionFrame()
        extensionFrame.height = 0.0
        if likedFriends.count > 0 || comments.count > 0 {
            extensionFrame.height += 5
        }
        extensionFrame.heightLiked = heightLiked()
        extensionFrame.height += extensionFrame.heightLiked
        extensionFrame.heightComments = heightComments()
        extensionFrame.height += extensionFrame.heightComments
        return extensionFrame
    }()
    override init() {
        super.init()
        WXMomentExtension.mj_setupObjectClass(inArray: {
            return ["likedFriends": "TLUser", "comments": "TLMomentComment"]
        })
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

class WXMoment: NSObject {
    var momentID = ""
    var user: WXUser?
    var date = Date()
    var detail: WXMomentDetail?
    var `extension` = WXMomentExtension()
    lazy var momentFrame: WXMomentFrame = {
        let _momentFrame = WXMomentFrame()
        _momentFrame.height = 76.0
        _momentFrame.heightDetail = detail?.detailFrame.height ?? 0
        _momentFrame.height += _momentFrame.heightDetail // 正文高度
        _momentFrame.heightExtension = self.extension.extensionFrame.height
        _momentFrame.height += _momentFrame.heightExtension // 拓展高度
        return _momentFrame
    }()
    override init() {
        super.init()
    }
}

class WXMomentCommentFrame: NSObject {
    var height: CGFloat = 0.0
}

class WXMomentComment: NSObject {
    var user: WXUser?
    var toUser: WXUser?
    var content = ""
    var commentFrame = WXMomentCommentFrame()
    override init() {
        super.init()
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
            return WXAddMenuItem.create(with: .groupChat, title: "发起群聊", iconPath: "nav_menu_groupchat", className: "")
        case .addFriend:
            return WXAddMenuItem.create(with: .addFriend, title: "添加朋友", iconPath: "nav_menu_addfriend", className: "TLAddFriendViewController")
        case .wallet:
            return WXAddMenuItem.create(with: .wallet, title: "收付款", iconPath: "nav_menu_wallet", className: "")
        case .scan:
            return WXAddMenuItem.create(with: .scan, title: "扫一扫", iconPath: "nav_menu_scan", className: "TLScanningViewController")
        default:
            break
        }
    }
}

class WXInfo: NSObject {
    var type = TLInfoType.defaultType
    var title = ""
    var subTitle = ""
    var subImageArray: [AnyHashable] = []
    var userInfo: Any?
    var titleColor = UIColor.black
    var buttonColor = UIColor.green
    var buttonHLColor = UIColor.green
    var buttonBorderColor = UIColor.gray
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
}
class WXMenuItem: NSObject {
    var iconPath = ""//左侧图标路径
    var title = ""//标题
    var subTitle = ""//副标题
    var rightIconURL = ""//副图片URL
    var showRightRedPoint = false//是否显示红点
    class func createMenu(withIconPath iconPath: String, title: String) -> WXMenuItem {
        let item = WXMenuItem()
        item.iconPath = iconPath
        item.title = title
        return item
    }
}

class WXSettingGroup: NSObject {
    var headerTitle = ""
    var footerTitle = ""
    var items: [WXSettingItem] = []//setcion元素
    private(set) var headerHeight: CGFloat = 0.0
    private(set) var footerHeight: CGFloat = 0.0
    private var count: Int {
        return items.count
    }
    class func createGroup(withHeaderTitle headerTitle: String, footerTitle: String, items: [WXSettingItem]) -> WXSettingGroup {
        let group = WXSettingGroup()
        group.headerTitle = headerTitle
        group.footerTitle = footerTitle
        group.items = items
        return group
    }
    func object(at index: Int) -> WXSettingItem {
        return items[index]
    }

    func index(of obj: WXSettingItem) -> Int {
        return items.index(of: obj) ?? 0
    }

    func remove(_ obj: WXSettingItem) {
        items.removeAll(where: { element in element == obj })
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

public class WXSettingItem: NSObject {
    var title = ""
    var subTitle = ""
    var rightImagePath = ""
    var rightImageURL = ""
    var showDisclosureIndicator = true
    var disableHighlight = false
    var type = TLSettingItemType.default
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
    var className = ""
    class func create(with type: TLAddMneuType, title: String, iconPath: String, className: String) -> WXAddMenuItem {
        let item = WXAddMenuItem()
        item.type = type
        item.title = title
        item.iconPath = iconPath
        item.className = className
        return item
    }
}

class WechatContact: NSObject {
    var name = ""
    var avatarPath = ""
    var avatarURL = ""
    var tel = ""
    var status = TLContactStatus.friend
    var recordID: String = ""
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
    var tags: [String] = []
}

class WXUserChatSetting: NSObject {
    var userID = ""
    var top = false
    var noDisturb = false
    var chatBGPath = ""
}

class WXUser: NSObject, WXChatUserProtocol {
    var userID = ""
    var avatarURL = ""
    var avatarPath = ""
    var pinyin = ""
    var pinyinInitial = ""
    var detailInfo = WXUserDetail()
    var userSetting = WXUserSetting()
    var chatSetting = WXUserChatSetting()
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
    var remarkName = "" {
        didSet {
            if self.remarkName.count > 0 {
                pinyin = remarkName.pinyin()
                pinyinInitial = remarkName.pinyin()
            }
        }
    }
    var showName: String {
        return remarkName.count > 0 ? remarkName : (nikeName.count > 0 ? nikeName : username)
    }
    override init() {
        super.init()
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

class WXUserGroup: NSObject {
    var groupName = ""
    var users: [WXUser] = []
    var count: Int {
        return users.count
    }
    override init() {
        super.init()
    }
    convenience init(groupName: String, users: [WXUser]) {
        self.init()
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
class WXGroup: NSObject, WXChatUserProtocol {
    lazy var groupAvatarPath = self.groupID + ".png"
    var groupID = ""
    var users: [WXUser] = []
    var post = ""
    var myNikeName = ""// WXUserHelper.shared.user.showName
    lazy var pinyin = groupName.pinyin()
    lazy var pinyinInitial = groupName.pinyin()
    var showNameInChat = false
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
        return users
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

class TLEmoji: NSObject {
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
}

class TLEmojiGroup: NSObject, WXPictureCarouselProtocol {
    var groupID = ""
    var groupName = ""
    lazy var path = FileManager.pathExpression(forGroupID: self.groupID)
    lazy var groupIconPath = "\(path)icon_\(groupID)"
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
    var data: [TLEmoji] = [] {
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
