//
//  WXWebViewController.swift
//  Freedom
import Foundation
import WebKit
class WXWebViewController: WXBaseViewController, WKNavigationDelegate {/// 是否使用网页标题作为nav标题，默认YES
    var useMPageTitleAsNavTitle = true/// 是否显示加载进度，默认YES
    // 是否禁止历史记录，默认NO
    var showLoadingProgress = true {
        didSet {
            progressView.isHidden = !showLoadingProgress
        }
    }
    var disableBackButton = false
    var url = "" {
        didSet {
            if view.isFirstResponder {
                progressView.progress = 0.0
                if let anUrl = URL(string: self.url) {
                    webView.load(URLRequest(url: anUrl))
                }
            }
        }
    }
    lazy var webView = WKWebView(frame: CGRect(x: 0, y: Int(TopHeight) + 20, width: Int(APPW), height: Int(APPH - TopHeight) - 20))
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x: 0, y: TopHeight + 20.0, width: APPW, height: 10.0))
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        progressView.progressTintColor = UIColor.green
        progressView.trackTintColor = UIColor.clear
        return progressView
    }()
    lazy var backButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItem.Style.done, actionBlick: {
        if self.webView.canGoBack {
            self.webView.goBack()
            self.navigationItem.leftBarButtonItems = [self.backButtonItem, self.closeButtonItem] as? [UIBarButtonItem]
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    })
    lazy var closeButtonItem = UIBarButtonItem(title: "关闭") {
        self.navigationController?.popViewController(animated: true)
    }
    lazy var authLabel: UILabel = {
        let authLabel = UILabel(frame: CGRect(x: 20, y: Int(TopHeight) + 20 + 13, width: Int(APPW - 40), height: 0))
            authLabel.font = UIFont.systemFont(ofSize: 12.0)
            authLabel.textAlignment = .center
            authLabel.textColor = UIColor.gray
            authLabel.numberOfLines = 0
            return authLabel
        }()

    override func loadView() {
        super.loadView()
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        view.addSubview(authLabel)
        view.addSubview(webView)
        view.addSubview(progressView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
        webView.scrollView.backgroundColor = UIColor.clear
        for vc in webView.scrollView.subviews {
            if let cls = object_getClass(vc) {
                if (NSStringFromClass(cls) == "WKContentView") {
                    vc.backgroundColor = UIColor.white
                    break
                }
            }
        }
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.scrollView.addObserver(self, forKeyPath: "backgroundColor", options: .new, context: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("WebVC")
        progressView.progress = 0.0
        if let anUrl = URL(string: url) {
            webView.load(URLRequest(url: anUrl))
        }
        if !disableBackButton && (navigationItem.leftBarButtonItems?.count ?? 0) <= 2 {
            navigationItem.leftBarButtonItems = [backButtonItem] as? [UIBarButtonItem]
        }
    }
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.scrollView.removeObserver(self, forKeyPath: "backgroundColor")
    }
    func observeValue(forKeyPath keyPath: String, of object: Any, change: [NSKeyValueChangeKey : Any], context: UnsafeMutableRawPointer) {
        if showLoadingProgress && (keyPath == "estimatedProgress") && (object as! WKWebView) == webView {
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0.0
                }) { finished in
                    self.progressView.setProgress(0.0, animated: false)
                }
            }
        } else if (keyPath == "backgroundColor") && (object as! UIScrollView) == webView.scrollView {
            let color = change[NSKeyValueChangeKey.newKey] as! UIColor
            if !(color.cgColor == UIColor.clear.cgColor) {
                (object as! UIView).backgroundColor = UIColor.clear
            }
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if useMPageTitleAsNavTitle {
            navigationItem.title = webView.title
            authLabel.text = "网页由 \(String(describing: webView.url?.host)) 提供"
            var rec: CGRect = authLabel.frame
            rec.size.height = authLabel.sizeThatFits(CGSize(width: authLabel.frame.size.width, height: CGFloat(MAXFLOAT))).height
            authLabel.frame = rec
        }
    }
}
