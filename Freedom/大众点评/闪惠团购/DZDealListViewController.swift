//
//  DZDealListViewController.swift
//  Freedom
import UIKit
import XExtension
class DZDealListViewTransverseCell:BaseTableViewCell<Any> {
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 0, width: APPW - 20, height: 60)
        title.frame = CGRect(x: icon.x, y: icon.bottom, width: icon.width, height: 30)
        script.frame = CGRect(x: title.x, y: title.bottom, width: title.width, height: 13)
        title.numberOfLines = 0
        title.font = .small
        script.font = Font(11)
        icon.image = UIImage(named: "image4.jpg")
        title.text = "与爱齐名，为有初心不变，小编为大家收集了超多好文好店，从手工匠人到原型设计，他们并没有忘记"
        script.text = "地道风味 精选外卖优惠"
    }
}
class DZDealListViewVerticalCell:BaseTableViewCell<Any> {
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 10, width: 70, height: 70)

        let name = UILabel(frame: CGRect(x: icon.right + 10, y: 10, width: APPW - icon.right - 30, height: 20), font: .middle,color:UIColor.grayx,text: "")
        let times = UILabel(frame: CGRect(x: APPW - 100, y: name.y, width: 80, height: 15), font: Font(11), color: .gray, text: nil)
        times.textAlignment = .right
        title.frame = CGRect(x: name.x, y: name.bottom + 5, width: name.width, height: 20)
        title.font = .small
        script.frame = CGRect(x: title.x, y: title.bottom + 5, width: 80, height: 20)
        let sees = UILabel(frame: CGRect(x: times.x, y: script.y, width: times.width, height: 15), font: Font(11), color: .gray, text: nil)
        sees.textAlignment = .right
        script.backgroundColor = .red
        script.textColor = .white
        addSubviews([name, times, sees])
        icon.image = UIImage(named: "image2.jpg")
        name.text = "传说张无忌肉夹馍"
        times.text = "2.3km"
        icon.image = UIImage(named: "image4.jpg")
        title.text = "49分钟送达|起送￥20.0|配送￥3.0"
        script.text = "满20减10"
        sees.text = "月售1000"
    }
}
class DZDealListViewController: DZBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
            tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: view.height - 20), style: .plain)
            tableView.dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
//            tableView.dataSource = self
//            tableView.delegate = self
            view.addSubview(tableView)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BaseTableViewCell<Any>!
        if indexPath.row % 5 != 0 {//竖着的
            cell = tableView.dequeueCell(DZDealListViewVerticalCell.self)
        } else {//横着的
            cell = tableView.dequeueCell(DZDealListViewTransverseCell.self)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(DZDealDetailViewController(), info: "", title: "详情")
    }
}
