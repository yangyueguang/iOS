//
//  UIView+CircularAnimation.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 10/5/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation
enum WXImage: String {
    case icon = "icon"
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
enum ALImage: String {
    case icon = ""
    var image: UIImage {
        let ima = UIImage(asset: rawValue)
        assert(ima != nil, "图片资源丢失\(rawValue)")
        return ima!
    }
}
extension UIImage {
    convenience init?(asset: String) {
        self.init(named: asset, in: Bundle.main, compatibleWith: nil)
    }
}


extension Array where Element: Equatable {
    func index(_ e: Element) -> Int? {
        for (index, value) in lazy.enumerated() where value == e {
            return index
        }
        return nil
    }
}
private var XCHView: UIView = UIView()
extension UICollectionView {
    var headView: UIView {
        set {
            XCHView.removeFromSuperview()
            XCHView = newValue
            var headFrame = newValue.frame
            headFrame.origin.y = -headFrame.size.height
            XCHView.frame = headFrame
            contentInset = UIEdgeInsets(top: headFrame.size.height, left: 0, bottom: 0, right: 0)
            addSubview(XCHView)
        }
        get {
            return XCHView
        }
    }
}
extension String {
    var intValue: Int {
        return Int((self as NSString).intValue)
    }
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }

    func substring(from index: Int) -> String {
        guard count > index else { return "" }
        return (self as NSString).substring(from:index)
    }
    var oc: NSString {
        return self as NSString
    }
}
extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ cell: T.Type) -> T {
        var ce = dequeueReusableCell(withIdentifier: cell.identifier)
        if ce == nil {
            ce = cell.init(style: .default, reuseIdentifier: cell.identifier)
        }
        return ce as! T
    }
}
extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as! T
    }
    func dequeueHeadFoot<T: UICollectionReusableView>(_ className: T.Type, kind: String, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: className.identifier, for: indexPath) as! T
    }
}
extension UIViewController {
    static func storyVC(_ name: String) -> UIViewController {
        let story = UIStoryboard(name: name, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: self.nameOfClass)
        return vc
    }
}
extension UIView {
    static func xibView() -> UIView? {
        let nib = UINib(nibName: nameOfClass, bundle: Bundle.main)
        let view = nib.instantiate(withOwner: self, options: [:]).first as? UIView
        return view
    }
}
class StarsOverlay: UIView {
    var emitterTimer: Timer?
    private var particle = CAEmitterCell()
    private var emitter: CAEmitterLayer {
        return layer as! CAEmitterLayer
    }
    override class var layerClass : AnyClass {
        return CAEmitterLayer.self
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    func setup() {
        emitter.emitterMode = CAEmitterLayerEmitterMode.outline
        emitter.emitterShape = CAEmitterLayerEmitterShape.circle
        emitter.renderMode = CAEmitterLayerRenderMode.oldestFirst
        emitter.preservesDepth = true
        particle.contents = UIImage(named: "spark")!.cgImage
        particle.birthRate = 10
        particle.lifetime = 50
        particle.lifetimeRange = 5
        particle.velocity = 20
        particle.velocityRange = 10
        particle.scale = 0.02
        particle.scaleRange = 0.1
        particle.scaleSpeed = 0.02
        emitter.emitterCells = [particle]
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if self.window != nil {
            if emitterTimer == nil {
                emitterTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(StarsOverlay.randomizeEmitterPosition), userInfo: nil, repeats: true)
            }
        } else if emitterTimer != nil {
            emitterTimer?.invalidate()
            emitterTimer = nil
        }
    }
    @objc func randomizeEmitterPosition() {
        let sizeWidth = max(bounds.width, bounds.height)
        let radius = CGFloat(arc4random()).truncatingRemainder(dividingBy: sizeWidth)
        emitter.emitterSize = CGSize(width: radius, height: radius)
        particle.birthRate = 10 + sqrt(Float(radius))
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        emitter.emitterPosition = self.center
        emitter.emitterSize = self.bounds.size
    }
}

private class CircularRevealAnimator {
    class AnimationDelegate: NSObject, CAAnimationDelegate {
        private let completion: () -> Void
        init(completion: @escaping () -> Void) {
            self.completion = completion
        }
        func animationDidStop(_: CAAnimation, finished: Bool) {
            completion()
        }
    }
    var completion: (() -> Void)?
    private let layer = CALayer()
    private let mask = CAShapeLayer()
    let animation: CABasicAnimation = CABasicAnimation(keyPath: "path")
    init(fillLayer: CALayer, center: CGPoint, startRadius: CGFloat, endRadius: CGFloat, color: UIColor?, invert: Bool = false) {
        fillLayer.insertSublayer(layer, at: 0)
        layer.backgroundColor = color?.cgColor ?? UIColor.red.cgColor
        layer.frame = fillLayer.bounds
        var startPath = CGPath(ellipseIn: CGRect(origin: center, size: CGSize.zero).insetBy(dx: startRadius, dy: startRadius), transform: nil)
        var endPath = CGPath(ellipseIn: CGRect(origin: center, size: CGSize.zero).insetBy(dx: -endRadius, dy: -endRadius), transform: nil)
        if invert {
            var path = CGMutablePath()
            path.addRect(layer.bounds)
            path.addPath(startPath)
            startPath = path
            path = CGMutablePath()
            path.addRect(layer.bounds)
            path.addPath(endPath)
            endPath = path
        }
        mask.path = endPath
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.delegate = AnimationDelegate {
            self.layer.mask = nil
            self.layer.opacity = 0
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = 0.2
            opacityAnimation.delegate = AnimationDelegate {
                self.layer.removeFromSuperlayer()
                self.completion?()
            }
            self.layer.add(opacityAnimation, forKey: "opacity")
            self.animation.delegate = nil
        }
    }
    func start() {
        layer.mask = mask
        mask.frame = layer.bounds
        mask.add(animation, forKey: "reveal")
    }
}

extension UIView {
    /// 从一个点扩大的动画
    func animateCircular(withDuration duration: TimeInterval, center: CGPoint, revert: Bool = false, animations: () -> Void, completion: ((Bool) -> Void)? = nil) {
        let snapshot = snapshotView(afterScreenUpdates: false)!
        snapshot.frame = bounds
        self.addSubview(snapshot)
        let center = convert(center, to: snapshot)
        let radius: CGFloat = {
            let x = max(center.x, frame.width - center.x)
            let y = max(center.y, frame.height - center.y)
            return sqrt(x * x + y * y)
        }()
        var animation : CircularRevealAnimator
        if !revert {
            animation = CircularRevealAnimator(fillLayer: snapshot.layer, center: center, startRadius: 0, endRadius: radius, color: .red, invert: true)
        } else {
            animation = CircularRevealAnimator(fillLayer: snapshot.layer, center: center, startRadius: radius, endRadius: 0, color: .red)
        }
        animation.animation.duration = duration
        animation.completion = {
            snapshot.removeFromSuperview()
            completion?(true)
        }
        animation.start()
        animations()
    }
}
