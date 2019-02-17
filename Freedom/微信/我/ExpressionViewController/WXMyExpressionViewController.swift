//
//  WXMyExpressionViewController.swift
//  Freedom

import Foundation
protocol WXMyExpressionCellDelegate: NSObjectProtocol {
    func myExpressionCellDeleteButtonDown(_ group: TLEmojiGroup)
}
class WXMyExpressionCell: BaseTableViewCell<TLEmojiGroup> {
    weak var delegate: WXMyExpressionCellDelegate?
    var group: TLEmojiGroup = TLEmojiGroup() {
        didSet {
            iconView.image = UIImage(named: group.groupIconPath)
            titleLabel.text = group.groupName
        }
    }
    var iconView = UIImageView()
    var titleLabel = UILabel()
    lazy var delButton: UIButton =  {
        let delButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        delButton.setTitle("移除", for: .normal)
        delButton.setTitleColor(UIColor.grayx, for: .normal)
        delButton.backgroundColor = UIColor.light
        delButton.setBackgroundImage(UIImage.imageWithColor(UIColor.grayx), for: .highlighted)
        delButton.titleLabel?.font = UIFont.small
        delButton.addTarget(self, action: #selector(self.delButtonDown), for: .touchUpInside)
        delButton.layer.masksToBounds = true
        delButton.layer.cornerRadius = 3.0
        delButton.layer.borderWidth = 1
        delButton.layer.borderColor = UIColor.grayx.cgColor
        return delButton
    }()

    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        accessoryView = delButton
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(35)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.iconView)
            make.left.equalTo(self.iconView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(self.contentView).offset(-15)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func delButtonDown() {
        delegate?.myExpressionCellDeleteButtonDown(group)
    }
}
class WXMyExpressionViewController: WXSettingViewController, WXMyExpressionCellDelegate {
    var helper = WXExpressionHelper.shared
    var emojiGroupData: [TLEmojiGroup] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的表情"
        let rightBarButtonItem = UIBarButtonItem(title: "排序", style: .plain, target: self, action: #selector(WXMyExpressionViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        if navigationController?.viewControllers.first == self {
            let dismissBarButton = UIBarButtonItem(title: "取消", action: {
                self.dismiss(animated: true)
            })
            navigationItem.leftBarButtonItem = dismissBarButton
        }
        tableView.register(WXMyExpressionCell.self, forCellReuseIdentifier: WXMyExpressionCell.identifier)
        emojiGroupData = helper.myExpressionListData()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = emojiGroupData[indexPath.section]
        if !group.groupName.isEmpty {
            // 有标题的就是表情组
            let cell = tableView.dequeueCell(WXMyExpressionCell.self)
            cell.group = group
            cell.delegate = self
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let group: WXSettingGroup = data[indexPath.section]
        if !group.headerTitle.isEmpty {
            return 50.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    func myExpressionCellDeleteButtonDown(_ group: TLEmojiGroup) {
        helper.deleteExpressionGroup(byID: group.groupID)
        let canDeleteFile = !helper.didExpressionGroupAlways(inUsed: group.groupID)
        if canDeleteFile {
            try! FileManager.default.removeItem(atPath:  group.path)
        }
        tableView.deleteSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = emojiGroupData[indexPath.section]
        if !group.groupName.isEmpty {
            // 有标题的就是表情组
            let detailVC = WXExpressionDetailViewController()
            detailVC.group = group
            navigationController?.pushViewController(detailVC, animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
}
