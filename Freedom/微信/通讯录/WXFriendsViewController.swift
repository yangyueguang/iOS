//
//  WXFriendsViewController.swift
//  Freedom

import Foundation
class WXFriendCell: WXTableViewCell {
    //用户信息
    var user: WXUser
    private var avatarImageView: UIImageView
    private var usernameLabel: UILabel
    private var subTitleLabel: UILabel

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

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

        p_addMasonry()

    }
    func setUser(_ user: WXUser) {
        self.user = user
        if user.avatarPath != nil {
            avatarImageView.image = UIImage(named: user.avatarPath  "")
        } else {
            avatarImageView.sd_setImage(with: URL(string: user.avatarURL  ""), placeholderImage: UIImage(named: PuserLogo))
        }

        usernameLabel.text = user.showName
        subTitleLabel.text = user.detailInfo.remarkInfo
        if user.detailInfo.remarkInfo.length  0 > 0 && subTitleLabel.isHidden() {
            subTitleLabel.hidden = false
            usernameLabel.mas_updateConstraints({ make in
                make.centerY.mas_equalTo(self.avatarImageView).mas_offset(-9.5)
            })
        } else if user.detailInfo.remarkInfo.length == 0 && !subTitleLabel.isHidden() {
            usernameLabel.mas_updateConstraints({ make in
                make.centerY.mas_equalTo(self.avatarImageView)
            })
        }
    }
    func p_addMasonry() {
        avatarImageView.mas_makeConstraints({ make in
            make.left.mas_equalTo(10)
            make.top.mas_equalTo(9)
            make.bottom.mas_equalTo(-9 + 0.5)
            make.width.mas_equalTo(self.avatarImageView.mas_height)
        })

        usernameLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10)
            make.centerY.mas_equalTo(self.avatarImageView)
            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-20)
        })

        subTitleLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.usernameLabel)
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(2)
            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-20)
        })
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
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
            subTitleLabel.hidden = true
        }
        return subTitleLabel
    }

}

class WXFriendHeaderView: UITableViewHeaderFooterView {
    var title = ""
    private var titleLabel: UILabel

    init(reuseIdentifier: String) {
        //if super.init(reuseIdentifier: reuseIdentifier)

        let bgView = UIView()
        bgView.backgroundColor = UIColor.lightGray
        backgroundView = bgView
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }

    }

    func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 10, y: 0, width: frame.size.width - 15, height: frame.size.height)
    }
    func setTitle(_ title: String) {
        self.title = title
        titleLabel.text = title
    }

    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 14.5)
            titleLabel.textColor = UIColor.gray
        }
        return titleLabel
    }

}

class WXFriendsViewController: WXTableViewController ,UISearchBarDelegate {
    private var footerLabel: UILabel
    private var friendHelper: WXFriendHelper
    private var searchController: WXSearchController


    weak var data: [AnyHashable]
    weak var sectionHeaders: [AnyHashable]
    var searchVC: WXFriendSearchViewController


    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "通讯录"

        p_initUI() // 初始化界面UI
        registerCellClass()

        friendHelper = WXFriendHelper.shared() // 初始化好友数据业务类
        data = friendHelper.data
        sectionHeaders = friendHelper.sectionHeaders
        footerLabel.text = String(format: "%ld位联系人", Int(friendHelper.friendCount))

