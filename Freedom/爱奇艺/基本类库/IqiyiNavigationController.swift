//
//  IqiyiNavigationController.swift
//  Freedom
import UIKit
//import XExtension
final class IqiyiNavigationController: BaseNavigationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        //不是半透明
        navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor.whitex,
            .font : FFont(16)
        ]
        navigationBar.barTintColor = UIColor.thin
        if (Double(UIDevice.current.systemVersion) ?? 0.0 >= 7.0) {
            edgesForExtendedLayout = []//视图控制器，四条边不指定
            extendedLayoutIncludesOpaqueBars = false//不透明的操作栏
            modalPresentationCapturesStatusBarAppearance = false
            UINavigationBar.appearance().setBackgroundImage(nilImage, for: .top, barMetrics: .default)
        } else {
            navigationBar.setBackgroundImage(nilImage, for: .default)
        }
    }
}
