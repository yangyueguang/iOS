//
//  WXAPI.swift
//  Freedom
import UIKit
import XCarryOn
import XExtension
enum WXExpressionURL: String {
    case host = "http://123.57.155.230:8080/ibiaoqing/admin/"
    case emojiHost1 = "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId="
    case emojiHost2 = "http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.dopId="
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
                    if let anURL = group.groupIconURL.url {
                        data = try! Data(contentsOf: anURL)
                    }
                } else {
                    let emoji: TLEmoji = group.data[i]
                    var urlString = WXExpressionURL.emojiHost1.rawValue + emoji.emojiID
                    if let aString = URL(string: urlString) {
                        data = try! Data(contentsOf: aString)
                    }
                    if data == nil {
                        urlString = WXExpressionURL.emojiHost2.rawValue + emoji.emojiID
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
        XNetKit.kit.request(urlString, parameters: nil, method: .get) { (response) in
            print(response.dictionary)
            let groups = TLEmojiGroup.parses(response.dictionary["ds"] as! [Any])
            success(groups as! [TLEmojiGroup])
        }
    }
    func requestExpressionChosenBannerSuccess(_ success: @escaping ([TLEmojiGroup]) -> Void, failure: @escaping (String) -> Void) {
        let urlString = WXExpressionURL.banner.urlString
        XNetKit.kit.request(urlString, parameters: nil, method: .get) { (response) in
            print(response.dictionary)
            let groups = TLEmojiGroup.parses(response.dictionary["ds"] as! [Any])
            success(groups as! [TLEmojiGroup])
        }
    }
    func requestExpressionPublicList(byPageIndex pageIndex: Int, success: @escaping (_ data: [TLEmojiGroup]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: WXExpressionURL.publicUrl.urlString, pageIndex)
        XNetKit.kit.request(urlString, parameters: nil, method: .get) { (response) in
            print(response.dictionary)
            let groups = TLEmojiGroup.parses(response.dictionary["ds"] as! [Any])
            success(groups as! [TLEmojiGroup])
        }
    }
    func requestExpressionSearch(byKeyword keyword: String, success: @escaping (_ data: [TLEmojiGroup]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: WXExpressionURL.search.urlString, keyword)
        XNetKit.kit.request(urlString, parameters: nil, method: .get) { (response) in
            print(response.dictionary)
            let groups = TLEmojiGroup.parses(response.dictionary["ds"] as! [Any])
            success(groups as! [TLEmojiGroup])
        }
    }
    func requestExpressionGroupDetail(byGroupID groupID: String, pageIndex: Int, success: @escaping (_ data: [TLEmoji]) -> Void, failure: @escaping (_ error: String) -> Void) {
        let urlString = String(format: WXExpressionURL.detail.urlString, pageIndex, groupID)
        XNetKit.kit.request(urlString, parameters: nil) { (response) in
            print(response.dictionary)
            let emojis = TLEmoji.parses(response.dictionary["ds"] as! [Any])
            success(emojis as! [TLEmoji])
        }
    }

    func downloadDefaultExpression() {
        XHud.show()
        var count: Int = 0
        var successCount: Int = 0
        let group = TLEmojiGroup()
        group.groupID = "241"
        group.groupName = "婉转的骂人"
        group.groupIconURL = "http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.do?pId=10790"
        group.groupInfo = "婉转的骂人"
        group.groupDetailInfo = "婉转的骂人表情，慎用"
        XNetKit.kit.requestExpressionGroupDetail(byGroupID: group.groupID, pageIndex: 1, success: { data in
            XHud.hide()
            group.data.removeAll()
            group.data.append(objectsIn: data)
            XNetKit.kit.downloadExpressions(withGroupInfo: group, progress: { progress in

            }, success: { group in
                WXExpressionHelper.shared.addExpressionGroup(group)
                successCount += 1
                count += 1
                if count == 2 {
                    print("成功下载\(successCount)组表情！")
                }
            }, failure: { group, error in

            })
        }, failure: { error in
            XHud.hide()
            count += 1
            if count == 2 {
                print("成功下载\(successCount)组表情！")
            }
        })
        let group1 = TLEmojiGroup()
        group1.groupID = "223"
        group1.groupName = "王锡玄"
        group1.groupIconURL = "http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.do?pId=10482"
        group1.groupInfo = "王锡玄 萌娃 冷笑宝宝"
        group1.groupDetailInfo = "韩国萌娃，冷笑宝宝王锡玄表情包"
        XNetKit.kit.requestExpressionGroupDetail(byGroupID: group1.groupID, pageIndex: 1, success: { data in
            group1.data.removeAll()
            group1.data.append(objectsIn: data)
            XNetKit.kit.downloadExpressions(withGroupInfo: group1, progress: { progress in
            }, success: { group in
                WXExpressionHelper.shared.addExpressionGroup(group)
                successCount += 1
                count += 1
                if count == 2 {
                    print("成功下载\(successCount)组表情！")
                }
            }, failure: { group, error in

            })
        }, failure: { error in
            count += 1
            if count == 2 {
                print("成功下载\(successCount)组表情！")
            }
        })
    }

}
