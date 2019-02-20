//
//  FoundationImage.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2019/1/29.
//  Copyright © 2019 薛超. All rights reserved.
//

import Foundation

enum Image: String {
    case `default` = "userLogo1"
    case logo = "userLogo"
    case code = "u_QRCode"
    case more = "u_white_more"
    case left = "u_cell_left"
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
enum WXImage: String {
    case `default` = "userLogo"
    case icon = "icon"
    case addFriend = "u_white_addfriend"
    case add = "u_message_add"
    case addHL = "u_message_addHL"
    case voice = "u_message_voicek"
    case voiceHL = "u_message_voicekHL"
    case keyboard = "u_message_keyboard"
    case keyboardHL = "u_message_keyboardHL"
    case face = "u_message_face"
    case faceHL = "u_message_faceHL"
    case barVoice = "searchBar_voice"
    case barVoiceHL = "searchBar_voice_HL"
    case emojiKB_tips = "emojiKB_tips"
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
enum ALImage: String {
    case icon = ""
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
extension UIImage {
    convenience init?(asset: String) {
        self.init(named: asset, in: Bundle.main, compatibleWith: nil)
    }
}
