//
//  TaobaoMiniArticleViewController.swift
//  Freedom
import UIKit
import XExtension
class TaobaoMiniArticleViewController: TaobaoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: view.height - 20), style: .plain)
        tableView.dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}
