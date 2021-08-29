//
//  UIImage+Extension.swift
import UIKit

public extension UIImage {

    /// 返回不渲染的图片
    var original: UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }

    /// 拉伸图片使用
    var resizableImage: UIImage {
        let w = self.size.width/2
        let h = self.size.height/2
        return self.resizableImage(withCapInsets: UIEdgeInsets(top: h, left: w, bottom: h, right: w), resizingMode: .stretch)
    }

    var stretchableImage: UIImage {
        return self.stretchableImage(withLeftCapWidth: Int(self.size.width/2), topCapHeight: Int(self.size.height/2))
    }

    /// 裁剪图片
    func imageInRect(_ rect: CGRect) -> UIImage {
        return UIImage(cgImage: (self.cgImage?.cropping(to: rect))!)
    }

    /// 从网络生成图片
    class func imageFromURL(_ imgSrc: String) -> UIImage? {
        let url = URL(string: imgSrc)
        let data = try! Data(contentsOf: url!)
        return UIImage(data: data)
    }

    /// 根据颜色生成图片
    class func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    /// 重设图片尺寸
    func resetSize(_ newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    /// 重设图片透明度
    func resetAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -area.size.height)
        ctx.setBlendMode(.multiply)
        ctx.setAlpha(alpha)
        ctx.draw(self.cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /// 裁剪成圆形图片
    func circle(insets: CGFloat, borderColor: UIColor, _ lineWidth: CGFloat = 0) -> UIImage {
        let ctxWH: CGFloat = self.size.width - 2 * insets
        let ctxRect = CGRect(x: insets, y: insets, width: ctxWH, height: ctxWH)
        UIGraphicsBeginImageContextWithOptions(ctxRect.size, false, 0)
        let bigCirclePath = UIBezierPath(ovalIn: ctxRect)
        borderColor.set()
        bigCirclePath.lineWidth = lineWidth
        bigCirclePath.fill()
        let clipRect = CGRect(x: ctxRect.origin.x + lineWidth, y: ctxRect.origin.y + lineWidth, width: ctxRect.size.width - 2 * lineWidth, height: ctxRect.size.height - 2 * lineWidth)
        let clipPath = UIBezierPath(ovalIn: clipRect)
        clipPath.addClip()
        self.draw(at: CGPoint(x: lineWidth, y: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
