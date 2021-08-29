//
//  WXCommonSettingViewController.swift
//  Freedom
import SnapKit
//import XExtension
import Foundation
class WXChatFontSettingView: UIView {
    var curFontSize: Float = 0.0 {
        didSet {
            slider.value = curFontSize
        }
    }
    var fontSizeChangeTo: ((_ size: Float) -> Void)?
    lazy var miniFontLabel: UILabel = {
        let miniFontLabel = UILabel()
        miniFontLabel.font = UIFont.normal
        miniFontLabel.text = "A"
        return miniFontLabel
    }()
    lazy var maxFontLabel: UILabel =  {
        let maxFontLabel = UILabel()
        maxFontLabel.font = UIFont.systemFont(ofSize: 20)
        maxFontLabel.text = "A"
        return maxFontLabel
    }()
    lazy var standardFontLabel: UILabel = {
        let standardFontLabel = UILabel()
        standardFontLabel.font = UIFont.big
        standardFontLabel.text = "标准"
        return standardFontLabel
    }()
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 15
        slider.maximumValue = 20
        slider.addTarget(self, action: #selector(self.sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whitex
        addSubview(miniFontLabel)
        addSubview(maxFontLabel)
        addSubview(standardFontLabel)
        addSubview(slider)
        miniFontLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.slider.snp.left)
            make.bottom.equalTo(self.slider.snp.top).offset(-6)
        }
        maxFontLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.slider.snp.right)
            make.bottom.equalTo(self.miniFontLabel)
        }
        standardFontLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.miniFontLabel)
            make.left.equalTo(self.miniFontLabel.snp.right).offset(40)
        }
        slider.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).offset(-35)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func sliderValueChanged(_ sender: UISlider) {
        var value = sender.value
        value = (sender.value - value) > 0.5 ? value + 1 : value
        if value == curFontSize { return }
        curFontSize = value
        fontSizeChangeTo?(value)
    }
}
class WXChatFontViewController: WXBaseViewController {
    lazy var chatTVC: WXChatTableViewController = {
        let chatTVC = WXChatTableViewController()
        chatTVC.disablePullToRefresh = true
        chatTVC.disableLongPressMenu = true
        return chatTVC
    }()
    var chatFontSettingView = WXChatFontSettingView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "字体大小"
        view.addSubview(chatTVC.view)
        addChild(chatTVC)
        view.addSubview(chatFontSettingView)
        chatFontSettingView.fontSizeChangeTo = { size in
            UserDefaults.standard.set(Double(size), forKey: "CHAT_FONT_SIZE")
            self.chatTVC.data = self.p_chatTVCData()
            self.chatTVC.tableView.reloadData()
        }
        let size = Float(UserDefaults.standard.double(forKey: "CHAT_FONT_SIZE"))
        chatFontSettingView.curFontSize = size
        chatTVC.data = p_chatTVCData()
        chatTVC.tableView.reloadData()
        chatTVC.view.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.chatFontSettingView.snp.top)
        }
        chatFontSettingView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(self.chatFontSettingView.snp.width).multipliedBy(0.4)
        }
    }
    func p_chatTVCData() -> [WXTextMessage] {
        let message = WXTextMessage()
        message.friendID = WXUserHelper.shared.user.userID
        message.messageType = .text
        message.ownerTyper = .own
        message.text = "预览字体大小"
        let user = WXUser()
        user.avatarPath = "AppIcon"
        let path = FileManager.pathUserAvatar("AppIcon")
        if !FileManager.default.isExecutableFile(atPath: path) {
            let iconPath = Bundle.main.infoDictionary?["CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] as! String
            let image = iconPath.image
            var data = image.pngData() != nil ? image.pngData() : image.jpegData(compressionQuality: 1)
            FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        }
        let message1 = WXTextMessage()
        message1.friendID = user.userID ?? ""
        message1.messageType = .text
        message1.ownerTyper = .friend
        message1.text = "拖动下面的滑块，可设置字体大小"
        let message2 = WXTextMessage()
        message2.friendID = user.userID ?? ""
        message2.messageType = .text
        message2.ownerTyper = .friend
        message2.text = "设置后，会改变聊天页面的字体大小。后续将支持更改菜单、朋友圈的字体修改。"
        var data = [message, message1, message2]
        return data
    }

}
class WXCommonSettingHelper: NSObject {
    var commonSettingData: [WXSettingGroup] = []
    class func chatBackgroundSettingData() -> [WXSettingGroup] {
        let select = WXSettingItem("选择背景图")
        let group1: WXSettingGroup = WXSettingGroup(nil, nil, [select])
        let album = WXSettingItem("从手机相册中选择")
        let camera = WXSettingItem("拍一张")
        let group2: WXSettingGroup = WXSettingGroup(nil, nil, ([album, camera]))
        let toAll = WXSettingItem("将背景应用到所有聊天场景")
        toAll.type = .titleButton
        let group3: WXSettingGroup = WXSettingGroup(nil, nil, [toAll])
        return [group1, group2, group3]
    }
    func p_initTestData() {
        let item1 = WXSettingItem("多语言")
        let group1: WXSettingGroup = WXSettingGroup(nil, nil, [item1])
        let item2 = WXSettingItem("字体大小")
        let item3 = WXSettingItem("聊天背景")
        let item4 = WXSettingItem("我的表情")
        let item5 = WXSettingItem("朋友圈小视频")
        let group2: WXSettingGroup = WXSettingGroup(nil, nil, ([item2, item3, item4, item5]))
        let item6 = WXSettingItem("听筒模式")
        item6.type = .switchBtn
        let group3: WXSettingGroup = WXSettingGroup(nil, nil, [item6])
        let item7 = WXSettingItem("功能")
        let group4: WXSettingGroup = WXSettingGroup(nil, nil, [item7])
        let item8 = WXSettingItem("聊天记录迁移")
        let item9 = WXSettingItem("清理微信存储空间")
        let group5: WXSettingGroup = WXSettingGroup(nil, nil, ([item8, item9]))
        let item10 = WXSettingItem("清空聊天记录")
        item10.type = .titleButton
        let group6: WXSettingGroup = WXSettingGroup(nil, nil, [item10])
        commonSettingData.append(contentsOf: [group1, group2, group3, group4, group5, group6])
    }
    override init() {
        super.init()
        p_initTestData()
    }
}
class WXCommonSettingViewController: WXSettingViewController {
    var helper = WXCommonSettingHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "通用"
        data = helper.commonSettingData
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section].items[indexPath.row]
        if (item.title == "字体大小") {
            let chatFontVC = WXChatFontViewController()
            navigationController?.pushViewController(chatFontVC, animated: true)
        } else if (item.title == "聊天背景") {
            let chatBGSettingVC = WXBgSettingViewController()
            navigationController?.pushViewController(chatBGSettingVC, animated: true)
        } else if (item.title == "我的表情") {
            let myExpressionVC = WXMyExpressionViewController()
            navigationController?.pushViewController(myExpressionVC, animated: true)
        } else if (item.title == "清空聊天记录") {
            let alert = UIAlertController("将删除所有个人和群的聊天记录。", "", T1: "清空聊天记录", T2: "取消", confirm1: {
                _ = WXMessageHelper.shared.deleteAllMessages()
                WXChatViewController.shared.resetChatVC()
            }, confirm2: {

            })
            self.present(alert, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
