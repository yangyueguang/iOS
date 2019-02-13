//
//  SDAssetsTableViewController.swift
//  Freedom
import UIKit
import XExtension
class AlipayMeCell:BaseTableViewCell<CellModelC<UIViewController>> {

}
final class AlipayAssetsTableViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = CellModelC("余额宝", "","", AlipayYuEBaoTableViewController.self)
        let vc = model.target?.init()
        push(vc, title: model.title)
    }
}
