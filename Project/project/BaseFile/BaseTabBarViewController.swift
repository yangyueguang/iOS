//
//  BaseTabBarViewController.swift
//  project
//
//  Created by Super on 2017/9/13.
//  Copyright © 2017年 Super. All rights reserved.
//
import UIKit
class BaseTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取UITabbarItem的样品实例
        let barItem = UITabBarItem.appearance()
        //保存正常状态下的文本属性
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)], for: .normal)
         //保存选中状态下的文本属性
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
        tabBar.barTintColor = .green
        tabBar.tintColor = .yellow
        view.backgroundColor = .black
        addChildViewControllers()
    }
    fileprivate func addChildViewControllers(){
        addChildViewController(HomeViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(ServiceViewController(), title: "服务", imageName: "tabbar_gift")
        addChildViewController(FindViewController(), title: "发现", imageName: "tabbar_category")
        addChildViewController(MineViewController(), title: "我的", imageName: "tabbar_me")
    }
    fileprivate func addChildViewController(_ controller: UIViewController, title:String, imageName:String){
        controller.tabBarItem.image = UIImage(named: imageName)
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
        controller.tabBarItem.title = title
        controller.title = title
        let nav = BaseNavigationViewController()
        nav.addChild(controller)
        addChild(nav)
    }
}
