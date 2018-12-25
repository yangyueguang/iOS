//
//  WXNewMessageSettingViewController.swift
//  Freedom

import Foundation
class WXNewMessageSettingHelper: NSObject {
    var mineNewMessageSettingData: [WXSettingGroup] = []
    override init() {
        super.init()
        let item1 = WXSettingItem.createItem(withTitle: ("接受新消息通知"))
        item1.subTitle = "已开启"
        item1.showDisclosureIndicator = false
        let group1: WXSettingGroup = TLCreateSettingGroup(nil, "如果你要关闭或开启微信的新消息通知，请在iPhone的“设置” - “通知”功能中，找到应用程序“微信”更改。", [item1])
        let item2 = WXSettingItem.createItem(withTitle: ("通知显示消息详情"))
        item2.type = .switchBtn
        let group2: WXSettingGroup = TLCreateSettingGroup(nil, "关闭后，当收到微信消息时，通知提示将不显示发信人和内容摘要。", [item2])
        let item3 = WXSettingItem.createItem(withTitle: ("功能消息免打扰"))
        let group3: WXSettingGroup = TLCreateSettingGroup(nil, "设置系统功能消息提示声音和振动时段。", [item3])
        let item4 = WXSettingItem.createItem(withTitle: ("声音"))
        item4.type = .switchBtn
        let item5 = WXSettingItem.createItem(withTitle: ("震动"))
        item5.type = .switchBtn
        let group4: WXSettingGroup = TLCreateSettingGroup(nil, "当微信在运行时，你可以设置是否需要声音或者振动。", ([item4, item5]))
        let item6 = WXSettingItem.createItem(withTitle: ("朋友圈照片更新"))
        item6.type = .switchBtn
        let group5: WXSettingGroup = TLCreateSettingGroup(nil, "关闭后，有朋友更新照片时，界面下面的“发现”切换按钮上不再出现红点提示。", [item6])
        mineNewMessageSettingData.append(contentsOf: [group1, group2, group3, group4, group5])
    }
}
class WXNewMessageSettingViewController: WXSettingViewController {
    var helper = WXNewMessageSettingHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "新消息通知"
        data = helper.mineNewMessageSettingData
    }
}
