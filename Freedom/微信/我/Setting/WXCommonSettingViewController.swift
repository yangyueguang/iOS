//
//  WXCommonSettingViewController.swift
//  Freedom

import Foundation
class WXChatFontSettingView: UIView {
    var curFontSize: CGFloat = 0.0
    var fontSizeChangeTo: ((_ size: CGFloat) -> Void)
    var miniFontLabel: UILabel
    var maxFontLabel: UILabel
    var standardFontLabel: UILabel
    var slider: UISlider
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white
        addSubview(miniFontLabel)
        addSubview(maxFontLabel)
        addSubview(standardFontLabel)
        addSubview(slider)
        p_addMasonry()

    }

    func setCurFontSize(_ curFontSize: CGFloat) {
        self.curFontSize = curFontSize
        slider.value = curFontSize
    }

    // MARK: - Event Response -
    func sliderValueChanged(_ sender: UISlider) {
        var value = Int(sender.value  0)
        value = ((sender.value  0.0) - Float(value)) > 0.5  value + 1 : value
        if value == Int(curFontSize) {
            return
        }
        curFontSize = CGFloat(value)
        if fontSizeChangeTo {
            fontSizeChangeTo(value)
        }
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func p_addMasonry() {
        miniFontLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.slider.mas_left)
            make.bottom.mas_equalTo(self.slider.mas_top).mas_offset(-6)
        })

        maxFontLabel.mas_makeConstraints({ make in
            make.right.mas_equalTo(self.slider.mas_right)
            make.bottom.mas_equalTo(self.miniFontLabel)
        })

        standardFontLabel.mas_makeConstraints({ make in
            make.bottom.mas_equalTo(self.miniFontLabel)
            make.left.mas_equalTo(self.miniFontLabel.mas_right).mas_equalTo(40)
        })

        slider.mas_makeConstraints({ make in
            make.centerX.mas_equalTo(self)
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-35)
            make.width.mas_equalTo(self).multipliedBy(0.8)
            make.height.mas_equalTo(40)
        })
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func miniFontLabel() -> UILabel {
        if miniFontLabel == nil {
            miniFontLabel = UILabel()
            miniFontLabel.font = UIFont.systemFont(ofSize: 15)
            miniFontLabel.text = "A"
        }
        return miniFontLabel
    }

    func maxFontLabel() -> UILabel {
        if maxFontLabel == nil {
            maxFontLabel = UILabel()
            maxFontLabel.font = UIFont.systemFont(ofSize: 20)
            maxFontLabel.text = "A"
        }
        return maxFontLabel
    }

    func standardFontLabel() -> UILabel {
        if standardFontLabel == nil {
            standardFontLabel = UILabel()
            standardFontLabel.font = UIFont.systemFont(ofSize: 16)
            standardFontLabel.text = "标准"
        }
        return standardFontLabel
    }

    func slider() -> UISlider {
        if slider == nil {
            slider = UISlider()
            slider.minimumValue = 15
            slider.maximumValue = 20
            slider.addTarget(self, action: #selector(self.sliderValueChanged(_:)), for: .valueChanged)
        }
        return slider
    }


    
}
class WXChatFontViewController: WXBaseViewController {
    var chatTVC: WXChatTableViewController
    var chatFontSettingView: WXChatFontSettingView

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "字体大小"

        if let aView = chatTVC.view {
            view.addSubview(aView)
        }
        if let aTVC = chatTVC {
            addChild(aTVC)
        }
        if let aView = chatFontSettingView {
            view.addSubview(aView)
        }
        p_addMasonry()

        weak var weakSelf: WXChatFontViewController = self
        chatFontSettingView.fontSizeChangeTo = { size in
            UserDefaults.standard.set(Double(size), forKey: "CHAT_FONT_SIZE")
            weakSelf.chatTVC.data = weakSelf.p_chatTVCData()
            weakSelf.chatTVC.tableView.reloadData()
        }
        let size = CGFloat(UserDefaults.standard.double(forKey: "CHAT_FONT_SIZE"))
        chatFontSettingView.curFontSize = size
        chatTVC.data = p_chatTVCData()
        chatTVC.tableView.reloadData()
    }
    func p_addMasonry() {
        chatTVC.view.mas_makeConstraints({ make in
            make.top.and().left().and().right().mas_equalTo(self.view)
            make.bottom.mas_equalTo(self.chatFontSettingView.mas_top)
        })

        chatFontSettingView.mas_makeConstraints({ make in
            make.left.and().right().and().bottom().mas_equalTo(self.view)
            make.height.mas_equalTo(self.chatFontSettingView.mas_width).multipliedBy(0.4)
        })
    }
    func p_chatTVCData() -> [AnyHashable] {
        let message = WXTextMessage()
        message.fromUser = WXUserHelper.shared().user
        message.messageType = TLMessageTypeText
        message.ownerTyper = TLMessageOwnerTypeSelf
        message.content["text"] = "预览字体大小"

        let user = WXUser()
        user.avatarPath = "AppIcon"
        let path = FileManager.pathUserAvatar("AppIcon")
        if !FileManager.default.isExecutableFile(atPath: path) {
            let iconPath = Bundle.main.infoDictionary.value(forKeyPath: "CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles").last as String
            let image = UIImage(named: iconPath  "")
            var data: Data = nil
            if let anImage = image {
                data = UIImagePNGRepresentation(image)  UIImagePNGRepresentation(image) : anImage.jpegData(compressionQuality: 1)
            }
            FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        }

        let message1 = WXTextMessage()
        message1.fromUser = user
        message1.messageType = TLMessageTypeText
        message1.ownerTyper = TLMessageOwnerTypeFriend
        message1.content["text"] = "拖动下面的滑块，可设置字体大小"
        let message2 = WXTextMessage()
        message2.fromUser = user
        message2.messageType = TLMessageTypeText
        message2.ownerTyper = TLMessageOwnerTypeFriend
        message2.content["text"] = "设置后，会改变聊天页面的字体大小。后续将支持更改菜单、朋友圈的字体修改。"

        var data = [message, message1, message2]
        return data
    }

    func chatTVC() -> WXChatTableViewController {
        if chatTVC == nil {
            chatTVC = WXChatTableViewController()
            chatTVC.disablePullToRefresh = true
            chatTVC.disableLongPressMenu = true
        }
        return chatTVC
    }

    func chatFontSettingView() -> WXChatFontSettingView {
        if chatFontSettingView == nil {
            chatFontSettingView = WXChatFontSettingView()
        }
        return chatFontSettingView
    }

    
}
class WXCommonSettingHelper: NSObject {
    var commonSettingData: [AnyHashable] = []

