//
//  WXExpressionHelper.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
class WXExpressionHelper: NSObject {
    /// 默认表情（Face）
    var defaultFaceGroup: TLEmojiGroup
    /// 默认系统Emoji
    var defaultSystemEmojiGroup: TLEmojiGroup
    /// 用户表情组
    var userEmojiGroups: [Any] = []
    /// 用户收藏的表情
    var userPreferEmojiGroup: TLEmojiGroup

    private var store: WXDBExpressionStore
    let IEXPRESSION_HOST_URL = "http://123.57.155.230:8080/ibiaoqing/admin/"
    let IEXPRESSION_NEW_URL = IEXPRESSION_HOST_URL + ("expre/listBy.dopageNumber=%ld&status=Y&status1=B")
    let IEXPRESSION_BANNER_URL = IEXPRESSION_HOST_URL + ("advertisement/getAll.dostatus=on")
    let IEXPRESSION_PUBLIC_URL = IEXPRESSION_HOST_URL + ("expre/listBy.dopageNumber=%ld&status=Y&status1=B&count=yes")
    let IEXPRESSION_SEARCH_URL = IEXPRESSION_HOST_URL + ("expre/listBy.dopageNumber=1&status=Y&eName=%@&seach=yes")
    let IEXPRESSION_DETAIL_URL = IEXPRESSION_HOST_URL + ("expre/getByeId.dopageNumber=%ld&eId=%@")
    func userEmojiGroups() -> [Any] {
        return store.expressionGroups(byUid: WXUserHelper.shared().user.userID)
    }

    func addExpressionGroup(_ emojiGroup: TLEmojiGroup) -> Bool {
        let ok = store.addExpressionGroup(emojiGroup, forUid: WXUserHelper.shared().user.userID)
        if ok {
            // 通知表情键盘
            WXUserHelper.shared().updateEmojiGroupData()
        }
        return ok
    }

    func deleteExpressionGroup(byID groupID: String) -> Bool {
        let ok = store.deleteExpressionGroup(byID: groupID, forUid: WXUserHelper.shared().user.userID)
        if ok {
            // 通知表情键盘
            WXUserHelper.shared().updateEmojiGroupData()
        }
        return ok
    }

    func didExpressionGroupAlways(inUsed groupID: String) -> Bool {
        let count = store.countOfUserWhoHasExpressionGroup(groupID)
        return count > 0
    }

    func emojiGroup(byID groupID: String) -> TLEmojiGroup {
        for group: TLEmojiGroup in userEmojiGroups {
            if (group.groupID == groupID) {
                return group
            }
        }
        return nil
    }
    
    func store() -> WXDBExpressionStore {
        if store == nil {
            store = WXDBExpressionStore()
        }
        return store
    }

    func myExpressionListData() -> [AnyHashable] {
        var data: [AnyHashable] = []
        var myEmojiGroups: [AnyHashable] = nil
        if let anID = store().expressionGroups(byUid: WXUserHelper.shared().user.userID) {
            myEmojiGroups = anID
        }
        if (myEmojiGroups.count) > 0 {
            let group1: WXSettingGroup = TLCreateSettingGroup("聊天面板中的表情", nil, myEmojiGroups)
            if let aGroup1 = group1 {
                data.append(aGroup1)
            }
        }

        let userEmojis = WXSettingItem.createItem(withTitle: "添加的表情")
        let buyedEmojis = WXSettingItem.createItem(withTitle: "购买的表情")
        let group2: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([userEmojis, buyedEmojis]))
        if let aGroup2 = group2 {
            data.append(aGroup2)
        }

