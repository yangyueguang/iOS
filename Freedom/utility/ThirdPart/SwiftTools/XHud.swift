//
//  XHud.swift
import UIKit
/// Hud 风格
/// - vomProgress: vom 里那种两个蓝色球球
/// - custom: contentView 需要遵循 XHudAnimating
/// - withDetail: vom 包含两个蓝色球 及 文字提示
public enum XHudStyle {
    case vomProgress
    case custom(contentView: UIView)
    case withDetail(message: String)
}
public final class XHud {
    /// 是否显示灰色背景蒙层，true 显示，false(default) 不显示
    public static var dimsBackground: Bool {
        get { return XHudManager.sharedHUD.dimsBackground }
        set { XHudManager.sharedHUD.dimsBackground = newValue }
    }
    /// 是否允许用户交互穿透，true 允许，false(default) 不允许
    public static var allowsInteraction: Bool {
        get { return XHudManager.sharedHUD.userInteractionOnUnderlyingViewsEnabled  }
        set { XHudManager.sharedHUD.userInteractionOnUnderlyingViewsEnabled = newValue }
    }
    /// (只读) 返回 Hud 是否可见
    public static var isVisible: Bool { return XHudManager.sharedHUD.isVisible }
    public static func show(_ style: XHudStyle, onView view: UIView? = nil) {
        XHudManager.sharedHUD.contentView = contentView(with: style)
        XHudManager.sharedHUD.show(onView: view)
    }
    public static func hide(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        XHudManager.sharedHUD.hide(animated: animated, completion: completion)
    }
    public static func hide(afterDelay delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        XHudManager.sharedHUD.hide(afterDelay: delay, completion: completion)
    }
    public static func flash(_ style: XHudStyle, onView view: UIView? = nil) {
        XHud.show(style, onView: view)
        XHud.hide(completion: nil)
    }
    public static func flash(_ style: XHudStyle, onView view: UIView? = nil, delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        XHud.show(style, onView: view)
        XHud.hide(afterDelay: delay, completion: completion)
    }
    private static func contentView(with style: XHudStyle) -> UIView {
        switch style {
        case .vomProgress:
            return XHudVomProgressView()
        case .custom(let contentView):
            return contentView
        case .withDetail(let message):
            return XHudVomProgressView(message: message)
        }
    }
}

/// contentView 通过该协议来实现动画
@objc public protocol XHudAnimating {
    func startAnimation()
    @objc optional func stopAnimation()
}

internal class FrameView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 9.0
        layer.masksToBounds = true
        addSubview(self.content)
        let offset = 20.0
        let motionEffectsX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        motionEffectsX.maximumRelativeValue = offset
        motionEffectsX.minimumRelativeValue = -offset
        let motionEffectsY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        motionEffectsY.maximumRelativeValue = offset
        motionEffectsY.minimumRelativeValue = -offset
        let group = UIMotionEffectGroup()
        group.motionEffects = [motionEffectsX, motionEffectsY]
        addMotionEffect(group)
    }

    internal var content: UIView = UIView() {
        didSet {
            content.alpha = 0.85
            content.clipsToBounds = true
            content.contentMode = .center
            frame.size = content.bounds.size
            addSubview(content)
        }
    }
}

