////
////  WXGameViewController.swift
////  Freedom
//
//import Foundation
//import WebKit
//class WXGameViewController: WXWebViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        useMPageTitleAsNavTitle(false)
//        setShowLoadingProgress(false)
//        disableBackButton(true)
//        navigationItem.title = "游戏"
//        setUrl("http://m.le890.com")
//        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_setting"), style: .plain, target: self, action: #selector(WXGameViewController.rightBarButtonDown(_:)))
//        navigationItem.rightBarButtonItem = rightBarButton
//        XHud.show()
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        XHud.hide()
//    }
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        XHud.hide()
//        super.webView(webView, didFinish: navigation)
//    }
//    func rightBarButtonDown(_ sender: UIBarButtonItem) {
//    }
//
//}
