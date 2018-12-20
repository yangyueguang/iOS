//
//  WXPublicServerViewController.swift
//  Freedom

import Foundation
class WXPublicServerViewController: WXTableViewController, UISearchBarDelegate {
    var searchController: WXSearchController
    var searchVC: WXPublicServerSearchViewController

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "公众号"
        view.backgroundColor = UIColor.white

        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_add"), style: .plain, target: self, action: #selector(WXPublicServerViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton

        tableView.tableHeaderView = searchController.searchBar
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }

    // MARK: - Delegate -
    //MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
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

    func searchVC() -> WXPublicServerSearchViewController {
        if searchVC == nil {
            searchVC = WXPublicServerSearchViewController()
        }
        return searchVC
    }

}
