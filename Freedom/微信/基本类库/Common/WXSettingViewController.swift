//
//  WXSettingViewController.swift
//  Freedom
import Foundation
import XExtension
import SnapKit
class WXSettingViewController: BaseTableViewController {
    var data: [WXSettingGroup] = []
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 15.0))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 12.0))
        tableView.backgroundColor = UIColor.lightGray
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.gray
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WXSettingHeaderTitleView.self, forHeaderFooterViewReuseIdentifier: WXSettingHeaderTitleView.identifier)
        tableView.register(WechatSettingFooterTitleView.self, forHeaderFooterViewReuseIdentifier: WechatSettingFooterTitleView.identifier)
        tableView.register(WXSettingCell.self, forCellReuseIdentifier: WXSettingCell.identifier)
        tableView.register(WechatSettingButtonCell.self, forCellReuseIdentifier: WechatSettingButtonCell.identifier)
        tableView.register(WechatSettingSwitchCell.self, forCellReuseIdentifier: WechatSettingSwitchCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(data[section].items.count)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = data[indexPath.section]
        let item = group.items[indexPath.row]
        switch item.type {
        case .defalut1:
            let cell = tableView.dequeueCell(WXSettingCell.self)
            cell.item = item
            return cell
        case .titleButton:
            let cell = tableView.dequeueCell(WechatSettingButtonCell.self)
            cell.item = item
            return cell
        default:
            let cell = tableView.dequeueCell(WechatSettingSwitchCell.self)
            cell.item = item
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let group: WXSettingGroup = data[section]
        if group.headerTitle.isEmpty {
            return nil
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: WXSettingHeaderTitleView.identifier) as! WXSettingHeaderTitleView
        view.text = group.headerTitle
        return view
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let group: WXSettingGroup = data[section]
        if group.footerTitle.isEmpty {
            return nil
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: WechatSettingFooterTitleView.identifier) as! WechatSettingFooterTitleView
        view.text = group.footerTitle
        return view
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let group: WXSettingGroup = data[section]
        return 0.5 + (group.headerTitle.isEmpty ? 0 : 5.0)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let group: WXSettingGroup = data[section]
        return 20.0 + (group.footerTitle.isEmpty ? 0 : 5.0)
    }
}
class WechatSettingSwitchCell: BaseTableViewCell {
    var item: WXSettingItem = WXSettingItem() {
        didSet {
            titleLabel.text = item.title
        }
    }
    private var titleLabel = UILabel()
    private var cellSwitch = UISwitch()
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryView = cellSwitch
        cellSwitch.addTarget(self, action: #selector(self.switchChangeStatus(_:)), for: .valueChanged)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.lessThanOrEqualToSuperview().offset(-15)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func switchChangeStatus(_ sender: UISwitch) {

    }
}

class WechatSettingButtonCell: BaseTableViewCell {
    var item: WXSettingItem = WXSettingItem() {
        didSet {
            textLabel?.text = item.title
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.textAlignment = .center
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WXSettingCell: BaseTableViewCell {
    private var titleLabel = UILabel()
    private var rightLabel = UILabel()
    private var rightImageView = UIImageView()
    var item: WXSettingItem = WXSettingItem() {
        didSet {
            titleLabel.text = item.title
            rightLabel.text = item.subTitle
            if !item.rightImagePath.isEmpty {
                rightImageView.image = UIImage(named: item.rightImagePath)
            } else if !item.rightImageURL.isEmpty {
                rightImageView.sd_setImage(with: URL(string: item.rightImageURL), placeholderImage: UIImage(named: PuserLogo))
            } else {
                rightImageView.image = nil
            }
            if item.showDisclosureIndicator == false {
                accessoryType = .none
                rightLabel.snp.updateConstraints { (make) in
                    make.right.equalTo(self.contentView).offset(-15)
                }
            } else {
                accessoryType = .disclosureIndicator
                rightLabel.snp.makeConstraints { (make) in
                    make.right.equalTo(self.contentView)
                }
            }
            if item.disableHighlight {
                selectionStyle = .none
            } else {
                selectionStyle = .default
            }
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(rightImageView)
        rightLabel.textColor = UIColor.gray
        rightLabel.font = UIFont.systemFont(ofSize: 15.0)
        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func p_addMasonry() {
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(500), for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(UILayoutPriority(200), for: .horizontal)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(self.titleLabel)
            make.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(20)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.rightLabel.snp.left).offset(-2)
            make.centerY.equalToSuperview()
        }
    }
}

class WXSettingHeaderTitleView: UITableViewHeaderFooterView {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.numberOfLines = 0
    return titleLabel
    }()
    var text = "" {
        didSet {
            titleLabel.text = text
        }
    }
    init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo(self.contentView).offset(-5)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WechatSettingFooterTitleView: WXSettingHeaderTitleView {
    override init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.top.equalTo(self.contentView).offset(5)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
