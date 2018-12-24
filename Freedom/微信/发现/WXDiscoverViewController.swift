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
        let item1: WXMenuItem = tlCreateMenuItem("u_frendsCircle", "朋友圈")
        item1.rightIconURL = "http://img4.duitang.com/uploads/item/201510/16/20151016113134_TZye4.thumb.224_0.jpeg"
        item1.showRightRedPoint = true
        let item2: WXMenuItem = tlCreateMenuItem("u_scan_b", "扫一扫")
        let item3: WXMenuItem = tlCreateMenuItem("u_shake", "摇一摇")
        let item4: WXMenuItem = tlCreateMenuItem("ff_IconLocationService", "附近的人")
        let item5: WXMenuItem = tlCreateMenuItem("ff_IconBottle", "漂流瓶")
        let item6: WXMenuItem = tlCreateMenuItem("CreditCard_ShoppingBag", "购物")
        let item7: WXMenuItem = tlCreateMenuItem("MoreGame", "游戏")
        item7.rightIconURL = "http://qq1234.org/uploads/allimg/140404/3_140404151205_8.jpg"
        item7.subTitle = "英雄联盟计算器版"
        item7.showRightRedPoint = true
        discoverMenuData.append(contentsOf: [[item1], [item2, item3], [item4, item5], [item6, item7]])
    }
    func tlCreateMenuItem(_ IconPath: String,_ Title: String) -> WXMenuItem {
        return WXMenuItem.createMenu(withIconPath: IconPath, title: Title)
    }
}
class WXDiscoverViewController: WXMenuViewController {
//    var momentsVC = WXMomentsViewController()
    var discoverHelper = WXDiscoverHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "发现"
//        data = discoverHelper.discoverMenuData
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = data[indexPath.section][indexPath.row] as WXMenuItem
//        if (item.title == "朋友圈") {
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(momentsVC, animated: true)
//            hidesBottomBarWhenPushed = false
//        }
//        if (item.title == "扫一扫") {
//            let scannerVC = WXScanningViewController()
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(scannerVC, animated: true)
//            hidesBottomBarWhenPushed = false
//        } else if (item.title == "摇一摇") {
//            let shakeVC = WXShakeViewController()
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(shakeVC, animated: true)
//            hidesBottomBarWhenPushed = false
//        } else if (item.title == "漂流瓶") {
//            let bottleVC = WXBottleViewController()
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(bottleVC, animated: true)
//            hidesBottomBarWhenPushed = false
//        } else if (item.title == "购物") {
//            let shoppingVC = WXShoppingViewController()
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(shoppingVC, animated: true)
//            hidesBottomBarWhenPushed = false
//        } else if (item.title == "游戏") {
//            let gameVC = WXGameViewController()
//            hidesBottomBarWhenPushed = true
//            navigationController.pushViewController(gameVC, animated: true)
//            hidesBottomBarWhenPushed = false
//        }
//        super.tableView(tableView, didSelectRowAt: indexPath)
//    }

}
