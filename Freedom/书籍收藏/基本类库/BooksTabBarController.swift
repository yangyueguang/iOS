//
//  BooksTabBarController.swift
//  Freedom
//
import UIKit
class BooksTabBarController: BaseTabBarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        hidesBottomBarWhenPushed = true
    }
}
