//
//  DZDealController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
class DZDealController: DZBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func buildUI() {
        view.backgroundColor = UIColor.white
        let map = UIBarButtonItem(title: "北京", style: .plain, actionBlick: {() -> Void in
        })
        navigationItem.leftBarButtonItem = map
        navigationItem.title = "团购"
        let titles = ["精选", "享美食", "点外卖", "看电影", "趣休闲"]
        let vc = DZDealListViewController()
        let controllers = [vc,vc,vc,vc,vc]
        let contentScrollView = BaseScrollView(contentTitleView: CGRect(x: 0, y: 0, width: APPW, height: APPH - 100), titles: titles, controllers:controllers, in: self)
        contentScrollView.selectBlock = {(_ index: Int, _ dict: [AnyHashable: Any]?) -> Void in
            Dlog("点击了\(String(describing: dict))")
        }
    }
}
