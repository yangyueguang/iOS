//
//  WXDiscoverViewController.swift
//  Freedom
import SnapKit
import XExtension
import Foundation
class WXDiscoverHelper: NSObject {
    var discoverMenuData: [[WXMenuItem]] = []
    override init() {
        super.init()
        let de = WXMenuItem("u_frendsCircle","朋友圈")

        var item1 = WXMenuItem("u_frendsCircle", "")
        item1.rightIconURL = "http://img4.duitang.com/uploads/item/201510/16/20151016113134_TZye4.thumb.224_0.jpeg"
        item1.showRightRedPoint = true
        let item2 = WXMenuItem("u_scan_b", "扫一扫")
        let item3 =  WXMenuItem("u_shake", "摇一摇")
        let item4 = WXMenuItem("ff_IconLocationService", "附近的人")
        let item5 = WXMenuItem("ff_IconBottle", "漂流瓶")
        let item6 = WXMenuItem("CreditCard_ShoppingBag", "购物")
        var item7 = WXMenuItem("MoreGame", "游戏")
        item7.rightIconURL = "http://qq1234.org/uploads/allimg/140404/3_140404151205_8.jpg"
        item7.subTitle = "英雄联盟计算器版"
        item7.showRightRedPoint = true
        discoverMenuData.append(contentsOf: [[item1], [item2, item3], [item4, item5], [item6, item7]])
    }
}
final class WXDiscoverViewController: BaseTableViewController {
    var momentsVC = WXMomentsViewController()
    var discoverHelper = WXDiscoverHelper()
    var data: [[WXMenuItem]] = []
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.lightGray
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.gray
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 20))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        navigationItem.title = "发现"
        data = discoverHelper.discoverMenuData
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row] as WXMenuItem
        if (item.title == "朋友圈") {
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(momentsVC, animated: true)
            hidesBottomBarWhenPushed = false
        }
        if (item.title == "扫一扫") {
            let scannerVC = WXScanningViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(scannerVC, animated: true)
            hidesBottomBarWhenPushed = false
        } else if (item.title == "摇一摇") {
            let shakeVC = WXShakeViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(shakeVC, animated: true)
            hidesBottomBarWhenPushed = false
        } else if (item.title == "漂流瓶") {
            let bottleVC = WXBottleViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(bottleVC, animated: true)
            hidesBottomBarWhenPushed = false
        } else if (item.title == "购物") {
            let shoppingVC = WXShoppingViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(shoppingVC, animated: true)
            hidesBottomBarWhenPushed = false
        } else if (item.title == "游戏") {
            let gameVC = WXGameViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(gameVC, animated: true)
            hidesBottomBarWhenPushed = false
        }
        super.tableView(tableView, didSelectRowAt: indexPath)
    }

}
