//
//  JFWebViewController.swift
//  Freedom
import UIKit
import XExtension
class IqiyiWebViewController: IqiyiBaseViewController,UIWebViewDelegate{
    let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64))
    var urlStr  = ""
    var isFirstIn = false
    var activityView = UIActivityIndicatorView(frame: CGRect(x: APPW / 2 - 15, y: APPH / 2 - 15, width: 30, height: 30))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whitex
        //返回
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        backBtn.setImage(Image.left.image, for: .normal)
        backBtn.addTarget(self, action: Selector(("OnBackBtn:")), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        webView.delegate = self
        webView.scalesPageToFit = true
        view.addSubview(webView)
        Dlog("webview URL:\( self.urlStr)")
        let urlStr = self.urlStr
        var request: URLRequest? = nil
        if let aStr = URL(string: urlStr ) {
            request = URLRequest(url: aStr)
            webView.loadRequest(request!)
            activityView.style = .gray
            activityView.hidesWhenStopped = true
            view.addSubview(activityView)
            view.bringSubviewToFront(activityView)
        }
    }
        func onBackBtn(_ sender: UIButton?) {
            Dlog("_isFirstIn:\(isFirstIn)")
            if isFirstIn {
                navigationController?.popViewController(animated: true)
            } else {
                isFirstIn = true
//                webView?.goBack()
            }
        }
        
        // MARK: - UIWebViewDelegate
        func webViewDidStartLoad(_ webView: UIWebView) {
            Dlog("开始加载webview")
        }
        
        func webViewDidFinishLoad(_ webView: UIWebView) {
            Dlog("加载webview完成")
            let theTitle = webView.stringByEvaluatingJavaScript(from: "document.title")
            title = theTitle
            activityView.stopAnimating()
        }
        
        func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
            Dlog("加载webview失败")
        }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
            activityView.startAnimating()
            return true
        }
}