internal class XHudManager: NSObject {
    fileprivate struct Constants {
        static let sharedHUD = XHudManager()
    }
    internal var viewToPresentOn: UIView?
    fileprivate let container = ContainerView()
    fileprivate var hideTimer: Timer?
    internal typealias TimerAction = (Bool) -> Void
    fileprivate var timerActions = [String: TimerAction]()
    @available(*, deprecated, message: "Will be removed with Swift4 support, use gracePeriod instead")
    internal var graceTime: TimeInterval {
        get {
            return gracePeriod
        }
        set(newPeriod) {
            gracePeriod = newPeriod
        }
    }
    internal var gracePeriod: TimeInterval = 0
    fileprivate var graceTimer: Timer?
    internal class var sharedHUD: XHudManager {
        return Constants.sharedHUD
    }
    internal override init () {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(XHudManager.willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        userInteractionOnUnderlyingViewsEnabled = false
        container.frameView.autoresizingMask = [ .flexibleLeftMargin, .flexibleRightMargin,
                                                 .flexibleTopMargin, .flexibleBottomMargin ]
        self.container.isAccessibilityElement = true
        self.container.accessibilityIdentifier = "XHudManager"
    }
    internal convenience init(viewToPresentOn view: UIView) {
        self.init()
        viewToPresentOn = view
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    internal var dimsBackground = false
    internal var userInteractionOnUnderlyingViewsEnabled: Bool {
        get {
            return !container.isUserInteractionEnabled
        }
        set {
            container.isUserInteractionEnabled = !newValue
        }
    }
    internal var isVisible: Bool {
        return !container.isHidden
    }
    internal var contentView: UIView {
        get { return container.frameView.content }
        set { container.frameView.content = newValue }
    }

    internal func show(onView view: UIView? = nil) {
        let view: UIView = view ?? viewToPresentOn ?? UIApplication.shared.keyWindow!
        if  !view.subviews.contains(container) {
            view.addSubview(container)
            container.frame.origin = CGPoint.zero
            container.frame.size = view.frame.size
            container.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
            container.isHidden = true
        }
        if dimsBackground {
            container.showBackground(animated: true)
        }
        if gracePeriod > 0.0 {
            let timer = Timer(timeInterval: gracePeriod, target: self, selector: #selector(XHudManager.handleGraceTimer(_:)), userInfo: nil, repeats: false)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            graceTimer = timer
        } else {
            showContent()
        }
    }
    
    func showContent() {
        graceTimer?.invalidate()
        container.showFrameView()
        startAnimatingContentView()
    }
    
    internal func hide(animated anim: Bool = true, completion: TimerAction? = nil) {
        graceTimer?.invalidate()
        container.hideFrameView(animated: anim, completion: completion)
        stopAnimatingContentView()
    }
    
    internal func hide(_ animated: Bool, completion: TimerAction? = nil) {
        hide(animated: animated, completion: completion)
    }
    
    internal func hide(afterDelay delay: TimeInterval, completion: TimerAction? = nil) {
        let key = UUID().uuidString
        let userInfo = ["timerActionKey": key]
        if let completion = completion {
            timerActions[key] = completion
        }
        hideTimer?.invalidate()
        hideTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(XHudManager.performDelayedHide(_:)), userInfo: userInfo, repeats: false)
    }
    @objc internal func willEnterForeground(_ notification: Notification?) {
        self.startAnimatingContentView()
    }
    internal func startAnimatingContentView() {
        if let animatingContentView = contentView as? XHudAnimating, isVisible {
            animatingContentView.startAnimation()
        } else {
            print("未遵循协议startAnimation()")
        }
    }
    internal func stopAnimatingContentView() {
        if let animatingContentView = contentView as? XHudAnimating {
            animatingContentView.stopAnimation?()
        } else {
            print("未遵循协议stopAnimation()")
        }
    }
    @objc internal func performDelayedHide(_ timer: Timer? = nil) {
        let userInfo = timer?.userInfo as? [String:AnyObject]
        let key = userInfo?["timerActionKey"] as? String
        var completion: TimerAction?
        if let key = key, let action = timerActions[key] {
            completion = action
            timerActions[key] = nil
        }
        hide(animated: true, completion: completion)
    }
    @objc internal func handleGraceTimer(_ timer: Timer? = nil) {
        if (graceTimer?.isValid)! {
            showContent()
        }
    }
}

internal class ContainerView: UIView {
    internal let frameView: FrameView
    internal init(frameView: FrameView = FrameView()) {
        self.frameView = frameView
        super.init(frame: CGRect.zero)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        frameView = FrameView()
        super.init(coder: aDecoder)
        commonInit()
    }
    fileprivate func commonInit() {
        backgroundColor = UIColor.clear
        isHidden = true
        addSubview(backgroundView)
        addSubview(frameView)
    }
    internal override func layoutSubviews() {
        super.layoutSubviews()
        frameView.center = center
        backgroundView.frame = bounds
    }
    internal func showFrameView() {
        layer.removeAllAnimations()
        frameView.center = center
        frameView.alpha = 1.0
        isHidden = false
    }
    fileprivate var willHide = false
    internal func hideFrameView(animated anim: Bool, completion: ((Bool) -> Void)? = nil) {
        let finalize: (_ finished: Bool) -> Void = { finished in
            self.isHidden = true
            self.removeFromSuperview()
            self.willHide = false
            completion?(finished)
        }
        
        if isHidden {
            return
        }
        willHide = true
        if anim {
            UIView.animate(withDuration: 0.8, animations: {
                self.frameView.alpha = 0.0
                self.hideBackground(animated: false)
            }, completion: { _ in finalize(true) })
        } else {
            self.frameView.alpha = 0.0
            finalize(true)
        }
    }
    
    fileprivate let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white:0.0, alpha:0.25)
        view.alpha = 0.0
        return view
    }()
    internal func showBackground(animated anim: Bool) {
        if anim {
            UIView.animate(withDuration: 0.175, animations: {
                self.backgroundView.alpha = 1.0
            })
        } else {
            backgroundView.alpha = 1.0
        }
    }
    internal func hideBackground(animated anim: Bool) {
        if anim {
            UIView.animate(withDuration: 0.65, animations: {
                self.backgroundView.alpha = 0.0
            })
        } else {
            backgroundView.alpha = 0.0
        }
    }
}

