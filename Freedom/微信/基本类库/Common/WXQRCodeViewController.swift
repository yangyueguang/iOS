//
//  WXQRCodeViewController.swift
//  Freedom
import Foundation
import CoreGraphics
class WXQRCodeViewController: WXBaseViewController {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var codeView: UIImageView!
    @IBOutlet weak var introduceLabel: UILabel!
    var user: WXUser? {
        didSet {
            iconImageView.kf.setImage(with: URL(string: user?.avatarURL ?? ""))
            titleLabel.text = user?.showName
            subTitleLabel.text = user?.detailInfo.location
            createQRCodeImage(for: user?.userID ?? "", ans: { ansImage in
            })
        }
    }
  
    func createQRCodeImage(for str: String, ans: @escaping (UIImage) -> Void) {
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
            bitmapRef.interpolationQuality = CGInterpolationQuality.none
            bitmapRef.scaleBy(x: scale, y: scale)
            bitmapRef.draw(bitmapImage!, in: extent)
            let scaledImage = bitmapRef.makeImage()
            let ansImage = UIImage(cgImage: scaledImage!)
            DispatchQueue.main.async(execute: {
                ans(ansImage)
                self.codeView.image = ansImage
            })
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        captureScreenshot(from: codeView, rect: codeView.bounds, finished: { avatarPath in
            let path = FileManager.pathScreenshotImage(avatarPath)
            UIImageWriteToSavedPhotosAlbum(path.image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        })
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
        if error != nil {
            noticeError("保存图片到系统相册失败\n\(String(describing: error?.localizedDescription))")
        } else {
            noticeSuccess("已保存到系统相册")
        }
    }
}
