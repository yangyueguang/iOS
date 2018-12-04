//
//  ToutiaoHomeSampleViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class ToutiaoHomeSampleViewCell:BaseTableViewCell{
    override func initUI() {
        icon = UIImageView(frame: CGRect(x: 10, y: 0, width: 80, height: 80))
        title = UILabel(frame: CGRect(x:100, y: 10, width: 300, height: 80))
        title.numberOfLines = 0
        addSubviews([icon,title])
    }
}
class ToutiaoHomeSampleViewController: ToutiaoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 90
    self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH), style: .grouped)
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
        self.tableView.dataArray = ["","","","","","","",""]
    view.addSubview(tableView)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headBanner = BaseScrollView(banner: CGRect(x: 0, y: 0, width: APPW, height: 120), icons: ["","",""])
        headBanner.selectBlock = {(index,dict) in
            print("\(index)\(String(describing: dict))")
        }
        return headBanner;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = self.push(ToutiaoHomeDetailViewController(), withInfo:"", withTitle: "")
    }
}
