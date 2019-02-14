//
//  WXNavigationController.swift
//  Freedom
import UIKit
final class WXNavigationController: BaseNavigationViewController {
    var isFullScreenPopGesture: Bool {
        get {
            return type(of: interactivePopGestureRecognizer) == UIPanGestureRecognizer.self
        }
        set {
            if isFullScreenPopGesture {
                if type(of: interactivePopGestureRecognizer) == UIPanGestureRecognizer.self {
                    return
                }
                object_setClass(interactivePopGestureRecognizer, UIPanGestureRecognizer.self)
            } else {
                if type(of: interactivePopGestureRecognizer) == UIScreenEdgePanGestureRecognizer.self {
                    return
                }
                object_setClass(interactivePopGestureRecognizer, UIScreenEdgePanGestureRecognizer.self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBar.appearance()
        appearance.isTranslucent = false
        appearance.backIndicatorImage = UIImage(named: "返回")?.withRenderingMode(.alwaysTemplate)
        appearance.setBackgroundImage(UIImage.imageWithColor(.white, size: CGSize(width: 1, height: 1)), for: UIBarMetrics.default)
        let item = UIBarButtonItem.appearance()
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkText,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)], for: UIControl.State())
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.darkText ,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]

        navigationBar.barTintColor = UIColor.lightGray
        navigationBar.tintColor = UIColor.gray
        view.backgroundColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
    }
}
