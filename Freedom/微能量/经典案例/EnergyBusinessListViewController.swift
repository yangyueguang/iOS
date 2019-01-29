//
//  EnergyBusinessListViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class EnergyBusinessViewCell:BaseTableViewCell<Any> {
    override func initUI() {
        accessoryType = .disclosureIndicator
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width:50, height:50))
        self.title = UILabel(frame: CGRect(x:self.icon.right+20, y:(70-20)/2.0, width: APPW-self.icon.right, height: 20))
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini3")
    }
}
class EnergyBusinessListViewController: EnergyBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight))
        self.tableView.rowHeight = 70
        self.tableView.dataArray = ["桌上美食","真心真艺","音响科技有限公司","智联招聘","前程无忧","百度百科","雅虎中国","360","布丁酒店","如家","莫泰168","宜家家居","微软中国","苹果公司","IBM"]
//     self.tableView.delegate = self;
//    self.tableView.dataSource = self;
        view.addSubview(self.tableView)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueCell(EnergyBusinessViewCell.self)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = self.tableView.dataArray[indexPath.row]
        _ = self.push(EnergyBusinessDetailViewController(), withInfo: "", withTitle: value as! String)
    }
}
