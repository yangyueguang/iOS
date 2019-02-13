//
//  SDDiscoverTableViewController.swift
//  Freedom
import UIKit
import XExtension
class AlipayDiscoverCell:BaseTableViewCell<Any> {
    override func initUI() {

    }
}
final class AlipayDiscoverTableViewController: AlipayBaseViewController {
    var dataArray = [[CellModelC<UIViewController>]]()
    open var tableView: BaseTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "口碑"
        let header = UIView(frame: CGRect.zero)
        header.height = 90
        let model01 = CellModelC<UIViewController>("淘宝电影","", "adw_icon_movie_normal")
        let model02 = CellModelC<UIViewController>("快抢","", "adw_icon_flashsales_normal")
        let model03 = CellModelC<UIViewController>("快的打车","", "adw_icon_taxi_normal", nil)
        let model11 = CellModelC<UIViewController>("我的朋友","", "adw_icon_contact_normal",nil)
        dataArray = [[model01, model02, model03],[model11]]
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - TopHeight))
        tableView.tableHeaderView = header
//        tableView.delegate = self
//        tableView.dataSource = self
        view.addSubview(tableView)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.section][indexPath.row]
        var cell = tableView.dequeueCell(AlipayDiscoverCell.self)
        cell.textLabel?.text = model.title
        cell.imageView?.image = UIImage(named:model.icon)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.section][indexPath.row]
        let vc: UIViewController? = UIViewController()// model?.target
        vc?.title = model.title
        if let aVc = vc {
            navigationController?.pushViewController(aVc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == dataArray.count - 1) ? 10 : 0
    }
}
