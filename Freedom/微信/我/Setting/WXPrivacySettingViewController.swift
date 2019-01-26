//
//  WXPrivacySettingViewController.swift
//  Freedom

import Foundation
class WXPrivacySettingHelper: NSObject {
    var minePrivacySettingData: [WXSettingGroup] = []
    override init() {
        super.init()
        p_initTestData()
    }
    func p_initTestData() {
        let item1 = WXSettingItem("加我为好友时需要验证")
        item1.type = .switchBtn
        let group1: WXSettingGroup = WXSettingGroup("通讯录", "", [item1])
        let item2 = WXSettingItem("向我推荐QQ好友")
        item2.type = .switchBtn
        let item3 = WXSettingItem("通过QQ号搜索到我")
        item3.type = .switchBtn
        let group2: WXSettingGroup = WXSettingGroup(nil, nil, ([item2, item3]))
        let item4 = WXSettingItem("可通过手机号搜索到我")
        item4.type = .switchBtn
        let item5 = WXSettingItem("向我推荐通讯录好友")
        item5.type = .switchBtn
        let group3: WXSettingGroup = WXSettingGroup(nil, "开启后，为你推荐已经开通微信的手机联系人", ([item4, item5]))
        let item6 = WXSettingItem("通过微信号搜索到我")
        item6.type = .switchBtn
        let group4: WXSettingGroup = WXSettingGroup(nil, "关闭后，其他用户将不能通过微信号搜索到你", [item6])
        let item7 = WXSettingItem("通讯录黑名单")
        let group5: WXSettingGroup = WXSettingGroup(nil, nil, [item7])
        let item8 = WXSettingItem("不让他(她)看我的朋友圈")
        let item9 = WXSettingItem("不看他(她)的朋友圈")
        let group6: WXSettingGroup = WXSettingGroup("朋友圈", nil, ([item8, item9]))
        let item10 = WXSettingItem("允许陌生人查看十张照片")
        item10.type = .switchBtn
        let group7: WXSettingGroup = WXSettingGroup(nil, nil, [item10])
        minePrivacySettingData.append(contentsOf: [group1, group2, group3, group4, group5, group6, group7])
    }
}
class WXPrivacySettingViewController: WXSettingViewController {
    var helper = WXPrivacySettingHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "隐私"
        helper = WXPrivacySettingHelper()
        data = helper.minePrivacySettingData
    }
}
