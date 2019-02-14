//
//  WXTabBarController.swift
//  Freedom

import UIKit
import SnapKit
import XCarryOn
import XExtension
final class WXTabBarController: BaseTabBarViewController {
    static let shared = WXTabBarController()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let barItem = UITabBarItem.appearance()
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)], for: .normal)
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.green,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
        tabBar.barTintColor = .white
        tabBar.tintColor = .green
        if FirstRun.shared.wechat {
            FirstRun.shared.wechat = false
            XNetKit.kit.downloadDefaultExpression()
        }
    }
    
}
