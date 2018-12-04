//
//  DetailScrollViewController.swift
//  Freedom
import UIKit
import XExtension
class DetailScrollViewController: TaobaoBaseViewController {
    private var titles = ["图文详情", "商品评论", "店铺推荐"]
    private var urls = ["http://m.b5m.com/item.html?tid=2614676&mps=____&type=content", "http://m.b5m.com/item.html?tid=2614676&mps=____&type=comment", "http://m.baidu.com"]
    var detailView: DetailView?
    var scrollView: UIScrollView?
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        detailView = DetailView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 64))
        scrollView?.contentSize = CGSize(width: view.bounds.size.width, height: (view.bounds.size.height - 64) * 1 + 1.0)
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 64))
        label.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
        label.text = "Label 1"
        label.textAlignment = .center
        scrollView?.addSubview(label)
        label = UILabel(frame: CGRect(x: 0, y: view.bounds.size.height - 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
        label.backgroundColor = .red
        label.text = "Label 2"
        label.textAlignment = .center
        scrollView?.addSubview(label)
        label = UILabel(frame: CGRect(x: 0, y: view.bounds.size.height - 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
        label.backgroundColor = .red
        label.text = "Label 2"
        label.textAlignment = .center
        scrollView?.addSubview(label)
        if let aView = detailView {
            view.addSubview(aView)
        }
        view.backgroundColor = .lightGray
        detailView?.reloadData()
        scrollView?.contentSize = CGSize(width: view.bounds.size.width, height: (view.bounds.size.height - 64) * 2)
    }
}
