//
//  WXMyQRCodeViewController.swift
//  Freedom

import Foundation
class WXMyQRCodeViewController: WXBaseViewController {
    var qrCodeVC = WXQRCodeViewController.storyVC(.wechat) 
    var user: WXUser = WXUser() {
        didSet {
            qrCodeVC.user = user
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.back
        navigationItem.title = "我的二维码"
        view.addSubview(qrCodeVC.view)
        addChild(qrCodeVC)
        let rightBarButtonItem = UIBarButtonItem(image:Image.more.image, style: .done, target: self, action: #selector(WXMyQRCodeViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        self.user = WXUserHelper.shared.user
    }
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        var ac: UIAlertAction
        var vc: UIViewController?
        for viewController in navigationController?.viewControllers ?? []{
            if (NSStringFromClass(object_getClass(viewController) ?? NSObject.self) == "TLScanningViewController") {
                vc = viewController
            }
        }

        if vc != nil {
            ac = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        } else {
            ac = UIAlertAction(title: "扫描二维码", style: .default, handler: { action in
                let scannerVC = WXScanningViewController()
                scannerVC.disableFunctionBar = true
                self.navigationController?.pushViewController(scannerVC, animated: true)
            })
        }
        let alert = UIAlertController("", "", T1: "换个样式", T2: "保存图片", confirm1: {

        }, confirm2: {
            self.qrCodeVC.saveQRCodeToSystemAlbum()
        })
        alert.addAction(ac)
        self.present(alert, animated: true, completion: nil)
    }
}
