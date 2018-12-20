//
//  WXPrivacySettingViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/20.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
class WXPrivacySettingHelper: NSObject {
    var minePrivacySettingData: [AnyHashable] = []

    override init() {
        //if super.init()

        minePrivacySettingData = [AnyHashable]()
        p_initTestData()

    }
    func p_initTestData() {
        let item1 = WXSettingItem.createItem(withTitle: ("加我为好友时需要验证"))
        item1.type = TLSettingItemTypeSwitch
        let group1: WXSettingGroup? = TLCreateSettingGroup("通讯录", nil, [item1])

        let item2 = WXSettingItem.createItem(withTitle: ("向我推荐QQ好友"))
        item2.type = TLSettingItemTypeSwitch
        let item3 = WXSettingItem.createItem(withTitle: ("通过QQ号搜索到我"))
        item3.type = TLSettingItemTypeSwitch
        let group2: WXSettingGroup? = TLCreateSettingGroup(nil, nil, ([item2, item3]))

        let item4 = WXSettingItem.createItem(withTitle: ("可通过手机号搜索到我"))
        item4.type = TLSettingItemTypeSwitch
        let item5 = WXSettingItem.createItem(withTitle: ("向我推荐通讯录好友"))
        item5.type = TLSettingItemTypeSwitch
        let group3: WXSettingGroup? = TLCreateSettingGroup(nil, "开启后，为你推荐已经开通微信的手机联系人", ([item4, item5]))

        let item6 = WXSettingItem.createItem(withTitle: ("通过微信号搜索到我"))
        item6.type = TLSettingItemTypeSwitch
        let group4: WXSettingGroup? = TLCreateSettingGroup(nil, "关闭后，其他用户将不能通过微信号搜索到你", [item6])

        let item7 = WXSettingItem.createItem(withTitle: ("通讯录黑名单"))
        let group5: WXSettingGroup? = TLCreateSettingGroup(nil, nil, [item7])

        let item8 = WXSettingItem.createItem(withTitle: ("不让他(她)看我的朋友圈"))
        let item9 = WXSettingItem.createItem(withTitle: ("不看他(她)的朋友圈"))
        let group6: WXSettingGroup? = TLCreateSettingGroup("朋友圈", nil, ([item8, item9]))

        let item10 = WXSettingItem.createItem(withTitle: ("允许陌生人查看十张照片"))
        item10.type = TLSettingItemTypeSwitch
        let group7: WXSettingGroup? = TLCreateSettingGroup(nil, nil, [item10])

        minePrivacySettingData.append(contentsOf: [group1, group2, group3, group4, group5, group6, group7])
    }




}
class WXPrivacySettingViewController: WXSettingViewController {
    var helper: WXPrivacySettingHelper?

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "隐私"

        helper = WXPrivacySettingHelper()
        data = helper?.minePrivacySettingData
    }
}
