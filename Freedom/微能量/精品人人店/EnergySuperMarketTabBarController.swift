//
//  EnergySuperMarketTabBarController.swift
//  Freedom
import UIKit
final class EnergySuperMarketTabBarController: BaseTabBarViewController {
    static let sharedRootViewController = EnergySuperMarketTabBarController()
    var isRemoveTab = true
    let stabbar = EnergyShopTabBarController.sharedRootViewController;
    var backTab:NSInteger=0;
    public var superTabbar : MicroEnergyTabBarController!
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isRemoveTab{
            stabbar.removeFromParent()
        superTabbar.selectedIndex = self.backTab
        }
    }
    deinit {
        print("dsfdsfsdf")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
       self.addChildViewController(EnergySuperHomeViewController(), title: "微商城", imageName: "tabbar_mainframe", selectImage: "tabbar_mainframeHL")
        self.addChildViewController(EnergyShopViewController(), title: "人人店案例", imageName: "tabbar_contacts", selectImage: "tabbar_contactsHL")
        self.addChildViewController(EnergySuperMeViewController(), title: "个人中心", imageName: "tabbar_me", selectImage: "tabbar_meHL")
    }
    fileprivate func addChildViewController(_ controller: UIViewController, title:String, imageName:String,selectImage:String){
        controller.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: selectImage)?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.title = title
        controller.title = title
        controller.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], for: .selected)
        addChild(controller)
    }
}
