//
//  ToutiaoHomeDetailViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/16.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
class ToutiaoHomeDetailViewController: ToutiaoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let web = UIWebView(frame:view.bounds)
        let url = URL(string:"http://weibo.com/tv/v/ErdijBWkT?ref=feedsdk&type=ug")
        let request = URLRequest(url: url!)
        web.loadRequest(request)
        view.addSubview(web)
    }
}
