//
//  WXModes.swift
//  Freedom
//
//  Created by uper S on 2021/8/30.
//  Copyright © 2021 薛超. All rights reserved.
//

import Foundation
class CRRouteLine: NSObject {
    var CodeID = 0
}

class WXModes: NSObject {
    var id = 0;
    var code = 0;
    var isLike = false;
    var longitude = 30.0;
    var tags = [AnyHashable]();
    var charge = "";
    var groupId = 0;
}

enum XContactStatus : Int {
    case stranger
    case friend
    case wait
}

class WechatContact: NSObject {
var name = "";
var avatarPath = "";
var avatarURL = "";
var tel = "";
    var status = XContactStatus.stranger;
var recordID = 0;
var email = "";
}

class WXUserSetting: NSObject {
var userID = "";
var star = false;
var dismissTimeLine = false;
var prohibitTimeLine = false;
var blackList = false
}

class WXUserDetail: NSObject {
var userID = "";
var sex = ""
var location = ""
var phoneNumber = ""
var qqNumber = ""
var email = ""
var albumArray = [AnyHashable]()
var motto = ""
var momentsWallURL = ""
var remarkInfo = ""
var remarkImagePath = ""
var remarkImageURL = ""
var tags = [AnyHashable]()
}

class WXUserChatSetting: NSObject {
var userID = ""
var top = false
var noDisturb = false
var chatBGPath = ""
}


class WXModel: NSObject {
var userID = ""
var username = ""
var nikeName = ""
var avatarURL = ""
var avatarPath = ""

    func groupMembers() -> [WXModel] {
        return []
    }
    func isUser() -> Bool{
        return true
    }
    func groupMemberbyID(_ id: String)-> WXModel {
        return WXModel()
    }
}

class WXUser : WXModel {
var remarkName = ""
var showName = ""
    var detailInfo = WXUserDetail()
var userSetting = ""
var chatSetting = ""
    
    func defaultPropertyValues() -> Dictionary<String, Any> {
        var detail = WXUserDetail()
        var setting = WXUserSetting()
        var chatSet = WXUserChatSetting()
        return [
            "detailInfo": detail,
            "userSetting":setting,
            "chatSetting":chatSet,
            "avatarPath":"",
            "nikeName":""
        ]
    }
}

class WXGroup : WXModel {
var users = [WXUser]();
var post = ""
var myNikeName = ""
var pinyin = ""
var pinyinInitial = ""
var count = 0
var showNameInChat = false

    override func groupMemberbyID(_ userID: String) -> WXUser{
        if self.users.count > 0 {
            return self.users[0]
        }
        return WXUser()
    }
    func groupMembers() -> [WXUser] {
        return self.users
    }
    func user() -> WXUser{
        var user = WXUser()
        user.userID = self.userID;
        user.username = self.username;
        return user
    }
    override func isUser() -> Bool {
        return false
    }
}

class WXUserGroup : NSObject {
var groupName = ""
var users = [AnyHashable]()
}

class WXMomentDetail : NSObject {
var text = ""
var images = [AnyHashable]()
}

class WXMomentComment : NSObject {
    var user:WXUser?
    var toUser:WXUser?
var content = ""
}

class WXMomentExtension : NSObject {
var likedFriends = [AnyHashable]()
var comments = [AnyHashable]()
}

class WXMoment : NSObject {
var momentID = 0
    var user = WXUser()
    var date: NSDate?
    var detail = WXMomentDetail()
    var extensio = WXMomentExtension()
}

class WXInfo : NSObject {
var type = 0
var title = ""
var subTitle = ""
var subImageArray = [AnyHashable]()
var userInfo = [AnyHashable]()
var showDisclosureIndicator = false
var disableHighlight = false
}


