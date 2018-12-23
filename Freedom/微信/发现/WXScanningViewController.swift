////
////  WXScanningViewController.swift
////  Freedom
//import SnapKit
//import Foundation
//class WXScannerButton: UIButton {
//    var title = "" {
//        didSet {
//            textLabel.text = title
//        }
//    }
//    var iconPath: String {
//        didSet {
//            iconImageView.image = UIImage(named: iconPath)
//        }
//    }
//    var iconHLPath = "" {
//        didSet {
//            iconImageView.highlightedImage = UIImage(named: iconHLPath)
//        }
//    }
//    var type: TLScannerType
//    var msgNumber: Int = 0
//    var iconImageView = UIImageView()
//    lazy var textLabel: UILabel = {
//        let textLabel = UILabel()
//        textLabel.font = UIFont.systemFont(ofSize: 12.0)
//        textLabel.textAlignment = .center
//        textLabel.textColor = UIColor.white
//        textLabel.highlightedTextColor = UIColor.green
//        return textLabel
//    }()
//    override var isSelected: Bool {
//        didSet {
//            iconImageView.isHighlighted = isSelected
//            textLabel.isHighlighted = isSelected
//        }
//    }
//    init(type: TLScannerType, title: String, iconPath: String, iconHLPath: String) {
//        super.init()
//        addSubview(iconImageView)
//        addSubview(textLabel)
//        self.type = type
//        self.title = title
//        self.iconPath = iconPath
//        self.iconHLPath = iconHLPath
////        p_addMasonry()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
////    func p_addMasonry() {
////        iconImageView.mas_makeConstraints({ make in
////            make.top.and().left().and().right().mas_equalTo(self)
////            make.height.mas_equalTo(self.iconImageView.mas_width)
////        })
////        textLabel.mas_makeConstraints({ make in
////            make.left.and().right().mas_equalTo(self)
////            make.bottom.mas_equalTo(self)
////        })
////    }
//}
//class WXScanningViewController: WXBaseViewController, WXScannerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    //禁用底部工具栏（默认NO，若开启，将只支持扫码）
//    var disableFunctionBar = false {
//        didSet {
//            bottomView.isHidden = disableFunctionBar
//        }
//    }
//    var curType = TLScannerType.qr
//    var scanVC = WXScannerViewController()
//    var albumBarButton = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(self.albumBarButtonDown(_:)))
//    lazy var myQRButton: UIButton = {
//        let myQRButton = UIButton()
//        myQRButton.setTitle("我的二维码", for: .normal)
//        myQRButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
//        myQRButton.setTitleColor(UIColor.green, for: .normal)
//        myQRButton.addTarget(self, action: #selector(self.myQRButtonDown), for: .touchUpInside)
//        myQRButton.isHidden = true
//        return myQRButton
//    }()
//    lazy var bottomView: UIView =  {
//        let blackView = UIView()
//        blackView.backgroundColor = UIColor.black
//        blackView.alpha = 0.5
//        let bottomView = UIView()
//        bottomView.addSubview(blackView)
//        blackView.snp.makeConstraints({ (make) in
//            make.edges.equalTo(bottomView)
//        })
//        return bottomView
//    }()
//    var qrButton = WXScannerButton(type: .qr, title: "扫码", iconPath: "u_scanQRCode", iconHLPath: "u_scanQRCodeHL")
//    var coverButton = WXScannerButton(type: .cover, title: "封面", iconPath: "scan_book", iconHLPath: "scan_book_HL")
//    var streetButton = WXScannerButton(type: .street, title: "街景", iconPath: "scan_street", iconHLPath: "scan_street_HL")
//    var translateButton = WXScannerButton(type: .translate, title: "翻译", iconPath: "scan_word", iconHLPath: "scan_word_HL")
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.black
//        view.addSubview(scanVC.view)
//        view.addSubview(bottomView)
//        view.addSubview(myQRButton)
//        bottomView.addSubview(qrButton)
//        bottomView.addSubview(coverButton)
//        bottomView.addSubview(streetButton)
//        bottomView.addSubview(translateButton)
//        addChild(scanVC)
//        scanVC.delegate = self
//        qrButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
//        coverButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
//        streetButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
//        translateButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
////        p_addMasonry()
//    }
//    func scannerViewControllerInitSuccess(_ scannerVC: WXScannerViewController) {
//        scannerButtonDown(qrButton) // 初始化
//    }
//    func scannerViewController(_ scannerVC: WXScannerViewController, initFailed errorString: String) {
//        SVProgressHUD.showError(withStatus: errorString)
//        let alvc = UIAlertController(title: "错误", message: errorString, preferredStyle: .alert)
//        let a = UIAlertAction(title: "确定", style: .default, handler: { action in
//            self.navigationController.popViewController(animated: true)
//        })
//        alvc.addAction(a)
//        present(alvc, animated: true)
//    }
//
//    func scannerViewController(_ scannerVC: WXScannerViewController, scanAnswer ansStr: String) {
//        p_analysisQRAnswer(ansStr)
//    }
//    func scannerButtonDown(_ sender: WXScannerButton) {
//        if !sender.isSelected {
//            if !scanVC.isRunning() {
//                scanVC.startCodeReading()
//            }
//            return
//        }
//        curType = sender.type
//        qrButton.selected = qrButton.type == sender.type
//        coverButton.selected = coverButton.type == sender.type
//        streetButton.selected = streetButton.type == sender.type
//        translateButton.selected = translateButton.type == sender.type
//        if sender.type == .qr {
//            navigationItem.rightBarButtonItem = albumBarButton
//            myQRButton.isHidden = false
//            navigationItem.title = "二维码/条码"
//        } else {
//            navigationItem.rightBarButtonItem = nil
//            myQRButton.isHidden = true
//            if sender.type == .cover {
//                navigationItem.title = "封面"
//            } else if sender.type == .street {
//                navigationItem.title = "街景"
//            } else if sender.type == .translate {
//                navigationItem.title = "翻译"
//            }
//        }
//        scanVC.scannerType = sender.type
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String : Any]) {
//        picker.dismiss(animated: true) {
//            let image = editingInfo[.originalImage] as UIImage
//            noticeInfo("扫描中，请稍候")
//            WXScannerViewController.scannerQRCode(from: image, ans: { ansStr in
//                SVProgressHUD.dismiss()
//                if ansStr == nil {
//                    let alvc = UIAlertController(title: "扫描失败", message: "请换张图片，或换个设备重试~", preferredStyle: .alert)
//                    let a = UIAlertAction(title: "确定", style: .default, handler: { action in
//                        self.scanVC.startCodeReading()
//                    })
//                    alvc.addAction(a)
//                    self.present(alvc, animated: true)
//                } else {
//                    self.p_analysisQRAnswer(ansStr)
//                }
//            })
//        }
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true) {
//            let image = info[.originalImage] as UIImage
//            XHud.show(XHudStyle.withDetail(message:"扫描中，请稍候"))
//            WXScannerViewController.scannerQRCode(from: image, ans: { ansStr in
//                XHud.hide()
//                if ansStr == nil {
//                    let alvc = UIAlertController(title: "扫描失败", message: "请换张图片，或换个设备重试~", preferredStyle: .alert)
//                    let a = UIAlertAction(title: "确定", style: .default, handler: { action in
//                        self.scanVC.startCodeReading()
//                    })
//                    alvc.addAction(a)
//                    self.present(alvc, animated: true)
//                } else {
//                    self.p_analysisQRAnswer(ansStr)
//                }
//            })
//        }
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//
//    func albumBarButtonDown(_ sender: UIBarButtonItem) {
//        scanVC.stopCodeReading()
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true)
//    }
//
//    @objc func myQRButtonDown() {
//        let myQRCodeVC = WXMyQRCodeViewController()
//        hidesBottomBarWhenPushed = true
//        navigationController.pushViewController(myQRCodeVC, animated: true)
//    }
//    func p_analysisQRAnswer(_ ansStr: String) {
//        if ansStr.hasPrefix("http")  false {
//            let webVC = WXWebViewController()
//            webVC.url = ansStr
//            let vc = navigationController.topViewController
//            navigationController.popViewController(animated: true)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//                vc.hidesBottomBarWhenPushed = true
//                vc.navigationController.pushViewController(webVC, animated: true)
//                vc.hidesBottomBarWhenPushed = false
//            })
//        } else {
//            let alvc = UIAlertController(title: "扫描结果", message: ansStr, preferredStyle: .alert)
//            let a = UIAlertAction(title: "确定", style: .default, handler: { action in
//                self.scanVC.startCodeReading()
//            })
//            alvc.addAction(a)
//            present(alvc, animated: true)
//        }
//    }
////    func p_addMasonry() {
////        bottomView.mas_makeConstraints({ make in
////            make.left.and().right().and().bottom().mas_equalTo(self.view)
////            make.height.mas_equalTo(82)
////        })
////        let widthButton: CGFloat = 35
////        let hightButton: CGFloat = 55
////        let space: CGFloat = (APPW - widthButton * 4) / 5
////        qrButton.mas_makeConstraints({ make in
////            make.centerY.mas_equalTo(self.bottomView)
////            make.left.mas_equalTo(self.bottomView).mas_offset(space)
////            make.width.mas_equalTo(widthButton)
////            make.height.mas_equalTo(hightButton)
////        })
////        coverButton.mas_makeConstraints({ make in
////            make.top.and().bottom().and().width().mas_equalTo(self.qrButton)
////            make.left.mas_equalTo(self.qrButton.mas_right).mas_offset(space)
////        })
////        streetButton.mas_makeConstraints({ make in
////            make.top.and().bottom().and().width().mas_equalTo(self.qrButton)
////            make.left.mas_equalTo(self.coverButton.mas_right).mas_offset(space)
////        })
////        translateButton.mas_makeConstraints({ make in
////            make.top.and().bottom().and().width().mas_equalTo(self.qrButton)
////            make.left.mas_equalTo(self.streetButton.mas_right).mas_offset(space)
////        })
////        myQRButton.mas_makeConstraints({ make in
////            make.centerX.mas_equalTo(self.view)
////            make.bottom.mas_equalTo(self.bottomView.mas_top).mas_offset(-40)
////        })
////    }
//}
