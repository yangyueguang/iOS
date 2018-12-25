//
//  WXMineSettingViewController.swift
//  Freedom

import Foundation
typealias CompleteBlock = ([AnyHashable]) -> Void
class WXSettingHelper: NSObject {
    var mineSettingData: [WXSettingGroup] = []
    override init() {
        super.init()
        let item1 = WXSettingItem.createItem(withTitle: ("账号与安全"))
        if (1) != 0 {
            item1.subTitle = "已保护"
            item1.rightImagePath = "u_protectHL"
        } else {
            item1.subTitle = "未保护"
            item1.rightImagePath = "u_protect"
        }
        let group1: WXSettingGroup = TLCreateSettingGroup(nil, nil, [item1])
        let item2 = WXSettingItem.createItem(withTitle: ("新消息通知"))
        let item3 = WXSettingItem.createItem(withTitle: ("隐私"))
        let item4 = WXSettingItem.createItem(withTitle: ("通用"))
        let group2: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([item2, item3, item4]))
        let item5 = WXSettingItem.createItem(withTitle: ("帮助与反馈"))
        let item6 = WXSettingItem.createItem(withTitle: ("关于微信"))
        let group3: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([item5, item6]))
        let item7 = WXSettingItem.createItem(withTitle: ("退出登录"))
        item7.type = .titleButton
        let group4: WXSettingGroup = TLCreateSettingGroup(nil, nil, [item7])
        mineSettingData.append(contentsOf: [group1, group2, group3, group4])
    }
}
class WXMineSettingViewController: WXSettingViewController {
    var helper = WXSettingHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "设置"
        data = helper.mineSettingData
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section].items[indexPath.row]
        if (item.title == "账号与安全") {
            let accountAndSafetyVC = WXAccountAndSafetyViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(accountAndSafetyVC, animated: true)
        } else if (item.title == "新消息通知") {
//            let newMessageSettingVC = WXNewMessageSettingViewController()
//            hidesBottomBarWhenPushed = true
//            navigationController?.pushViewController(newMessageSettingVC, animated: true)
        } else if (item.title == "隐私") {
//            let privacySettingVC = WXPrivacySettingViewController()
//            hidesBottomBarWhenPushed = true
//            navigationController?.pushViewController(privacySettingVC, animated: true)
        } else if (item.title == "通用") {
            let commonSettingVC = WXCommonSettingViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(commonSettingVC, animated: true)
        } else if (item.title == "帮助与反馈") {
            let helpAndFeedbackVC = WXHelpAndFeedbackViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(helpAndFeedbackVC, animated: true)
        } else if (item.title == "关于微信") {
            let aboutVC = WXAboutViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(aboutVC, animated: true)
        } else if (item.title == "退出登录") {
            let alert = UIAlertController("退出后不会删除任何历史数据，下次登录依然可以使用本账号。", "", T1: "退出登录", T2: "取消", confirm1: {

            }, confirm2: {

            })
            self.present(alert, animated: true, completion: nil)
        }
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}
