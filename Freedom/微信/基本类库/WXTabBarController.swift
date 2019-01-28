//
//  WXTabBarController.swift
//  Freedom

import UIKit
import SnapKit
import XCarryOn
import XExtension
final class WXTabBarController: UITabBarController {
    static let shared = WXTabBarController()
    let conversationVC = WXConversationViewController()
    let friendsVC = WXFriendsViewController()
    let discoverVC = WXDiscoverViewController()
    let mineVC = WXMineViewController()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = UIColor.lightGray
        tabBar.tintColor = UIColor.green
        let proxy = WXMessageManager.shared
        proxy.requestClientInitInfoSuccess({ data in
        }, failure: { error in
        })
        if FirstRun.shared.wechat {
            FirstRun.shared.wechat = false
            self.p_downloadDefaultExpression()
        }
    }
    func p_downloadDefaultExpression() {
        XHud.show()
        var count: Int = 0
        var successCount: Int = 0
        let proxy = WXExpressionHelper.shared
        let group = TLEmojiGroup()
        group.groupID = "241"
        group.groupName = "婉转的骂人"
        group.groupIconURL = "http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.do?pId=10790"
        group.groupInfo = "婉转的骂人"
        group.groupDetailInfo = "婉转的骂人表情，慎用"
        proxy.requestExpressionGroupDetail(byGroupID: group.groupID, pageIndex: 1, success: { data in
            XHud.hide()
            group.data.removeAll()
            group.data.append(objectsIn: data)
            WXExpressionHelper.shared.downloadExpressions(withGroupInfo: group, progress: { progress in

            }, success: { group in
                WXExpressionHelper.shared.addExpressionGroup(group)
                successCount += 1
                count += 1
                if count == 2 {
                    self.noticeSuccess("成功下载\(successCount)组表情！")
                }
            }, failure: { group, error in

            })
        }, failure: { error in
            XHud.hide()
            count += 1
            if count == 2 {
                self.noticeSuccess("成功下载\(successCount)组表情！")
            }
        })
        let group1 = TLEmojiGroup()
        group1.groupID = "223"
        group1.groupName = "王锡玄"
        group1.groupIconURL = "http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.do?pId=10482"
        group1.groupInfo = "王锡玄 萌娃 冷笑宝宝"
        group1.groupDetailInfo = "韩国萌娃，冷笑宝宝王锡玄表情包"
        proxy.requestExpressionGroupDetail(byGroupID: group1.groupID, pageIndex: 1, success: { data in
            group1.data.removeAll()
            group1.data.append(objectsIn: data)
            WXExpressionHelper.shared.downloadExpressions(withGroupInfo: group1, progress: { progress in
            }, success: { group in
                WXExpressionHelper.shared.addExpressionGroup(group)
                successCount += 1
                count += 1
                if count == 2 {
                    self.noticeSuccess("成功下载\(successCount)组表情！")
                }
            }, failure: { group, error in

            })
        }, failure: { error in
            count += 1
            if count == 2 {
                self.noticeSuccess("成功下载\(successCount)组表情！")
            }
        })
    }
}
