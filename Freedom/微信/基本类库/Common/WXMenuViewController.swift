//
//  WXMenuViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
class WXMenuCell: UITableViewCell {
    var menuItem: WXMenuItem

    private var iconImageView: UIImageView
    private var titleLabel: UILabel
    private var midLabel: UILabel
    private var rightImageView: UIImageView
    private var redPointView: UIView
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator
        contentView.addSubview(iconImageView)
        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        contentView.addSubview(midLabel)
        contentView.addSubview(rightImageView)
        contentView.addSubview(redPointView)

        p_addMasonry()

    }
    var menuItem: NSMenuItem {
        get {
            return super.menuItem
        }
        set(menuItem) {
            self.menuItem = menuItem
            iconImageView.image = UIImage(named: menuItem.iconPath  "")
            titleLabel.text = menuItem.title
            midLabel.text = menuItem.subTitle
            if menuItem.rightIconURL == nil {
                rightImageView.mas_updateConstraints({ make in
                    make.width.mas_equalTo(0)
                })
            } else {
                rightImageView.mas_updateConstraints({ make in
                    make.height.mas_equalTo(self.rightImageView.mas_height)
                })
                rightImageView.sd_setImage(with: URL(string: menuItem.rightIconURL  ""), placeholderImage: UIImage(named: PuserLogo))
            }
            redPointView.hidden = !menuItem.showRightRedPoint
        }
    }
    func p_addMasonry() {
        iconImageView.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.contentView).mas_offset(15.0)
            make.centerY.mas_equalTo(self.contentView)
            make.width.and().height().mas_equalTo(25.0)
        })
        titleLabel.mas_makeConstraints({ make in
            make.centerY.mas_equalTo(self.iconImageView)
            make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(15.0)
            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(15.0)
        })
        rightImageView.mas_makeConstraints({ make in
            make.right.mas_equalTo(self.contentView)
            make.centerY.mas_equalTo(self.iconImageView)
            make.width.and().height().mas_equalTo(31)
        })
        midLabel.mas_makeConstraints({ make in
            make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).mas_offset(15)
            make.right.mas_equalTo(self.rightImageView.mas_left).mas_offset(-5)
            make.centerY.mas_equalTo(self.iconImageView)
        })
        redPointView.mas_makeConstraints({ make in
            make.centerX.mas_equalTo(self.rightImageView.mas_right).mas_offset(1)
            make.centerY.mas_equalTo(self.rightImageView.mas_top).mas_offset(1)
            make.width.and().height().mas_equalTo(8)
        })
    }
    func iconImageView() -> UIImageView {
        if iconImageView == nil {
            iconImageView = UIImageView()
        }
        return iconImageView
    }

    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
        }
        return titleLabel
    }

    func midLabel() -> UILabel {
        if midLabel == nil {
            midLabel = UILabel()
            midLabel.textColor = UIColor.gray
            midLabel.font = UIFont.systemFont(ofSize: 14.0)
        }
        return midLabel
    }
    func rightImageView() -> UIImageView {
        if rightImageView == nil {
            rightImageView = UIImageView()
        }
        return rightImageView
    }

    func redPointView() -> UIView {
        if redPointView == nil {
            redPointView = UIView()
            redPointView.backgroundColor = UIColor.red

            redPointView.layer.masksToBounds = true
            redPointView.layer.cornerRadius = 8 / 2.0
            redPointView.hidden = true
        }
        return redPointView
    }
}

class WXMenuViewController: UITableViewController {
    var data: [AnyHashable] = []
    var analyzeTitle = ""
    func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.lightGray
        tableView.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 0)
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0)
        tableView.separatorColor = UIColor.gray
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 20))
    }
    func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WXMenuCell.self, forCellReuseIdentifier: "TLMenuCell")
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
        let temp = data[section]
        return temp.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLMenuCell") as WXMenuCell
        let item = data[indexPath.section][indexPath.row] as WXMenuItem
        cell.menuItem = item
        return cell!
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row] as WXMenuItem
        if item.rightIconURL != nil || item.subTitle != nil {
            item.rightIconURL = nil
            item.subTitle = nil
            item.showRightRedPoint = false
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

    // MARK: - Getter -
    // MARK: - Getter -
    func analyzeTitle() -> String {
        if analyzeTitle == nil {
            return navigationItem.title
        }
        return analyzeTitle
    }


}
