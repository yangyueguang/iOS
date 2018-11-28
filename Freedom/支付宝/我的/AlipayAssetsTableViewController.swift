//
//  SDAssetsTableViewController.swift
//  Freedom
import UIKit
import XExtension
class AlipayAssetsTableViewControllerCell:BaseTableViewCell{
    override func initUI() {
        textLabel?.textColor = UIColor.darkGray
        textLabel?.font = UIFont.systemFont(ofSize: 15)
        
    }
    func setModel(_ model: NSObject?) {
        let cellModel = model as? AlipayAssetsTableViewControllerCellModel
        textLabel?.text = cellModel?.title
        imageView?.image = UIImage(named: cellModel?.iconImageName ?? "")
        accessoryType = .disclosureIndicator
    }
}
class AlipayAssetsTableViewController: AlipayBaseViewController {
    var dataArray = [[AlipayAssetsTableViewControllerCellModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的"
        let model01 = AlipayAssetsTableViewControllerCellModel(title: "余额宝", iconImageName: "alipayMeYuebao", destinationControllerClass: AlipayYuEBaoTableViewController.self)
        let model02 = AlipayAssetsTableViewControllerCellModel(title: "招财宝", iconImageName: "alipayMeZhaocai", destinationControllerClass: BaseTableView.self)
        let model03 = AlipayAssetsTableViewControllerCellModel(title: "娱乐宝", iconImageName: "alipayMeYulebao", destinationControllerClass: BaseTableView.self)
        let model11 = AlipayAssetsTableViewControllerCellModel(title: "芝麻信用分", iconImageName: "alipayMeZhima", destinationControllerClass: BaseTableView.self)
        let model12 = AlipayAssetsTableViewControllerCellModel(title: "随身贷", iconImageName: "alipayMeSuidai", destinationControllerClass: BaseTableView.self)
        let model13 = AlipayAssetsTableViewControllerCellModel(title: "我的保障", iconImageName: "alipayMeBaozhang", destinationControllerClass: BaseTableView.self)
        let model21 = AlipayAssetsTableViewControllerCellModel(title: "爱心捐赠", iconImageName: "alipayMeDonation", destinationControllerClass: BaseTableView.self)
        dataArray = [[model01, model02, model03], [model11, model12, model13], [model21]]
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - TopHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        view.addSubview(tableView)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.section][indexPath.row]
        var cell: AlipayAssetsTableViewControllerCell? = tableView.dequeueReusableCell(withIdentifier: AlipayAssetsTableViewControllerCell.identifier()) as? AlipayAssetsTableViewControllerCell
        if cell == nil {
            cell = AlipayAssetsTableViewControllerCell.getInstance() as? AlipayAssetsTableViewControllerCell
        }
        cell?.setModel(model)
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
