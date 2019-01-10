//
//  WXTabBarController.swift
//  Freedom

import UIKit
import SnapKit
import XCarryOn
import XExtension
class WXTabBarController: UITabBarController {
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
        setupChildController(conversationVC, imageName: "tabbar_mainframe", shImageName: "tabbar_mainframeHL", title: "消息")
        setupChildController(friendsVC, imageName: "tabbar_contacts", shImageName: "tabbar_contactsHL", title: "通讯录")
        setupChildController(discoverVC, imageName: "tabbar_discoverS", shImageName: "tabbar_discoverHL", title: "发现")
        setupChildController(mineVC, imageName: "tabbar_me", shImageName: "tabbar_meHL", title: "我")
        p_initThirdPartSDK() // 初始化第三方SDK
    }
    func setupChildController(_ vc: UIViewController, imageName: String, shImageName: String, title: String?) {
        let image = UIImage(named: imageName)
        let shImage = UIImage(named: shImageName)
        vc.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = shImage?.withRenderingMode(.alwaysOriginal)
        var attM: [NSAttributedString.Key : Any] = [:]
        attM[.foregroundColor] = UIColor.gray
        vc.tabBarItem.setTitleTextAttributes(attM, for: .normal)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(0, 190, 12)], for: .selected)
        let nav = WXNavigationController(rootViewController: vc)
        self.addChild(nav)
    }
    func p_initThirdPartSDK() {
        // 友盟统计
        let config = UMAnalyticsConfig.sharedInstance()
        config?.appKey = UMENG_APPKEY
        config?.ePolicy = BATCH
        config?.channelId = APP_CHANNEL
        MobClick.start(withConfigure: config)
        // 网络环境监测
        AFNetworkReachabilityManager.shared().startMonitoring()
        let proxy = WXMessageManager.shared
        proxy.requestClientInitInfoSuccess({ data in
        }, failure: { error in
        })
        // 初始化用户信息
        Dlog("沙盒路径:\n\(FileManager.documentsPath())");
        if UserDefaults.standard.object(forKey: "IsFirstRunApp") == nil {
            UserDefaults.standard.set("NO", forKey: "IsFirstRunApp")
            let alert = UIAlertController("提示", "首次启动App，是否随机下载两组个性表情包，稍候也可在“我的”-“表情”中选择下载。", T1: "确定", T2: "取消", confirm1: {
                self.p_downloadDefaultExpression()
            }, confirm2: {

            })
            self.present(alert, animated: true, completion: nil)
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
            group.data = data
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
            group1.data = data
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
