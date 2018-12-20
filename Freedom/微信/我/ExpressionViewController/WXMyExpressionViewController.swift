//
//  WXMyExpressionViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/20.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
protocol WXMyExpressionCellDelegate: NSObjectProtocol {
    func myExpressionCellDeleteButtonDown(_ group: TLEmojiGroup?)
}

class WXMyExpressionCell: UITableViewCell {
    weak var delegate: WXMyExpressionCellDelegate?
    var group: TLEmojiGroup?
    var iconView: UIImageView?
    var titleLabel: UILabel?
    var delButton: UIButton?
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(iconView)
        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        accessoryView = delButton

        p_addMasonry()

    }

    func setGroup(_ group: TLEmojiGroup?) {
        self.group = group
        iconView.image = UIImage(named: group?.groupIconPath ?? "")
        titleLabel?.text = group?.groupName
    }

    // MARK: - Event Response -
    func delButtonDown() {
        if delegate && delegate.responds(to: #selector(self.myExpressionCellDeleteButtonDown(_:))) {
            delegate.myExpressionCellDeleteButtonDown(group)
        }
    }
    func p_addMasonry() {
        iconView.mas_makeConstraints({ make in
            make?.left.mas_equalTo(self.contentView).mas_offset(15.0)
            make?.centerY.mas_equalTo(self.contentView)
            make?.width.and().height().mas_equalTo(35)
        })
        titleLabel?.mas_makeConstraints({ make in
            make?.centerY.mas_equalTo(self.iconView)
            make?.left.mas_equalTo(self.iconView.mas_right).mas_offset(10.0)
            make?.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-15.0)
        })
    }
    func iconView() -> UIImageView? {
        if iconView == nil {
            iconView = UIImageView()
        }
        return iconView
    }

    var titleLabel: UILabel? {
        if titleLabel == nil {
            titleLabel = UILabel()
        }
        return titleLabel
    }

    func delButton() -> UIButton? {
        if delButton == nil {
            delButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            delButton.setTitle("移除", for: .normal)
            delButton.setTitleColor(UIColor.gray, for: .normal)
            delButton.backgroundColor = UIColor.lightGray
            delButton.setBackgroundImage(FreedomTools(color: UIColor.gray), for: .highlighted)
            delButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
            delButton.addTarget(self, action: #selector(self.delButtonDown), for: .touchUpInside)
            delButton.layer.masksToBounds = true
            delButton.layer.cornerRadius = 3.0
            delButton.layer.borderWidth = 1
            delButton.layer.borderColor = UIColor.gray.cgColor
        }
        return delButton
    }

}
class WXMyExpressionViewController: WXSettingViewController, WXMyExpressionCellDelegate {
    var helper: WXExpressionHelper?

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的表情"

        let rightBarButtonItem = UIBarButtonItem(title: "排序", style: .plain, target: self, action: #selector(WXMyExpressionViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem

        if navigationController?.viewControllers.first == self {
            let dismissBarButton = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, actionBlick: {
                self.dismiss(animated: true)
            })
            navigationItem.leftBarButtonItem = dismissBarButton
        }

        tableView.register(WXMyExpressionCell.self, forCellReuseIdentifier: "TLMyExpressionCell")
        helper = WXExpressionHelper.shared()
        data = helper.myExpressionListData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group: WXSettingGroup? = data[indexPath.section]
        if group?.headerTitle != nil {
            // 有标题的就是表情组
            let emojiGroup = group?[indexPath.row] as? TLEmojiGroup
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMyExpressionCell") as? WXMyExpressionCell
            cell?.group = emojiGroup
            cell?.delegate = self
            return cell!
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let group: WXSettingGroup? = data[indexPath.section]
        if group?.headerTitle != nil {
            return 50.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    func myExpressionCellDeleteButtonDown(_ group: TLEmojiGroup?) {
        var ok = helper.deleteExpressionGroup(byID: group?.groupID)
        if ok {
            let canDeleteFile = !helper.didExpressionGroupAlways(inUsed: group?.groupID)
            if canDeleteFile {
                var error: Error?
                ok = try? FileManager.default.removeItem(atPath: group?.path ?? "") ?? false
                if !ok {
                    DLog("删除表情文件失败\n路径:%@\n原因:%@", group?.path, error?.description())
                }
            }

            var row: Int? = nil
            if let aGroup = group {
                row = data[0].index(of: aGroup)
            }
            data[0].removeAll(where: { element in element == group })
            let temp = data[0]
            if temp.count == 0 {
                data.remove(at: 0)
                tableView.deleteSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
            } else {
                tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }
        } else {
            SVProgressHUD.showError(withStatus: "表情包删除失败")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group: WXSettingGroup? = data[indexPath.section]
        if group?.headerTitle != nil {
            // 有标题的就是表情组
            let emojiGroup = group?[indexPath.row] as? TLEmojiGroup
            let detailVC = WXExpressionDetailViewController()
            detailVC.group = emojiGroup
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }

    //MARK: TLMyExpressionCellDelegate

    // MARK: - Event Response -
    func rightBarButtonDown(_ sender: UIBarButtonItem?) {
    }

}
