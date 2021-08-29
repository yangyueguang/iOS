//
//  WXGameViewController.swift
//  Freedom

import Foundation
import WebKit
//import XCarryOn
class WXGameViewController: WXWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        useMPageTitleAsNavTitle = false
        showLoadingProgress = false
        disableBackButton = true
        self.url = "http://m.le890.com"
        navigationItem.title = "游戏"
        let rightBarButton = UIBarButtonItem(image: Image.setting.image, style: .plain, target: self, action: #selector(self.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        XHud.show()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        XHud.hide()
    }
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        XHud.hide()
        super.webView(webView, didFinish: navigation)
    }
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
}
