//
//  WXInfoViewController.swift
//  Freedom
import SnapKit
import XExtension
import Foundation
protocol WXInfoButtonCellDelegate: NSObjectProtocol {
    func infoButtonCellClicked(_ info: WXInfo)
}
class WXInfoButtonCell: WXTableViewCell {
    weak var delegate: WXInfoButtonCellDelegate?
    var info: WXInfo = WXInfo() {
        didSet {
            button.setTitle(info.title, for: .normal)
            button.backgroundColor = info.buttonColor
            button.setBackgroundImage(UIImage.imageWithColor(info.buttonHLColor), for: .highlighted)
            button.setTitleColor(info.titleColor, for: .normal)
            button.layer.borderColor = info.buttonBorderColor.cgColor
        }
    }
    private lazy var button: UIButton =  {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4.0
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.addTarget(self, action: #selector(self.cellButtonDown(_:)), for: .touchUpInside)
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        accessoryType = .none
        separatorInset = UIEdgeInsets(top: 0, left: APPW / 2, bottom: 0, right: APPW / 2)
        layoutMargins = UIEdgeInsets(top: 0, left: APPW / 2, bottom: 0, right: APPW / 2)
        contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.top.equalTo(self.contentView)
            make.width.equalTo(self.contentView).multipliedBy(0.92)
            make.height.equalTo(self.contentView).multipliedBy(0.78)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func cellButtonDown(_ sender: UIButton) {
        delegate?.infoButtonCellClicked(info)
    }
}

class WXInfoCell: WXTableViewCell {
    private var subTitleLabel = UILabel()
    var info: WXInfo = WXInfo() {
        didSet {
            textLabel?.text = info.title
            subTitleLabel.text = info.subTitle
            accessoryType = info.showDisclosureIndicator ? .disclosureIndicator : .none
            selectionStyle = info.disableHighlight ? .none : .default
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        subTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(APPW * 0.28)
            make.right.lessThanOrEqualTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WXInfoHeaderFooterView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.lightGray
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WXInfoViewController: BaseTableViewController, WXInfoButtonCellDelegate {
    var data: [[WXInfo]] = []
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 15.0))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 12.0))
        tableView.backgroundColor = UIColor.lightGray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 10.0))
        tableView.register(WXInfoHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "TLInfoHeaderFooterView")
        tableView.register(WXInfoCell.self, forCellReuseIdentifier: "TLInfoCell")
        tableView.register(WXInfoButtonCell.self, forCellReuseIdentifier: "TLInfoButtonCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = .none
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let temp = data[section]
        return temp.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = data[indexPath.section]
        let info = group[indexPath.row]
        var cell: WXTableViewCell
        if info.type == TLInfoType.button.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: WXInfoButtonCell.identifier) as! WXInfoButtonCell
            (cell as! WXInfoButtonCell).delegate = self
            (cell as! WXInfoButtonCell).info = info
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: WXInfoCell.identifier) as! WXTableViewCell
            (cell as! WXInfoCell).info = info
        }
        if indexPath.row == 0 && info.type != TLInfoType.button.rawValue {
            cell.topLineStyle = .fill
        } else {
            cell.topLineStyle = .none
        }
        if info.type == TLInfoType.button.rawValue {
            cell.bottomLineStyle = .none
        } else if indexPath.row == group.count - 1 {
            cell.bottomLineStyle = .fill
        } else {
            cell.bottomLineStyle = .default
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLInfoHeaderFooterView")
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLInfoHeaderFooterView")
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let info = data[indexPath.section][indexPath.row]
        if info.type == Int32(TLInfoType.button.rawValue) {
            return 50.0
        }
        return 44.0
    }
    func infoButtonCellClicked(_ info: WXInfo) {
        let alert = UIAlertController("子类未处理按钮点击事件", "", T1: "取消", T2: "", confirm1: {

        }, confirm2: {

        })
        self.present(alert, animated: true, completion: nil)
    }
}
