//
//  WXTagsViewController.swift
//  Freedom
import SnapKit
import XExtension
import Foundation
class WXTagCell: BaseTableViewCell<Any> {
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15.0)
        contentView.addSubview(title)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class WXTagsViewController: BaseTableViewController {
    var data: [WXUserGroup] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "标签"
        view.backgroundColor = UIColor.white
        tableView.register(WXTagCell.self, forCellReuseIdentifier: WXTagCell.identifier)
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
        let cell = tableView.dequeueCell(WXTagCell.self)
        cell.title.text = String(format: "%@(%ld)", group.groupName, Int(group.users.count))
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
