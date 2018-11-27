//
//  EnergyDetailViewController.swift
//  Freedom
import UIKit
class EnergyDetailViewController: EnergyBaseViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let web = UIWebView(frame:view.bounds)
        let url = URL(string:"http://weibo.com/tv/v/ErlcFmAdZ?from=vhot")
        let request = URLRequest(url: url!)
        web.loadRequest(request)
        view.addSubview(web)
    }
}
