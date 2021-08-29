//
//  WXScannerViewController.swift
//  Freedom
import SnapKit
//import XExtension
import Foundation
import AVFoundation
@objc protocol WXScannerDelegate: NSObjectProtocol {
    @objc optional func scannerViewControllerInitSuccess(_ scannerVC: WXScannerViewController)
    @objc optional func scannerViewController(_ scannerVC: WXScannerViewController, initFailed errorString: String)
    @objc optional func scannerViewController(_ scannerVC: WXScannerViewController, scanAnswer ansStr: String)
}

class WXScannerView: UIView {
    var timer: Timer?
    var hiddenScannerIndicator = false {
        didSet {
            if hiddenScannerIndicator {
                var rec: CGRect = scannerLine.frame
                rec.origin.y = 0
                scannerLine.frame = rec
                scannerLine.isHidden = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    var rec: CGRect = self.scannerLine.frame
                    rec.origin.y = 0
                    self.scannerLine.frame = rec
                    self.scannerLine.isHidden = self.hiddenScannerIndicator
                })
            }
        }
    }
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        bgView.layer.masksToBounds = true
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.whitex.cgColor
        return bgView
    }()
    var topLeftView = UIImageView(image: WXImage.scannerTopLeft.image)
    var topRightView = UIImageView(image: WXImage.scannerTopRight.image)
    var btmLeftView = UIImageView(image: WXImage.scannerBottomLeft.image)
    var btmRightView = UIImageView(image: WXImage.scannerBottomRight.image)
    var scannerLine = UIImageView(image: WXImage.scannerLine.image)
    override init(frame: CGRect) {
        super.init(frame: frame)
        scannerLine.frame = CGRect.zero
        clipsToBounds = true
        addSubview(bgView)
        addSubview(topLeftView)
        addSubview(topRightView)
        addSubview(btmLeftView)
        addSubview(btmRightView)
        addSubview(scannerLine)
        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func startScanner() {
        stopScanner()
        timer = Timer(timeInterval: 1.0 / 60, repeats: true, block: { (timer) in
            if self.hiddenScannerIndicator {
                return
            }
            self.scannerLine.center = CGPoint(x: self.bgView.center.x, y: self.scannerLine.center.y)
            var rec: CGRect = self.scannerLine.frame
            rec.size.height = 10
            if self.scannerLine.frame.origin.y + self.scannerLine.frame.size.height >= self.frame.size.height {
                rec.origin.y = 0
            } else {
                rec.origin.y += 1
            }
            self.scannerLine.frame = rec
            self.scannerLine.frame = CGRect(x: self.scannerLine.frame.origin.x, y: self.scannerLine.frame.origin.y, width: self.bgView.frame.size.width * 1.4, height: self.scannerLine.frame.size.height)
        })
        if let aTimer = timer {
            RunLoop.current.add(aTimer, forMode: .common)
        }
    }
    func p_addMasonry() {
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        topLeftView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.height.lessThanOrEqualToSuperview()
        }
        topRightView.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.width.height.lessThanOrEqualToSuperview()
        }
        btmLeftView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.height.lessThanOrEqualToSuperview()
        }
        btmRightView.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.width.height.lessThanOrEqualToSuperview()
        }
    }
    func stopScanner() {
        timer?.invalidate()
    }
}

class WXScannerBackgroundView: UIView {
    var topView = UIView()
    var btmView = UIView()
    var leftView = UIView()
    var rightView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topView)
        addSubview(btmView)
        addSubview(leftView)
        addSubview(rightView)
        topView.backgroundColor = .dark
        btmView.backgroundColor = .dark
        leftView.backgroundColor = .dark
        rightView.backgroundColor = .dark
        addMasonry()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func addMasonry() {
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.snp.top)
        }
        btmView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
        }
        leftView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(self.snp.left)
            make.top.equalTo(self.topView.snp.bottom)
            make.bottom.equalTo(self.btmView.snp.top)
        }
        rightView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.right)
            make.right.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
            make.bottom.equalTo(self.btmView.snp.top)
        }
    }
}

