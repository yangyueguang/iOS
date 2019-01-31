//
//  WXAPI.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2019/1/31.
//  Copyright © 2019 薛超. All rights reserved.
//

import UIKit
enum WXExpressionURL: String {
    case host = "http://123.57.155.230:8080/ibiaoqing/admin/"
    case newUrl = "expre/listBy.dopageNumber=%ld&status=Y&status1=B"
    case banner = "advertisement/getAll.dostatus=on"
    case publicUrl = "expre/listBy.dopageNumber=%ld&status=Y&status1=B&count=yes"
    case search = "expre/listBy.dopageNumber=1&status=Y&eName=%@&seach=yes"
    case detail = "expre/getByeId.dopageNumber=%ld&eId=%@"
    var urlString: String {
        return WXExpressionURL.host.rawValue + rawValue
    }
}
extension XNetKit {

    func downloadExpressions(withGroupInfo group: TLEmojiGroup, progress: @escaping (CGFloat) -> Void, success: @escaping (TLEmojiGroup) -> Void, failure: @escaping (TLEmojiGroup, String) -> Void) {
        let downloadQueue = DispatchQueue(label: group.groupID)
        let downloadGroup = DispatchGroup()
        for i in 0...group.data.count {
            downloadQueue.async(group: downloadGroup) {
                let groupPath = FileManager.pathExpression(forGroupID: group.groupID)
                var emojiPath: String
                var data: Data?
                if i == group.data.count {
                    emojiPath = "\(groupPath)icon_\(group.groupID)"
                    if let anURL = URL(string: group.groupIconURL) {
                        data = try! Data(contentsOf: anURL)
                    }
                } else {
                    let emoji: TLEmoji = group.data[i]
                    var urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(emoji.emojiID)"
                    if let aString = URL(string: urlString) {
                        data = try! Data(contentsOf: aString)
                    }
                    if data == nil {
                        urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.dopId=\(emoji.emojiID)"
                        if let aString = URL(string: urlString) {
                            data = try! Data(contentsOf: aString)
                        }
                    }
                    emojiPath = "\(groupPath)\(emoji.emojiID)"
                }
                try! data?.write(to: URL(fileURLWithPath: emojiPath))
            }
        }
        downloadGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            success(group)
        }))
    }
    func requestExpressionChosenList(byPageIndex pageIndex: Int, success: @escaping (_ data: [TLEmojiGroup]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: WXExpressionURL.newUrl.urlString, pageIndex)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            //            let respArray = (responseObject as! NSArray).mj_JSONObject()!
            //            let status = respArray[0] as String
            //            if (status == "OK") {
            //                let infoArray = respArray[2] as [Any]
            //                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
            //                success(data)
            //            } else {
            //                failure(status)
            //            }
        }, failure: { task, error in
            failure(error.localizedDescription)
        })
    }
    func requestExpressionChosenBannerSuccess(_ success: @escaping ([TLEmojiGroup]) -> Void, failure: @escaping (String) -> Void) {
        let urlString = WXExpressionURL.banner.urlString
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            //            let respArray = responseObject.mj_JSONObject()
            //            let status = respArray[0] as String
            //            if (status == "OK") {
            //                let infoArray = respArray[2] as [Any]
            //                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
            //                success(data)
            //            } else {
            //                failure(status)
            //            }
        }, failure: { task, error in
            failure(error.localizedDescription)
        })
    }
    func requestExpressionPublicList(byPageIndex pageIndex: Int, success: @escaping (_ data: [TLEmojiGroup]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: WXExpressionURL.publicUrl.urlString, pageIndex)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            //            let respArray = responseObject.mj_JSONObject()
            //            let status = respArray[0] as String
            //            if (status == "OK") {
            //                let infoArray = respArray[2] as [Any]
            //                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
            //                success(data)
            //            } else {
            //                failure(status)
            //            }
        }, failure: { task, error in
            failure(error.localizedDescription)
        })
    }
    func requestExpressionSearch(byKeyword keyword: String, success: @escaping (_ data: [TLEmojiGroup]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: WXExpressionURL.search.urlString, keyword)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            //            let respArray = responseObject.mj_json()
            //            let status = respArray[0] as String
            //            if (status == "OK") {
            //                let infoArray = respArray[2] as [Any]
            //                var data = TLEmojiGroup.mj_objectArray(withKeyValuesArray: infoArray)
            //                success(data)
            //            } else {
            //                failure(status)
            //            }
        }, failure: { task, error in
            failure(error.localizedDescription)
        })
    }
    func requestExpressionGroupDetail(byGroupID groupID: String, pageIndex: Int, success: @escaping (_ data: [TLEmoji]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: WXExpressionURL.detail.urlString, pageIndex, groupID)
        AFHTTPSessionManager().post(urlString, parameters: nil, progress: nil, success: { task, responseObject in
            //            let respArray = responseObject.mj_JSONObject()
            //            let status = respArray[0] as String
            //            if (status == "OK") {
            //                let infoArray = respArray[2] as [Any]
            //                var data = TLEmoji.mj_objectArray(withKeyValuesArray: infoArray)
            //                success(data)
            //            } else {
            //                failure(status)
            //            }
        }, failure: { task, error in
            failure(error.localizedDescription)
        })
    }
}
