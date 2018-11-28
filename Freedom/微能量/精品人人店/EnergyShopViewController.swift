//
//  EnergyShopViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class EnergyShopViewCell:BaseTableViewCell{
    override func initUI() {
        accessoryType = .disclosureIndicator
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        self.title = UILabel(frame: CGRect(x:XW( self.icon)+20, y:(80-20)/2.0, width: APPW-XW( self.icon), height: 20))
        self.line = UIView(frame: CGRect(x: 10, y: 79, width: APPW-20, height: 1))
        self.addSubviews([self.title,self.icon,self.line])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini3")
    }
}
class EnergyShopViewController: EnergyBaseViewController {
    let myTabBar = EnergyShopTabBarController.sharedRootViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-110))
        self.cellHeight = 80
        self.tableView.dataArray = NSMutableArray(array: ["酒水","茶饮","水果","生鲜","土地产","旅游","美丽人生","养生","服饰鞋袜","百货","美食","坚果零食","饰品","手工制品","家电家居","健身","宠品"])
    self.tableView.delegate = self
    self.tableView.dataSource = self
        view.addSubview(tableView)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: EnergyShopViewCell.identifier()) as? EnergyShopViewCell
        if cell == nil{
            cell = EnergyShopViewCell.getInstance() as? EnergyShopViewCell
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
EnergySuperMarketTabBarController.sharedRootViewController.isRemoveTab = false
//        myTabBar.hidesBottomBarWhenPushed = true
//        let animation = CATransition()
//        animation.duration = 1
//        view.window?.layer.add(animation, forKey: nil)
//        self.present(self.myTabBar, animated: true) {}
       
    self.navigationController?.pushViewController(myTabBar, animated: true)
    }
}
