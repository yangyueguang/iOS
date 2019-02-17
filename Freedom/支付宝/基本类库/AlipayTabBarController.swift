//
//  AlipayTabBarController.swift
//  Freedom
import UIKit
final class AlipayTabBarController: BaseTabBarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        for vc in self.children{
            vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.redx,NSAttributedString.Key.font : UIFont.small], for: .selected)
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }
}
