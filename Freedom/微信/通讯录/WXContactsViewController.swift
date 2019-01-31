//
//  WXContactsViewController.swift
//  Freedom
import SnapKit
import XCarryOn
import Foundation
class WechatContactCell: BaseTableViewCell<WechatContact> {
    var avatarImageView = UIImageView()
    var usernameLabel = UILabel()
    lazy var subTitleLabel: UILabel =  {
        let subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.systemFont(ofSize: 14.0)
        subTitleLabel.textColor = UIColor.gray
        return subTitleLabel
    }()
    lazy var rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        rightButton.layer.masksToBounds = true
        rightButton.layer.cornerRadius = 4.0
        rightButton.layer.borderWidth = 1
        return rightButton
    }()
    var contact: WechatContact = WechatContact() {
        didSet {
            if !contact.avatarPath.isEmpty {
                let path = FileManager.pathContactsAvatar(contact.avatarPath)
                avatarImageView.image = UIImage(named: path)
            } else {
                avatarImageView.sd_setImage(with: URL(string: contact.avatarURL), placeholderImage: Image.logo.image)
            }
            usernameLabel.text = contact.name
            subTitleLabel.text = contact.tel
            if contact.status == .stranger {
                rightButton.backgroundColor = UIColor.green
                rightButton.setTitle("添加", for: .normal)
                rightButton.setTitleColor(UIColor.white, for: .normal)
                rightButton.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
            } else {
                rightButton.backgroundColor = UIColor.clear
                rightButton.setTitleColor(UIColor.gray, for: .normal)
                rightButton.layer.borderColor = UIColor.clear.cgColor
                if contact.status == .friend {
                    rightButton.setTitle("已添加", for: .normal)
                } else if contact.status == .wait {
                    rightButton.setTitle("等待验证 ", for: .normal)
                }
            }
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        usernameLabel.font = UIFont.systemFont(ofSize: 17.0)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(rightButton)
        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func p_addMasonry() {
        avatarImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(9.5)
            make.bottom.equalTo(-9)
            make.width.equalTo(self.avatarImageView.snp.height)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10)
            make.top.equalTo(self.avatarImageView).offset(-1)
            make.right.lessThanOrEqualTo(self.rightButton.snp.left).offset(-10)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.usernameLabel)
            make.top.equalTo(self.usernameLabel.snp.bottom).offset(2)
            make.right.lessThanOrEqualTo(self.rightButton.snp.left).offset(-10)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-5)
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(30)
            make.width.greaterThanOrEqualTo(48)
        }
    }
}

final class WXContactsSearchViewController: BaseTableViewController, UISearchResultsUpdating {
    var contactsData: [WechatContact] = []
    private var data: [WechatContact] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WechatContactCell.self, forCellReuseIdentifier: WechatContactCell.identifier)
        automaticallyAdjustsScrollViewInsets = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: TopHeight + 20.0, width: tableView.frame.size.width, height: APPH - tableView.frame.origin.y)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(WechatContactCell.self)
        let contact = data[indexPath.row]
        cell.contact = contact
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        data.removeAll()
        for contact: WechatContact in contactsData {
            if contact.name.contains(searchText) || contact.name.pinyin().contains(searchText) || contact.name.firstLetter().contains(searchText) {
                data.append(contact)
            }
        }
        tableView.reloadData()
    }
}

class WXContactsViewController: BaseTableViewController, UISearchBarDelegate {
    var contactsData: [WechatContact] = []// 通讯录好友（初始数据）
    var data: [WXUserGroup] = []// 通讯录好友（格式化的列表数据）
    var headers: [String] = []// 通讯录好友索引
    var searchVC = WXContactsSearchViewController()
    private lazy var searchController: WXSearchController = {
        let searchController = WXSearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.delegate = self
        return searchController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "通讯录朋友"
        view.backgroundColor = UIColor.white
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor(46.0, 49.0, 50.0, 1.0)
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(WXFriendHeaderView.self, forHeaderFooterViewReuseIdentifier: WXFriendHeaderView.identifier)
        tableView.register(WechatContactCell.self, forCellReuseIdentifier: WechatContactCell.identifier)
        XHud.show(.withDetail(message: "加载中"))
        WXFriendHelper.trytoGetAllContacts(success: { data, formatData, headers in
            XHud.hide()
            self.data = formatData
            self.contactsData = data
            self.headers = headers
            self.tableView.reloadData()
            MobClick.event("e_get_contacts")
        }, failed: {
            XHud.hide()
            self.noticeError("未成功获取到通讯录信息")
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        XHud.hide()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = data[section]
        return Int(group.users.count)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = data[indexPath.section].users[UInt(indexPath.row)]
        let cell = tableView.dequeueCell(WechatContactCell.self)
//        cell.contact = contact
        let temp = data[indexPath.section]
        if indexPath.section == data.count - 1 && indexPath.row == temp.users.count - 1 {

        } else {
            
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let group = data[section] as WXUserGroup
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLFriendHeaderView") as! WXFriendHeaderView
        view.title = group.groupName
        return view
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String] {
        return headers
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchVC.contactsData = contactsData
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
}
