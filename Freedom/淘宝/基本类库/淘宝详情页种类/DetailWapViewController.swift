//
//  DetailWapViewController.swift
//  Freedom
import UIKit
import XExtension
class DetailWapViewController: TaobaoBaseViewController {
    private var totalNumber: Int = 3
    private var images = ["1.jpg", "l.jpg", "w.jpg", "xt.jpg"]
    private var titles = ["图文详情", "商品评论", "百度"]
    private var urls = ["http://m.b5m.com/item.html?tid=2614676&mps=____&type=content", "http://m.b5m.com/item.html?tid=2614676&mps=____&type=comment", "http://m.baidu.com"]
    var detailView: DetailView!
    var topWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        detailView = DetailView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
        topWebView = UIWebView(frame: detailView.bounds)
        topWebView.scrollView.showsVerticalScrollIndicator = false
        topWebView.backgroundColor = UIColor.white
        topWebView.isOpaque = false
        view.addSubview(detailView)
        view.backgroundColor = UIColor.lightGray
        if let aString = URL(string: "http://m.b5m.com/item.html?tid=2614676&mps=____&type=index") {
            topWebView.loadRequest(URLRequest(url: aString))
        }
        detailView.reloadData()
    }
}
