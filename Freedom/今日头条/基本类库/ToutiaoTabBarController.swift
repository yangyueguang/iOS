//
//  ToutiaoTabBarController.swift
//  Freedom
//
//  Created by Super on 2018/5/16.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
class ToutiaoTabBarController: XBaseTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        for vc in self.children{
            vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }
    
}
