//
//  JuheQuestionViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/16.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
import BaseFile
import XExtension
import XCarryOn
class JuheQuestionViewCell:BaseTableViewCell{
    override func initUI() {
        accessoryType = .disclosureIndicator
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        self.title = UILabel(frame: CGRect(x:XW( self.icon)+10, y: 10, width: APPW-XW( self.icon)-20, height: 20))
        self.line = UIView(frame: CGRect(x: 10, y: 69, width: APPW-20, height: 1))
        self.addSubviews([self.title,self.icon,self.line])
        self.title.text = "免费接口，不认证会影响使用吗？"
        self.icon.image = UIImage(named:"juhetab2")
    }
}
class JuheQuestionViewController: JuheBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let more = UIBarButtonItem(image: UIImage(named:"juheadd"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = more
    let searchBar = UISearchBar()
    searchBar.placeholder = "输入问题关键字";
    self.navigationItem.titleView = searchBar;
    self.cellHeight = 60
        self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        self.tableView.dataArray = NSMutableArray(array: ["","","","","","",""])
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    view.addSubview(tableView)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: JuheQuestionViewCell.identifier()) as? JuheQuestionViewCell
        if cell == nil{
            cell = JuheQuestionViewCell.getInstance() as? JuheQuestionViewCell
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = self.push(JuheDetailQuestion(), withInfo: "", withTitle: "问题详情")
    }
}
