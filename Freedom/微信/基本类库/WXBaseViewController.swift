//
//  WXBaseViewController.swift
//  Freedom
//
import UIKit
class WXBaseViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", action: {
        })
    }
}
