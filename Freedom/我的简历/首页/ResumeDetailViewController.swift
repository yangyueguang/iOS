//
//  ResumeDetailViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/15.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
import XExtension
class ResumeDetailViewController: ResumeBaseViewController,UIWebViewDelegate {
    let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight))
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.backgroundColor = .white
        let request = URLRequest(url: URL(string: "http://u1610639.jisuapp.cn/app?_app_id=FPNRLS1lOl")!)
        webView.loadRequest(request)
        view.addSubview(webView)
    
    }
}
