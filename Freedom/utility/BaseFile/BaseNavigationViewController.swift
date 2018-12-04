//
//  BaseNavigationViewController.swift
//  project
//  Created by Super on 2017/9/13.
//  Copyright © 2017年 Super. All rights reserved.
import UIKit
@objcMembers
open class BaseNavigationViewController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBar.appearance()
        appearance.isTranslucent = false
        appearance.backIndicatorImage = UIImage(named: "返回")?.withRenderingMode(.alwaysTemplate)
        appearance.setBackgroundImage(UIImage.imageWithColor(.white, size: CGSize(width: 1, height: 1)), for: UIBarMetrics.default)
        let item = UIBarButtonItem.appearance()
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)], for: UIControl.State())
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white ,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
        let rect = CGRect(x: 0, y: 0, width: 1.0, height:1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        navigationBar.shadowImage = image
        navigationBar.barTintColor = UIColor.gray
        navigationBar.tintColor = UIColor.white
        navigationBar.barStyle = UIBarStyle.default
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = .white
        edgesForExtendedLayout = UIRectEdge.all
        automaticallyAdjustsScrollViewInsets = false
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
        interactivePopGestureRecognizer?.delegate = self
        if responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.delegate = self
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: "Font") : UIFont.systemFont(ofSize: 16)]
            delegate = self
        }
    }
    override open var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    lazy var backBtn: UIButton = {
       let bt = UIButton()
        bt.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        return bt
    }()
    @objc func backBtnAction() {
        _ = popViewController(animated: true)
    }
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            viewController.hidesBottomBarWhenPushed = true
            viewController.view.backgroundColor = UIColor.white
        }
        if responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) && animated {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        super.pushViewController(viewController, animated: animated)
    }
    override open func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) && animated {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        return super.popToRootViewController(animated: animated)
    }
    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) && animated {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        return super.popToViewController(viewController, animated: false)
    }
    //MARK: - UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    //MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0] {
                return false
            }
        }
        return true
    }
}
