//
//  DZDealListViewController.swift
//  Freedom
import UIKit
import XExtension
class DZDealListViewTransverseCell:BaseTableViewCell{
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 0, width: APPW - 20, height: 60)
        title.frame = CGRect(x: X(icon), y: YH(icon), width: W(icon), height: 30)
        script.frame = CGRect(x: X(title), y: YH(title), width: W(title), height: 13)
        title.numberOfLines = 0
        title.font = fontSmall
        script.font = Font(11)
        line.frame = CGRect(x: 0, y: 100 - 1, width: APPW, height: 1)
        icon.image = UIImage(named: "image4.jpg")
        title.text = "与爱齐名，为有初心不变，小编为大家收集了超多好文好店，从手工匠人到原型设计，他们并没有忘记"
        script.text = "地道风味 精选外卖优惠"
    }
}
class DZDealListViewVerticalCell:BaseTableViewCell{
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 10, width: 70, height: 70)

        let name = UILabel(frame: CGRect(x: XW(icon) + 10, y: 10, width: APPW - XW(icon) - 30, height: 20), font: fontMiddle,color:UIColor(0, 111, 255),text: "")
        let times = UILabel(frame: CGRect(x: APPW - 100, y: Y(name), width: 80, height: 15), font: Font(11), color: .gray, text: nil)
        times.textAlignment = .right
        title.frame = CGRect(x: X(name), y: YH(name) + 5, width: W(name), height: 20)
        title.font = fontSmall
        script.frame = CGRect(x: X(title), y: YH(title) + 5, width: 80, height: 20)
        let sees = UILabel(frame: CGRect(x: X(times), y: Y(script), width: W(times), height: 15), font: Font(11), color: .gray, text: nil)
        sees.textAlignment = .right
        line.frame = CGRect(x: 0, y: 100 - 1, width: APPW, height: 1)
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
            tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: view.frameHeight - 20), style: .plain)
            tableView.dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
            tableView.dataSource = self
            tableView.delegate = self
            view.addSubview(tableView)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BaseTableViewCell?
        if indexPath.row % 5 != 0 {
            //竖着的
            cell = tableView.dequeueReusableCell(withIdentifier: DZDealListViewVerticalCell.identifier()) as? BaseTableViewCell
            if cell == nil {
                cell = DZDealListViewVerticalCell.getInstance() as? BaseTableViewCell
            }
        } else {
            //横着的
            cell = tableView.dequeueReusableCell(withIdentifier: DZDealListViewTransverseCell.identifier()) as? BaseTableViewCell
            if cell == nil {
                cell = DZDealListViewTransverseCell.getInstance() as? BaseTableViewCell
            }
        }
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = push(DZDealDetailViewController(), withInfo: "", withTitle: "详情")
    }
}