    class func chatBackgroundSettingData() -> [AnyHashable] {
        let select = WXSettingItem.createItem(withTitle: ("选择背景图"))
        let group1: WXSettingGroup = TLCreateSettingGroup(nil, nil, [select])

        let album = WXSettingItem.createItem(withTitle: ("从手机相册中选择"))
        let camera = WXSettingItem.createItem(withTitle: ("拍一张"))
        let group2: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([album, camera]))

        let toAll = WXSettingItem.createItem(withTitle: ("将背景应用到所有聊天场景"))
        toAll.type = TLSettingItemTypeTitleButton
        let group3: WXSettingGroup = TLCreateSettingGroup(nil, nil, [toAll])

        var data = [group1, group2, group3]
        return data
    }
    func p_initTestData() {
        let item1 = WXSettingItem.createItem(withTitle: ("多语言"))
        let group1: WXSettingGroup = TLCreateSettingGroup(nil, nil, [item1])

        let item2 = WXSettingItem.createItem(withTitle: ("字体大小"))
        let item3 = WXSettingItem.createItem(withTitle: ("聊天背景"))
        let item4 = WXSettingItem.createItem(withTitle: ("我的表情"))
        let item5 = WXSettingItem.createItem(withTitle: ("朋友圈小视频"))
        let group2: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([item2, item3, item4, item5]))

        let item6 = WXSettingItem.createItem(withTitle: ("听筒模式"))
        item6.type = TLSettingItemTypeSwitch
        let group3: WXSettingGroup = TLCreateSettingGroup(nil, nil, [item6])

        let item7 = WXSettingItem.createItem(withTitle: ("功能"))
        let group4: WXSettingGroup = TLCreateSettingGroup(nil, nil, [item7])

        let item8 = WXSettingItem.createItem(withTitle: ("聊天记录迁移"))
        let item9 = WXSettingItem.createItem(withTitle: ("清理微信存储空间"))
        let group5: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([item8, item9]))

        let item10 = WXSettingItem.createItem(withTitle: ("清空聊天记录"))
        item10.type = TLSettingItemTypeTitleButton
        let group6: WXSettingGroup = TLCreateSettingGroup(nil, nil, [item10])

        commonSettingData.append(contentsOf: [group1, group2, group3, group4, group5, group6])
    }


    init() {
        super.init()

        commonSettingData = [AnyHashable]()
        p_initTestData()

    }

}
class WXCommonSettingViewController: WXSettingViewController {
    var helper: WXCommonSettingHelper

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "通用"

        helper = WXCommonSettingHelper()
        data = helper.commonSettingData
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row] as WXSettingItem
        if (item.title == "字体大小") {
            let chatFontVC = WXChatFontViewController()
            hidesBottomBarWhenPushed = true
            navigationController.pushViewController(chatFontVC, animated: true)
        } else if (item.title == "聊天背景") {
            let chatBGSettingVC = WXBgSettingViewController()
            hidesBottomBarWhenPushed = true
            navigationController.pushViewController(chatBGSettingVC, animated: true)
        } else if (item.title == "我的表情") {
            let myExpressionVC = WXMyExpressionViewController()
            hidesBottomBarWhenPushed = true
            navigationController.pushViewController(myExpressionVC, animated: true)
        } else if (item.title == "清空聊天记录") {
            showAlerWithtitle("将删除所有个人和群的聊天记录。", message: nil, style: UIAlertController.Style.actionSheet, ac1: {
                return UIAlertAction(title: "清空聊天记录", style: .default, handler: { action in
                    WXMessageManager.sharedInstance().deleteAllMessages()
                    WXChatViewController.sharedChatVC().resetChatVC()
                })
            }, ac2: {
                return UIAlertAction(title: "取消", style: .cancel, handler: { action in

                })
            }, ac3: nil, completion: nil)
        }

        tableView.deselectRow(at: indexPath, animated: false)
    }



}
