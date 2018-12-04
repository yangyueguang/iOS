//
//  EnergySampleViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/16.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
import UIKit
import XExtension
import XCarryOn
class EnergySampleViewCell:BaseTableViewCell{
    override func initUI() {
        accessoryType = .disclosureIndicator
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        self.title = UILabel(frame: CGRect(x:XW( self.icon)+20, y: (70-20)/2.0, width: APPW-XW( self.icon), height: 20))
        self.line = UIView(frame: CGRect(x: 10, y: 69, width: APPW-20, height: 1))
        self.addSubviews([self.title,self.icon,self.line])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
class EnergySampleViewController: EnergyBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "经典案例"
        self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-110))
        self.tableView.dataArray = NSMutableArray(array:["政府机构/媒体","母婴/儿童","教育/培训","商场百货","电商/商贸/零售","金融/投资/保险","医疗/健康/保健/养生","旅游","酒店","婚庆","房产","装饰","娱乐","金融","政务","汽车","餐饮"])
        self.tableView.rowHeight = 70
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        view.addSubview(self.tableView)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: EnergySampleViewCell.identifier()) as? EnergySampleViewCell
        if cell == nil{
            cell = EnergySampleViewCell.getInstance() as? EnergySampleViewCell
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = self.tableView.dataArray[indexPath.row]
        _ = self.push(EnergyBusinessListViewController(), withInfo: "", withTitle: value as! String)
    }
}
