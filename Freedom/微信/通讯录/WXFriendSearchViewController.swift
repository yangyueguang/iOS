//
//  WXFriendSearchViewController.swift
//  Freedom

import Foundation
class WXFriendSearchViewController: WXTableViewController, UISearchResultsUpdating {
    var friendsData: [AnyHashable] = []
    var data: [AnyHashable] = []

    func viewDidLoad() {
        super.viewDidLoad()

        data = [AnyHashable]()
        tableView.register(WXFriendCell.self, forCellReuseIdentifier: "FriendCell")
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return "联系人"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as WXFriendCell

        let user = data[indexPath.row] as WXUser
        cell.user = user
        cell.topLineStyle = (indexPath.row == 0  TLCellLineStyleFill : TLCellLineStyleNone)
        cell.bottomLineStyle = (indexPath.row == data.count - 1  TLCellLineStyleFill : TLCellLineStyleDefault)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text.lowercased()
        data.removeAll()
        for user: WXUser in friendsData {
            if user.remarkName.contains(searchText  "")  false || user.username.contains(searchText  "")  false || user.nikeName.contains(searchText  "")  false || user.pinyin.contains(searchText  "")  false || user.pinyinInitial.contains(searchText  "")  false {
                if let anUser = user {
                    data.append(anUser)
                }
            }
        }
        tableView.reloadData()
    }



    
}
