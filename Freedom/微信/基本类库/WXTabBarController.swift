////
////  WXTabBarController.swift
////  Freedom
//
//import UIKit
//
//import SVProgressHUD
//class WXTabBarController: UITabBarController {
//    static let shared = WXTabBarController()
//    private var childVCArray: [UIViewController] = []
//    let conversationVC = WXConversationViewController()
//    let friendsVC = WXFriendsViewController()
//    let discoverVC = WXDiscoverViewController()
//    let mineVC = WXMineViewController()
//    func setupChildController(_ vc: UIViewController, image: UIImage, shImage: UIImage, title: String) {
//        vc.tabBarItem.image = image.withRenderingMode(.alwaysOriginal)
//        vc.tabBarItem.selectedImage = shImage?.withRenderingMode(.alwaysOriginal)
//        var attM: [NSAttributedString.Key : Any] = [:]
//        attM[.foregroundColor] = UIColor.gray
//        vc.tabBarItem.setTitleTextAttributes(attM as? [NSAttributedString.Key : Any], for: .normal)
//        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
//    }
//    var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    func childVCArray() -> [UIViewController] {
//        if childVCArray == nil {
//            let convNavC = WXNavigationController(rootViewController: conversationVC)
//            let friendNavC = WXNavigationController(rootViewController: friendsVC)
//            let discoverNavC = WXNavigationController(rootViewController: discoverVC)
//            let mineNavC = WXNavigationController(rootViewController: mineVC)
//            childVCArray = [convNavC, friendNavC, discoverNavC, mineNavC]
//        }
//        return childVCArray
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tabBar.backgroundColor = UIColor.lightGray
//        tabBar.tintColor = UIColor.green
//        for s: UIViewController in children {
//            setupChildController(s, image: s.tabBarItem.image, shImage: s.tabBarItem.selectedImage, title: s.title)
//        }
//        p_initThirdPartSDK() // 初始化第三方SDK
//
//        mineVC.tabBarItem.title = "我"
//        mineVC.tabBarItem.image = UIImage(named: "tabbar_me")
//        mineVC.tabBarItem.selectedImage = UIImage(named: "tabbar_meHL")
//        conversationVC.tabBarItem.title = "消息"
//        conversationVC.tabBarItem.image = UIImage(named: "tabbar_mainframe")
//        conversationVC.tabBarItem.selectedImage = UIImage(named: "tabbar_mainframeHL")
//        discoverVC.tabBarItem.title = "发现"
//        discoverVC.tabBarItem.image = UIImage(named: "tabbar_discoverS")
//        discoverVC.tabBarItem.selectedImage = UIImage(named: "tabbar_discoverHL")
//        friendsVC.tabBarItem.title = "通讯录"
//        friendsVC.tabBarItem.image = UIImage(named: "tabbar_contacts")
//        friendsVC.tabBarItem.selectedImage = UIImage(named: "tabbar_contactsHL")
//        let childItemsArray = [["rootVCClassString": "SDHomeTableViewController", "title": "微信", "imageName": "tabbar_mainframe", "selectedImageName": "tabbar_mainframeHL"], ["rootVCClassString": "SDContactsTableViewController", "title": "通讯录", "imageName": "tabbar_contacts", "selectedImageName": "tabbar_contactsHL"], ["rootVCClassString": "SDDiscoverTableViewController", "title": "发现", "imageName": "tabbar_discover", "selectedImageName": "tabbar_discoverHL"], ["rootVCClassString": "SDMeTableViewController", "title": "我", "imageName": "tabbar_me", "selectedImageName": "tabbar_meHL"]]
//        childItemsArray.enumerateObjects({ dict, idx, stop in
//            let vc = (NSClassFromString(dict["rootVCClassString"]))() as! UIViewController
//            vc.title = dict["title"]
//            var nav = WXNavigationController(rootViewController: vc)
//            let item = nav.tabBarItem
//            item.title = dict["title"]
//            item.image = UIImage(named: dict["imageName"])
//            item.selectedImage = (UIImage(named: dict["selectedImageName"]))?.withRenderingMode(.alwaysOriginal)
//            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: RGBCOLOR(0, 190, 12)], for: .selected)
//            self.addChild(nav)
//        })
//    }
//
//    func p_initThirdPartSDK() {
//        // 友盟统计
//        let config = UMAnalyticsConfig.sharedInstance() as? UMAnalyticsConfig
//        config?.appKey = UMENG_APPKEY
//        config?.ePolicy = BATCH
//        config?.channelId = APP_CHANNEL
//        MobClick.start(withConfigure: config)
//        // 网络环境监测
//        AFNetworkReachabilityManager.shared().startMonitoring()
//        // JSPatch
//        //    [JSPatch testScriptInBundle];
//        let proxy = WXMessageManager.shared
//        proxy.requestClientInitInfoSuccess({ data in
//        }, failure: { error in
//        })
//        // 初始化用户信息
//        //    DLog(@"沙盒路径:\n%@", [NSFileManager documentsPath]);
//        if UserDefaults.standard.object(forKey: "IsFirstRunApp") == nil {
//            UserDefaults.standard.set("NO", forKey: "IsFirstRunApp")
//            showAlerWithtitle("提示", message: "首次启动App，是否随机下载两组个性表情包，稍候也可在“我的”-“表情”中选择下载。", style: UIAlertController.Style.alert, ac1: {
//                return UIAlertAction(title: "确定", style: .default, handler: { action in
//                    self.p_downloadDefaultExpression()
//                })
//            }, ac2: {
//                return UIAlertAction(title: "取消", style: .cancel, handler: { action in
//                })
//            }, ac3: nil, completion: nil)
//        }
//        WXUserHelper.shared
//        WXFriendHelper.shared
//    }
//    func p_downloadDefaultExpression() {
//        SVProgressHUD.show()
//        let count: Int = 0
//        let successCount: Int = 0
//        let proxy = WXExpressionHelper.shared
//        let group = TLEmojiGroup()
//        group.groupID = "241"
//        group.groupName = "婉转的骂人"
//        group.groupIconURL = "http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.do?pId=10790"
//        group.groupInfo = "婉转的骂人"
//        group.groupDetailInfo = "婉转的骂人表情，慎用"
//        proxy.requestExpressionGroupDetail(byGroupID: group.groupID, pageIndex: 1, success: { data in
//            group.data = data
//            WXExpressionHelper.shared().downloadExpressions(withGroupInfo: group, progress: { progress in
//
//            }, success: { group in
//                let ok = WXExpressionHelper.shared().addExpressionGroup(group)
//                if !ok {
//                    DLog("表情存储失败！")
//                } else {
//                    successCount += 1
//                }
//                count += 1
//                if count == 2 {
//                    SVProgressHUD.showSuccess(withStatus: String(format: "成功下载%ld组表情！", Int(successCount)))
//                }
//            }, failure: { group, error in
//
//            })
//        }, failure: { error in
//            count += 1
//            if count == 2 {
//                SVProgressHUD.showSuccess(withStatus: String(format: "成功下载%ld组表情！", Int(successCount)))
//            }
//        })
//        let group1 = TLEmojiGroup()
//        group1.groupID = "223"
//        group1.groupName = "王锡玄"
//        group1.groupIconURL = "http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.do?pId=10482"
//        group1.groupInfo = "王锡玄 萌娃 冷笑宝宝"
//        group1.groupDetailInfo = "韩国萌娃，冷笑宝宝王锡玄表情包"
//        proxy.requestExpressionGroupDetail(byGroupID: group1.groupID, pageIndex: 1, success: { data in
//            group1.data = data
//            WXExpressionHelper.shared().downloadExpressions(withGroupInfo: group1, progress: { progress in
//            }, success: { group in
//                let ok = WXExpressionHelper.shared().addExpressionGroup(group)
//                if !ok {
//                    DLog("表情存储失败！")
//                } else {
//                    successCount += 1
//                }
//                count += 1
//                if count == 2 {
//                    SVProgressHUD.showSuccess(withStatus: String(format: "成功下载%ld组表情！", Int(successCount)))
//                }
//            }, failure: { group, error in
//
//            })
//        }, failure: { error in
//            count += 1
//            if count == 2 {
//                SVProgressHUD.showSuccess(withStatus: String(format: "成功下载%ld组表情！", Int(successCount)))
//            }
//        })
//    }
//}
