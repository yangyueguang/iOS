//
//  WXPublicServerViewController.swift
//  Freedom
import XExtension
import Foundation
class WXPublicServerViewController: BaseTableViewController, UISearchBarDelegate {
    lazy var searchController: WXSearchController = {
        let searchController = WXSearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.delegate = self
        return searchController
    }()
    var searchVC = WXPublicServerSearchViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "公众号"
        view.backgroundColor = UIColor.whitex
        let rightBarButton = UIBarButtonItem(image: Image.add.image, style: .plain, target: self, action: #selector(WXPublicServerViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        tableView.tableHeaderView = searchController.searchBar
    }
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
}
