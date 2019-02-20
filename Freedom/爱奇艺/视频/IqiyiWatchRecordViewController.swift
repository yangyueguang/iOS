//
//  JFWatchRecordViewController.swift
//  Freedom
import UIKit
import XExtension
class IqiyiWatchRecordViewController: IqiyiBaseViewController {
    func initNav() {
        title = "观看纪录"
        navigationController?.navigationBar.isHidden = false
        let leftBarButtonItem = UIBarButtonItem(image: IQYImage.playBack.image, style: .done , target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}
