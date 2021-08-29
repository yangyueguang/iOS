//
//  UIView+Extension.swift
import UIKit
import Foundation
public extension UIView  {

    var x: CGFloat {
        set {
            self.frame = CGRect(x: x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
        get {
            return frame.origin.x
        }
    }

    var y: CGFloat {
        set {
            self.frame = CGRect(x: frame.origin.x, y: y, width: frame.size.width, height: frame.size.height)
        }
        get {
            return frame.origin.y
        }
    }

    var width: CGFloat {
        set {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.size.height)
        }
        get {
            return frame.size.width
        }
    }

    var height: CGFloat {
        set {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        }
        get {
            return frame.size.height
        }
    }

    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: right - frame.origin.x, height: frame.size.height)
        }
    }

    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: bottom - frame.origin.y)
        }
    }

    var size: CGSize {
        set {
            self.frame.size = size
        }
        get {
            return frame.size
        }
    }

    func alignmentLeft(_ view: UIView, _ offset: CGFloat = 0) {
        self.frame = CGRect(x: view.x + offset, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
    }

    func alignmentRight(_ view: UIView, _ offset: CGFloat = 0) {
        self.frame = CGRect(x: view.right - self.width + offset, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
    }

    func alignmentTop(_ view: UIView, _ offset: CGFloat = 0) {
        self.frame = CGRect(x: frame.origin.x, y: view.y + offset, width: frame.size.width, height: frame.size.height)
    }

    func alignmentBottom(_ view: UIView, _ offset: CGFloat = 0) {
        self.frame = CGRect(x: frame.origin.x, y: view.bottom - frame.size.height + offset, width: frame.size.width, height: frame.size.height)
    }

    func alignmentHorizontal(_ view: UIView) {
        self.center = CGPoint(x: view.center.x, y: center.y)
    }
    
    func alignmentVertical(_ view: UIView) {
        self.center = CGPoint(x: center.x, y: view.center.y)
    }

    /// 变圆
    func round() {
        layer.masksToBounds = true
        layer.cornerRadius = size.width / 2
    }

    // MARK:- 裁剪圆角
    func clipCorner(direction: UIRectCorner, radius: CGFloat) {
        let cornerSize = CGSize(width: radius, height: radius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.addSublayer(maskLayer)
        layer.mask = maskLayer
    }

    /// 批量添加子视图
    func addSubviews(_ views:[UIView]) {
        for v in views {
            self.addSubview(v)
        }
    }

    /// 添加点击响应
    func add(_ target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }

    /// 类似qq聊天窗口的抖动效果
    func shakeAnimation() {
        let t: CGFloat = 5.0
        let translateRight = CGAffineTransform.identity.translatedBy(x: t, y: 0.0)
        let translateLeft = CGAffineTransform.identity.translatedBy(x: -t, y: 0.0)
        let translateTop = CGAffineTransform.identity.translatedBy(x: 0.0, y: 1)
        let translateBottom = CGAffineTransform.identity.translatedBy(x: 0.0, y: -1)
        self.transform = translateLeft
        UIView.animate(withDuration: 0.07, delay: 0.0, options: .autoreverse, animations: {
            UIView.setAnimationRepeatCount(2.0)
            self.transform = translateRight
        }) { finished in
            UIView.animate(withDuration: 0.07, animations: {
                self.transform = translateBottom
            }) { finished in
                UIView.animate(withDuration: 0.07, animations: {
                    self.transform = translateTop
                }) { finished in
                    UIView.animate(withDuration: 0.05, delay: 0.0, options: .beginFromCurrentState, animations: {
                        self.transform = .identity //回到没有设置transform之前的坐标
                    })
                }
            }
        }
    }

    /// 左右抖动
    func leftRightAnimation() {
        let t: CGFloat = 5.0
        let translateRight = CGAffineTransform.identity.translatedBy(x: t, y: 0.0)
        let translateLeft = CGAffineTransform.identity.translatedBy(x: -t, y: 0.0)
        self.transform = translateLeft
        UIView.animate(withDuration: 0.07, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            UIView.setAnimationRepeatCount(2.0)
            self.transform = translateRight
        }) { finished in
            if finished {
                UIView.animate(withDuration: 0.05, delay: 0.0, options: .beginFromCurrentState, animations: {
                    self.transform = .identity
                })
            }
        }
    }

    func imageFromView() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        if let aContext = context {
            layer.render(in: aContext)
        }
        let theImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }

    func bestRoundCorner() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: bounds.size)
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.path = path.cgPath
        self.layer.mask = layer
    }

    /// 是否包含视图类型或指定视图
    func contains(_ subView: UIView?, typeClass: AnyClass?) -> Bool {
        for view in subviews {
            if let subView = subView {
                return view.isEqual(subView)
            }
            if let typeClass = typeClass {
                if type(of: view) === typeClass {
                    return true
                }
            }
        }
        return false
    }

    func linearColorFromcolors(_ colors: [UIColor], isHorizantal hor: Bool = true) {
        if colors.count < 2 {
            backgroundColor = colors.first
            return
        }
        var cgColors: [CGColor] = []
        var locations: [NSNumber] = []
        let lenth: Float = 1.0 / Float(colors.count - 1)
        for i in 0..<colors.count {
            let loc = NSNumber(value: Float(i) * lenth)
            locations.append(loc)
            let color: UIColor = colors[i]
            cgColors.append(color.cgColor)
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = cgColors
        if hor {
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        }
        gradientLayer.locations = locations
        layer.addSublayer(gradientLayer)
    }

    func gotCircleLinear(fromColors colors: [UIColor]) -> UIImage? {
        let rect: CGRect = bounds
        var ra = CGAffineTransform(scaleX: 1, y: 1)
        let path = CGPath(rect: rect, transform: &ra)
        // 绘制渐变层
        var cgColors = [AnyHashable](repeating: 0, count: colors.count)
        for co in colors {
            cgColors.append(co.cgColor)
        }
        UIGraphicsBeginImageContext(rect.size)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = UIGraphicsGetCurrentContext(),
            let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: nil) else { return nil}
        let pathRect: CGRect = path.boundingBox
        let center = CGPoint(x: pathRect.midX, y: pathRect.midY)
        let radius: CGFloat = max(pathRect.size.width / 2.0, pathRect.size.height / 2.0) * sqrt(2)
        context.saveGState()
        context.addPath(path)
        context.clip()
        context.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        context.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func linearTextColor(fromSuperView bgView: UIView, colors: [UIColor]) {
        var cgColors: [CGColor] = []
        for co in colors {
            cgColors.append(co.cgColor)
        }
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.frame = frame
        gradientLayer1.colors = cgColors
        gradientLayer1.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer1.endPoint = CGPoint(x: 1, y: 0)
        bgView.layer.addSublayer(gradientLayer1)
        gradientLayer1.mask = layer
        frame = gradientLayer1.bounds
    }

    static func xibView() -> Self? {
        let nib = UINib(nibName: nameOfClass, bundle: Bundle.main)
        let view = nib.instantiate(withOwner: self, options: [:]).first as? UIView
        return view?.toType()
    }
    
}
