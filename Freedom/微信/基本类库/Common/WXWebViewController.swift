//
//  WXWebViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
class WXWebViewController: WXBaseViewController, WKNavigationDelegate {
    /// 是否使用网页标题作为nav标题，默认YES
    var useMPageTitleAsNavTitle = false
    /// 是否显示加载进度，默认YES
    var showLoadingProgress = false
    // 是否禁止历史记录，默认NO
    var disableBackButton = false
    var url = ""
    var webView: WKWebView
    var progressView: UIProgressView
    var backButtonItem: UIBarButtonItem
    var closeButtonItem: UIBarButtonItem
    var authLabel: UILabel

    init() {
        super.init()

        useMPageTitleAsNavTitle = true
        showLoadingProgress = true

    }

    func loadView() {
        super.loadView()
        view.addSubview(authLabel)
        if let aView = webView {
            view.addSubview(aView)
        }
        view.addSubview(progressView)
    }

    func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
        webView.scrollView.backgroundColor = UIColor.clear
        for vc: Any in webView.scrollView.subviews  [] {
            let className = NSStringFromClass(vc.self.self)
            if (className == "WKContentView") {
                vc.backgroundColor = UIColor.white
                break
            }
        }
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.scrollView.addObserver(self, forKeyPath: "backgroundColor", options: .new, context: nil)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("WebVC")
        progressView.progress = 0.0
        if let anUrl = URL(string: url) {
            webView.load(URLRequest(url: anUrl))
        }
        if !disableBackButton && (navigationItem.leftBarButtonItems.count  0) <= 2 {
            navigationItem.leftBarButtonItems = [backButtonItem]
        }
    }

    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("WebVC")
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.scrollView.removeObserver(self, forKeyPath: "backgroundColor")
        #if DEBUG_MEMERY
        DLog("dealloc WebVC")
        #endif
    }

    // MARK: - Public Methods -
    func setUrl(_ url: String) {
        self.url = url
        if view.isFirstResponder {
            progressView.progress = 0.0
            if let anUrl = URL(string: self.url) {
                webView.load(URLRequest(url: anUrl))
            }
        }
    }
    func observeValue(forKeyPath keyPath: String, of object: Any, change: [NSKeyValueChangeKey : Any], context: UnsafeMutableRawPointer) {

        if showLoadingProgress && (keyPath == "estimatedProgress") && (object as WKWebView) == webView {
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress  0.0), animated: true)

            if (webView.estimatedProgress  0.0) >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0.0
                }) { finished in
                    self.progressView.setProgress(0.0, animated: false)
                }
            }
        } else if (keyPath == "backgroundColor") && (object as UIScrollView) == webView.scrollView {
            let color = change["new"] as UIColor
            if !(color.cgColor == UIColor.clear.cgColor) {
                object.backgroundColor = UIColor.clear
            }
        }
    }
    func setShowLoadingProgress(_ showLoadingProgress: Bool) {
        self.showLoadingProgress = showLoadingProgress
        progressView.hidden = !showLoadingProgress
    }

    // MARK: - Event Response -
    func navBackButotnDown() {
        if webView.canGoBack  false {
            webView.goBack()
            navigationItem.leftBarButtonItems = [backButtonItem, closeButtonItem]
        } else {
            navigationController.popViewController(animated: true)
        }
    }

    func navCloseButtonDown() {
        navigationController.popViewController(animated: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if useMPageTitleAsNavTitle {
            navigationItem.title = webView.title
            authLabel.text = "网页由 \(webView.url.host  "") 提供"
            let rec: CGRect = authLabel.frame
            rec.size.height = authLabel.sizeThatFits(CGSize(width: authLabel.frame.size.width, height: MAXFLOAT)).height
            authLabel.frame = rec
        }
    }
    weak var webView: WKWebView {
        if webView == nil {
            webView = WKWebView(frame: CGRect(x: 0, y: Int(TopHeight) + 20, width: APPW, height: Int(APPH - TopHeight) - 20))
            webView.allowsBackForwardNavigationGestures = true
            webView.navigationDelegate = self
        }
        return webView
    }

    func progressView() -> UIProgressView {
        if progressView == nil {
            progressView = UIProgressView(frame: CGRect(x: 0, y: Int(TopHeight) + 20, width: APPW, height: 10.0))
            progressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
            progressView.progressTintColor = UIColor.green
            progressView.trackTintColor = UIColor.clear
        }
        return progressView
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func backButtonItem() -> UIBarButtonItem {
        if backButtonItem == nil {
            backButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItem.Style.done, actionBlick: {
                self.navBackButotnDown()
            })
        }
        return backButtonItem
    }

    func closeButtonItem() -> UIBarButtonItem {
        if closeButtonItem == nil {
            closeButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(self.navCloseButtonDown))
        }
        return closeButtonItem
    }

    func authLabel() -> UILabel {
        if authLabel == nil {
            authLabel = UILabel(frame: CGRect(x: 20, y: Int(TopHeight) + 20 + 13, width: APPW - 40, height: 0))
            authLabel.font = UIFont.systemFont(ofSize: 12.0)
            authLabel.textAlignment = .center
            authLabel.textColor = UIColor.gray
            authLabel.numberOfLines = 0
        }
        return authLabel
    }

}
