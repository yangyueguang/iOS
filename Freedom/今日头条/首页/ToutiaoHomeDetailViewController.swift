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
        var model: TopicModel.TopicNew = self.userInfo as! TopicModel.TopicNew
        let web = UIWebView(frame:view.bounds)
        let url = URL(string:model.rawUrl)
        let request = URLRequest(url: url!)
        web.loadRequest(request)
        view.addSubview(web)
    }
}
