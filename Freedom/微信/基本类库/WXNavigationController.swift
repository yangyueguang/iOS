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
        navigationBar.barTintColor = UIColor.lightGray
        navigationBar.tintColor = UIColor.darkText
        view.backgroundColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
    }
}
