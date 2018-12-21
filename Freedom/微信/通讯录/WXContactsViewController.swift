//
//  WXContactsViewController.swift
//  Freedom

import Foundation

class WechatContactCell: WXTableViewCell {
    var contact: WechatContact
    var avatarImageView: UIImageView
    var usernameLabel: UILabel
    var subTitleLabel: UILabel
    var rightButton: UIButton

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        leftSeparatorSpace = 10

        if let aView = avatarImageView {
            contentView.addSubview(aView)
        }
        if let aLabel = usernameLabel {
            contentView.addSubview(aLabel)
        }
        if let aLabel = subTitleLabel {
            contentView.addSubview(aLabel)
        }
        if let aButton = rightButton {
            contentView.addSubview(aButton)
        }

        p_addMasonry()

    }
    func setContact(_ contact: WechatContact) {
        self.contact = contact
        if contact.avatarPath != nil {
            let path = FileManager.pathContactsAvatar(contact.avatarPath)
            avatarImageView.image = UIImage(named: path)
        } else {
            avatarImageView.sd_setImage(with: URL(string: contact.avatarURL), placeholderImage: UIImage(named: PuserLogo))
        }

        usernameLabel.text = contact.name
        subTitleLabel.text = contact.tel
        if contact.status == TLContactStatusStranger {
            rightButton.backgroundColor = UIColor.green
            rightButton.setTitle("添加", for: .normal)
            rightButton.setTitleColor(UIColor.white, for: .normal)
            rightButton.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
        } else {
            rightButton.backgroundColor = UIColor.clear
            rightButton.setTitleColor(UIColor.gray, for: .normal)
            rightButton.layer.borderColor = UIColor.clear.cgColor
            if contact.status == TLContactStatusFriend {
                rightButton.setTitle("已添加", for: .normal)
            } else if contact.status == TLContactStatusWait {
                rightButton.setTitle("等待验证 ", for: .normal)
            }
        }
    }
    func p_addMasonry() {
        avatarImageView.mas_makeConstraints({ make in
            make.left.mas_equalTo(10)
            make.top.mas_equalTo(9.5)
            make.bottom.mas_equalTo(-9.5 + 0.5)
            make.width.mas_equalTo(self.avatarImageView.mas_height)
        })

        usernameLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10)
            make.top.mas_equalTo(self.avatarImageView).mas_offset(-1)
            make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).mas_offset(-10)
        })

        subTitleLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.usernameLabel)
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(2)
            make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).mas_offset(-10)
        })

        rightButton.mas_makeConstraints({ make in
            make.right.mas_equalTo(self.contentView).mas_offset(-5)
            make.centerY.mas_equalTo(self.contentView)
            make.height.mas_equalTo(30)
            make.width.mas_greaterThanOrEqualTo(48)
        })
    }
    func avatarImageView() -> UIImageView {
        if avatarImageView == nil {
            avatarImageView = UIImageView()
        }
        return avatarImageView
    }

    func usernameLabel() -> UILabel {
        if usernameLabel == nil {
            usernameLabel = UILabel()
            usernameLabel.font = UIFont.systemFont(ofSize: 17.0)
        }
        return usernameLabel
    }

    func subTitleLabel() -> UILabel {
        if subTitleLabel == nil {
            subTitleLabel = UILabel()
            subTitleLabel.font = UIFont.systemFont(ofSize: 14.0)
            subTitleLabel.textColor = UIColor.gray
        }
        return subTitleLabel
    }
    func rightButton() -> UIButton {
        if rightButton == nil {
            rightButton = UIButton()
            rightButton.titleLabel.font = UIFont.systemFont(ofSize: 14.0)
            rightButton.layer.masksToBounds = true
            rightButton.layer.cornerRadius = 4.0
            rightButton.layer.borderWidth = 1
        }
        return rightButton
    }


}

class WXContactsSearchViewController: WXTableViewController, UISearchResultsUpdating {
    var contactsData: [Any] = []

    private var data: [AnyHashable] = []

    func viewDidLoad() {
        super.viewDidLoad()

        data = [AnyHashable]()
        tableView.register(WechatContactCell.self, forCellReuseIdentifier: "TLContactCell")
        automaticallyAdjustsScrollViewInsets = false
    }

    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: Int(TopHeight) + 20, width: tableView.frame.size.width, height: APPH - tableView.frame.origin.y)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLContactCell") as WechatContactCell

        let contact = data[indexPath.row] as WechatContact
        cell.contact = contact
        cell.topLineStyle = (indexPath.row == 0  TLCellLineStyleFill : TLCellLineStyleNone)
        cell.bottomLineStyle = (indexPath.row == data.count - 1  TLCellLineStyleFill : TLCellLineStyleDefault)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }

    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text.lowercased()
        data.removeAll()
        for contact: WechatContact in contactsData {
            if contact.name.contains(searchText)  false || contact.pinyin.contains(searchText)  false || contact.pinyinInitial.contains(searchText)  false {
                if let aContact = contact {
                    data.append(aContact)
                }
            }
        }
        tableView.reloadData()
    }

    
}

class WXContactsViewController: WXTableViewController, UISearchBarDelegate {
    /// 通讯录好友（初始数据）
    var contactsData: [Any] = []
    /// 通讯录好友（格式化的列表数据）
    var data: [Any] = []
    /// 通讯录好友索引
    var headers: [Any] = []
    var searchVC: WXContactsSearchViewController

    private var searchController: WXSearchController
    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "通讯录朋友"
        view.backgroundColor = UIColor.white

        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor(46.0, 49.0, 50.0, 1.0)
        tableView.tableHeaderView = searchController.searchBar

        registerCellClass()

        SVProgressHUD.show(withStatus: "加载中")
        WXFriendHelper.try(toGetAllContactsSuccess: { data, formatData, headers in
            SVProgressHUD.dismiss()
            self.data = formatData
            self.contactsData = data
            self.headers = headers
            self.tableView.reloadData()

            MobClick.event("e_get_contacts")
        }, failed: {
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "未成功获取到通讯录信息")
        })
    }
    
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }

    // MARK: - Getter -
    var searchController: UISearchController {
        if searchController == nil {
            searchController = WXSearchController(searchResultsController: searchVC())
            searchController.searchResultsUpdater = searchVC()
            searchController.searchBar.placeholder = "搜索"
            searchController.searchBar.delegate = self
        }
        return searchController
    }

    func searchVC() -> WXContactsSearchViewController {
        if searchVC == nil {
            searchVC = WXContactsSearchViewController()
        }
        return searchVC
    }
    func registerCellClass() {
        tableView.register(WXFriendHeaderView.self, forHeaderFooterViewReuseIdentifier: "TLFriendHeaderView")
        tableView.register(WechatContactCell.self, forCellReuseIdentifier: "TLContactCell")
    }

    // MARK: - Delegate -
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = data[section] as WXUserGroup
        return group.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = data[indexPath.section][indexPath.row] as WechatContact
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLContactCell") as WechatContactCell
        cell.contact = contact
        let temp = data[indexPath.section]
        if indexPath.section == data.count - 1 && indexPath.row == temp.count - 1 {
            cell.bottomLineStyle = TLCellLineStyleFill
        } else {
            cell.bottomLineStyle = (indexPath.row == temp.count - 1  TLCellLineStyleNone : TLCellLineStyleDefault)
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let group = data[section] as WXUserGroup
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLFriendHeaderView") as WXFriendHeaderView
        view.title = group.groupName
        return view
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String] {
        return headers
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }

    //MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchVC.contactsData = contactsData
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }




    
}
