//
//  EnergyNewsViewController.swift
//  Freedom
import UIKit
//import XExtension
//import XCarryOn
class EnergyNewsViewCell:BaseTableViewCell<Any> {
    override func initUI() {
        accessoryType = .disclosureIndicator
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height:50))
        self.title = UILabel(frame: CGRect(x:self.icon.right+20, y: (70-20)/2.0, width: APPW-self.icon.right, height: 20))
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = Image.logo.image
    }
}
final class EnergyNewsViewController: EnergyBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新闻动态";
    self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight))
        self.tableView.rowHeight = 70
        self.tableView.dataArray = ["人人店分销团队如何持续裂变","微营销流量引入的几点思考","”微时代 新电商“邀您对话千万资产","养出80%的回购率","0.2元低成本吸粉的玩法","阿罗古堡人人店，上线当月销量近60万","高潮迭起 微巴人人店征战中国","微营销对话微市场，新时代的迭起"]
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    view.addSubview(tableView)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueCell(EnergyNewsViewCell.self)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = self.tableView.dataArray[indexPath.row]
        push(EnergyNewsDetailViewController(), info: "", title: value as! String)
    }
}
