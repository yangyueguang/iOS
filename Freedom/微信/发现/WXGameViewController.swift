//
//  WXGameViewController.swift
//  Freedom

import Foundation
class WXGameViewController: WXWebViewController {
    func viewDidLoad() {
        super.viewDidLoad()
        setUseMPageTitleAsNavTitle(false)
        setShowLoadingProgress(false)
        setDisableBackButton(true)

        navigationItem.title = "游戏"
        setUrl("http://m.le890.com")

        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_setting"), style: .plain, target: self, action: #selector(WXGameViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton

        SVProgressHUD.show(withStatus: "加载中")
    }
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }

    // MARK: - Delegate -
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        super.webView(webView, didFinish: navigation)
    }

    // MARK: - Event Response
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }

}
