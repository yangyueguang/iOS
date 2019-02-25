//
//  AlipayNavigationViewController.swift
//  Freedom
import UIKit
final class AlipayNavigationViewController: BaseNavigationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem.appearance()
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.small.bold], for: UIControl.State())
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white ,NSAttributedString.Key.font : UIFont.big]
        navigationBar.barTintColor = UIColor.red
        navigationBar.tintColor = UIColor.red

        let appearance = UINavigationBar.appearance()
        let backImage = UIImage.imageWithColor(UIColor.alipay, size: CGSize(width: 1, height: 1))
        appearance.setBackgroundImage(backImage, for: UIBarMetrics.default)
    }
}
