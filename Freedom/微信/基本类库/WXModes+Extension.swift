//
//  WXModes.swift
//  Freedom
import Realm
import RealmSwift
import Foundation
import XExtension
func TLCreateSettingGroup(_ Header: String?,_ Footer: String?, _ Items: [WXSettingItem]) -> WXSettingGroup {
    return WXSettingGroup.createGroup(withHeaderTitle: Header ?? "", footerTitle: Footer ?? "", items: Items)
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
extension WechatContact {
    var pinyin: String { return self.name.pinyin() }
    var pinyinInitial: String { return self.name.pinyin() }
}
extension WXMomentDetail {
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
                let row: Int = Int((images.count / 3) + (images.count % 3 == 0 ? 0 : 1))
                height += APPW - 70.0 * 0.31 * CGFloat(row) + space * CGFloat((row - 1))
            }
        }
        return height
    }
    func initValue() {
        detailFrame = WXMomentDetailFrame()
        detailFrame.height = 0.0
        detailFrame.heightText = heightText()
        detailFrame.height += detailFrame.heightText
        detailFrame.heightImages = heightImages()
        detailFrame.height += detailFrame.heightImages
    }
}

extension WXMomentExtension {
    func initValue() {
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
        for comment: WXMomentComment in (comments as! [WXMomentComment]) {
            height += comment.commentFrame.height
        }
        return height
    }
}
extension WXMoment {
    func initValue() {
        self.extension = WXMomentExtension()
        momentFrame = WXMomentFrame()
        momentFrame.height = 76.0
        momentFrame.heightDetail = detail.detailFrame.height 
        momentFrame.height += momentFrame.heightDetail // 正文高度
        momentFrame.heightExtension = self.extension.extensionFrame.height
        momentFrame.height += momentFrame.heightExtension // 拓展高度

    }
}
extension WXMomentComment: RealmCollectionValue {
    private func initValue() {
        commentFrame = WXMomentCommentFrame()
        commentFrame.height = 35.0
    }
}

extension WXMenuItem {
    class func createMenu(withIconPath iconPath: String, title: String) -> WXMenuItem {
        let item = WXMenuItem()
        item.iconPath = iconPath
        item.title = title
        return item
    }
}

extension WXSettingGroup {
    private var count: Int {
        return Int(items.count) 
    }
    class func createGroup(withHeaderTitle headerTitle: String, footerTitle: String, items: [WXSettingItem]) -> WXSettingGroup {
        let group = WXSettingGroup()
        group.headerTitle = headerTitle
        group.footerTitle = footerTitle
        group.items.addObjects(items as NSFastEnumeration)
        return group
    }
    func object(at index: Int) -> WXSettingItem {
        return items[UInt(index)] 
    }

    func index(of obj: WXSettingItem) -> Int {
        return Int(items.index(of: obj) )
    }

    func remove(_ obj: WXSettingItem) {
//        items.remove(obj)
    }
    func setHeaderTitle(_ headerTitle: String) {
        self.headerTitle = headerTitle
//        self.headerHeight = getTextHeightOfText(headerTitle, font: UIFont.systemFont(ofSize: 14.0), width: APPW - 30)
    }
    func setFooterTitle(_ footerTitle: String) {
        self.footerTitle = footerTitle
//        self.footerHeight = getTextHeightOfText(footerTitle, font: UIFont.systemFont(ofSize: 14.0), width: APPW - 30)
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
extension WXSettingItem: RealmCollectionValue {
    class func createItem(withTitle title: String) -> WXSettingItem {
        let item = WXSettingItem()
        item.title = title
        return item
    }
    func cellClassName() -> String {
        switch type {
        case .defalut1:return "TLSettingCell"
        case .titleButton:return "TLSettingButtonCell"
        case .switchBtn:return "TLSettingSwitchCell"
        default:break
        }
        return ""
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
    func initValue(){
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
extension WXUserGroup {
    var count: Int {
        return Int(users.count)
    }
    convenience init(groupName: String, users: [WXUser]) {
        self.init()
        self.groupName = groupName
        self.users.addObjects(users as NSFastEnumeration)
    }
}
extension WXGroup: WXChatUserProtocol, RealmCollectionValue {
    var groupAvatarPath: String {
        return self.groupID + ".png"
    }
    var pinyin: String {return groupName.pinyin()}
    var pinyinInitial: String {return groupName.pinyin()}
    var count: Int {
        return Int(users.count)
    }
    func add(_ anObject: WXUser) {
        users.add(anObject)
    }
    func object(at index: Int) -> WXUser {
        return users.object(at: UInt(index)) as! WXUser
    }
    func member(byUserID uid: String) -> WXUser? {
        for user in (users as! [WXUser]) where user.userID == uid {
            return user as! WXUser
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
        return users as! [WXUser]
    }
}

//FIXME: 本类🎄
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
