//
//  BaseTableViewController.swift
//  Freedom
import UIKit
import RxSwift
//import XExtension
import Alamofire
@objcMembers
open class BaseTableViewController: UITableViewController {
    let disposeBag = DisposeBag()
    override open func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = UIRectEdge.all;
        let appearance = UINavigationBar.appearance()
        appearance.backIndicatorImage = Image.left.image.withRenderingMode(.alwaysOriginal);
        appearance.backIndicatorTransitionMaskImage = Image.left.image.withRenderingMode(.alwaysOriginal)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", action: {
        })
    }
    public func push(_ controller: UIViewController?, title: String = "", tabBarHid: Bool = true) {
        guard let `controller` = controller else { return }
        print("跳转到 \(title) 页面")
        controller.title = title
        controller.hidesBottomBarWhenPushed = tabBarHid
        navigationController?.pushViewController(controller, animated: true)
    }
    // 开始摇一摇
    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.showRadialMenu()
    }
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion != .motionShake {
            return
        }
        print("结束摇一摇")
    }
    override open func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("取消摇一摇")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
