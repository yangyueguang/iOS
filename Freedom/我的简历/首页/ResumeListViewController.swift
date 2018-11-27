//
//  ResumeListViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/15.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
import BaseFile
import XExtension
import XCarryOn
class ResumeListViewCell:BaseTableViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        self.title = UILabel(frame: CGRect(x: XW( self.icon)+10, y: 10, width: APPW-100, height: 20))
        self.script = UILabel(frame: CGRect(x: self.title.x(), y: YH( self.title), width: APPW-100, height: 20))
        self.script.textColor = .gray
        addSubviews([self.icon,self.title,self.script])
    }
    
}
class ResumeListViewController: ResumeBaseViewController {
    public var listArray:[String]!
    override func viewDidLoad() {
        super.viewDidLoad()
self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        view.addSubview(self.tableView)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ResumeListViewCell.identifier()) as? ResumeListViewCell
        if cell == nil{
            cell = ResumeListViewCell.getInstance() as? ResumeListViewCell
        }
        cell?.icon.image = UIImage(named: "userLogo")
        cell?.title.text = self.listArray[indexPath.row]
        cell?.script.text = "url"
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ss = self.listArray[indexPath.row]
        _ = self.push(ResumeDetailViewController(), withInfo:ss, withTitle:ss)
    }
}
