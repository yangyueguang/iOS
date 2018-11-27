//
//  IqiyiNavigationController.swift
//  Freedom
import UIKit
import XExtension
class IqiyiNavigationController: XBaseNavigationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        //不是半透明
        navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor.white,
            .font : Font(16)
        ]
        navigationBar.barTintColor = RGBAColor(47, 47, 47,1)
        if (Double(UIDevice.current.systemVersion) ?? 0.0 >= 7.0) {
            edgesForExtendedLayout = []//视图控制器，四条边不指定
            extendedLayoutIncludesOpaqueBars = false//不透明的操作栏
            modalPresentationCapturesStatusBarAppearance = false
            UINavigationBar.appearance().setBackgroundImage(UIImage(named: ""), for: .top, barMetrics: .default)
        } else {
            navigationBar.setBackgroundImage(UIImage(named: ""), for: .default)
        }
    }
}
