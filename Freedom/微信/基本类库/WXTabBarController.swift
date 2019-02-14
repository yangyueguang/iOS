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
        tabBar.backgroundColor = UIColor.lightGray
        tabBar.tintColor = UIColor.green
        if FirstRun.shared.wechat {
            FirstRun.shared.wechat = false
            XNetKit.kit.downloadDefaultExpression()
        }
    }
    
}
