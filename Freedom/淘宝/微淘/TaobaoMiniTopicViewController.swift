//
//  TaobaoMiniTopicViewController.swift
//  Freedom
import UIKit
//import XExtension
class TaobaoMiniTopicViewCell:BaseTableViewCell<Any> {
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        title.frame = CGRect(x: icon.right + 10, y: icon.y, width: APPW - icon.right - 10, height: 20)
        script.frame = CGRect(x: title.x, y: title.bottom + 10, width: title.width, height: 20)
        let sees = UILabel(frame: CGRect(x: script.x, y: script.bottom, width: script.width, height: 15), font: Font(12), color: .gray, text: nil)
        Dlog(self.height)
        addSubview(sees)
        icon.image = Image.a.image
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
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: view.height - 20), style: .plain)
        tableView.dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
        tableView.separatorStyle = .none
//        tableView.dataSource = self
//        tableView.delegate = self
        view.addSubview(tableView)
    }
}
