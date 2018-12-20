//
//  WXHelpAndFeedbackViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/20.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
class WXHelpAndFeedbackViewController: WXWebViewController {
    func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_more"), style: .plain, target: self, action: #selector(WXHelpAndFeedbackViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        setUrl("https://github.com/tbl00c/TLChat/issues")
    }

    // MARK: - Event Response -
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem?) {
    }
}
