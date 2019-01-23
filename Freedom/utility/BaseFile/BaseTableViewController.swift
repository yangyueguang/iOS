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

    // MARK: - Table view data source
    override open func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
