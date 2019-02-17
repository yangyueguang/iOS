//
//  DZDiscoverController.swift
//  Freedom
import UIKit
import XExtension
final class DZDiscoverController: DZBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar()
        searchBar.placeholder = "输入商户名、地点"
        navigationItem.titleView = searchBar
        view.backgroundColor = UIColor.whitex
        let map = UIBarButtonItem(title: "北京", action: {
        })
        navigationItem.leftBarButtonItem = map
        let titles = ["精选", "嗨周末", "变漂亮", "潮餐厅", "出去浪", "探店报告"]
        let vc = DZDealListViewController()
        let controllers = [vc,vc,vc,vc,vc,vc]
        let contentScrollView = BaseScrollView(contentTitleView: CGRect(x: 0, y: 0, width: APPW, height: APPH - 55), titles: titles, controllers:controllers, in: self)
        contentScrollView.selectBlock = {(_ index: Int, _ dict: [AnyHashable: Any]?) -> Void in
            Dlog("点击了\(String(describing: dict))")
        }
    }
}
