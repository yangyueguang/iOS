//
//  BaseTableViewController.swift
//  Freedom
import UIKit
import RxSwift
import XExtension
import Alamofire
@objcMembers
open class BaseTableViewController: UITableViewController {
    let disposeBag = DisposeBag()
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white ,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = UIRectEdge.all;
        let appearance = UINavigationBar.appearance()
        appearance.backIndicatorImage = UIImage(named:"u_cellLeft")?.withRenderingMode(.alwaysOriginal);
        appearance.backIndicatorTransitionMaskImage = UIImage(named:"u_cellLeft")?.withRenderingMode(.alwaysOriginal);
        let backItem: UIBarButtonItem = UIBarButtonItem()
        backItem.title = "返回"
        self.navigationItem.backBarButtonItem = backItem;
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
