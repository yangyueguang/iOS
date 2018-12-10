//
//  SDScanViewController.swift
//  Freedom
import UIKit
import XExtension
import AVFoundation
class AlipayScanViewController: AlipayBaseViewController {
    private let kBorderW: CGFloat = 60
    private let kMargin: CGFloat = 15
    var session: AVCaptureSession?
    weak var maskView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.disMiss)))
        view.clipsToBounds = true
        setupMaskView()
        setupBottomBar()
        setupScanWindowView()
        beginScanning()
    }
    func setupMaskView() {
        let mask = UIView()
        maskView = mask
        mask.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        mask.layer.borderWidth = kBorderW
        mask.bounds = CGRect(x: 0, y: 0, width: view.frame.size.width + kBorderW + kMargin * 2, height: view.height * 0.9)
        mask.center = CGPoint(x: view.frame.size.width * 0.5, y: view.height * 0.5)
        mask.y = 0
        view.addSubview(mask)
    }
    func setupBottomBar() {
        let bottomBar = UIView(frame: CGRect(x: 0, y: view.height * 0.9, width: view.frame.size.width, height: view.height * 0.1))
        bottomBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        view.addSubview(bottomBar)
    }
    func setupScanWindowView() {
        let scanWindowH: CGFloat = view.height * 0.9 - kBorderW * 2
        let scanWindowW: CGFloat = view.frame.size.width - kMargin * 2
        let scanWindow = UIView(frame: CGRect(x: kMargin, y: kBorderW, width: scanWindowW, height: scanWindowH))
        scanWindow.clipsToBounds = true
        view.addSubview(scanWindow)
        let scanNetImageViewH: CGFloat = 241
        let scanNetImageViewW: CGFloat = scanWindow.frame.size.width
        let scanNetImageView = UIImageView(image: UIImage(named: "scan_net"))
        scanNetImageView.frame = CGRect(x: 0, y: -scanNetImageViewH, width: scanNetImageViewW, height: scanNetImageViewH)
        let scanNetAnimation = CABasicAnimation()
        scanNetAnimation.keyPath = "transform.translation.y"
        scanNetAnimation.byValue = scanWindowH
        scanNetAnimation.duration = 1.0
        scanNetAnimation.repeatCount = MAXFLOAT
        scanNetImageView.layer.add(scanNetAnimation, forKey: nil)
        scanWindow.addSubview(scanNetImageView)
        let buttonWH: CGFloat = 18
        let topLeft = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWH, height: buttonWH))
        topLeft.setImage(UIImage(named: "u_scan_1"), for: .normal)
        scanWindow.addSubview(topLeft)
        let topRight = UIButton(frame: CGRect(x: scanWindowW - buttonWH, y: 0, width: buttonWH, height: buttonWH))
        topRight.setImage(UIImage(named: "u_scan_2"), for: .normal)
        scanWindow.addSubview(topRight)
        let bottomLeft = UIButton(frame: CGRect(x: 0, y: scanWindowH - buttonWH, width: buttonWH, height: buttonWH))
        bottomLeft.setImage(UIImage(named: "u_scan_3"), for: .normal)
        scanWindow.addSubview(bottomLeft)
        let bottomRight = UIButton(frame: CGRect(x: topRight.x, y: bottomLeft.y, width: buttonWH, height: buttonWH))
        bottomRight.setImage(UIImage(named: "u_scan_4"), for: .normal)
        scanWindow.addSubview(bottomRight)
    }
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func beginScanning() {
        //获取摄像设备
        let device = AVCaptureDevice.default(for: .video)
        //创建输入流
        var input: AVCaptureDeviceInput? = nil
        if let aDevice = device {
            input = try? AVCaptureDeviceInput(device: aDevice)
        }
        if input == nil {
            return
        }
        //创建输出流
        let output = AVCaptureMetadataOutput()
        output.rectOfInterest = CGRect(x: 0.1, y: 0, width: 0.9, height: 1)
        //设置代理 在主线程里刷新
        output.setMetadataObjectsDelegate(self as? AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
        //初始化链接对象
        session = AVCaptureSession()
        //高质量采集率
        session?.sessionPreset = .high
//        session?.add(input)
//        session?.add(output)
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]
        let layer = AVCaptureVideoPreviewLayer(session: session!)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.layer.bounds
        view.layer.insertSublayer(layer, at: 0)
        //开始捕获
        session?.startRunning()
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if (metadataObjects.count ) > 0 {
            session?.stopRunning()
            let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            let alvc = UIAlertController(title: "扫描结果", message: (metadataObject?.stringValue)!, preferredStyle: .alert)
            let ac = UIAlertAction(title: "退出", style: .cancel) { (action) in
                self.disMiss()
            }
            let bc = UIAlertAction(title: "再次扫描", style: .default) { (action) in
                self.session?.startRunning();
            }
            alvc.addAction(ac)
            alvc.addAction(bc)
            self.present(alvc, animated: true) {
            }
        }
    }
    func disMiss() {
        navigationController?.popViewController(animated: true)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            navigationController?.navigationBar.isHidden = false
        }
    }
}
