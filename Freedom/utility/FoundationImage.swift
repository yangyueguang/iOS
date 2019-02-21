//
//  FoundationImage.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2019/1/29.
//  Copyright © 2019 薛超. All rights reserved.
//

import Foundation
let nilImage = UIImage(named:"")
enum Image: String {
    case `default` = "userLogo1"
    case logo = "userLogo"
    case code = "u_QRCode"
    case more = "u_white_more"
    case launch = "launchImage"
    case left = "u_cell_left"
    case add = "nav_add"
    case setting = "u_white_setting"
    case shopping = "CreditCard_ShoppingBag"
    case camera = "u_camora"
    case scanNet = "scan_net"
    case search = "search"
    case navi = "wnavi"
    case slider = "slider"
    case calendar = "calendar"
    case scan1 = "u_scan_1"
    case scan2 = "u_scan_2"
    case scan3 = "u_scan_3"
    case scan4 = "u_scan_4"
    case lock = "main_clock"
    case holder = "placeHoder-128"
    case back = "bj"
    case mainPhone = "main_phone"
    case arrow = "arrow"
    case music = "music"
    case wechart = "wechart"
    case a = "a"
    case u_scan = "u_scan"
    case u_Add = "u_personAdd"
    case movie = "movie"
    case snow = "snow"
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
    case barVoice = "u_voice"
    case emojiKB_tips = "EmoticonTips"
    case tipLeft = "EmoticonBigTipsLeft"
    case tipMiddle = "EmoticonBigTipsMiddle"
    case tipRight = "EmoticonBigTipsRight"
    case senderHL = "message_sender_bgHL"
    case sender = "message_sender_bg"
    case receiver = "message_receiver_bg"
    case receiverHL = "message_receiver_bgHL"
    case chatDetailAdd = "RemoveGroupMemberBtnHL"
    case logoTop = "shake_logo_top"
    case logoBottom = "shake_logo_bottom"
    case logoCenter = "ShakeHideImg_women"
    case shakeTop = "Shake_Line_Up"
    case shakeBottom = "Shake_Line_Down"
    case shakePeople = "shake_button_people"
    case shakePeopleHL = "shake_button_peopleHL"
    case shakeMusic = "shake_button_music"
    case shakeMusicHL = "shake_button_musicHL"
    case shakeTV = "shake_button_tv"
    case shakeTVHL = "shake_button_tvHL"
    case shkeImage = "Shake_Image_Path"
    case bottleDay = "bottle_backgroud_day"
    case bottleNight = "bottle_backgroud_night"
    case bottleBoard = "bottle_board"
    case bottleThrow = "bottle_button_throw"
    case bottlePickup = "bottle_button_pickup"
    case bottleMine = "bottle_button_mine"
    case momentsMore = "moments_more"
    case momentsMoreHL = "moments_moreHL"
    case scannerTopLeft = "scanner_top_left"
    case scannerTopRight = "scanner_top_right"
    case scannerBottomLeft = "scanner_bottom_left"
    case scannerBottomRight = "scanner_bottom_right"
    case scannerLine = "scanner_line"
    case corner = "icon_corner_new"

    var image: UIImage {
        var ima = UIImage(asset: rawValue)
//        assert(ima != nil, "图片资源丢失\(rawValue)")
        if ima == nil {
            print("图片资源丢失\(rawValue)")
            ima = Image.logo.image
        }
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
enum TBImage: String {
    case scanner = "TaobaoScanner"
    case  im4 = "image4.jpg"
    case xin = "xin"
    case taobaono = "taobaono"
    case hot = "hot"
    case message = "Taobaomessage"
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
enum KGImage: String {
    case noBackground = "CollectDetailPage_NoBackground.jpg"
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
enum IQYImage: String {
    case playBack = "ic_player_back"
    case groupCell = "GroupCell"
    case searchSmall = "search_small"
    case holder = "rec_holder"
    case logo = "qylogo_p"
    case camera = "wcamera"
    case history = "whistory"
    case search = "wsearch"
    case bgholder = "bg_customReview_image_default"
    case moren = "morentu"
    case titleBar = "titlebar"
    case setting = "wsetting"
    case wbell = "wbell"
    case favourite = "wfavourite"
    case vip = "wvip"
    case noData = "cache_no_data"
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
enum SImage: String {
    case compose = "tabbar_compose_button"
    case add = "tabbar_compose_icon_add"
    case slogan = "compose_slogan"
    case composeIcon = "tabbar_compose_background_icon_add"
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
enum DZImage: String {
    case personSend = "personal_icon_send"
    case login = "bg_login"
    case right = "icon_mine_accountViewRightArrow"
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
