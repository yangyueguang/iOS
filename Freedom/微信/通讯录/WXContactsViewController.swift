//
//  WXContactsViewController.swift
//  Freedom
import SnapKit
import Foundation
class WechatContactCell: WXTableViewCell {
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
                avatarImageView.sd_setImage(with: URL(string: contact.avatarURL), placeholderImage: UIImage(named: PuserLogo))
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftSeparatorSpace = 10
        usernameLabel.font = UIFont.systemFont(ofSize: 17.0)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(rightButton)
//        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    func p_addMasonry() {
//        avatarImageView.mas_makeConstraints({ make in
//            make.left.mas_equalTo(10)
//            make.top.mas_equalTo(9.5)
//            make.bottom.mas_equalTo(-9.5 + 0.5)
//            make.width.mas_equalTo(self.avatarImageView.mas_height)
//        })
//        usernameLabel.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10)
//            make.top.mas_equalTo(self.avatarImageView).mas_offset(-1)
//            make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).mas_offset(-10)
//        })
//        subTitleLabel.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self.usernameLabel)
//            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(2)
//            make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).mas_offset(-10)
//        })
//        rightButton.mas_makeConstraints({ make in
//            make.right.mas_equalTo(self.contentView).mas_offset(-5)
//            make.centerY.mas_equalTo(self.contentView)
//            make.height.mas_equalTo(30)
//            make.width.mas_greaterThanOrEqualTo(48)
//        })
//    }
}

class WXContactsSearchViewController: WXTableViewController, UISearchResultsUpdating {
    var contactsData: [WechatContact] = []
    private var data: [WechatContact] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WechatContactCell.self, forCellReuseIdentifier: "TLContactCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLContactCell") as! WechatContactCell
        let contact = data[indexPath.row]
        cell.contact = contact
        cell.topLineStyle = (indexPath.row == 0 ? .fill : .none)
        cell.bottomLineStyle = (indexPath.row == data.count - 1 ? .fill : .default)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        data.removeAll()
        for contact: WechatContact in contactsData {
            if contact.name.contains(searchText) || contact.pinyin.contains(searchText) || contact.pinyinInitial.contains(searchText) {
                data.append(contact)
            }
        }
        tableView.reloadData()
    }
}

class WXContactsViewController: WXTableViewController, UISearchBarDelegate {
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
        tableView.register(WXFriendHeaderView.self, forHeaderFooterViewReuseIdentifier: "TLFriendHeaderView")
        tableView.register(WechatContactCell.self, forCellReuseIdentifier: "TLContactCell")
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
        return group.users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = data[indexPath.section].users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLContactCell") as! WechatContactCell
//        cell.contact = contact
        let temp = data[indexPath.section]
        if indexPath.section == data.count - 1 && indexPath.row == temp.count - 1 {
            cell.bottomLineStyle = .fill
        } else {
            cell.bottomLineStyle = (indexPath.row == temp.count - 1 ? .none : .default)
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
