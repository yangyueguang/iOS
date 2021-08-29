//
//  KugouBaseViewController.swift
//  Freedom
import UIKit
//import XExtension
class KugouBaseViewController: BaseViewController {
    open var tableView: BaseTableView!
    override  func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.whitex
    }
    func goBack() {
        let vcarr = navigationController?.viewControllers
        if (vcarr?.count ?? 0) > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
