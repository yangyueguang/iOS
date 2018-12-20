//
//  WXMineSettingViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/20.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
typealias CompleteBlock = ([AnyHashable]?) -> Void
class WXSettingHelper: NSObject {
    var mineSettingData: [AnyHashable] = []

    override init() {
        //if super.init()

        mineSettingData = [AnyHashable]()
        p_initTestData()

    }
    func p_initTestData() {
        let item1 = WXSettingItem.createItem(withTitle: ("账号与安全"))
        if (1) != 0 {
            item1.subTitle = "已保护"
            item1.rightImagePath = "u_protectHL"
        } else {
            item1.subTitle = "未保护"
            item1.rightImagePath = "u_protect"
        }
        let group1: WXSettingGroup? = TLCreateSettingGroup(nil, nil, [item1])

        let item2 = WXSettingItem.createItem(withTitle: ("新消息通知"))
        let item3 = WXSettingItem.createItem(withTitle: ("隐私"))
        let item4 = WXSettingItem.createItem(withTitle: ("通用"))
        let group2: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([item2, item3, item4]))

        let item5 = WXSettingItem.createItem(withTitle: ("帮助与反馈"))
        let item6 = WXSettingItem.createItem(withTitle: ("关于微信"))
        let group3: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([item5, item6]))

        let item7 = WXSettingItem.createItem(withTitle: ("退出登录"))
        item7.type = TLSettingItemTypeTitleButton
        let group4: WXSettingGroup? = TLCreateSettingGroup(nil, nil, [item7])

        mineSettingData.append(contentsOf: [group1, group2, group3, group4])
    }



}
class WXMineSettingViewController: WXSettingViewController {
    var helper: WXSettingHelper?

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "设置"

        helper = WXSettingHelper()
        data = helper?.mineSettingData
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row] as? WXSettingItem
        if (item?.title == "账号与安全") {
            let accountAndSafetyVC = WXAccountAndSafetyViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(accountAndSafetyVC, animated: true)
        } else if (item?.title == "新消息通知") {
            let newMessageSettingVC = WXNewMessageSettingViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(newMessageSettingVC, animated: true)
        } else if (item?.title == "隐私") {
            let privacySettingVC = WXPrivacySettingViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(privacySettingVC, animated: true)
        } else if (item?.title == "通用") {
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
            showAlerWithtitle("退出后不会删除任何历史数据，下次登录依然可以使用本账号。", message: nil, style: UIAlertController.Style.actionSheet, ac1: {
                return UIAlertAction(title: "退出登录", style: .default, handler: { action in
                })
            }, ac2: {
                return UIAlertAction(title: "取消", style: .cancel, handler: { action in

                })
            }, ac3: nil, completion: nil)
        }
        super.tableView(tableView, didSelectRowAt: indexPath)
    }




}
