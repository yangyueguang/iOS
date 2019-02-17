//
//  MicroEnergyTabBarController.swift
//  Freedom
import UIKit
import XExtension
//class JuheTabBar: UITabBar {
//    var centerButton = UIButton()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        centerButton.setImage(UIImage(named: "juhetab3"), for: .normal)
//        centerButton.frame = CGRect(x: 0, y: 0, width:APPW/5, height:50)
//        centerButton.layer.cornerRadius = 25
//        centerButton.clipsToBounds = true
//        addSubview(centerButton)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        centerButton.center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5 - 12)
//        let tabbarButtonW: CGFloat = bounds.size.width / 5
//        var buttonIndex: CGFloat = 0
//        for view in subviews {
//            if view.isKind(of: NSClassFromString("UITabBarButton")! ) {
//                view.frame = CGRect(x: buttonIndex * tabbarButtonW,y:view.frame.origin.y, width: tabbarButtonW, height:view.bounds.size.height)
//                buttonIndex += 1
//                if buttonIndex == 3 {
//                    //buttonIndex++;
//                    view.isHidden = true
//                }
//            }
//        }
//    }
//}
//class JuheDataTabBarController: BaseTabBarViewController{
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        var i=0
//        for vc in self.children{
//            vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.redx,NSAttributedString.Key.font : UIFont.small], for: .selected)
//            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
//            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
//            vc.tabBarItem.tag = i;
//            i += 1
//        }
//        let tabbar = JuheTabBar()
//        self.setValue(tabbar, forKeyPath: "tabBar")
//        tabbar.centerButton.addTarget(self, action:#selector(centerClicked), for: .touchUpInside)
//    }
//    @objc private func centerClicked(){
//        selectedIndex = 2
//    }
//}

final class MicroEnergyTabBarController: BaseTabBarViewController,UITabBarControllerDelegate {
    let myTabBar = EnergySuperMarketTabBarController.sharedRootViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.thin
        myTabBar.hidesBottomBarWhenPushed = true
        myTabBar.superTabbar = self;
       var i=0
        for vc in self.children{
            vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.redx,NSAttributedString.Key.font : UIFont.small], for: .selected)
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.tag = i;
            i += 1
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag != 3{
            myTabBar.backTab = item.tag
        }else if let navi:EnergyNavigationController = children[3] as? EnergyNavigationController{
            navi.pushViewController(myTabBar, animated: true)
        }
    }
}
