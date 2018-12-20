//
//  WXSettingViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
@objc protocol WXSettingSwitchCellDelegate: NSObjectProtocol {
    @objc optional func settingSwitchCell(for settingItem: WXSettingItem, didChangeStatus on: Bool)
}

class WXSettingViewController: UITableViewController, WXSettingSwitchCellDelegate {
    var data: [AnyHashable] = []
    var analyzeTitle = ""
    func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 15.0))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 12.0))
        tableView.backgroundColor = UIColor.lightGray
        tableView.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 0)
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0)
        tableView.separatorColor = UIColor.gray
    }
    func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(WXSettingHeaderTitleView.self, forHeaderFooterViewReuseIdentifier: "TLSettingHeaderTitleView")
        tableView.register(WechatSettingFooterTitleView.self, forHeaderFooterViewReuseIdentifier: "TLSettingFooterTitleView")
        tableView.register(WXSettingCell.self, forCellReuseIdentifier: "TLSettingCell")
        tableView.register(WechatSettingButtonCell.self, forCellReuseIdentifier: "TLSettingButtonCell")
        tableView.register(WechatSettingSwitchCell.self, forCellReuseIdentifier: "TLSettingSwitchCell")
    }
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(analyzeTitle)
    }

    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(analyzeTitle)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((data[section]) as [Any]).count  0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.section][indexPath.row] as WXSettingItem
        let cell = tableView.dequeueReusableCell(withIdentifier: item.cellClassName  "")
        cell.setItem(item)
        if item.type == TLSettingItemTypeSwitch {
            cell.setDelegate(self)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let group: WXSettingGroup = data[section]
        if group.headerTitle == nil {
            return nil
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLSettingHeaderTitleView") as WXSettingHeaderTitleView
        view.text = group.headerTitle
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView {
        let group: WXSettingGroup = data[section]
        if group.footerTitle == nil {
            return nil
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLSettingFooterTitleView") as WechatSettingFooterTitleView
        view.text = group.footerTitle
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let group: WXSettingGroup = data[section]
        return 0.5 + (group.headerTitle == nil  0 : 5.0 + group.headerHeight  0.0)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let group: WXSettingGroup = data[section]
        return 20.0 + (group.footerTitle == nil  0 : 5.0 + group.footerHeight  0.0)
    }


    func settingSwitchCell(for settingItem: WXSettingItem, didChangeStatus on: Bool) {
        if let aTitle = settingItem.title {
            SVProgressHUD.showError(withStatus: "Switch事件未被子类处理Title: \(aTitle)\nStatus: \(on  "on" : "off")")
        }
    }

    // MARK: - Getter -
    func analyzeTitle() -> String {
        if analyzeTitle == nil {
            return navigationItem.title
        }
        return analyzeTitle
    }


}
class WechatSettingSwitchCell: UITableViewCell {
    weak var delegate: WXSettingSwitchCellDelegate
    var item: WXSettingItem
    private var titleLabel: UILabel
    private var cellSwitch: UISwitch
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        accessoryView = cellSwitch
        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        p_addMasonry()

    }

    func setItem(_ item: WXSettingItem) {
        self.item = item
        titleLabel.text = item.title
    }

    // MARK: - Event Response -
    func switchChangeStatus(_ sender: UISwitch) {
        if delegate && delegate.responds(to: #selector(self.settingSwitchCell(forItem:didChangeStatus:))) {
            delegate.settingSwitchCell(forItem: item, didChangeStatus: sender.isOn)
        }
    }
    func p_addMasonry() {
        titleLabel.mas_makeConstraints({ make in
            make.centerY.mas_equalTo(self.contentView)
            make.left.mas_equalTo(self.contentView).mas_offset(15)
            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-15)
        })
    }

    // MARK: - Getter -
    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
        }
        return titleLabel
    }

    func cellSwitch() -> UISwitch {
        if cellSwitch == nil {
            cellSwitch = UISwitch()
            cellSwitch.addTarget(self, action: #selector(self.switchChangeStatus(_:)), for: .valueChanged)
        }
        return cellSwitch
    }

}

