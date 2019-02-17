//
//  Constants.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/1.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import AdSupport
import UIKit
enum NetworkError: Int {
    case HttpResquestFailed = -1000,UrlResourceFailed = -2000
}

let NetworkDomain:String = "com.start.douyin"

//请求地址
let BaseUrl:String = "http://116.62.9.17:8080/douyin/"
//let BaseUrl:String = "http://192.168.1.2:8080/"
//let BaseUrl:String = "http://192.168.43.45:8080/"

//创建访客用户接口
let CREATE_VISITOR_BY_UDID_URL:String = "visitor/create"

//根据用户id获取用户信息
let FIND_USER_BY_UID_URL:String = "user"

//获取用户发布的短视频列表数据
let FIND_AWEME_POST_BY_PAGE_URL:String = "aweme/post"
//获取用户喜欢的短视频列表数据
let FIND_AWEME_FAVORITE_BY_PAGE_URL:String = "aweme/favorite"

//发送文本类型群聊消息
let POST_GROUP_CHAT_TEXT_URL:String = "groupchat/text"
//发送单张图片类型群聊消息
let POST_GROUP_CHAT_IMAGE_URL:String = "groupchat/image"
//发送多张图片类型群聊消息
let POST_GROUP_CHAT_IMAGES_URL:String = "groupchat/images"
//根据id获取指定图片
let FIND_GROUP_CHAT_BY_IMAGE_ID_URL:String = "groupchat/image"
//获取群聊列表数据
let FIND_GROUP_CHAT_BY_PAGE_URL:String = "groupchat/list"
//根据id删除指定群聊消息
let DELETE_GROUP_CHAT_BY_ID_URL:String = "groupchat/delete"

//根据视频id发送评论
let POST_COMMENT_URL:String = "comment/post"
//根据id删除评论
let DELETE_COMMENT_BY_ID_URL:String = "comment/delete"
//获取评论列表
let FIND_COMMENT_BY_PAGE_URL:String = "comment/list"

//enum
enum LoadingType: Int {
    case LoadStateIdle
    case LoadStateLoading
    case LoadStateAll
    case LoadStateFailed
}

enum RefreshingType: Int {
    case RefreshHeaderStateIdle
    case RefreshHeaderStatePulling
    case RefreshHeaderStateRefreshing
    case RefreshHeaderStateAll
}

enum ChatEditMessageType: Int {
    case EditTextMessage
    case EditPhotoMessage
    case EditEmotionMessage
    case EditNoneMessage
}

enum MenuActionType: Int {
    case DeleteAction
    case CopyAction
    case PasteAction
}
//UDID MD5_UDID
//let UDID:String = (UIDevice.current.identifierForVendor?.uuidString)!
let UDID:String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
let MD5_UDID:String = UDID.md5()

