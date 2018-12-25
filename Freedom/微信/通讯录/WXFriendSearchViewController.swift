//
//  WXFriendSearchViewController.swift
//  Freedom

import Foundation
class WXFriendSearchViewController: WXTableViewController, UISearchResultsUpdating {
    var friendsData: [WXUser] = []
    var data: [WXUser] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WXFriendCell.self, forCellReuseIdentifier: "FriendCell")
        automaticallyAdjustsScrollViewInsets = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: TopHeight + 20, width: tableView.frame.size.width, height: APPH - tableView.frame.origin.y)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return "联系人"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! WXFriendCell
        let user = data[indexPath.row] as WXUser
        cell.user = user
        cell.topLineStyle = (indexPath.row == 0 ? .fill : .none)
        cell.bottomLineStyle = (indexPath.row == data.count - 1 ? .fill : .default)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        data.removeAll()
        for user: WXUser in friendsData {
            if user.remarkName.contains(searchText) || user.username.contains(searchText) || user.nikeName.contains(searchText) || user.pinyin.contains(searchText) || user.pinyinInitial.contains(searchText) {
                data.append(user)
            }
        }
        tableView.reloadData()
    }
}
