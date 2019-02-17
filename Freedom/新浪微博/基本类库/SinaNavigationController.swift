//
//  SinaNavigationController.swift
//  Freedom
//
//  Created by Super on 6/28/18.
//  Copyright © 2018 薛超. All rights reserved.
import UIKit
final class SinaNavigationController: BaseNavigationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.yellowx ,NSAttributedString.Key.font : UIFont.normal]
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if viewControllers.count > 1 {
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(target: self, action: #selector(self.back), image: "u_cellLeftA", heighlightImage: "u_cellLeftA_y")
//            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(target: self, action: #selector(self.more), image: "u_navi3p_b", heighlightImage: "u_navi3p_y")
        }
    }
    func back() {
        _ = popViewController(animated: true)
    }
    func more() {
        _ = popToRootViewController(animated: true)
    }
}
