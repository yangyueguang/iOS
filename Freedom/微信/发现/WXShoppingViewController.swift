//
//  WXShoppingViewController.swift
//  Freedom

import Foundation
class WXShoppingViewController: WXWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_shopping_menu"), style: .plain, target: self, action: #selector(WXShoppingViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        self.url = "http://m.zhuanzhuan.com"
    }
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
}
