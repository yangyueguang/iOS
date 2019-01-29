//
//  WXQRCodeViewController.swift
//  Freedom
import Foundation
class WXQRCodeViewController: WXBaseViewController {/// 信息页面元素 —— 头像URL (若为nil，会尝试根据Path设置)
    var avatarURL = "" {
        didSet {
            avatarImageView.sd_setImage(with: URL(string: avatarURL), placeholderImage: Image.logo.image)
        }
    }/// 信息页面元素 —— 头像Path
    var avatarPath = "" {
        didSet {
            avatarImageView.image = avatarPath.count > 0 ? UIImage(named: avatarPath) : nil
        }
    }/// 信息页面元素 —— 用户名
    var username = "" {
        didSet {
            usernameLabel.text = username
        }
    }/// 信息页面元素 —— 副标题（如地址）
    var subTitle = "" {
        didSet {
            subTitleLabel.text = subTitle
            if !subTitle.isEmpty {
//                usernameLabel.mas_remakeConstraints({ make in
//                    make.top.mas_equalTo(self.avatarImageView).mas_offset(8)
//                    make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10)
//                    make.right.mas_lessThanOrEqualTo(self.whiteBGView).mas_offset(-20)
//                })
            }
        }
    }/// 信息页面元素 —— 底部说明
    var introduction = "" {
        didSet {
            introductionLabel.text = introduction
        }
    }/// 信息页面元素 —— 二维码字符串
    var qrCode = "" {
        didSet {
            WXQRCodeViewController.createQRCodeImage(for: qrCode, ans: { ansImage in
                self.qrCodeImageView.image = ansImage
            })
        }
    }
    private lazy var whiteBGView: UIView = {
        let whiteBGView = UIView()
        whiteBGView.backgroundColor = UIColor.white
        whiteBGView.layer.masksToBounds = true
        whiteBGView.layer.cornerRadius = 2.0
        whiteBGView.layer.borderWidth = 1
        whiteBGView.layer.borderColor = UIColor.black.cgColor
        return whiteBGView
    }()
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 3.0
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        return avatarImageView
    }()
    private lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        usernameLabel.numberOfLines = 3
        return usernameLabel
    }()
    private lazy var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.systemFont(ofSize: 12.0)
        subTitleLabel.textColor = UIColor.gray
        return subTitleLabel
    }()
    private lazy var qrCodeImageView: UIImageView = {
        let qrCodeImageView = UIImageView()
        qrCodeImageView.backgroundColor = UIColor(white: 0.1, alpha: 0.1)
        return qrCodeImageView
    }()
    private var introductionLabel: UILabel = {
        let introductionLabel = UILabel()
        introductionLabel.textColor = UIColor.gray
        introductionLabel.font = UIFont.systemFont(ofSize: 11.0)
        return introductionLabel
    }()


    class func createQRCodeImage(for str: String, ans: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .default).async(execute: {
            let stringData = str.data(using: .utf8)
            var qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter?.setValue(stringData, forKey: "inputMessage")
            qrFilter?.setValue("M", forKey: "inputCorrectionLevel")
            guard let image = qrFilter?.outputImage else { return }
            let size: CGFloat = 300.0
            let extent = image.extent.integral
            let scale = min(size / extent.width, size / extent.height)
            let width = size_t(extent.width * scale)
            let height = size_t(extent.height * scale)
            let cs = CGColorSpaceCreateDeviceGray()
            guard let bitmapRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).rawValue) else { return }
            let context = CIContext(options: nil)
            let bitmapImage = context.createCGImage(image, from: extent)
//            CGContextSetInterpolationQuality(bitmapRef, CGInterpolationQuality.none)
//            bitmapRef.scaleBy(x: scale, y: scale)
//            bitmapRef.draw(in: bitmapImage, image: extent)
//            let scaledImage = bitmapRef.makeImage()
//            CGContextRelease(bitmapRef)
//            CGImageRelease(bitmapImage)
//            let ansImage = UIImage(cgImage: scaledImage)
//            DispatchQueue.main.async(execute: {
//                ans(ansImage)
//            })
        })
    }
    override func viewDidLoad() {
        view.addSubview(whiteBGView)
        whiteBGView.addSubview(avatarImageView)
        whiteBGView.addSubview(usernameLabel)
        whiteBGView.addSubview(subTitleLabel)
        whiteBGView.addSubview(qrCodeImageView)
        whiteBGView.addSubview(introductionLabel)
        p_addMasonry()
    }
    func captureScreenshot(from view: UIView, rect: CGRect, finished: @escaping (_ avatarPath: String) -> Void) {
        DispatchQueue.global(qos: .default).async {
            UIGraphicsBeginImageContextWithOptions(rect.size, _: false, _: 2.0)
            if let aContext = UIGraphicsGetCurrentContext() {
                view.layer.render(in: aContext)
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageRef = image?.cgImage
            let imageRefRect = imageRef?.cropping(to: CGRect(x: rect.origin.x * 2, y: rect.origin.y * 2, width: rect.size.width * 2, height: rect.size.height * 2))
            let ansImage = UIImage(cgImage: imageRefRect!)
            let imageViewData = ansImage.pngData()
            let imageName = String(format: "%.0lf.png", Date().timeIntervalSince1970 * 10000)
            let savedImagePath = FileManager.pathScreenshotImage(imageName)
            try! imageViewData?.write(to: URL(fileURLWithPath: savedImagePath), options: Data.WritingOptions.atomic)
            DispatchQueue.main.async {
                finished(imageName)
            }
        }
    }

    //将二维码信息页面保存到系统相册
    func saveQRCodeToSystemAlbum() {
        captureScreenshot(from: whiteBGView, rect: whiteBGView.bounds, finished: { avatarPath in
            let path = FileManager.pathScreenshotImage(avatarPath)
            let image = UIImage(named: path)
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        })
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
        if error != nil {
            noticeError("保存图片到系统相册失败\n\(String(describing: error?.localizedDescription))")
        } else {
            noticeSuccess("已保存到系统相册")
        }
    }
    func p_addMasonry() {
        whiteBGView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(TopHeight / 2)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.bottom.equalTo(self.introductionLabel.snp.bottom).offset(15)
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.whiteBGView).offset(20)
            make.width.height.equalTo(86)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10)
            make.centerY.equalTo(self.avatarImageView)
            make.right.lessThanOrEqualTo(self.whiteBGView).offset(-20)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.usernameLabel)
            make.top.equalTo(self.usernameLabel.snp.bottom).offset(10)
        }
        qrCodeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(15)
            make.left.equalTo(self.avatarImageView)
            make.right.equalTo(self.whiteBGView).offset(-20)
            make.height.equalTo(self.qrCodeImageView.snp.width)
        }
        introductionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.whiteBGView)
            make.top.equalTo(self.qrCodeImageView.snp.bottom).offset(15)
        }
    }
}
