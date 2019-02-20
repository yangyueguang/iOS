//
//  WXShoppingViewController.swift
//  Freedom

import Foundation
class WXShoppingViewController: WXWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(image:Image.shopping.image, style: .plain, target: self, action: #selector(WXShoppingViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        self.url = "http://m.zhuanzhuan.com"
    }
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
}
