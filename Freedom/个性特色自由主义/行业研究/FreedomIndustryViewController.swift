//
//  FreedomIndustryViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/15.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
import XExtension
import XCarryOn
final class FreedomIndustryViewController: FreedomBaseViewController {
    var controllers:[String]!
    var banner:BaseScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人应用"
        banner = BaseScrollView.init(banner: CGRect(x: 0, y: 0, width: APPW, height: 120), icons: ["","",""])
        banner.backgroundColor = .red

        self.tableView.dataArray = ["互联网行业","教育培训行业","计算机软件","计算机硬件","个人电脑","食品连锁","快消品行业","耐消品行业","手机市场","房地产行业","汽车行业","奢侈品行业","其他行业"]
    }
}
