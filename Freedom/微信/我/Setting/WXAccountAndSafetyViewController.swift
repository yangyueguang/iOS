//
//  WXAccountAndSafetyViewController.swift
//  Freedom

import Foundation
class WXAccountAndSafetyHelper: NSObject {
    func mineAccountAndSafetyData(byUserInfo userInfo: WXUser) -> [AnyHashable] {
    }

    private var data: [AnyHashable] = []

    override init() {
        //if super.init()

        data = [AnyHashable]()

    }
    func mineAccountAndSafetyData(byUserInfo userInfo: WXUser) -> [AnyHashable] {
        let username = WXSettingItem.createItem(withTitle: ("微信号"))
        if userInfo.username.length  0 > 0 {
            username.subTitle = userInfo.username
            username.showDisclosureIndicator = false
            username.disableHighlight = true
        } else {
            username.subTitle = "未设置"
        }
        let group1: WXSettingGroup = TLCreateSettingGroup(nil, nil, [username])

        let qqNumber = WXSettingItem.createItem(withTitle: ("QQ号"))
        qqNumber.subTitle = userInfo.detailInfo.qqNumber.length  0 > 0  userInfo.detailInfo.qqNumber : "未绑定"
        let phoneNumber = WXSettingItem.createItem(withTitle: ("手机号"))
        phoneNumber.subTitle = phoneNumber.subTitle.length > 0  userInfo.detailInfo.phoneNumber : "未绑定"
        let email = WXSettingItem.createItem(withTitle: ("邮箱地址"))
        email.subTitle = userInfo.detailInfo.email.length  0 > 0  userInfo.detailInfo.email : "未绑定"
        let group2: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([qqNumber, phoneNumber, email]))

        let voiceLock = WXSettingItem.createItem(withTitle: ("声音锁"))
        let password = WXSettingItem.createItem(withTitle: ("微信密码"))
        let idProtect = WXSettingItem.createItem(withTitle: ("账号保护"))
        if (1) != 0 {
            idProtect.subTitle = "已保护"
            idProtect.rightImagePath = "u_protectHL"
        } else {
            idProtect.subTitle = "未保护"
            idProtect.rightImagePath = "u_protect"
        }
        let safetyCenter = WXSettingItem.createItem(withTitle: ("微信安全中心"))
        let group3: WXSettingGroup = TLCreateSettingGroup(nil, "如果遇到账号信息泄露、忘记密码、诈骗等账号问题，可前往微信安全中心。", ([voiceLock, password, idProtect, safetyCenter]))
        data.removeAll()
        data.append(contentsOf: [group1, group2, group3])
        return data
    }


}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXAccountAndSafetyViewController: WXSettingViewController {
    var helper: WXAccountAndSafetyHelper

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "账号与安全"
        helper = WXAccountAndSafetyHelper()
        data = helper.mineAccountAndSafetyData(byUserInfo: WXUserHelper.shared().user)
    }

    // MARK: - Delegate -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row] as WXSettingItem
        if (item.title == "微信安全中心") {
            let webVC = WXWebViewController()
            webVC.url = "http://weixin110.qq.com/"
            hidesBottomBarWhenPushed = true
            navigationController.pushViewController(webVC, animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
