//
//  TaobaoMiniTopicViewController.swift
//  Freedom
import UIKit
import XExtension
class TaobaoMiniTopicViewCell:BaseTableViewCell{
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        title.frame = CGRect(x: XW(icon) + 10, y: Y(icon), width: APPW - XW(icon) - 10, height: 20)
        script.frame = CGRect(x: X(title), y: YH(title) + 10, width: W(title), height: 20)
        let sees = UILabel(frame: CGRect(x: X(script), y: YH(script), width: W(script), height: 15), font: Font(12), color: .gray, text: nil)
        line.frame = CGRect(x: 0, y: 90 - 1, width: APPW, height: 1)
        Dlog(H(self))
        addSubview(sees)
        icon.image = UIImage(named: "a")
        title.text = "韩国年度榜"
        script.text = "主持人：全球购买手小队长"
        sees.text = "热度：79570  参与人：100"
    }
}
class TaobaoMiniTopicViewController: TaobaoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = BaseScrollView(banner: CGRect(x: 0, y: 0, width: APPW, height: 120), icons:["",""])
        _ = [
            "type" : "1"
        ]
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: view.frameHeight - 20), style: .plain)
        tableView.dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}
