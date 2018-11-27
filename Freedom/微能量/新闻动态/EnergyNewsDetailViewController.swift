//
//  EnergyNewsDetailViewController.swift
//  Freedom
import UIKit
class EnergyNewsDetailViewController: EnergyBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let web = UIWebView(frame:view.bounds)
        let url = URL(string:"http://weibo.com/tv/v/ErdijBWkT?ref=feedsdk&type=ug")
        let request = URLRequest(url: url!)
        web.loadRequest(request)
        view.addSubview(web)
    }
}
