//
//  WXGroupViewController.swift
//  Freedom

import Foundation

class WXGroupSearchViewController: WXTableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var groupData: [AnyHashable] = []
    private var data: [AnyHashable] = []

    func viewDidLoad() {
        super.viewDidLoad()

        data = [AnyHashable]()
        tableView.register(WXGroupCell.self, forCellReuseIdentifier: "TLGroupCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLGroupCell") as WXGroupCell

        let group = data[indexPath.row] as WXGroup
        cell.group = group
        return cell!
    }

    // MARK: - Delegate -
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text.lowercased()
        data.removeAll()
        for group: WXGroup in groupData {
            if group.groupName.contains(searchText)  false || group.pinyin.contains(searchText)  false || group.pinyinInitial.contains(searchText)  false {
                if let aGroup = group {
                    data.append(aGroup)
                }
            }
        }
        tableView.reloadData()
    }

    
}

class WXGroupCell: WXTableViewCell {
    var group: WXGroup
    private var avatarImageView: UIImageView
    private var usernameLabel: UILabel

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        leftSeparatorSpace = 10

        if let aView = avatarImageView {
            contentView.addSubview(aView)
        }
        if let aLabel = usernameLabel {
            contentView.addSubview(aLabel)
        }

        p_addMasonry()

    }
    func setGroup(_ group: WXGroup) {
        self.group = group
        let path = FileManager.pathUserAvatar(group.groupAvatarPath)
        var image = UIImage(named: path)
        if image == nil {
            image = UIImage(named: PuserLogo)
        }
        avatarImageView.image = image
        usernameLabel.text = group.groupName
    }

    // MARK: - Private Methods -
    func p_addMasonry() {
        avatarImageView.mas_makeConstraints({ make in
            make.left.mas_equalTo(10)
            make.top.mas_equalTo(9.5)
            make.bottom.mas_equalTo(-9.5 + 0.5)
            make.width.mas_equalTo(self.avatarImageView.mas_height)
        })

        usernameLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10)
            make.centerY.mas_equalTo(self.avatarImageView)
            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-20)
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

    
}

class WXGroupViewController: WXTableViewController ,UISearchBarDelegate {
    private var searchController: WXSearchController
    var data: [AnyHashable] = []
    var searchVC: WXGroupSearchViewController
    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "群聊"
        view.backgroundColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar

        registerCellClass()

        data = WXFriendHelper.shared().groupsData
    }
    var searchController: UISearchController {
        if searchController == nil {
            searchController = WXSearchController(searchResultsController: searchVC())
            searchController.searchResultsUpdater = searchVC()
            searchController.searchBar.placeholder = "搜索"
            searchController.searchBar.delegate = self
        }
        return searchController
    }

    func searchVC() -> WXGroupSearchViewController {
        if searchVC == nil {
            searchVC = WXGroupSearchViewController()
        }
        return searchVC
    }

    // MARK: - Public Methods -
    func registerCellClass() {
        tableView.register(WXGroupCell.self, forCellReuseIdentifier: "TLGroupCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group: WXGroup = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLGroupCell") as WXGroupCell
        cell.group = group
        cell.bottomLineStyle = (indexPath.row == data.count - 1  TLCellLineStyleFill : TLCellLineStyleDefault)
        return cell!
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = data[indexPath.row] as WXGroup
        let chatVC = WXChatViewController.sharedChatVC()
        chatVC.partner = group
        let vc: UIViewController = WXTabBarController.sharedRootView().childViewController(atIndex: 0)
        WXTabBarController.sharedRootView().selectedIndex = 0
        vc.hidesBottomBarWhenPushed = true
        vc.navigationController.push(chatVC, animated: true) { finished in
            self.navigationController.popViewController(animated: false)
        }
        vc.hidesBottomBarWhenPushed = false
    }

    //MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchVC.groupData = data
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }





}
