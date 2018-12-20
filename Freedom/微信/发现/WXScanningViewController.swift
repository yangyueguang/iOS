//
//  WXScanningViewController.swift
//  Freedom

import Foundation
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXScannerButton: UIButton {
    var title = ""
    var iconPath = ""
    var iconHLPath = ""
    var type: TLScannerType
    var msgNumber: Int = 0
    var iconImageView: UIImageView
    var textLabel: UILabel

    init(type: TLScannerType, title: String, iconPath: String, iconHLPath: String) {
        //if super.init()

        if let aView = iconImageView {
            addSubview(aView)
        }
        if let aLabel = textLabel {
            addSubview(aLabel)
        }
        p_addMasonry()
        self.type = type
        self.title = title  ""
        self.iconPath = iconPath  ""
        self.iconHLPath = iconHLPath  ""

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func setTitle(_ title: String) {
        self.title = title
        textLabel.text = title
    }

    func setIconPath(_ iconPath: String) {
        self.iconPath = iconPath
        iconImageView.image = UIImage(named: iconPath  "")
    }

    func setIconHLPath(_ iconHLPath: String) {
        self.iconHLPath = iconHLPath
        iconImageView.highlightedImage = UIImage(named: iconHLPath  "")
    }

    func setSelected(_ selected: Bool) {
        super.setSelected(selected)
        iconImageView.highlighted = selected
        textLabel.isHighlighted = selected
    }

    // MARK: - Private Methods -
    func p_addMasonry() {
        iconImageView.mas_makeConstraints({ make in
            make.top.and().left().and().right().mas_equalTo(self)
            make.height.mas_equalTo(self.iconImageView.mas_width)
        })
        textLabel.mas_makeConstraints({ make in
            make.left.and().right().mas_equalTo(self)
            make.bottom.mas_equalTo(self)
        })
    }
    func iconImageView() -> UIImageView {
        if iconImageView == nil {
            iconImageView = UIImageView()
        }
        return iconImageView
    }

    var textLabel: UILabel {
        if textLabel == nil {
            textLabel = UILabel()
            textLabel.font = UIFont.systemFont(ofSize: 12.0)
            textLabel.textAlignment = .center
            textLabel.textColor = UIColor.white
            textLabel.highlightedTextColor = UIColor.green
        }
        return textLabel
    }
}
class WXScanningViewController: WXBaseViewController, WXScannerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //禁用底部工具栏（默认NO，若开启，将只支持扫码）
    var disableFunctionBar = false
    var curType: TLScannerType
    var scanVC: WXScannerViewController
    var albumBarButton: UIBarButtonItem
    var myQRButton: UIButton
    var bottomView: UIView
    var qrButton: WXScannerButton
    var coverButton: WXScannerButton
    var streetButton: WXScannerButton
    var translateButton: WXScannerButton

    func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black

        view.addSubview(scanVC.view)
        addChild(scanVC)
        view.addSubview(bottomView)
        view.addSubview(myQRButton)

        bottomView.addSubview(qrButton)
        bottomView.addSubview(coverButton)
        bottomView.addSubview(streetButton)
        bottomView.addSubview(translateButton)

        p_addMasonry()
    }

    func setDisableFunctionBar(_ disableFunctionBar: Bool) {
        self.disableFunctionBar = disableFunctionBar
        bottomView.hidden = disableFunctionBar
    }
    func scannerViewControllerInitSuccess(_ scannerVC: WXScannerViewController) {
        scannerButtonDown(qrButton) // 初始化
    }

    func scannerViewController(_ scannerVC: WXScannerViewController, initFailed errorString: String) {
        SVProgressHUD.showError(withStatus: errorString)
        let alvc = UIAlertController(title: "错误", message: errorString, preferredStyle: .alert)
        let a = UIAlertAction(title: "确定", style: .default, handler: { action in
            self.navigationController.popViewController(animated: true)
        })
        alvc.addAction(a)
        present(alvc, animated: true)
    }

    func scannerViewController(_ scannerVC: WXScannerViewController, scanAnswer ansStr: String) {
        p_analysisQRAnswer(ansStr)
    }
    func scannerButtonDown(_ sender: WXScannerButton) {
        if sender.isSelected != nil {
            if !scanVC.isRunning() {
                scanVC.startCodeReading()
            }
            return
        }
        curType = sender.type
        qrButton.selected = qrButton.type == sender.type
        coverButton.selected = coverButton.type == sender.type
        streetButton.selected = streetButton.type == sender.type
        translateButton.selected = translateButton.type == sender.type
        if sender.type == TLScannerTypeQR {
            navigationItem.rightBarButtonItem = albumBarButton
            myQRButton.hidden = false
            navigationItem.title = "二维码/条码"
        } else {
            navigationItem.rightBarButtonItem = nil
            myQRButton.hidden = true
            if sender.type == TLScannerTypeCover {
                navigationItem.title = "封面"
            } else if sender.type == TLScannerTypeStreet {
                navigationItem.title = "街景"
            } else if sender.type == TLScannerTypeTranslate {
                navigationItem.title = "翻译"
            }
        }
        scanVC.scannerType = sender.type
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String : Any]) {
        picker.dismiss(animated: true) {
            let image = editingInfo[.originalImage] as UIImage
            SVProgressHUD.show(withStatus: "扫描中，请稍候")
            WXScannerViewController.scannerQRCode(from: image, ans: { ansStr in
                SVProgressHUD.dismiss()
                if ansStr == nil {
                    let alvc = UIAlertController(title: "扫描失败", message: "请换张图片，或换个设备重试~", preferredStyle: .alert)
                    let a = UIAlertAction(title: "确定", style: .default, handler: { action in
                        self.scanVC.startCodeReading()
                    })
                    alvc.addAction(a)
                    self.present(alvc, animated: true)
                } else {
                    self.p_analysisQRAnswer(ansStr)
                }
            })
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[.originalImage] as UIImage
            SVProgressHUD.show(withStatus: "扫描中，请稍候")
            WXScannerViewController.scannerQRCode(from: image, ans: { ansStr in
                SVProgressHUD.dismiss()
                if ansStr == nil {
                    let alvc = UIAlertController(title: "扫描失败", message: "请换张图片，或换个设备重试~", preferredStyle: .alert)
                    let a = UIAlertAction(title: "确定", style: .default, handler: { action in
                        self.scanVC.startCodeReading()
                    })
                    alvc.addAction(a)
                    self.present(alvc, animated: true)
                } else {
                    self.p_analysisQRAnswer(ansStr)
                }
            })
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func albumBarButtonDown(_ sender: UIBarButtonItem) {
        scanVC.stopCodeReading()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    func myQRButtonDown() {
        let myQRCodeVC = WXMyQRCodeViewController()
        hidesBottomBarWhenPushed = true
        navigationController.pushViewController(myQRCodeVC, animated: true)
    }
    func p_analysisQRAnswer(_ ansStr: String) {
        if ansStr.hasPrefix("http")  false {
            let webVC = WXWebViewController()
            webVC.url = ansStr
            let vc = navigationController.topViewController
            navigationController.popViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                vc.hidesBottomBarWhenPushed = true
                vc.navigationController.pushViewController(webVC, animated: true)
                vc.hidesBottomBarWhenPushed = false
            })
        } else {
            let alvc = UIAlertController(title: "扫描结果", message: ansStr, preferredStyle: .alert)
            let a = UIAlertAction(title: "确定", style: .default, handler: { action in
                self.scanVC.startCodeReading()
            })
            alvc.addAction(a)
            present(alvc, animated: true)
        }
    }
    func p_addMasonry() {
        bottomView.mas_makeConstraints({ make in
            make.left.and().right().and().bottom().mas_equalTo(self.view)
            make.height.mas_equalTo(82)
        })

        // bottom
        let widthButton: CGFloat = 35
        let hightButton: CGFloat = 55
        let space: CGFloat = (APPW - widthButton * 4) / 5
        qrButton.mas_makeConstraints({ make in
            make.centerY.mas_equalTo(self.bottomView)
            make.left.mas_equalTo(self.bottomView).mas_offset(space)
            make.width.mas_equalTo(widthButton)
            make.height.mas_equalTo(hightButton)
        })
        coverButton.mas_makeConstraints({ make in
            make.top.and().bottom().and().width().mas_equalTo(self.qrButton)
            make.left.mas_equalTo(self.qrButton.mas_right).mas_offset(space)
        })
        streetButton.mas_makeConstraints({ make in
            make.top.and().bottom().and().width().mas_equalTo(self.qrButton)
            make.left.mas_equalTo(self.coverButton.mas_right).mas_offset(space)
        })
        translateButton.mas_makeConstraints({ make in
            make.top.and().bottom().and().width().mas_equalTo(self.qrButton)
            make.left.mas_equalTo(self.streetButton.mas_right).mas_offset(space)
        })
        myQRButton.mas_makeConstraints({ make in
            make.centerX.mas_equalTo(self.view)
            make.bottom.mas_equalTo(self.bottomView.mas_top).mas_offset(-40)
        })
    }
    func scanVC() -> WXScannerViewController {
        if scanVC == nil {
            scanVC = WXScannerViewController()
            scanVC.delegate = self
        }
        return scanVC
    }

    func bottomView() -> UIView {
        if bottomView == nil {
            let blackView = UIView()
            blackView.backgroundColor = UIColor.black
            blackView.alpha = 0.5
            bottomView = UIView()
            bottomView.addSubview(blackView)
            blackView.mas_makeConstraints({ make in
                make.edges.mas_equalTo(bottomView)
            })
        }
        return bottomView
    }
    func qrButton() -> WXScannerButton {
        if qrButton == nil {
            qrButton = WXScannerButton(type: TLScannerTypeQR, title: "扫码", iconPath: "u_scanQRCode", iconHLPath: "u_scanQRCodeHL")
            qrButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
        }
        return qrButton
    }

    func coverButton() -> WXScannerButton {
        if coverButton == nil {
            coverButton = WXScannerButton(type: TLScannerTypeCover, title: "封面", iconPath: "scan_book", iconHLPath: "scan_book_HL")
            coverButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
        }
        return coverButton
    }
    func streetButton() -> WXScannerButton {
        if streetButton == nil {
            streetButton = WXScannerButton(type: TLScannerTypeStreet, title: "街景", iconPath: "scan_street", iconHLPath: "scan_street_HL")
            streetButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
        }
        return streetButton
    }
    func translateButton() -> WXScannerButton {
        if translateButton == nil {
            translateButton = WXScannerButton(type: TLScannerTypeTranslate, title: "翻译", iconPath: "scan_word", iconHLPath: "scan_word_HL")
            translateButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
        }
        return translateButton
    }

    func albumBarButton() -> UIBarButtonItem {
        if albumBarButton == nil {
            albumBarButton = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(self.albumBarButtonDown(_:)))
        }
        return albumBarButton
    }

    func myQRButton() -> UIButton {
        if myQRButton == nil {
            myQRButton = UIButton()
            myQRButton.setTitle("我的二维码", for: .normal)
            myQRButton.titleLabel.font = UIFont.systemFont(ofSize: 15.0)
            myQRButton.setTitleColor(UIColor.green, for: .normal)
            myQRButton.addTarget(self, action: #selector(self.myQRButtonDown), for: .touchUpInside)
            myQRButton.hidden = true
        }
        return myQRButton
    }


    
}