        weak var weakSelf = self
        friendHelper.dataChangedBlock = { data, headers, friendCount in
            weakSelf.data = data
            weakSelf.sectionHeaders = headers
            weakSelf.footerLabel.text = String(format: "%ld位联系人", friendCount)
            weakSelf.tableView.reloadData()
        }
    }
    // MARK: - Event Response -
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        let addFriendVC = WXAddFriendViewController()
        hidesBottomBarWhenPushed = true
        navigationController.pushViewController(addFriendVC, animated: true)
        hidesBottomBarWhenPushed = false
    }
    func p_initUI() {
        tableView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 0)
        tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0)
        tableView.separatorColor = UIColor.gray
        tableView.backgroundColor = UIColor.white
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor(46.0, 49.0, 50.0, 1.0)
        tableView.tableHeaderView = searchController.searchBar

        tableView.tableFooterView = footerLabel

        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_add_friend"), style: .done, target: self, action: #selector(self.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    var searchController: UISearchController {
        if searchController == nil {
            searchController = WXSearchController(searchResultsController: searchVC())
            searchController.searchResultsUpdater = searchVC()
            searchController.searchBar.placeholder = "搜索"
            searchController.searchBar.delegate = self
            searchController.showVoiceButton = true
        }
        return searchController
    }

    func searchVC() -> WXFriendSearchViewController {
        if searchVC == nil {
            searchVC = WXFriendSearchViewController()
        }
        return searchVC
    }
    func footerLabel() -> UILabel {
        if footerLabel == nil {
            footerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: APPW, height: 50.0))
            footerLabel.textAlignment = .center
            footerLabel.font = UIFont.systemFont(ofSize: 17.0)
            footerLabel.textColor = UIColor.gray
        }
        return footerLabel
    }

    // MARK: - Public Methods -
    func registerCellClass() {
        tableView.register(WXFriendHeaderView.self, forHeaderFooterViewReuseIdentifier: "TLFriendHeaderView")
        tableView.register(WXFriendCell.self, forCellReuseIdentifier: "TLFriendCell")
    }

    // MARK: - Delegate -
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = data[section] as WXUserGroup
        return group.count  0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        if section == 0 {
            return nil
        }
        let group = data[section] as WXUserGroup
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLFriendHeaderView") as WXFriendHeaderView
        view.title = group.groupName
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLFriendCell") as WXFriendCell
        let group = data[indexPath.section] as WXUserGroup
        let user = group[indexPath.row] as WXUser
        cell.user = user

        if indexPath.section == data.count - 1 && indexPath.row == group.count  0 - 1 {
            // 最后一个cell，底部全线
            cell.bottomLineStyle = TLCellLineStyleFill
        } else {
            cell.bottomLineStyle = indexPath.row == group.count  0 - 1  TLCellLineStyleNone : TLCellLineStyleDefault
        }

        return cell!
    }

    // 拼音首字母检索
    func sectionIndexTitles(for tableView: UITableView) -> [String] {
        return sectionHeaders
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if index == 0 {
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height), animated: false)
            return -1
        }
        return index
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 22
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = data[indexPath.section][indexPath.row] as WXUser
        if indexPath.section == 0 {
            if (user.userID == "-1") {
                let newFriendVC = WXNewFriendViewController()
                hidesBottomBarWhenPushed = true
                navigationController.pushViewController(newFriendVC, animated: true)
                hidesBottomBarWhenPushed = false
            } else if (user.userID == "-2") {
                let groupVC = WXGroupViewController()
                hidesBottomBarWhenPushed = true
                navigationController.pushViewController(groupVC, animated: true)
                hidesBottomBarWhenPushed = false
            } else if (user.userID == "-3") {
                let tagsVC = WXTagsViewController()
                hidesBottomBarWhenPushed = true
                navigationController.pushViewController(tagsVC, animated: true)
                hidesBottomBarWhenPushed = false
            } else if (user.userID == "-4") {
                let publicServer = WXPublicServerViewController()
                hidesBottomBarWhenPushed = true
                navigationController.pushViewController(publicServer, animated: true)
                hidesBottomBarWhenPushed = false
            }
        } else {
            let detailVC = WXFriendDetailViewController()
            detailVC.user = user
            hidesBottomBarWhenPushed = true
            navigationController.pushViewController(detailVC, animated: true)
            hidesBottomBarWhenPushed = false
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchVC.friendsData = WXFriendHelper.shared().friendsData
        //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tabBarController.tabBar.isHidden = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tabBarController.tabBar.isHidden = false
        //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        SVProgressHUD.showInfo(withStatus: "语音搜索按钮")
    }

    
}
