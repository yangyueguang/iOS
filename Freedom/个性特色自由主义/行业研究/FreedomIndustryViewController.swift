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
class FreedomViewCell:BaseTableViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        self.title = UILabel(frame: CGRect(x:self.icon.right+10, y: 20, width: APPW-self.icon.right-20, height: 20))
        self.title.font = UIFont.systemFont(ofSize: 14)
        self.title.textAlignment = .center
        self.script = UILabel(frame:CGRect(x: self.title.x, y:  self.title.bottom, width: self.title.width, height: self.title.height))
        self.script.textColor = .gray
        self.line = UIView(frame: CGRect(x: 10, y: 79, width: APPW-20, height: 1))
        self.addSubviews([self.title,self.icon,self.script,self.line])
    }
}
class FreedomIndustryViewController: FreedomBaseViewController {
    var controllers:[String]!
    var banner:BaseScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人应用"
        banner = BaseScrollView.init(banner: CGRect(x: 0, y: 0, width: APPW, height: 120), icons: ["","",""])
        banner.backgroundColor = .red
        self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight))
        self.tableView.dataArray = ["互联网行业","教育培训行业","计算机软件","计算机硬件","个人电脑","食品连锁","快消品行业","耐消品行业","手机市场","房地产行业","汽车行业","奢侈品行业","其他行业"]
        self.tableView.tableHeaderView = banner;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        view.addSubview(self.tableView)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: FreedomViewCell.identifier) as? FreedomViewCell
        if cell == nil{
            cell = FreedomViewCell.getInstance() as? FreedomViewCell
        }
        cell?.icon.image = UIImage(named: "userLogo")
        cell?.title.text = self.tableView.dataArray[indexPath.row] as? String
        cell?.script.text = "url"
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
