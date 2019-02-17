//
//  WXScanningViewController.swift
//  Freedom
import SnapKit
import Foundation
import XCarryOn
class WXScannerButton: UIButton {
    var title = "" {
        didSet {
            textLabel.text = title
        }
    }
    var iconPath: String = "" {
        didSet {
            iconImageView.image = UIImage(named: iconPath)
        }
    }
    var iconHLPath = "" {
        didSet {
            iconImageView.highlightedImage = UIImage(named: iconHLPath)
        }
    }
    var type = TLScannerType.qr
    var msgNumber: Int = 0
    var iconImageView = UIImageView()
    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.small
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.whitex
        textLabel.highlightedTextColor = UIColor.greenx
        return textLabel
    }()
    override var isSelected: Bool {
        didSet {
            iconImageView.isHighlighted = isSelected
            textLabel.isHighlighted = isSelected
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(type: TLScannerType, title: String, iconPath: String, iconHLPath: String) {
        self.init(frame: CGRect.zero)
        addSubview(iconImageView)
        addSubview(textLabel)
        self.type = type
        self.title = title
        self.iconPath = iconPath
        self.iconHLPath = iconHLPath
        iconImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.iconImageView.snp.width)
        }
        textLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class WXScanningViewController: WXBaseViewController, WXScannerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //禁用底部工具栏（默认NO，若开启，将只支持扫码）
    var disableFunctionBar = false {
        didSet {
            bottomView.isHidden = disableFunctionBar
        }
    }
    var curType = TLScannerType.qr
    var scanVC = WXScannerViewController()
    lazy var albumBarButton = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(self.albumBarButtonDown(_:)))
    lazy var myQRButton: UIButton = {
        let myQRButton = UIButton()
        myQRButton.setTitle("我的二维码", for: .normal)
        myQRButton.titleLabel?.font = UIFont.normal
        myQRButton.setTitleColor(UIColor.greenx, for: .normal)
        myQRButton.addTarget(self, action: #selector(self.myQRButtonDown), for: .touchUpInside)
        myQRButton.isHidden = true
        return myQRButton
    }()
    lazy var bottomView: UIView =  {
        let blackView = UIView()
        blackView.backgroundColor = UIColor.blackx
        blackView.alpha = 0.5
        let bottomView = UIView()
        bottomView.addSubview(blackView)
        blackView.snp.makeConstraints({ (make) in
            make.edges.equalTo(bottomView)
        })
        return bottomView
    }()
    var qrButton = WXScannerButton(type: .qr, title: "扫码", iconPath: "u_scanQRCode", iconHLPath: "u_scanQRCodeHL")
    var coverButton = WXScannerButton(type: .cover, title: "封面", iconPath: "scan_book", iconHLPath: "scan_book_HL")
    var streetButton = WXScannerButton(type: .street, title: "街景", iconPath: "scan_street", iconHLPath: "scan_street_HL")
    var translateButton = WXScannerButton(type: .translate, title: "翻译", iconPath: "scan_word", iconHLPath: "scan_word_HL")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackx
        view.addSubview(scanVC.view)
        view.addSubview(bottomView)
        view.addSubview(myQRButton)
        bottomView.addSubview(qrButton)
        bottomView.addSubview(coverButton)
        bottomView.addSubview(streetButton)
        bottomView.addSubview(translateButton)
        addChild(scanVC)
        scanVC.delegate = self
        qrButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
        coverButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
        streetButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
        translateButton.addTarget(self, action: #selector(self.scannerButtonDown(_:)), for: .touchUpInside)
        p_addMasonry()
    }
    func scannerViewControllerInitSuccess(_ scannerVC: WXScannerViewController) {
        scannerButtonDown(qrButton) // 初始化
    }
    func scannerViewController(_ scannerVC: WXScannerViewController, initFailed errorString: String) {
        noticeError(errorString)
        let alvc = UIAlertController(title: "错误", message: errorString, preferredStyle: .alert)
        let a = UIAlertAction(title: "确定", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        alvc.addAction(a)
        present(alvc, animated: true)
    }

    func scannerViewController(_ scannerVC: WXScannerViewController, scanAnswer ansStr: String) {
        p_analysisQRAnswer(ansStr)
    }
    func scannerButtonDown(_ sender: WXScannerButton) {
        if !sender.isSelected {
            if !scanVC.isRunning {
                scanVC.startCodeReading()
            }
            return
        }
        curType = sender.type
        qrButton.isSelected = qrButton.type == sender.type
        coverButton.isSelected = coverButton.type == sender.type
        streetButton.isSelected = streetButton.type == sender.type
        translateButton.isSelected = translateButton.type == sender.type
        if sender.type == .qr {
            navigationItem.rightBarButtonItem = albumBarButton
            myQRButton.isHidden = false
            navigationItem.title = "二维码/条码"
        } else {
            navigationItem.rightBarButtonItem = nil
            myQRButton.isHidden = true
            if sender.type == .cover {
                navigationItem.title = "封面"
            } else if sender.type == .street {
                navigationItem.title = "街景"
            } else if sender.type == .translate {
                navigationItem.title = "翻译"
            }
        }
        scanVC.scannerType = sender.type
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String : Any]) {
        picker.dismiss(animated: true) {
            self.noticeInfo("扫描中，请稍候")
            WXScannerViewController.scannerQRCode(from: image, ans: { ansStr in
                XHud.hide()
                if ansStr.isEmpty {
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
            let image = info[.originalImage] as! UIImage
            XHud.show(XHudStyle.withDetail(message:"扫描中，请稍候"))
            WXScannerViewController.scannerQRCode(from: image, ans: { ansStr in
                XHud.hide()
                if ansStr.isEmpty {
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

    @objc func albumBarButtonDown(_ sender: UIBarButtonItem) {
        scanVC.stopCodeReading()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    @objc func myQRButtonDown() {
        let myQRCodeVC = WXMyQRCodeViewController()
        navigationController?.pushViewController(myQRCodeVC, animated: true)
    }
    func p_analysisQRAnswer(_ ansStr: String) {
        if ansStr.hasPrefix("http") {
            let webVC = WXWebViewController()
            webVC.url = ansStr
            let vc = navigationController?.topViewController
            navigationController?.popViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                vc?.navigationController?.pushViewController(webVC, animated: true)
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

        let widthButton: CGFloat = 35
        let hightButton: CGFloat = 55
        let space: CGFloat = (APPW - widthButton * 4) / 5
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(82)
        }
        qrButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.bottomView)
            make.left.equalTo(self.bottomView).offset(space)
            make.width.equalTo(widthButton)
            make.height.equalTo(hightButton)
        }
        coverButton.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(self.qrButton)
            make.left.equalTo(self.qrButton.snp.right).offset(space)
        }
        streetButton.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(self.qrButton)
            make.left.equalTo(self.coverButton.snp.right).offset(space)
        }
        translateButton.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(self.qrButton)
            make.left.equalTo(self.streetButton.snp.right).offset(space)
        }
        myQRButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.bottomView.snp.top).offset(-40)
        }
    }
}
