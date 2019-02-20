//
//  EnergyShopTabBarController.swift
//  Freedom
import UIKit
class EnergyShopTabBarController: BaseTabBarViewController {
    static let sharedRootViewController = EnergyShopTabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        self.addChildViewController(EnergyShopHomeViewController(), title: "首页", imageName: "tabbar_mainframe", selectImage: "tabbar_mainframeHL")
        self.addChildViewController(EnergyShopFindViewController(), title: "人人店", imageName: "tabbar_contacts", selectImage: "tabbar_contactsHL")
        self.addChildViewController(EnergyShopCarViewController(), title: "购物车", imageName: "tabbar_discover", selectImage: "tabbar_discoverHL")
        self.addChildViewController(EnergyShopMeViewController(), title: "我的", imageName: "tabbar_me", selectImage: "tabbar_meHL")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
EnergySuperMarketTabBarController.sharedRootViewController.isRemoveTab = true
    }
    fileprivate func addChildViewController(_ controller: UIViewController, title:String, imageName:String,selectImage:String){
        controller.tabBarItem.image = imageName.image.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.selectedImage = selectImage.image.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.title = title
        controller.title = title
        controller.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.redx], for: .selected)
        addChild(controller)
    }
}
