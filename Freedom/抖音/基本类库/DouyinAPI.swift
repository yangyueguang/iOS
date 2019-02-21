
//
//  DouyinAPI.swift
//  Freedom
import UIKit
import Foundation
import Alamofire
import RxSwift
import Starscream
enum DouyinURL: String {
    //请求地址
    case BaseUrl = "http://116.62.9.17:8080/douyin/"
    //let BaseUrl:String = "http://192.168.1.2:8080/"
    //let BaseUrl:String = "http://192.168.43.45:8080/"
    //创建访客用户接口
    case createVisitor = "visitor/create"
    //根据用户id获取用户信息
    case findUser = "user"
    //获取用户发布的短视频列表数据
    case findAwemePost = "aweme/post"
    //获取用户喜欢的短视频列表数据
    case findAwemeFavorite = "aweme/favorite"
    //发送文本类型群聊消息
    case chatText = "groupchat/text"
    //发送单张图片类型群聊消息//根据id获取指定图片
    case chatImage = "groupchat/image"
    //发送多张图片类型群聊消息
    case chatImages = "groupchat/images"
    //获取群聊列表数据
    case findGroupChatList = "groupchat/list"
    //根据id删除指定群聊消息
    case deleteGroupChat = "groupchat/delete"
    //根据视频id发送评论
    case comment = "comment/post"
    //根据id删除评论
    case deleteComment = "comment/delete"
    //获取评论列表
    case findComment = "comment/list"
    var urlString: String {
        return DouyinURL.BaseUrl.rawValue + rawValue
    }
}

extension XNetKit {
    static func douyinVisitor(_ id:String, next: PublishSubject<Visitor>) {
        let param: Parameters = ["id": id, "uuid": String.uuid]
        request(DouyinURL.createVisitor.urlString, parameters: param) { (response) in
            let model = Visitor.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    static func douyinfindUser(_ uid:String, next: PublishSubject<DouYinUser>) {
        let param: Parameters = ["id": "", "uid": uid]
        request(DouyinURL.findUser.urlString, parameters: param) { (response) in
            let responseDict = FileManager.readJson2Dict(fileName: "user")
            let model = DouYinUser.parse(responseDict as NSDictionary)
            next.onNext(model)
        }
    }
    static func douyinfindPostAwemesPaged(_ uid:String,page: Int,size:Int, next: PublishSubject<[Aweme]>) {
        let param: Parameters = ["id": "", "uid": uid,"page":page,"size":size]
        request(DouyinURL.findAwemePost.urlString, parameters: param) { (response) in
            let responseDict = FileManager.readJson2Dict(fileName: "awemes")
            let model = Aweme.parses(responseDict[""] as! [Any])
            next.onNext(model as! [Aweme])
        }
    }
    static func douyinfindFavoriteAwemesPaged(_ uid:String,page: Int,size:Int = 20, next: PublishSubject<[Aweme]>) {
        let param: Parameters = ["id": "", "uid": uid,"page":page,"size":size]
        request(DouyinURL.findAwemeFavorite.urlString, parameters: param) { (response) in
            let responseDict = FileManager.readJson2Dict(fileName: "favorites")
            let model = Aweme.parses(responseDict[""] as! [Any])
            next.onNext(model as! [Aweme])
        }
    }
    static func douyinfindGroupChatsPaged(page: Int,size:Int = 20, next: PublishSubject<[GroupChat]>) {
        let param: Parameters = ["id": "","page":page,"size":size]
        request(DouyinURL.findGroupChatList.urlString, parameters: param) { (response) in
            let responseDict = FileManager.readJson2Dict(fileName: "groupchats")
            let model = GroupChat.parses(responseDict[""] as! [Any])
            next.onNext(model as! [GroupChat])
        }
    }
    static func douyinGroupChatText(text: String, next: PublishSubject<GroupChat>) {
        let param: Parameters = ["id": "","text":text]
        request(DouyinURL.chatText.urlString, parameters: param) { (response) in
            let model = GroupChat.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    static func douyinGroupChatImage(next: PublishSubject<GroupChat>) {
        let param: Parameters = ["id": "", "udid":String.uuid]
        request(DouyinURL.chatImage.urlString, parameters: param) { (response) in
            let model = GroupChat.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    static func douyinDeleteGroupChat(next: PublishSubject<BaseResponse>) {
        let param: Parameters = ["id": "", "udid":String.uuid]
        request(DouyinURL.deleteGroupChat.urlString, parameters: param) { (response) in
            let model = BaseResponse.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    static func douyinfindCommentsPaged(aweme_id: String, page: Int,size:Int = 20, next: PublishSubject<[Comment]>) {
        let param: Parameters = ["id": "","page":page,"size":size,"aweme_id":aweme_id]
        request(DouyinURL.findComment.urlString, parameters: param) { (response) in
            let responseDict = FileManager.readJson2Dict(fileName: "comments")
            let model = Comment.parses(responseDict[""] as! [Any])
            next.onNext(model as! [Comment])
        }
    }
    static func douyinCommentText(aweme_id: String, text: String, next: PublishSubject<Comment>) {
        let param: Parameters = ["id": "","text":text, "udid": String.uuid,"aweme_id":aweme_id]
        request(DouyinURL.comment.urlString, parameters: param) { (response) in
            let model = Comment.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
    static func douyinDeleteComment(cid: String, next: PublishSubject<BaseResponse>) {
        let param: Parameters = ["id": "","cid":cid, "udid": String.uuid]
        request(DouyinURL.deleteComment.urlString, parameters: param,method: .delete) { (response) in
            let model = BaseResponse.parse(response.dictionary as NSDictionary)
            next.onNext(model)
        }
    }
}