class WXScannerViewController: WXBaseViewController ,AVCaptureMetadataOutputObjectsDelegate {
    private var scannerView = WXScannerView()
    private var scannerBGView = WXScannerBackgroundView()
    private lazy var scannerSession: AVCaptureSession = {
        let session = AVCaptureSession()
        let device = AVCaptureDevice.default(for: .video)
        var input = try? AVCaptureDeviceInput(device: device!)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        if session.canSetSessionPreset(.hd1920x1080) {
            session.sessionPreset = .hd1920x1080
        } else if session.canSetSessionPreset(.hd1280x720) {
            session.sessionPreset = .hd1280x720
        } else {
            session.sessionPreset = .photo
        }
        if session.canAddInput(input!) {
            session.addInput(input!)
            session.addOutput(output)
        }
        output.metadataObjectTypes = [.ean13, .ean8, .code128, .qr]
        return session
    }()
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: scannerSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        return videoPreviewLayer
    }()
    private lazy var introudctionLabel: UILabel = {
        let introudctionLabel = UILabel()
        introudctionLabel.backgroundColor = UIColor.clear
        introudctionLabel.textAlignment = .center
        introudctionLabel.font = UIFont.small
        introudctionLabel.textColor = UIColor.whitex
        return introudctionLabel
    }()
    var scannerType = TLScannerType.qr {
        didSet {
            var width: CGFloat = 0
            var height: CGFloat = 0
            if scannerType == .qr {
                introudctionLabel.text = "将二维码/条码放入框内，即可自动扫描"
                height = APPW * 0.7
                width = height
            } else if scannerType == .cover {
                introudctionLabel.text = "将书、CD、电影海报放入框内，即可自动扫描"
                height = APPW * 0.85
                width = height
            } else if scannerType == .street {
                introudctionLabel.text = "扫一下周围环境，寻找附近街景"
                height = APPW * 0.85
                width = height
            } else if scannerType == .translate {
                width = APPW * 0.7
                height = 55
                introudctionLabel.text = "将英文单词放入框内"
            }
            scannerView.hiddenScannerIndicator = scannerType == .translate
            UIView.animate(withDuration: 0.3, animations: {
                self.scannerView.snp.updateConstraints({ (make) in
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                })
                self.view.layoutIfNeeded()
            })
            // rect值范围0-1，基准点在右上角
            let rect = CGRect(x: scannerView.frame.origin.y / APPH, y: scannerView.frame.origin.x / APPW, width: scannerView.frame.size.height / APPH, height: scannerView.frame.size.width / APPW)
            scannerSession.outputs[0].outputRectConverted(fromMetadataOutputRect: rect)
            if !isRunning {
                startCodeReading()
            }
        }
    }
    weak var delegate: WXScannerDelegate?
    var isRunning: Bool {
        return scannerSession.isRunning
    }
    class func scannerQRCode(from image: UIImage, ans: @escaping (_ ansStr: String) -> Void) {
        DispatchQueue.global(qos: .default).async(execute: {
            let imageData = image.pngData() != nil ? image.pngData() : image.jpegData(compressionQuality: 1)
            let ciImage = CIImage(data: imageData!)
            var ansStr: String = ""
            if let ciImage = ciImage {
                let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: CIContext(options: nil), options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
                let features: [CIFeature] = detector?.features(in: ciImage) ?? []
                for feature: CIFeature in features where feature is CIQRCodeFeature {
                    ansStr = (feature as! CIQRCodeFeature).messageString ?? ""
                    break
                }
            }
            DispatchQueue.main.async(execute: {
                ans(ansStr)
            })
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackx
        view.addSubview(introudctionLabel)
        view.addSubview(scannerView)
        view.addSubview(scannerBGView)
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
        scannerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-55)
            make.width.height.equalTo(0)
        }
        scannerBGView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        introudctionLabel.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.top.equalTo(self.scannerView.snp.bottom).offset(30)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if scannerSession != nil {
            delegate?.scannerViewControllerInitSuccess!(self)
        } else {
            delegate?.scannerViewController!(self, initFailed: "相机初始化失败")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if scannerSession.isRunning {
            stopCodeReading()
        }
    }
    func startCodeReading() {
        scannerView.startScanner()
        scannerSession.startRunning()
    }
    func stopCodeReading() {
        scannerView.stopScanner()
        scannerSession.stopRunning()
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if (metadataObjects.count) > 0 {
            stopCodeReading()
            let obj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            delegate?.scannerViewController!(self, scanAnswer: obj.stringValue ?? "")
        }
    }
}
