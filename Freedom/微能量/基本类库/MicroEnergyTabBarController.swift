//
//  MicroEnergyTabBarController.swift
//  Freedom
import UIKit
import XExtension
class MicroEnergyTabBarController: BaseTabBarViewController,UITabBarControllerDelegate {
    let myTabBar = EnergySuperMarketTabBarController.sharedRootViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor(59, 59,59, 1);
        myTabBar.hidesBottomBarWhenPushed = true
        myTabBar.superTabbar = self;
       var i=0
        for vc in self.children{
            vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.tag = i;
            i += 1
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag != 3{
            myTabBar.backTab = item.tag
        }else if let navi:EnergyNavigationController = children[3] as? EnergyNavigationController{
            navi.pushViewController(myTabBar, animated: true)
        }
    }
}
