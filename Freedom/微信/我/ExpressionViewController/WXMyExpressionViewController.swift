//
//  WXMyExpressionViewController.swift
//  Freedom

import Foundation
protocol WXMyExpressionCellDelegate: NSObjectProtocol {
    func myExpressionCellDeleteButtonDown(_ group: TLEmojiGroup)
}
class WXMyExpressionCell: UITableViewCell {
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
        delButton.setTitleColor(UIColor.gray, for: .normal)
        delButton.backgroundColor = UIColor.lightGray
        delButton.setBackgroundImage(UIImage.imageWithColor(UIColor.gray), for: .highlighted)
        delButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        delButton.addTarget(self, action: #selector(self.delButtonDown), for: .touchUpInside)
        delButton.layer.masksToBounds = true
        delButton.layer.cornerRadius = 3.0
        delButton.layer.borderWidth = 1
        delButton.layer.borderColor = UIColor.gray.cgColor
        return delButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        tableView.register(WXMyExpressionCell.self, forCellReuseIdentifier: "TLMyExpressionCell")
        data = helper.myExpressionListData()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group: WXSettingGroup = data[indexPath.section]
        if !group.headerTitle.isEmpty {
            // 有标题的就是表情组
            let emojiGroup = group.items[indexPath.row] as! TLEmojiGroup
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMyExpressionCell") as! WXMyExpressionCell
            cell.group = emojiGroup
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
        var row = data[0].items.index(of: (group as! WXSettingItem)) ?? -1
        let tempItems = data[0].items
        var tempArray = tempItems.array()
        tempArray.removeAll(where: { element in element == group })
        data[0].items.removeAll()
        data[0].items.append(objectsIn: tempArray)
        let temp = data[0]
        if temp.items.count == 0 {
            data.remove(at: 0)
            tableView.deleteSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
        } else {
            tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .none)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group: WXSettingGroup = data[indexPath.section]
        if !group.headerTitle.isEmpty {
            // 有标题的就是表情组
            let emojiGroup = group.items[indexPath.row] as! TLEmojiGroup
            let detailVC = WXExpressionDetailViewController()
            detailVC.group = emojiGroup
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
}