class WechatSettingButtonCell: UITableViewCell {
    var item: WXSettingItem
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel.textAlignment = .center

    }

    func setItem(_ item: WXSettingItem) {
        self.item = item
        textLabel.text = item.title
    }

}

class WXSettingCell: UITableViewCell {
    var item: WXSettingItem
    private var titleLabel: UILabel
    private var rightLabel: UILabel
    private var rightImageView: UIImageView

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        if let aLabel = rightLabel {
            contentView.addSubview(aLabel)
        }
        if let aView = rightImageView {
            contentView.addSubview(aView)
        }
        p_addMasonry()

    }
    func p_addMasonry() {
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(500), for: .horizontal)
        titleLabel.mas_makeConstraints({ make in
            make.centerY.mas_equalTo(self.contentView)
            make.left.mas_equalTo(self.contentView).mas_offset(15)
        })

        rightLabel.setContentCompressionResistancePriority(UILayoutPriority(200), for: .horizontal)
        rightLabel.mas_makeConstraints({ make in
            make.right.mas_equalTo(self.contentView)
            make.centerY.mas_equalTo(self.titleLabel)
            make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).mas_offset(20)
        })

        rightImageView.mas_makeConstraints({ make in
            make.right.mas_equalTo(self.rightLabel.mas_left).mas_offset(-2)
            make.centerY.mas_equalTo(self.contentView)
        })
    }

    func setItem(_ item: WXSettingItem) {
        self.item = item
        titleLabel.text = item.title
        rightLabel.text = item.subTitle
        if item.rightImagePath != nil {
            rightImageView.image = UIImage(named: item.rightImagePath  "")
        } else if item.rightImageURL != nil {
            rightImageView.sd_setImage(with: URL(string: item.rightImageURL  ""), placeholderImage: UIImage(named: PuserLogo))
        } else {
            rightImageView.image = nil
        }

        if item.showDisclosureIndicator == false {
            accessoryType = .none
            rightLabel.mas_updateConstraints({ make in
                make.right.mas_equalTo(self.contentView).mas_offset(-15.0)
            })
        } else {
            accessoryType = .disclosureIndicator
            rightLabel.mas_updateConstraints({ make in
                make.right.mas_equalTo(self.contentView)
            })
        }
        if item.disableHighlight != nil {
            selectionStyle = .none
        } else {
            selectionStyle = .default
        }
    }
    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
        }
        return titleLabel
    }

    func rightLabel() -> UILabel {
        if rightLabel == nil {
            rightLabel = UILabel()
            rightLabel.textColor = UIColor.gray
            rightLabel.font = UIFont.systemFont(ofSize: 15.0)
        }
        return rightLabel
    }

    func rightImageView() -> UIImageView {
        if rightImageView == nil {
            rightImageView = UIImageView()
        }
        return rightImageView
    }



            
}

class WXSettingHeaderTitleView: UITableViewHeaderFooterView {
    var titleLabel: UILabel
    var text = ""
    init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)

        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        titleLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.contentView).mas_offset(15)
            make.right.mas_equalTo(self.contentView).mas_offset(-15)
            make.bottom.mas_equalTo(self.contentView).mas_offset(-5.0)
        })

    }

    func setText(_ text: String) {
        self.text = text
        titleLabel.text = text
    }

    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.textColor = UIColor.gray
            titleLabel.font = UIFont.systemFont(ofSize: 14.0)
            titleLabel.numberOfLines = 0
        }
        return titleLabel
    }

}

class WechatSettingFooterTitleView: WXSettingHeaderTitleView {
    init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)

        titleLabel.mas_remakeConstraints({ make in
            make.left.mas_equalTo(self.contentView).mas_offset(15)
            make.right.mas_equalTo(self.contentView).mas_offset(-15)
            make.top.mas_equalTo(self.contentView).mas_offset(5.0)
        })

    }

}
