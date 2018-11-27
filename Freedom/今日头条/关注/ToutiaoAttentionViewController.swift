//
//  ToutiaoAttentionViewController.swift
//  Freedom
import UIKit
class ToutiaoAttentionViewController: ToutiaoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
}
