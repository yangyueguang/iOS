//
//  SDDiscoverTableViewController.swift
//  Freedom
import UIKit
import XExtension
class AlipayDiscoverTableViewHeaderItemModel: NSObject {
    var imageName = ""
    var title = ""
    convenience init(title: String?, imageName: String?) {
        self.init()
        self.title = title!
        self.imageName = imageName!
    }
}
class AlipayDiscoverTableViewControllerCell:BaseTableViewCell{
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.textColor = UIColor.darkGray
        textLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class AlipayDiscoverTableViewController: AlipayBaseViewController {
    var dataArray = [[AlipayAssetsTableViewControllerCellModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "口碑"
        let header = UIView(frame: CGRect.zero)
        header.height = 90
        let model01 = AlipayAssetsTableViewControllerCellModel(title: "淘宝电影", iconImageName: "adw_icon_movie_normal", destinationControllerClass: BaseTableView.self)
        let model02 = AlipayAssetsTableViewControllerCellModel(title: "快抢", iconImageName: "adw_icon_flashsales_normal", destinationControllerClass: BaseTableView.self)
        let model03 = AlipayAssetsTableViewControllerCellModel(title: "快的打车", iconImageName: "adw_icon_taxi_normal", destinationControllerClass: BaseTableView.self)
        let model11 = AlipayAssetsTableViewControllerCellModel(title: "我的朋友", iconImageName: "adw_icon_contact_normal", destinationControllerClass: BaseTableView.self)
        dataArray = [[model01, model02, model03],[model11]]
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - TopHeight))
        tableView.tableHeaderView = header
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.section][indexPath.row]
        var cell: AlipayDiscoverTableViewControllerCell? = tableView.dequeueReusableCell(withIdentifier: AlipayDiscoverTableViewControllerCell.identifier()) as? AlipayDiscoverTableViewControllerCell
        if cell == nil {
            cell = AlipayDiscoverTableViewControllerCell.getInstance() as? AlipayDiscoverTableViewControllerCell
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = model.title
        cell?.imageView?.image = UIImage(named:model.iconImageName)
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.section][indexPath.row]
        let vc: UIViewController? = UIViewController()// model?.destinationControllerClass
        vc?.title = model.title
        if let aVc = vc {
            navigationController?.pushViewController(aVc, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == dataArray.count - 1) ? 10 : 0
    }
}
