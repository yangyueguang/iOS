//
//  ResumeViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/15.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
import XExtension
import XCarryOn
class ResumeViewCell:BaseCollectionViewCell{
    override func initUI() {
    }
}
class ResumeViewController: ResumeBaseViewController {
    var ResumeHomeScrollV:BaseScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        let a = ["我的简历","微信","微信小程序2","微页1","微页2","微页3"]
        let b = ["我的简历","微页1","微页3","微信小程序1","微信小程序2","微页2"]
        let c = ["微信小程序1","我的简历","微信小程序2","微页1","微页2","微页3"]
        let titles = ["我的成长史","我的作品","我的经历"];
        let con1 = ResumeListViewController()
        let con2 = ResumeListViewController()
        let con3 = ResumeListViewController()
        con1.listArray = a
        con2.listArray = b
        con3.listArray = c
        let controllers = [con1,con2,con3];
        ResumeHomeScrollV = BaseScrollView(contentTitleView: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight), titles: titles, controllers: controllers, in: self)
        ResumeHomeScrollV.selectBlock = {(index,dict) in
            
        }
//        view.addSubview(ResumeHomeScrollV)
    }
}
