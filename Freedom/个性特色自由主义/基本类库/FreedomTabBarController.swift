//
//  FreedomTabBarController.swift
//  Freedom
import UIKit
final class FreedomTabBarController: BaseTabBarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        let barItem = UITabBarItem.appearance()
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray,NSAttributedString.Key.font : UIFont.small], for: .normal)
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : UIFont.small], for: .selected)
        for vc in self.children{
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }
}
