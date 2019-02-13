//
//  WXAPI.swift
//  Freedom
import UIKit
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
                    if let anURL = URL(string: group.groupIconURL) {
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
}
