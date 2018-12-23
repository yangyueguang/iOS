////
////  WXScannerViewController.swift
////  Freedom
//
//import Foundation
//@objc protocol WXScannerDelegate: NSObjectProtocol {
//    @objc optional func scannerViewControllerInitSuccess(_ scannerVC: WXScannerViewController)
//    @objc optional func scannerViewController(_ scannerVC: WXScannerViewController, initFailed errorString: String)
//    @objc optional func scannerViewController(_ scannerVC: WXScannerViewController, scanAnswer ansStr: String)
//}
//
//class WXScannerView: UIView {
//    var timer: Timer?
//    var hiddenScannerIndicator = false
//    lazy var bgView: UIView = {
//        bgView = UIView()
//        bgView.backgroundColor = UIColor.clear
//        bgView.layer.masksToBounds = true
//        bgView.layer.borderWidth = 1
//        bgView.layer.borderColor = UIColor.white.cgColor
//        return bgView
//    }()
//    var topLeftView = UIImageView(image: UIImage(named: "scanner_top_left"))
//    var topRightView = UIImageView(image: UIImage(named: "scanner_top_right"))
//    var btmLeftView = UIImageView(image: UIImage(named: "scanner_bottom_left"))
//    var btmRightView = UIImageView(image: UIImage(named: "scanner_bottom_right"))
//    var scannerLine = UIImageView(image: UIImage(named: "scanner_line"))
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        scannerLine.frame = CGRect.zero
//        clipsToBounds = true
//        addSubview(aView)
//        addSubview(topLeftView)
//        addSubview(topRightView)
//        addSubview(btmLeftView)
//        addSubview(btmRightView)
//        addSubview(scannerLine)
////        p_addMasonry()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    func startScanner() {
//        stopScanner()
//        timer = Timer.bk_scheduledTimer(withTimeInterval: 1.0 / 60, block: { timer in
//            if self.hiddenScannerIndicator {
//                return
//            }
//            self.scannerLine.center = CGPoint(x: self.bgView.center.x, y: self.scannerLine.center.y)
//            let rec: CGRect = self.scannerLine.frame
//            rec.size.height = 10
//            if self.scannerLine.frame.origin.y + self.scannerLine.frame.size.height >= self.frame.size.height {
//                rec.origin.y = 0
//            } else {
//                rec.origin.y += 1
//            }
//            self.scannerLine.frame = rec
//            self.scannerLine.frame = CGRect(x: self.scannerLine.frame.origin.x, y: self.scannerLine.frame.origin.y, width: self.bgView.frame.size.width * 1.4, height: self.scannerLine.frame.size.height)
//        }, repeats: true)
//        if let aTimer = timer {
//            RunLoop.current.add(aTimer, forMode: .common)
//        }
//    }
//    func setHiddenScannerIndicator(_ hiddenScannerIndicator: Bool) {
//        if hiddenScannerIndicator == self.hiddenScannerIndicator {
//            return
//        }
//        if hiddenScannerIndicator {
//            let rec: CGRect = scannerLine.frame
//            rec.origin.y = 0
//            scannerLine.frame = rec
//            scannerLine.hidden = true
//            self.hiddenScannerIndicator = hiddenScannerIndicator
//        } else {
//            self.hiddenScannerIndicator = hiddenScannerIndicator
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//                let rec: CGRect = self.scannerLine.frame
//                rec.origin.y = 0
//                self.scannerLine.frame = rec
//                self.scannerLine.hidden = hiddenScannerIndicator
//            })
//        }
//    }
////    func p_addMasonry() {
////        bgView.mas_makeConstraints({ make in
////            make.edges.mas_equalTo(self)
////        })
////        topLeftView.mas_makeConstraints({ make in
////            make.left.and().top().mas_equalTo(self)
////            make.width.and().height().mas_lessThanOrEqualTo(self)
////        })
////        topRightView.mas_makeConstraints({ make in
////            make.right.and().top().mas_equalTo(self)
////            make.width.and().height().mas_lessThanOrEqualTo(self)
////        })
////        btmLeftView.mas_makeConstraints({ make in
////            make.left.and().bottom().mas_equalTo(self)
////            make.width.and().height().mas_lessThanOrEqualTo(self)
////        })
////        btmRightView.mas_makeConstraints({ make in
////            make.right.and().bottom().mas_equalTo(self)
////            make.width.and().height().mas_lessThanOrEqualTo(self)
////        })
////    }
//
//    func stopScanner() {
//        timer?.invalidate()
//    }
//}
//
//class WXScannerBackgroundView: UIView {
//    var topView = UIView()
//    var btmView = UIView()
//    var leftView = UIView()
//    var rightView = UIView()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(topView)
//        addSubview(btmView)
//        addSubview(leftView)
//        addSubview(rightView)
//        topView.backgroundColor = UIColor(71, 70, 73, 1.0)
//        btmView.backgroundColor = UIColor(71, 70, 73, 1.0)
//        leftView.backgroundColor = UIColor(71, 70, 73, 1.0)
//        rightView.backgroundColor = UIColor(71, 70, 73, 1.0)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
////    func addMasonry(withContain containView: UIView) {
////        let scannerView: UIView = containView
////        topView.mas_makeConstraints({ make in
////            make.top.and().left().and().right().mas_equalTo(self)
////            make.bottom.mas_equalTo(scannerView.mas_top)
////        })
////        btmView.mas_makeConstraints({ make in
////            make.left.and().right().and().bottom().mas_equalTo(self)
////            make.top.mas_equalTo(scannerView.mas_bottom)
////        })
////        leftView.mas_makeConstraints({ make in
////            make.left.mas_equalTo(self)
////            make.right.mas_equalTo(scannerView.mas_left)
////            make.top.mas_equalTo(self.topView.mas_bottom)
////            make.bottom.mas_equalTo(self.btmView.mas_top)
////        })
////        rightView.mas_makeConstraints({ make in
////            make.left.mas_equalTo(scannerView.mas_right)
////            make.right.mas_equalTo(self)
////            make.top.mas_equalTo(self.topView.mas_bottom)
////            make.bottom.mas_equalTo(self.btmView.mas_top)
////        })
////    }
//}
//
//class WXScannerViewController: WXBaseViewController ,AVCaptureMetadataOutputObjectsDelegate {
//    private var scannerView = WXScannerView()
//    private var scannerBGView = WXScannerBackgroundView()
//    private lazy var scannerSession: AVCaptureSession = {
//        let session = AVCaptureSession()
//        let device = AVCaptureDevice.default(for: .video)
//        var error: Error = nil
//        var input: AVCaptureDeviceInput = nil
//        if let aDevice = device {
//            input = try AVCaptureDeviceInput(device: aDevice)
//        }
//        if error != nil { return nil }
//        let output = AVCaptureMetadataOutput()
//        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//        if session.canSetSessionPreset(.hd1920x1080) {
//            session.sessionPreset = .hd1920x1080
//        } else if session.canSetSessionPreset(.hd1280x720) {
//            session.sessionPreset = .hd1280x720
//        } else {
//            session.sessionPreset = .photo
//        }
//        if session.canAdd(input) { session.add(input) }
//        if session.canAdd(output) { session.add(output) }
//        output.metadataObjectTypes = [.ean13, .ean8, .code128, .qr]
//        return session
//    }()
//    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
//        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: scannerSession)
//        videoPreviewLayer.videoGravity = .resizeAspectFill
//        videoPreviewLayer.frame = view.layer.bounds
//        return videoPreviewLayer
//    }()
//    private lazy var introudctionLabel: UILabel = {
//        let introudctionLabel = UILabel()
//        introudctionLabel.backgroundColor = UIColor.clear
//        introudctionLabel.textAlignment = .center
//        introudctionLabel.font = UIFont.systemFont(ofSize: 12.0)
//        introudctionLabel.textColor = UIColor.white
//        return introudctionLabel
//    }()
//    var scannerType = TLScannerType.qr
//    weak var delegate: WXScannerDelegate?
//    private var isRunning: Bool {
//        return scannerSession.isRunning()
//    }
//    class func scannerQRCode(from image: UIImage, ans: @escaping (_ ansStr: String) -> Void) {
//        DispatchQueue.global(qos: .default).async(execute: {
//            var imageData: Data = nil
//            if let anImage = image {
//                imageData = UIImagePNGRepresentation(image)  UIImagePNGRepresentation(image) : anImage.jpegData(compressionQuality: 1)
//            }
//            var ciImage: CIImage = nil
//            if let aData = imageData {
//                ciImage = CIImage(data: aData)
//            }
//            var ansStr: String = nil
//            if ciImage != nil {
//                let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: CIContext(options: nil), options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
//                var features: [CIFeature] = nil
//                features = detector.features(in: ciImage)
//                if features.count != nil {
//                    for feature: CIFeature in features where feature is CIQRCodeFeature {
//                        ansStr = (feature as CIQRCodeFeature).messageString
//                        break
//                    }
//                }
//            }
//            DispatchQueue.main.async(execute: {
//                ans(ansStr)
//            })
//        })
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.black
//        view.addSubview(introudctionLabel)
//        view.addSubview(scannerView)
//        view.addSubview(scannerBGView)
//        view.layer.insertSublayer(videoPreviewLayer, at: 0)
//        p_addMasonry()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if scannerSession {
//            delegate?.scannerViewControllerInitSuccess(self)
//        } else {
//            delegate?.scannerViewController(self, initFailed: "相机初始化失败")
//        }
//    }
//    func setScannerType(_ scannerType: TLScannerType) {
//        if self.scannerType == scannerType {
//            return
//        }
//        self.scannerType = scannerType
//
//        var width: CGFloat = 0
//        var height: CGFloat = 0
//        if scannerType == TLScannerTypeQR {
//            introudctionLabel.text = "将二维码/条码放入框内，即可自动扫描"
//            height = APPW * 0.7
//            width = height
//        } else if scannerType == .cover {
//            introudctionLabel.text = "将书、CD、电影海报放入框内，即可自动扫描"
//            height = APPW * 0.85
//            width = height
//        } else if scannerType == .street {
//            introudctionLabel.text = "扫一下周围环境，寻找附近街景"
//            height = APPW * 0.85
//            width = height
//        } else if scannerType == .translate {
//            width = APPW * 0.7
//            height = 55
//            introudctionLabel.text = "将英文单词放入框内"
//        }
//        scannerView.hiddenScannerIndicator = scannerType == .translate
//        UIView.animate(withDuration: 0.3, animations: {
//            self.scannerView.mas_updateConstraints({ make in
//                make.width.mas_equalTo(width)
//                make.height.mas_equalTo(height)
//            })
//            self.view.layoutIfNeeded()
//        })
//        // rect值范围0-1，基准点在右上角
//        let rect = CGRect(x: scannerView.frame.origin.y / APPH, y: scannerView.frame.origin.x / APPW, width: scannerView.frame.size.height / APPH, height: scannerView.frame.size.width / APPW)
//        scannerSession.outputs[0].rectOfInterest = rect
//        if !isRunning {
//            startCodeReading()
//        }
//    }
//    func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if scannerSession.isRunning() {
//            stopCodeReading()
//        }
//    }
//    func startCodeReading() {
//        scannerView.startScanner()
//        scannerSession.startRunning()
//    }
//    func stopCodeReading() {
//        scannerView.stopScanner()
//        scannerSession.stopRunning()
//    }
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        if (metadataObjects.count) > 0 {
//            stopCodeReading()
//            let obj = metadataObjects[0] as AVMetadataMachineReadableCodeObject
//            delegate?.scannerViewController(self, scanAnswer: obj.stringValue)
//        }
//    }
////    func p_addMasonry() {
////        scannerView.mas_makeConstraints({ make in
////            make.centerX.mas_equalTo(self.view)
////            make.centerY.mas_equalTo(self.view).mas_offset(-55)
////            make.width.and().height().mas_equalTo(0)
////        })
////        scannerBGView.mas_makeConstraints({ make in
////            make.edges.mas_equalTo(self.view)
////        })
////        scannerBGView.addMasonry(withContainView: scannerView)
////        introudctionLabel.mas_makeConstraints({ make in
////            make.left.and().width().mas_equalTo(self.view)
////            make.top.mas_equalTo(self.scannerView.mas_bottom).mas_offset(30)
////        })
////    }
//}
