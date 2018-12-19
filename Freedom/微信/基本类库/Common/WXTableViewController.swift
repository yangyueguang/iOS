//
//  WXTableViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/19.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
class WXTableViewController: UITableViewController {
    var analyzeTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = .none
        MobClick.beginLogPageView(analyzeTitle)
    }
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(analyzeTitle())
    }

    deinit {
        DLog("dealloc %@", navigationItem?.title)
    }

    // MARK: - Getter -
    func analyzeTitle() -> String? {
        if analyzeTitle == nil {
            return navigationItem?.title
        }
        return analyzeTitle
    }

}
