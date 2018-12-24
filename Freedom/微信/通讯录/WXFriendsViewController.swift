//
//  WXFriendsViewController.swift
//  Freedom
import SnapKit
import Foundation
class WXFriendCell: WXTableViewCell {
    private var avatarImageView = UIImageView()
    private var usernameLabel = UILabel()
    private lazy var subTitleLabel: UILabel =  {
        let subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.systemFont(ofSize: 14.0)
        subTitleLabel.textColor = UIColor.gray
        subTitleLabel.isHidden = true
        return subTitleLabel
    }()
    var user: WXUser = WXUser() {
        didSet {
            if !user.avatarPath.isEmpty {
                avatarImageView.image = UIImage(named: user.avatarPath)
            } else {
                avatarImageView.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: UIImage(named: PuserLogo))
            }
            usernameLabel.text = user.showName
            subTitleLabel.text = user.detailInfo.remarkInfo
            if user.detailInfo.remarkInfo.count > 0 && subTitleLabel.isHidden {
                subTitleLabel.isHidden = false
                usernameLabel.snp.updateConstraints { (make) in
                    make.centerY.equalTo(self.avatarImageView).offset(-9.5)
                }
            } else if user.detailInfo.remarkInfo.count == 0 && !subTitleLabel.isHidden {
                usernameLabel.snp.updateConstraints { (make) in
                    make.centerY.equalTo(self.avatarImageView)
                }
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftSeparatorSpace = 10
        usernameLabel.font = UIFont.systemFont(ofSize: 17.0)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(subTitleLabel)
//        p_addMasonry()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    func p_addMasonry() {
//        avatarImageView.mas_makeConstraints({ make in
//            make.left.mas_equalTo(10)
//            make.top.mas_equalTo(9)
//            make.bottom.mas_equalTo(-9 + 0.5)
//            make.width.mas_equalTo(self.avatarImageView.mas_height)
//        })
//        usernameLabel.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10)
//            make.centerY.mas_equalTo(self.avatarImageView)
//            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-20)
//        })
//        subTitleLabel.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self.usernameLabel)
//            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(2)
//            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-20)
//        })
//    }
}
class WXFriendHeaderView: UITableViewHeaderFooterView {
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14.5)
        titleLabel.textColor = UIColor.gray
        return titleLabel
    }()
    init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        let bgView = UIView()
        bgView.backgroundColor = UIColor.lightGray
        backgroundView = bgView
        addSubview(titleLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 10, y: 0, width: frame.size.width - 15, height: frame.size.height)
    }
}

class WXFriendsViewController: WXTableViewController ,UISearchBarDelegate {
    private lazy var footerLabel: UILabel = {
        let footerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: APPW, height: 50.0))
        footerLabel.textAlignment = .center
        footerLabel.font = UIFont.systemFont(ofSize: 17.0)
        footerLabel.textColor = UIColor.gray
        return footerLabel
    }()
//    private lazy var searchController: WXSearchController = {
//        let searchController = WXSearchController(searchResultsController: searchVC)
//        searchController.searchResultsUpdater = searchVC
//        searchController.searchBar.placeholder = "搜索"
//        searchController.searchBar.delegate = self
//        searchController.showVoiceButton = true
//        return searchController
//    }()
    private var friendHelper = WXFriendHelper.shared
    var data: [WXUserGroup] = []
    var sectionHeaders: [String] = []
//    var searchVC = WXFriendSearchViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "通讯录"
        tableView.register(WXFriendHeaderView.self, forHeaderFooterViewReuseIdentifier: "TLFriendHeaderView")
        tableView.register(WXFriendCell.self, forCellReuseIdentifier: "TLFriendCell")
        data = friendHelper.data
        sectionHeaders = friendHelper.sectionHeaders
        footerLabel.text = String(format: "%ld位联系人",friendHelper.friendCount)
        friendHelper.dataChangedBlock = { data, headers, friendCount in
            self.data = data
            self.sectionHeaders = headers
            self.footerLabel.text = String(format: "%ld位联系人", friendCount)
            self.tableView.reloadData()
        }
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.gray
        tableView.backgroundColor = UIColor.white
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor(46.0, 49.0, 50.0, 1.0)
//        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = footerLabel
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_add_friend"), style: .done, target: self, action: #selector(self.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
//        let addFriendVC = WXAddFriendViewController()
//        hidesBottomBarWhenPushed = true
//        navigationController.pushViewController(addFriendVC, animated: true)
//        hidesBottomBarWhenPushed = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = data[section] as WXUserGroup
        return group.count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let group = data[section] as WXUserGroup
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TLFriendHeaderView") as! WXFriendHeaderView
        view.title = group.groupName
        return view
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLFriendCell") as! WXFriendCell
        let group = data[indexPath.section] as WXUserGroup
        let user = group.users[indexPath.row]
        cell.user = user
        if indexPath.section == data.count - 1 && indexPath.row == group.count - 1 {
            cell.bottomLineStyle = .fill
        } else {
            cell.bottomLineStyle = indexPath.row == group.count - 1 ? .none : .default
        }
        return cell
    }
    // 拼音首字母检索
    override func sectionIndexTitles(for tableView: UITableView) -> [String] {
        return sectionHeaders
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if index == 0 {
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height), animated: false)
            return -1
        }
        return index
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 22
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = data[indexPath.section].users[indexPath.row]
//        if indexPath.section == 0 {
//            if (user.userID == "-1") {
//                let newFriendVC = WXNewFriendViewController()
//                hidesBottomBarWhenPushed = true
//                navigationController.pushViewController(newFriendVC, animated: true)
//                hidesBottomBarWhenPushed = false
//            } else if (user.userID == "-2") {
//                let groupVC = WXGroupViewController()
//                hidesBottomBarWhenPushed = true
//                navigationController.pushViewController(groupVC, animated: true)
//                hidesBottomBarWhenPushed = false
//            } else if (user.userID == "-3") {
//                let tagsVC = WXTagsViewController()
//                hidesBottomBarWhenPushed = true
//                navigationController.pushViewController(tagsVC, animated: true)
//                hidesBottomBarWhenPushed = false
//            } else if (user.userID == "-4") {
//                let publicServer = WXPublicServerViewController()
//                hidesBottomBarWhenPushed = true
//                navigationController.pushViewController(publicServer, animated: true)
//                hidesBottomBarWhenPushed = false
//            }
//        } else {
//            let detailVC = WXFriendDetailViewController()
//            detailVC.user = user
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(detailVC, animated: true)
//            hidesBottomBarWhenPushed = false
//        }
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchVC.friendsData = WXFriendHelper.shared.friendsData
//        UIApplication.shared.statusBarStyle = .default
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tabBarController?.tabBar.isHidden = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        noticeInfo("语音搜索按钮")
    }
}
