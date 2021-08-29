//
//  EnergyShopViewController.swift
//  Freedom
import UIKit
//import XExtension
//import XCarryOn
class EnergyShopViewCell:BaseTableViewCell<Any>{
    override func initUI() {
        accessoryType = .disclosureIndicator
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        self.title = UILabel(frame: CGRect(x:self.icon.right+20, y:(80-20)/2.0, width: APPW-self.icon.right, height: 20))
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = Image.logo.image
    }
}
class EnergyShopViewController: EnergyBaseViewController {
    let myTabBar = EnergyShopTabBarController.sharedRootViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-110))
        self.tableView.rowHeight = 80
        self.tableView.dataArray = ["酒水","茶饮","水果","生鲜","土地产","旅游","美丽人生","养生","服饰鞋袜","百货","美食","坚果零食","饰品","手工制品","家电家居","健身","宠品"]
//    self.tableView.delegate = self
//    self.tableView.dataSource = self
        view.addSubview(tableView)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueCell(EnergyShopViewCell.self)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
EnergySuperMarketTabBarController.sharedRootViewController.isRemoveTab = false
//        let animation = CATransition()
//        animation.duration = 1
//        view.window?.layer.add(animation, forKey: nil)
//        self.present(self.myTabBar, animated: true) {}
       
    self.navigationController?.pushViewController(myTabBar, animated: true)
    }
}
