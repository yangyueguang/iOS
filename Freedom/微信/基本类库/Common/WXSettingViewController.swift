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
        tableView.register(WXSettingHeaderTitleView.self)
        tableView.register(WechatSettingFooterTitleView.self)
        tableView.register(WXSettingCell.self)
        tableView.register(WechatSettingButtonCell.self)
        tableView.register(WechatSettingSwitchCell.self)
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
            cell.viewModel.onNext(item)
            return cell
        case .titleButton:
            let cell = tableView.dequeueCell(WechatSettingButtonCell.self)
            cell.viewModel.onNext(item)
            return cell
        default:
            let cell = tableView.dequeueCell(WechatSettingSwitchCell.self)
            cell.viewModel.onNext(item)
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let group: WXSettingGroup = data[section]
        if group.headerTitle.isEmpty {
            return nil
        }
        let view = tableView.dequeueHeadFootView(view: WXSettingHeaderTitleView.self)
        view?.text = group.headerTitle
        return view
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let group: WXSettingGroup = data[section]
        if group.footerTitle.isEmpty {
            return nil
        }
        let view = tableView.dequeueHeadFootView(view: WechatSettingFooterTitleView.self)
        view?.text = group.footerTitle
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

class WechatSettingSwitchCell: BaseTableViewCell<WXSettingItem> {
    private var titleLabel = UILabel()
    private var cellSwitch = UISwitch()
    override func initUI() {
        selectionStyle = .none
        accessoryView = cellSwitch
        contentView.addSubview(titleLabel)
        viewModel.subscribe(onNext: {[weak self] (item) in
            guard let `self` = self else { return }
            self.titleLabel.text = item.title
        }).disposed(by: disposeBag)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.lessThanOrEqualToSuperview().offset(-15)
        }
    }
}

class WechatSettingButtonCell: BaseTableViewCell<WXSettingItem> {
    override func initUI() {
        textLabel?.textAlignment = .center
        viewModel.subscribe(onNext: {[weak self] (item) in
            guard let `self` = self else { return }
            self.textLabel?.text = item.title
        }).disposed(by: disposeBag)
    }
}

class WXSettingCell: BaseTableViewCell<WXSettingItem> {
    private var titleLabel = UILabel()
    private var rightLabel = UILabel()
    private var rightImageView = UIImageView()

    override func initUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(rightImageView)
        rightLabel.textColor = UIColor.gray
        rightLabel.font = UIFont.systemFont(ofSize: 15.0)
        p_addMasonry()
        viewModel.subscribe(onNext: {[weak self] (item) in
            guard let `self` = self else { return }
            self.titleLabel.text = item.title
            self.rightLabel.text = item.subTitle
            if !item.rightImagePath.isEmpty {
                self.rightImageView.image = UIImage(named: item.rightImagePath)
            } else if !item.rightImageURL.isEmpty {
                self.rightImageView.sd_setImage(with: URL(string: item.rightImageURL), placeholderImage: Image.logo.image)
            } else {
                self.rightImageView.image = nil
            }
            if item.showDisclosureIndicator == false {
                self.accessoryType = .none
                self.rightLabel.snp.updateConstraints { (make) in
                    make.right.equalTo(self.contentView).offset(-15)
                }
            } else {
                self.accessoryType = .disclosureIndicator
                self.rightLabel.snp.makeConstraints { (make) in
                    make.right.equalTo(self.contentView)
                }
            }
            if item.disableHighlight {
                self.selectionStyle = .none
            } else {
                self.selectionStyle = .default
            }
        }).disposed(by: disposeBag)
    }
    func p_addMasonry() {

        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(20)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.rightLabel.snp.left).offset(-2)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
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
