//
//  SDAssetsTableViewController.swift
//  Freedom
import UIKit
import XExtension
class AlipayMeCell:BaseTableViewCell<AlipayMeCellModel<UIViewController>> {
    override func initUI() {
        textLabel?.textColor = UIColor.darkGray
        textLabel?.font = UIFont.systemFont(ofSize: 15)
        
    }
    func setModel(_ model: NSObject?) {
        let cellModel = model as? AlipayMeCellModel
        textLabel?.text = cellModel?.title
        imageView?.image = UIImage(named: cellModel?.icon ?? "")
        accessoryType = .disclosureIndicator
    }
}
final class AlipayAssetsTableViewController: BaseTableViewController {
    var dataArray = [[AlipayMeCellModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的"
        let model01 = AlipayMeCellModel("余额宝", "alipayMeYuebao", AlipayYuEBaoTableViewController.self)
        let model02 = AlipayMeCellModel("招财宝", "alipayMeZhaocai", nil)
        let model03 = AlipayMeCellModel("娱乐宝", "alipayMeYulebao", nil)
        let model11 = AlipayMeCellModel("芝麻信用分","alipayMeZhima", nil)
        let model12 = AlipayMeCellModel("随身贷", "alipayMeSuidai", nil)
        let model13 = AlipayMeCellModel("我的保障", "alipayMeBaozhang", nil)
        let model21 = AlipayMeCellModel("爱心捐赠", "alipayMeDonation", nil)
        dataArray = [[model01, model02, model03], [model11, model12, model13], [model21]] as! [[AlipayMeCellModel<UIViewController>]]
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - TopHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.section][indexPath.row]
        let cell = tableView.dequeueCell(AlipayMeCell.self)
        cell.viewModel.onNext(model)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.section][indexPath.row]
        let vc = model.target?.init()
        vc?.title = model.title
        push(vc)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == dataArray.count - 1) ? 10 : 0
    }
}
