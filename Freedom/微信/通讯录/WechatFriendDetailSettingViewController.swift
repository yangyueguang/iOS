//
//  WechatFriendDetailSettingViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2019/2/20.
//  Copyright © 2019 薛超. All rights reserved.
//

import UIKit

class WechatFriendDetailSettingViewController: WXSettingViewController {
    var user: WXUser = WXUser()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "资料设置"
        data = WXFriendHelper.shared.friendDetailSettingArray(byUserInfo: user)
    }
}