        return data
    }
    func defaultFaceGroup() -> TLEmojiGroup {
        if defaultFaceGroup == nil {
            defaultFaceGroup = TLEmojiGroup()
            defaultFaceGroup.type = TLEmojiTypeFace
            defaultFaceGroup.groupIconPath = "emojiKB_group_face"
            let path = Bundle.main.path(forResource: "FaceEmoji", ofType: "json")
            let data = NSData(contentsOfFile: path) as Data
            defaultFaceGroup.data = TLEmoji.mj_objectArray(withKeyValuesArray: data)
        }
        return defaultFaceGroup
    }

    func defaultSystemEmojiGroup() -> TLEmojiGroup {
        if defaultSystemEmojiGroup == nil {
            defaultSystemEmojiGroup = TLEmojiGroup()
            defaultSystemEmojiGroup.type = TLEmojiTypeEmoji
            defaultSystemEmojiGroup.groupIconPath = "emojiKB_group_face"
            let path = Bundle.main.path(forResource: "SystemEmoji", ofType: "json")
            let data = NSData(contentsOfFile: path) as Data
            defaultSystemEmojiGroup.data = TLEmoji.mj_objectArray(withKeyValuesArray: data)
        }
        return defaultSystemEmojiGroup
    }
    func downloadExpressions(withGroupInfo group: TLEmojiGroup, progress: @escaping (CGFloat) -> Void, success: @escaping (TLEmojiGroup) -> Void, failure: @escaping (TLEmojiGroup, String) -> Void) {
        let downloadQueue = DispatchQueue(label: group.groupID.utf8CString)
        let downloadGroup = DispatchGroup()

        for i in 0...group.data.count {
            downloadGroup.async(group: downloadQueue, execute: {
                let groupPath = FileManager.pathExpression(forGroupID: group.groupID)
                var emojiPath: String
                var data: Data = nil
                if i == group.data.count {
                    if let anID = group.groupID {
                        emojiPath = "\(groupPath)icon_\(anID)"
                    }
                    if let anURL = URL(string: group.groupIconURL) {
                        data = Data(contentsOf: anURL)
                    }
                } else {
                    let emoji: TLEmoji = group.data[i]
                    var urlString: String = nil
                    if let anID = emoji.emojiID {
                        urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(anID)"
                    }
                    if let aString = URL(string: urlString) {
                        data = Data(contentsOf: aString)
                    }
                    if data == nil {
                        if let anID = emoji.emojiID {
                            urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.dopId=\(anID)"
                        }
                        if let aString = URL(string: urlString) {
                            data = Data(contentsOf: aString)
                        }
                    }
                    emojiPath = "\(groupPath)\(emoji.emojiID)"
                }

                data.write(toFile: emojiPath, atomically: true)
            })
        }
        dispatch_group_notify(downloadGroup, DispatchQueue.main, {
            success(group)
        })
    }
    func requestExpressionChosenList(byPageIndex pageIndex: Int, success: @escaping (_ data: Any) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: IEXPRESSION_NEW_URL, pageIndex)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            let respArray = responseObject.mj_JSONObject()
            let status = respArray[0] as String
            if (status == "OK") {
                let infoArray = respArray[2] as [Any]
                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
                success(data)
            } else {
                failure(status)
            }
        }, failure: { task, error in
            failure(error.description())
        })
    }
    func requestExpressionChosenBannerSuccess(_ success: @escaping (Any) -> Void, failure: @escaping (String) -> Void) {
        let urlString = IEXPRESSION_BANNER_URL
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            let respArray = responseObject.mj_JSONObject()
            let status = respArray[0] as String
            if (status == "OK") {
                let infoArray = respArray[2] as [Any]
                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
                success(data)
            } else {
                failure(status)
            }
        }, failure: { task, error in
            failure(error.description())
        })
    }
    func requestExpressionPublicList(byPageIndex pageIndex: Int, success: @escaping (_ data: Any) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: IEXPRESSION_PUBLIC_URL, pageIndex)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            let respArray = responseObject.mj_JSONObject()
            let status = respArray[0] as String
            if (status == "OK") {
                let infoArray = respArray[2] as [Any]
                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
                success(data)
            } else {
                failure(status)
            }
        }, failure: { task, error in
            failure(error.description())
        })
    }
    func requestExpressionSearch(byKeyword keyword: String, success: @escaping (_ data: Any) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: IEXPRESSION_SEARCH_URL, keyword)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            let respArray = responseObject.mj_JSONObject()
            let status = respArray[0] as String
            if (status == "OK") {
                let infoArray = respArray[2] as [Any]
                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
                success(data)
            } else {
                failure(status)
            }
        }, failure: { task, error in
            failure(error.description())
        })
    }
    func requestExpressionGroupDetail(byGroupID groupID: String, pageIndex: Int, success: @escaping (_ data: Any) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: IEXPRESSION_DETAIL_URL, pageIndex, groupID)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            let respArray = responseObject.mj_JSONObject()
            let status = respArray[0] as String
            if (status == "OK") {
                let infoArray = respArray[2] as [Any]
                var data = TLEmoji.mj_objectArray(withKeyValuesArray: infoArray)
                success(data)
            } else {
                failure(status)
            }
        }, failure: { task, error in
            failure(error.description())
        })
    }
    
}
