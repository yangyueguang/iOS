//
//  WXNavigationController.swift
//  Freedom
import UIKit
class WXNavigationController: UINavigationController {
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
        navigationBar.barTintColor = UIColor(46.0, 49.0, 50.0, 1.0)
        navigationBar.tintColor = UIColor.white
        view.backgroundColor = UIColor.lightGray
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.5)]
    }

}