internal class XHudVomProgressView: UIView, XHudAnimating {
    let ballWidth:CGFloat = 10
    var showText: String = ""
    static let defaultFrame = CGRect(x: 0, y: 0, width: 156, height: 156)
    init(frame: CGRect = .zero, message: String = "") {
        super.init(frame: XHudVomProgressView.defaultFrame)
        showText = message
        let textHeight = (showText as NSString).boundingRect(with: bounds.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [:], context: nil).size.height
        label.frame = CGRect(x:0, y:firstView.frame.origin.y + firstView.frame.size.height + 20, width: bounds.size.width, height: textHeight)
        addSubview(firstView)
        addSubview(secondView)
        if showText.count > 0 {
            addSubview(label)
//            backgroundColor = UIColor.lightGray
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private lazy var firstView: UIView = {
        let halfWidth = CGFloat(ceilf(CFloat(bounds.size.width / 2.0)))
        let view = UIView(frame: CGRect(x: halfWidth-16, y: bounds.size.height / 2, width: self.ballWidth, height: self.ballWidth))
        view.alpha = 0.85
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = UIColor.green
        return view
    }()
    private lazy var secondView: UIView = {
        let halfWidth = CGFloat(ceilf(CFloat(bounds.size.width / 2.0)))
        let view = UIView(frame: CGRect(x: halfWidth+8, y: bounds.size.height / 2, width: ballWidth, height: ballWidth))
        view.alpha = 0.85
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = UIColor.red
        return view
    }()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = showText
        label.textColor = UIColor(white: 0.8, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    func startAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "position")
        let x = firstView.frame.origin.x
        let y = firstView.frame.origin.y
        let x1 = secondView.frame.origin.x
        let y1 = secondView.frame.origin.y
        animation.values = [CGPoint(x:x , y: y),CGPoint(x:x1, y: y),CGPoint(x:x, y: y)]
        animation.duration = 0.8
        animation.repeatCount = Float(INT_MAX)
        animation.isRemovedOnCompletion = false
        firstView.layer.add(animation, forKey: "crossAnimation")
        let secondAnimation = CAKeyframeAnimation(keyPath: "position")
        secondAnimation.values = [CGPoint(x:x1 , y: y1),CGPoint(x:x, y: y1),CGPoint(x:x1, y: y1)]
        secondAnimation.duration = 0.8
        secondAnimation.repeatCount = Float(INT_MAX)
        secondAnimation.isRemovedOnCompletion = false
        secondView.layer.add(secondAnimation, forKey: "crossAnimation")
    }
    func stopAnimation() {
    }
}
