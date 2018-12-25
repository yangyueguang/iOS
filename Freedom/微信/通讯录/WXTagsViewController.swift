//
//  WXTagsViewController.swift
//  Freedom
import SnapKit
import XExtension
import Foundation
class WXTagCell: WXTableViewCell {
    var titleLabel = UILabel()
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        leftSeparatorSpace = 15
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftSeparatorSpace)
            make.right.lessThanOrEqualTo(-self.leftSeparatorSpace)
            make.centerY.equalTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class WXTagsViewController: WXTableViewController {
    var data: [WXUserGroup] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "标签"
        view.backgroundColor = UIColor.white
        tableView.register(WXTagCell.self, forCellReuseIdentifier: "TLTagCell")
        let rightBarButton = UIBarButtonItem(title: "新建", style: .plain, target: self, action: #selector(WXTagsViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        data = WXFriendHelper.shared.tagsData
    }
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLTagCell") as! WXTagCell
        cell.title = String(format: "%@(%ld)", group.groupName, Int(group.count))
        cell.topLineStyle = (indexPath.row == 0 ? .none : .none)
        cell.bottomLineStyle = (indexPath.row == data.count - 1 ? .none : .default)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
