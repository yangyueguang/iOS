//
//  FoundationEnum.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/21.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
//FIXME:里面定义各种程序中要用的枚举类型

//会话提示类型
enum TLClueType : Int {
    case none
    case point
    case pointWithNumber
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
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
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

enum TLAddMneuType : Int {
    case groupChat = 0
    case addFriend
    case scan
    case wallet
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
    case `init`
    case voice
    case emoji
    case more
    case keyboard
}

enum GestureType : Int {
    case tapGesType = 1
    case longGesType
}
