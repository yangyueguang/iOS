//
//  EnergyContactUSViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class EnergyContactUSViewCell:BaseTableViewCell<Any> {
    override func initUI() {
        accessoryType = .disclosureIndicator
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width:60, height: 60))
        self.title = UILabel(frame: CGRect(x: self.icon.right+20, y: (80-20)/2.0, width: APPW-self.icon.right, height: 20))
        self.addSubviews([self.title,self.icon])
        self.title.text = ""
        self.icon.image = UIImage(named:"taobaomini3")
    }
}
final class EnergyContactUSViewController: EnergyBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    self.title = "联系我们"
    let banner = BaseScrollView(banner: CGRect(x: 0, y: 0, width: APPW, height: 120), icons: ["",""])
        banner.backgroundColor = .red
        self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight))
        self.tableView.rowHeight = 80
        self.tableView.dataArray = ["一键导航","关注公众号","查看历史消息","微信营销交流","客服聊天","诚聘精英"]
    self.tableView.tableHeaderView = banner
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    view.addSubview(tableView)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueCell(EnergyContactUSViewCell.self)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let value = self.tableView.dataArray[indexPath.row];
        push(EnergyContactDetailViewController(), info: "", title: value as! String)
    }
}
