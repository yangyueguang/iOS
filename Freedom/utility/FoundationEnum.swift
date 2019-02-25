//
//  FoundationEnum.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/21.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
//FIXME:里面定义各种程序中要用的枚举类型
public extension UIFont {
    static var sbig: UIFont {return UIFont.systemFont(ofSize: 26)}
    static var huge: UIFont {return UIFont.systemFont(ofSize: 20)}
    static var large: UIFont {return UIFont.systemFont(ofSize: 18)}
    static var big: UIFont {return UIFont.systemFont(ofSize: 16)}
    static var normal: UIFont {return UIFont.systemFont(ofSize: 15)}
    static var middle: UIFont {return UIFont.systemFont(ofSize: 14)}
    static var small: UIFont {return UIFont.systemFont(ofSize: 12)}
    static var mini: UIFont {return UIFont.systemFont(ofSize: 10)}
    var bold: UIFont {return UIFont.boldSystemFont(ofSize: pointSize)}
}

public extension UIColor {
    class var c3: UIColor {return UIColor(hex:0x333333)}
    class var c6: UIColor {return UIColor(hex:0x666666)}
    class var c9: UIColor {return UIColor(hex:0x999999)}
    class var cd: UIColor {return UIColor(hex: 0xdddddd)}
    class var title: UIColor {return UIColor(hex: 0x363C54)}
    class var subTitle: UIColor {return UIColor(hex: 0xCDCED4)}
    class var back: UIColor {return UIColor(hex: 0xEFEFEF)}
    class var hold: UIColor {return UIColor(hex: 0xD0D0D0)}
    class var dark: UIColor {return UIColor(hex: 0x3c3c3c)}
    class var thin: UIColor {return UIColor(hex: 0x696D7F)}
    class var light: UIColor {return UIColor(hex: 0xeeeeee)}

    class var redx: UIColor {return UIColor.red}
    class var greenx: UIColor {return UIColor.green}
    class var bluex: UIColor {return UIColor.blue}
    class var yellowx: UIColor {return UIColor.yellow}
    class var blackx: UIColor {return UIColor.black }
    class var whitex: UIColor {return UIColor.white }
    class var grayx: UIColor {return UIColor.gray }
    class var alipay: UIColor { return UIColor(hex: 0x1ca1ff)}
    class func blackAlpha(_ alpha: CGFloat) -> UIColor {
        return UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: alpha)
    }
    class func whiteAlpha(_ alpha: CGFloat) -> UIColor {
        return UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: alpha)
    }
}

enum StoryName: String {
    case wechat = "WX"
    case alipay = "Alipay"
    case kugou = "Kugou"
    case iqiyi = "Iqiyi"
    case douyin = "Douyin"
    case taobao = "Taobao"
    case sina = "Sina"
    case people = "DZ"
    case topic = "Toutiao"
    case energy = "MicroEnergy"
    case freedom = "Freedom"
    case books = "Books"
    case database = "MyDatabase"
    case main = "Main"
}
class FirstRun: NSObject {
    static let shared = FirstRun()
    let defaults = UserDefaults.standard
    var wechat: Bool {
        set {
            defaults.set(wechat, forKey: StoryName.wechat.rawValue)
            defaults.synchronize()
        }
        get {
            return !defaults.bool(forKey: StoryName.wechat.rawValue)
        }
    }
    var alipay = false
    var kugou = false
    var iqiyi = false
    var douyin = false
    var taobao = false
    var sina = false
    var people = false
    var topic = false
    var energy = false
    var freedom = false
    var books = false
    var database = false
    var main = false
}
struct CellModelS {
    var title = ""
    var subTitle = ""
    var icon = ""
}
class CellModelC<T>: NSObject {
    var title = ""
    var subTitle = ""
    var icon = ""
    var target: T.Type?
    override init() {
        super.init()
    }
    convenience init(_ title: String, _ subTitle: String, _ icon: String, _ target: T.Type? = nil) {
        self.init()
        self.title = title
        self.icon = icon
        self.target = target
    }
}

//会话提示类型
enum TLClueType : Int {
    case none
    case point
    case pointWithNumber
}
//三方登陆类型
enum TLThirdPartType: String {
    case contacts = "1"
    case QQ = "2"
    case google = "3"
}
//会话类型
enum TLConversationType : Int {
    case personal // 个人
    case group // 群聊
    case `public` // 公众号
    case serverGroup // 服务组（订阅号、企业号）
}

enum TLMessageRemindType : Int {
    case normal // 正常接受
    case closed // 不提示
    case notLook // 不看
    case unlike // 不喜欢
}
//消息类型

enum TLMessageType : Int {
    case unknown
    case text // 文字
    case image // 图片
    case expression // 表情
    case voice // 语音
    case video // 视频
    case url // 链接
    case position // 位置
    case businessCard // 名片
    case system // 系统
    case other
}
// 更多键盘的选项
enum TLMoreKeyboardItemType : Int {
    case image
    case camera
    case video
    case videoCall
    case wallet
    case transfer
    case position
    case favorite
    case businessCard
    case voice
    case cards
}
enum TLScannerType : Int {
    case qr = 1 // 扫一扫 - 二维码
    case cover // 扫一扫 - 封面
    case street // 扫一扫 - 街景
    case translate // 扫一扫 - 翻译
}

@objc enum TLEmojiType : Int {
    case emoji
    case favorite
    case face
    case image
    case imageWithTitle
    case other
}
enum TLChatBarStatus : Int {
    case `default`
    case voice
    case emoji
    case more
    case keyboard
}

enum GestureType : Int {
    case tapGesType = 1
    case longGesType
}
