//
//  WXGroupQRCodeViewController.swift
//  Freedom

import Foundation
class WXGroupQRCodeViewController: WXBaseViewController {
    var group: WXGroup = WXGroup() {
        didSet {
            qrCodeVC.avatarPath = group.groupID
            qrCodeVC.username = group.groupName
            qrCodeVC.qrCode = group.groupID
            let date = Date()
            qrCodeVC.introduction = String(format: "该二维码7天内(%lu月%lu日前)有效，重新进入将更新", date.components.month ?? 0, date.components.day ?? 0)
        }
    }
    var qrCodeVC = WXQRCodeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
        navigationItem.title = "群二维码名片"
        view.addSubview(qrCodeVC.view)
        addChild(qrCodeVC)
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more"), style: .done, target: self, action: #selector(WXGroupQRCodeViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        let alert = UIAlertController("", "", T1: "用邮件发送", T2: "保存图片", confirm1: {
            self.noticeError("正在开发")
        }) {
            self.qrCodeVC.saveQRCodeToSystemAlbum()
        }
        let act = UIAlertAction(title: "取消", style: .cancel, handler: { _ in
        })
        alert.addAction(act)
        self.present(alert, animated: true) {

        }
    }
}
