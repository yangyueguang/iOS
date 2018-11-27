//
//  XBaseViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/15.
//  Copyright © 2018年 Super. All rights reserved.
//
import UIKit
import BaseFile
import XExtension
import SVProgressHUD
class XBaseViewController: BaseViewController{
    var cellHeight:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = UIRectEdge.all;
        let appearance = UINavigationBar.appearance()
        appearance.backIndicatorImage = UIImage(named:"u_cellLeft")?.withRenderingMode(.alwaysOriginal);
        appearance.backIndicatorTransitionMaskImage = UIImage(named:"u_cellLeft")?.withRenderingMode(.alwaysOriginal);
        let backItem: UIBarButtonItem = UIBarButtonItem()
        backItem.title = "返回"
        self.navigationItem.backBarButtonItem = backItem;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    // 开始摇一摇
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.showRadialMenu()
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion != .motionShake {
            return
        }
        print("结束摇一摇")
    }
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("取消摇一摇")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
