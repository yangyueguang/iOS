//
//  EnergyBusinessDetailViewController.swift
//  Freedom
import UIKit
class EnergyBusinessDetailViewController: EnergyBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let web = UIWebView(frame:view.bounds)
        let url = URL(string: "http://www.taobao.com")
        let request = URLRequest(url: url!)
        web.loadRequest(request)
        view.addSubview(web)
    }
}
