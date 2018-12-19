//
//  WXInfoViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
protocol WXInfoButtonCellDelegate: NSObjectProtocol {
    func infoButtonCellClicked(_ info: WXInfo?)
}

class WXInfoButtonCell: WXTableViewCell {
    weak var delegate: WXInfoButtonCellDelegate?
    var info: WXInfo?
    private var button: UIButton?

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear
        selectionStyle = .none
        accessoryType = .none
        separatorInset = UIEdgeInsetsMake(0, APPW / 2, 0, APPW / 2)
        layoutMargins = UIEdgeInsetsMake(0, APPW / 2, 0, APPW / 2)
        if let aButton = button {
            contentView.addSubview(aButton)
        }
        p_addMasonry()

    }
    func setInfo(_ info: WXInfo?) {
        self.info = info
        button.setTitle(info?.title, for: .normal)
        button.backgroundColor = info?.buttonColor
        if let aColor = info?.buttonHLColor {
            button.setBackgroundImage(FreedomTools(color: aColor), for: .highlighted)
        }
        button.setTitleColor(info?.titleColor, for: .normal)
        button.layer.borderColor = info?.buttonBorderColor.cgColor
    }

    // MARK: - Event Response -
    func cellButtonDown(_ sender: UIButton?) {
        if delegate && delegate.responds(to: #selector(self.infoButtonCellClicked(_:))) {
            delegate.infoButtonCellClicked(info)
        }
    }
    func p_addMasonry() {
        button()?.mas_makeConstraints({ make in
            make?.centerX.and.top.mas_equalTo(self.contentView)
            make?.width.mas_equalTo(self.contentView).multipliedBy(0.92)
            make?.height.mas_equalTo(self.contentView).multipliedBy(0.78)
        })
    }

    // MARK: - Getter -
    func button() -> UIButton? {
        if button == nil {
            button = UIButton()
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 4.0
            button.layer.borderWidth = 1
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.addTarget(self, action: #selector(self.cellButtonDown(_:)), for: .touchUpInside)
        }
        return button
    }



    
}

class WXInfoCell: WXTableViewCell {
    var info: WXInfo?
    private var subTitleLabel: UILabel?

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel.font = UIFont.systemFont(ofSize: 15.0)
        if let aLabel = subTitleLabel {
            contentView.addSubview(aLabel)
        }
        p_addMasonry()

    }
    func setInfo(_ info: WXInfo?) {
        self.info = info
        textLabel?.text = info?.title
        subTitleLabel.text = info?.subTitle
        accessoryType = info?.showDisclosureIndicator != nil ? .disclosureIndicator : .none
        selectionStyle = info?.disableHighlight != nil ? .none : .default
    }

    // MARK: - Private Methods -
    func p_addMasonry() {
        subTitleLabel.mas_makeConstraints({ make in
            make?.centerY.mas_equalTo(self.contentView)
            make?.left.mas_equalTo(self.contentView).mas_offset(APPW * 0.28)
            make?.right.mas_lessThanOrEqualTo(self.contentView)
        })
    }
    func subTitleLabel() -> UILabel? {
        if subTitleLabel == nil {
            subTitleLabel = UILabel()
            subTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        }
        return subTitleLabel
    }

    
}

class WXInfoHeaderFooterView: UITableViewHeaderFooterView {
    init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor.lightGray

    }

}

class WXInfoViewController: UITableViewController, WXInfoButtonCellDelegate {
    var data: [AnyHashable] = []
    func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 15.0))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 12.0))
        tableView.backgroundColor = UIColor.lightGray
    }

    func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 10.0))
        tableView.register(WXInfoHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "TLInfoHeaderFooterView")
        tableView.register(WXInfoCell.self, forCellReuseIdentifier: "TLInfoCell")
        tableView.register(WXInfoButtonCell.self, forCellReuseIdentifier: "TLInfoButtonCell")
    }
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = .none
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let temp = data[section]
        return temp.count
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = data[indexPath.section]
        let info = group[indexPath.row] as? WXInfo
        var cell: Any?
        if info?.type == TLInfoTypeButton {
            cell = tableView.dequeueReusableCell(withIdentifier: "TLInfoButtonCell")
            cell?.delegate = self
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "TLInfoCell")
        }
        cell?.info = info

        if indexPath.row == 0 && info?.type != TLInfoTypeButton {
            cell?.topLineStyle = TLCellLineStyleFill
        } else {
            cell?.topLineStyle = TLCellLineStyleNone
        }
        if info?.type == TLInfoTypeButton {
            cell?.bottomLineStyle = TLCellLineStyleNone
        } else if indexPath.row == group.count - 1 {
            cell?.bottomLineStyle = TLCellLineStyleFill
        } else {
            cell?.bottomLineStyle = TLCellLineStyleDefault
        }
        return cell as! UITableViewCell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLInfoHeaderFooterView")
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLInfoHeaderFooterView")
    }

    //MARK: TLTableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let info = data[indexPath.section][indexPath.row] as? WXInfo
        if info?.type == TLInfoTypeButton {
            return 50.0
        }
        return 44.0
    }

    //MARK: TLInfoButtonCellDelegate
    func infoButtonCellClicked(_ info: WXInfo?) {
        if let aTitle = info?.title {
            showAlerWithtitle("子类未处理按钮点击事件", message: "Title: \(aTitle)", style: UIAlertController.Style.alert, ac1: {
                return UIAlertAction(title: "取消", style: .cancel, handler: { action in
                })
            }, ac2: nil, ac3: nil, completion: nil)
        }
    }

    
}
