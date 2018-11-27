//
//  JFWatchRecordViewController.swift
//  Freedom
import UIKit
import XExtension
class IqiyiWatchRecordViewController: IqiyiBaseViewController {
    func initNav() {
        title = "观看纪录"
        navigationController?.navigationBar.isHidden = false
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_player_back"), style: .plain, actionBlick: {
            self.navigationController?.popViewController(animated: true)
        })
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}
