//
//  KugouBaseViewController.swift
//  Freedom
import UIKit
import XExtension
class KugouBaseViewController: BaseViewController {
    override  func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.white
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
