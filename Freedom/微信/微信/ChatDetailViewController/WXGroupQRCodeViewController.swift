//
//  WXGroupQRCodeViewController.swift
//  Freedom

import Foundation
class WXGroupQRCodeViewController: WXBaseViewController {
    var group: WXGroup
    var qrCodeVC: WXQRCodeViewController

    func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
        navigationItem.title = "群二维码名片"

        if let aView = qrCodeVC.view {
            view.addSubview(aView)
        }
        if let aVC = qrCodeVC {
            addChild(aVC)
        }

        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more"), style: .done, target: self, action: #selector(WXGroupQRCodeViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    func setGroup(_ group: WXGroup) {
        self.group = group
        qrCodeVC.avatarPath = group.groupAvatarPath
        qrCodeVC.username = group.groupName
        qrCodeVC.qrCode = group.groupID
        let date = Date()
        qrCodeVC.introduction = String(format: "该二维码7天内(%lu月%lu日前)有效，重新进入将更新", Int(date.ymdComponents.month), Int(date.ymdComponents.day))
    }
    
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        showAlerWithtitle(nil, message: nil, style: UIAlertController.Style.actionSheet, ac1: {
            return UIAlertAction(title: "用邮件发送", style: .default, handler: { action in
                SVProgressHUD.showError(withStatus: "正在开发")
            })
        }, ac2: {
            return UIAlertAction(title: "保存图片", style: .default, handler: { action in
                self.qrCodeVC().saveQRCodeToSystemAlbum()
            })
        }, ac3: {
            return UIAlertAction(title: "取消", style: .cancel, handler: nil)
        }, completion: nil)
    }

    // MARK: - Getter -
    func qrCodeVC() -> WXQRCodeViewController {
        if qrCodeVC == nil {
            qrCodeVC = WXQRCodeViewController()
        }
        return qrCodeVC
    }


    
}
