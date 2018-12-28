//
import UIKit
import GLKit
/// 转场方式 只使用这个就够了
public enum XTransitionType {
    /// 破碎效果 present
    case brokenAnim
    /// 视图动画 present
    case viewAnim
    /// 动态动画 present
    case dynamicAnim
    /// 弹框动画 present
    case alertAnim
    /// 从天而降动画 present
    case alertDropDownAnim
    /// sheet动画 present
    case sheetAnim
    /// 放大动画 present
    case scaleAnim(origionFrame: CGRect)
    /// 放大动画 push... self.navigationController?.delegate = self
    case navPushAnim(operation: UINavigationController.Operation)

    func presentAnimation() -> UIViewControllerAnimatedTransitioning {
        switch self {
        case .brokenAnim: return XGLAnimator()
        case .viewAnim: return XUIViewAnimator()
        case .dynamicAnim: return XUIDynamicAnimator()
        case .alertAnim:
            return XAlertAnimatedTransition(isPresent: true)
        case .alertDropDownAnim:
            return XAlertDropDownAnimatedTransition(isPresent: true)
        case .sheetAnim:
            return XActionSheetAnimatedTransition(isPresent: true)
        case .scaleAnim(origionFrame: let rec):
            let scale = XScaleAnimation()
            scale.originFrame = rec
            scale.presenting = true
            return scale
        case .navPushAnim(operation: let operation):
           return XScaleNavAnimation(operation: operation)
        }
    }
    func dismissAnimation() -> UIViewControllerAnimatedTransitioning {
        switch self {
        case .brokenAnim: return XGLAnimator()
        case .viewAnim: return XUIViewAnimator()
        case .dynamicAnim: return XUIDynamicAnimator()
        case .alertAnim:
            return XAlertAnimatedTransition(isPresent: false)
        case .alertDropDownAnim:
            return XAlertDropDownAnimatedTransition(isPresent: false)
        case .sheetAnim:
            return XActionSheetAnimatedTransition(isPresent: false)
        case .scaleAnim(origionFrame: let rec):
            let scale = XScaleAnimation()
            scale.originFrame = rec
            scale.presenting = false
            return scale
        case .navPushAnim(operation: let operation):
            return XScaleNavAnimation(operation: operation)
        }
    }
}

//FIXME: 以下不用动
private struct TexturedVertex {
    var geometryVertex = Vector2()
    var textureVertex = Vector2()
}
private struct TexturedQuad {
    var bl = TexturedVertex()
    var br = TexturedVertex()
    var tl = TexturedVertex()
    var tr = TexturedVertex()
}
private struct Vector2: CustomStringConvertible, Equatable {
    var x : CGFloat = 0.0
    var y : CGFloat = 0.0
    init() {}
    init(x: CGFloat ,y: CGFloat) {
        self.x = x
        self.y = y
    }
    var description: String { return "[\(x),\(y)]" }
    static func + (left: Vector2, right: Vector2) -> Vector2 {
        return Vector2(x:left.x + right.x, y:left.y + right.y)
    }
}
private struct Sprite {
    var quad = TexturedQuad()
    var moveVelocity = Vector2()
    mutating func slice(_ rect: CGRect, textureSize: CGSize) {
        quad.bl.geometryVertex = Vector2(x: 0.0, y: 0.0)
        quad.br.geometryVertex = Vector2(x: rect.size.width, y: 0)
        quad.tl.geometryVertex = Vector2(x: 0, y: rect.size.height)
        quad.tr.geometryVertex = Vector2(x: rect.size.width, y: rect.size.height)
        quad.bl.textureVertex = Vector2(x: rect.origin.x / textureSize.width, y: rect.origin.y / textureSize.height)
        quad.br.textureVertex = Vector2(x: (rect.origin.x + rect.size.width) / textureSize.width, y: rect.origin.y / textureSize.height)
        quad.tl.textureVertex = Vector2(x: rect.origin.x / textureSize.width, y: (rect.origin.y + rect.size.height) / textureSize.height)
        quad.tr.textureVertex = Vector2(x: (rect.origin.x + rect.size.width) / textureSize.width, y: (rect.origin.y + rect.size.height) / textureSize.height)
        position = Vector2(x:position.x+rect.origin.x,y:position.y+rect.origin.y)
    }
    var position = Vector2() {
        didSet {
            let diff = Vector2(x:position.x - oldValue.x,y:position.y - oldValue.y)
            quad.bl.geometryVertex = quad.bl.geometryVertex + diff
            quad.br.geometryVertex = quad.br.geometryVertex + diff
            quad.tl.geometryVertex = quad.tl.geometryVertex + diff
            quad.tr.geometryVertex = quad.tr.geometryVertex + diff
        }
    }
    mutating func update(_ tick: TimeInterval) {
        position =  Vector2(x:position.x + moveVelocity.x * CGFloat(tick),y:position.y + moveVelocity.y * CGFloat(tick))
    }
}

private class SpriteRender {
    fileprivate let texture: ViewTexture
    fileprivate let effect: GLKBaseEffect
    init(texture: ViewTexture, effect: GLKBaseEffect) {
        self.texture = texture
        self.effect = effect
    }
    func render(_ sprites: [Sprite]) {
        effect.texture2d0.name = self.texture.name
        effect.texture2d0.enabled = 1
        effect.prepareToDraw()
        var vertex = sprites.map { $0.quad }
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue))
        withUnsafePointer(to: &vertex[0].bl.geometryVertex) { offset in
            glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), 2, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(MemoryLayout<TexturedVertex>.size), offset)
        }
        withUnsafePointer(to: &vertex[0].bl.textureVertex) { offset in
            glVertexAttribPointer(GLuint(GLKVertexAttrib.texCoord0.rawValue), 2, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(MemoryLayout<TexturedVertex>.size), offset)
        }
        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(vertex.count * 6))
    }
}
private class ViewTexture {
    var name: GLuint = 0
    var width: GLsizei = 0
    var height: GLsizei = 0
    func setupOpenGL() {
        glGenTextures(1, &name)
        glBindTexture(GLenum(GL_TEXTURE_2D), name)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GLint(GL_LINEAR))
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GLint(GL_LINEAR))
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GLint(GL_CLAMP_TO_EDGE))
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GLint(GL_CLAMP_TO_EDGE))
        glBindTexture(GLenum(GL_TEXTURE_2D), 0);
    }
    deinit {
        if name != 0 {
            glDeleteTextures(1, &name)
        }
    }
    func render(view: UIView) {
        let scale = UIScreen.main.scale
        width = GLsizei(view.layer.bounds.size.width * scale)
        height = GLsizei(view.layer.bounds.size.height * scale)
        var texturePixelBuffer = [GLubyte](repeating: 0, count: Int(height * width * 4))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        withUnsafeMutablePointer(to: &texturePixelBuffer[0]) { texturePixelBuffer in
            let context = CGContext(data: texturePixelBuffer,
                                    width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: Int(width * 4), space: colorSpace,
                                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)!
            context.scaleBy(x: scale, y: scale)
            UIGraphicsPushContext(context)
            view.drawHierarchy(in: view.layer.bounds, afterScreenUpdates: false)
            UIGraphicsPopContext()
            glBindTexture(GLenum(GL_TEXTURE_2D), name);
            glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GLint(GL_RGBA), width, height, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), texturePixelBuffer)
            glBindTexture(GLenum(GL_TEXTURE_2D), 0);
        }
    }
}

//vc.transitioningDelegate = self
class XGLAnimator: NSObject, UIViewControllerAnimatedTransitioning, GLKViewDelegate {
    open var duration: TimeInterval = 2
    open var spriteWidth: CGFloat = 8
    fileprivate var sprites: [Sprite] = []
    fileprivate var glContext: EAGLContext!
    fileprivate var effect: GLKBaseEffect!
    fileprivate var glView: GLKView!
    fileprivate var displayLink: CADisplayLink!
    fileprivate var lastUpdateTime: TimeInterval?
    fileprivate var startTransitionTime: TimeInterval!
    fileprivate var transitionContext: UIViewControllerContextTransitioning!
    fileprivate var render: SpriteRender!
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        containerView.addSubview(toView!)
        containerView.sendSubviewToBack(toView!)
        func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> Float {
            let diff = bigNumber - smallNumber
            return Float((CGFloat(arc4random()) / 100.0).truncatingRemainder(dividingBy: diff) + smallNumber)
        }
        self.glContext = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(glContext)
        glView = GLKView(frame: (fromView?.frame)!, context: glContext)
        glView.enableSetNeedsDisplay = true
        glView.delegate = self
        glView.isOpaque = false
        containerView.addSubview(glView)
        let texture = ViewTexture()
        texture.setupOpenGL()
        texture.render(view: fromView!)
        effect = GLKBaseEffect()
        let projectionMatrix = GLKMatrix4MakeOrtho(0, Float(texture.width), 0, Float(texture.height), -1, 1)
        effect.transform.projectionMatrix = projectionMatrix
        render = SpriteRender(texture: texture, effect: effect)
        let size = CGSize(width: CGFloat(texture.width), height: CGFloat(texture.height))
        let scale = UIScreen.main.scale
        let width = spriteWidth * scale
        let height = width
        for x in stride(from: CGFloat(0), through: size.width, by: width) {
            for y in stride(from: CGFloat(0), through: size.height, by: height) {
                let region = CGRect(x: x, y: y, width: width, height: height)
                var sprite = Sprite()
                sprite.slice(region, textureSize: size)
                sprite.moveVelocity = Vector2(x:CGFloat(randomFloatBetween(-100, and: 100)), y: CGFloat(randomFloatBetween(-CGFloat(texture.height)*1.3/CGFloat(duration), and: -CGFloat(texture.height)/CGFloat(duration))))
                sprites.append(sprite)
            }
        }
        fromView?.removeFromSuperview()
        self.transitionContext = transitionContext
        displayLink = CADisplayLink(target: self, selector: #selector(XGLAnimator.displayLinkTick(_:)))
        displayLink.isPaused = false
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        self.startTransitionTime = Date.timeIntervalSinceReferenceDate
    }
    open func animationEnded(_ transitionCompleted: Bool) {
        displayLink.invalidate()
        displayLink = nil
    }
    @objc func displayLinkTick(_ displayLink: CADisplayLink) {
        if let lastUpdateTime = lastUpdateTime {
            let timeSinceLastUpdate = Date.timeIntervalSinceReferenceDate - lastUpdateTime
            self.lastUpdateTime = Date.timeIntervalSinceReferenceDate
            for index in 0..<sprites.count {
                sprites[index].update(timeSinceLastUpdate)
            }
        } else {
            lastUpdateTime = Date.timeIntervalSinceReferenceDate
        }
        glView.setNeedsDisplay()
        if Date.timeIntervalSinceReferenceDate - startTransitionTime > duration {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    public func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0, 0, 0, 0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glEnable(GLenum(GL_BLEND))
        render.render(self.sprites)
    }
}
//vc.transitioningDelegate = self
class XUIDynamicAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    open var duration: TimeInterval = 2
    open var spriteWidth: CGFloat = 20
    var transitionContext: UIViewControllerContextTransitioning!
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    var animator: UIDynamicAnimator!
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        containerView.addSubview(toView!)
        containerView.sendSubviewToBack(toView!)
        let size = fromView!.frame.size
        func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
            let diff = bigNumber - smallNumber
            return (CGFloat(arc4random()) / 100.0).truncatingRemainder(dividingBy: diff) + smallNumber
        }
        let fromViewSnapshot = fromView?.snapshotView(afterScreenUpdates: false)
        let width = spriteWidth
        let height = width
        animator = UIDynamicAnimator(referenceView: containerView)
        var snapshots: [UIView] = []
        for x in stride(from: CGFloat(0), through: size.width, by: width) {
            for y in stride(from: CGFloat(0), through: size.height, by: height) {
                let snapshotRegion = CGRect(x: x, y: y, width: width, height: height)
                let snapshot = fromViewSnapshot!.resizableSnapshotView(from: snapshotRegion, afterScreenUpdates: false, withCapInsets: .zero)!
                containerView.addSubview(snapshot)
                snapshot.frame = snapshotRegion
                snapshots.append(snapshot)
                let push = UIPushBehavior(items: [snapshot], mode: .instantaneous)
                push.pushDirection = CGVector(dx: randomFloatBetween(-0.15 , and: 0.15), dy: randomFloatBetween(-0.15 , and: 0))
                push.active = true
                animator.addBehavior(push)
            }
        }
        let gravity = UIGravityBehavior(items: snapshots)
        animator.addBehavior(gravity)
        print(snapshots.count)
        fromView?.removeFromSuperview()
        Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(XUIDynamicAnimator.completeTransition), userInfo: nil, repeats: false)
        self.transitionContext = transitionContext
    }
    @objc func completeTransition() {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}

//vc.transitioningDelegate = self
class XUIViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    open var duration: TimeInterval = 2
    open var spriteWidth: CGFloat = 10
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        containerView.addSubview(toView!)
        containerView.sendSubviewToBack(toView!)
        var snapshots:[UIView] = []
        let size = fromView?.frame.size
        func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
            let diff = bigNumber - smallNumber
            return (CGFloat(arc4random()) / 100.0).truncatingRemainder(dividingBy: diff) + smallNumber
        }
        // snapshot the from view, this makes subsequent snaphots more performant
        let fromViewSnapshot = fromView?.snapshotView(afterScreenUpdates: false)
        let width = spriteWidth
        let height = width
        for x in stride(from: CGFloat(0), through: (size?.width)!, by: width) {
            for y in stride(from: CGFloat(0), through: (size?.height)!, by: height) {
                let snapshotRegion = CGRect(x: x, y: y, width: width, height: height)
                let snapshot = fromViewSnapshot!.resizableSnapshotView(from: snapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
                containerView.addSubview(snapshot!)
                snapshot!.frame = snapshotRegion
                snapshots.append(snapshot!)
            }
        }
        containerView.sendSubviewToBack(fromView!)
        UIView.animate(withDuration:duration,delay: 0,options: UIView.AnimationOptions.curveLinear,animations: {
                for view in snapshots {
                    let xOffset = randomFloatBetween(-200 , and: 200)
                    let yOffset = randomFloatBetween(fromView!.frame.height, and: fromView!.frame.height * 1.3)
                    view.frame = view.frame.offsetBy(dx: xOffset, dy: yOffset)
                }
            },completion: { _ in
                for view in snapshots {
                    view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}

//vc.transitioningDelegate = self
class XScaleAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    /// 图片原位置
    var originFrame = CGRect.zero
    /// 展示或消失
    var presenting = false
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        var fromView: UIView?
        var toView: UIView?
        if transitionContext.responds(to: #selector(UIViewControllerContextTransitioning.view(forKey:))) {
            // iOS8以上用此方法准确获取
            fromView = transitionContext.view(forKey: .from)
            toView = transitionContext.view(forKey: .to)
        } else {
            fromView = transitionContext.viewController(forKey: .from)?.view
            toView = transitionContext.viewController(forKey: .to)?.view
        }
        let pictureView = presenting ? toView : fromView
        let scaleX: CGFloat = originFrame.width / (pictureView?.frame.width ?? 1)
        let scaleY: CGFloat = originFrame.height / (pictureView?.frame.height ?? 1)
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let orginCenter = CGPoint(x: originFrame.midX, y: originFrame.midY)
        let pictureCenter = CGPoint(x: pictureView?.frame.size.width ?? 1 / 2, y: pictureView?.frame.size.height ?? 1 / 2)
        var startTransform: CGAffineTransform
        var endTransform: CGAffineTransform
        var startCenter: CGPoint
        var endCenter: CGPoint
        if presenting {
            startTransform = transform
            startCenter = orginCenter
            endTransform = .identity
            endCenter = pictureCenter
        } else {
            startTransform = .identity
            startCenter = pictureCenter
            endTransform = transform
            endCenter = orginCenter
        }
        let container: UIView = transitionContext.containerView
        container.addSubview(toView!)
        container.bringSubviewToFront(pictureView!)
        pictureView?.transform = startTransform
        pictureView?.center = startCenter
        UIView.animate(withDuration: 0.5, animations: {
            pictureView?.transform = endTransform
            pictureView?.center = endCenter
        }) { finished in
            let wasCancelled: Bool = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}

//vc.transitioningDelegate = self
class XAlertAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    public var isPresent:Bool = true
    required public init(isPresent:Bool){
        self.isPresent = isPresent
        super.init()
    }
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            presentAnimateTransition(using: transitionContext)
        }else {
            dismissAnimateTransition(using: transitionContext)
        }
    }
    open func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from) else { return }
        UIView.animate(withDuration: 0.25, delay: 0.0, options:.curveEaseInOut, animations: {
            from.view.layer.opacity = 0.0
            from.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    public func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        to.view.frame = to.presentationController!.frameOfPresentedViewInContainerView
        containerView.addSubview(to.view)
        to.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.25, delay: 0.0, options:.curveEaseInOut, animations: {
            to.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options:.curveEaseInOut, animations: {
                to.view.transform = CGAffineTransform.identity
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
//vc.transitioningDelegate = self
class XAlertDropDownAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    public var isPresent:Bool = true
    required public init(isPresent:Bool){
        self.isPresent = isPresent
        super.init()
    }
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            presentAnimateTransition(using: transitionContext)
        }else {
            dismissAnimateTransition(using: transitionContext)
        }
    }
    open func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from) else { return }
        UIView.animate(withDuration: 0.25, delay: 0.0, options:.curveEaseInOut, animations: {
            from.view.layer.opacity = 0.0
            from.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    public func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        to.view.frame = to.presentationController!.frameOfPresentedViewInContainerView
        containerView.addSubview(to.view)
        to.view.transform = CGAffineTransform(translationX: 0.0, y: -to.view.frame.maxY)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            to.view.transform = CGAffineTransform.identity
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
//vc.transitioningDelegate = self
class XActionSheetAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    public var isPresent:Bool = true
    required public init(isPresent:Bool){
        super.init()
    }
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            presentAnimateTransition(using: transitionContext)
        }else {
            dismissAnimateTransition(using: transitionContext)
        }
    }
    open func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from) else { return }
        UIView.animate(withDuration: 0.25, delay: 0.0, options:.curveEaseInOut, animations: {
            from.view.layer.opacity = 0.0
            from.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    public func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard var from = transitionContext.viewController(forKey: .from),
            var to = transitionContext.viewController(forKey: .to)
            else { return }
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        var start = CGAffineTransform(translationX: 0.0, y: to.view.frame.height)
        var end = CGAffineTransform.identity
        if isPresent == false {
            swap(&from, &to)
            swap(&start, &end)
        }else{
            /// 只有在 present 时候 需要将 to.view 添加到 containerView
            to.view.frame = to.presentationController!.frameOfPresentedViewInContainerView
            containerView.addSubview(to.view)
        }
        to.view.transform = start
        UIView.animate(withDuration: duration, delay: 0.0, options:UIView.AnimationOptions(rawValue: 7 << 16 | UIView.AnimationOptions.allowAnimatedContent.rawValue), animations: {
            to.view.transform = end
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}



//FIXME: Navigation 转场,需要遵守下面代理并设置self.navigationController?.delegate = self
@objc protocol Animatable {
    var containerView: UIView? { get }
    var childView: UIView? { get }
    @available(iOS 10.0, *)
    @objc optional func presentingView(
        sizeAnimator: UIViewPropertyAnimator,
        positionAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    )
    @available(iOS 10.0, *)
    @objc optional func dismissingView(
        sizeAnimator: UIViewPropertyAnimator,
        positionAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    )
}

class XScaleNavAnimation: NSObject {
    fileprivate let operationType: UINavigationController.Operation
    fileprivate let positioningDuration: TimeInterval = 1
    fileprivate let resizingDuration: TimeInterval = 0.5
    init(operation: UINavigationController.Operation) {
        self.operationType = operation
    }
    internal func presentTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? Animatable, let fromContainer = fromVC.containerView,
            let fromChild = fromVC.childView else { return }
        guard
            let toVC = transitionContext.viewController(forKey: .to) as? Animatable,
            let toView = transitionContext.view(forKey: .to) else { return }
        let originalFrame = toView.frame
        container.addSubview(toView)
        let originFrame = CGRect(origin: fromContainer.convert(fromChild.frame.origin, to: container),size: fromChild.frame.size)
        let destinationFrame = toView.frame
        toView.frame = originFrame
        toView.layoutIfNeeded()
        fromChild.isHidden = true
        let yDiff = destinationFrame.origin.y - originFrame.origin.y
        let xDiff = destinationFrame.origin.x - originFrame.origin.x
        if #available(iOS 10.0, *) {
            let positionAnimator = UIViewPropertyAnimator(duration: self.positioningDuration, dampingRatio: 0.7)
            positionAnimator.addAnimations {
                toView.transform = CGAffineTransform(translationX: 0, y: yDiff)
            }
            let sizeAnimator = UIViewPropertyAnimator(duration: self.resizingDuration, curve: .easeInOut)
            sizeAnimator.addAnimations {
                toView.frame.size = destinationFrame.size
                toView.layoutIfNeeded()
                toView.transform = toView.transform.concatenating(CGAffineTransform(translationX: xDiff, y: 0))
            }
            toVC.presentingView?(
                sizeAnimator: sizeAnimator,
                positionAnimator: positionAnimator,
                fromFrame: originFrame,
                toFrame: destinationFrame
            )
            let completionHandler: (UIViewAnimatingPosition) -> Void = { _ in
                toView.transform = .identity
                toView.frame = originalFrame
                toView.layoutIfNeeded()
                fromChild.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            if (self.positioningDuration > self.resizingDuration) {
                positionAnimator.addCompletion(completionHandler)
            } else {
                sizeAnimator.addCompletion(completionHandler)
            }
            positionAnimator.startAnimation()
            sizeAnimator.startAnimation()
        } else {
        }
    }
    internal func dismissTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? Animatable,
            let fromView = transitionContext.view(forKey: .from)
            else { return }
        guard
            let toVC = transitionContext.viewController(forKey: .to) as? Animatable,
            let toView = transitionContext.view(forKey: .to),
            let toContainer = toVC.containerView,
            let toChild = toVC.childView
            else { return }
        container.addSubview(toView)
        container.addSubview(fromView)
        let originFrame = fromView.frame
        let destinationFrame = CGRect(
            origin: toContainer.convert(toChild.frame.origin, to: container),
            size: toChild.frame.size
        )
        toChild.isHidden = true
        let yDiff = destinationFrame.origin.y - originFrame.origin.y
        let xDiff = destinationFrame.origin.x - originFrame.origin.x
        if #available(iOS 10.0, *) {
            let positionAnimator = UIViewPropertyAnimator(duration: self.positioningDuration, dampingRatio: 0.7)
            positionAnimator.addAnimations {
                fromView.transform = CGAffineTransform(translationX: 0, y: yDiff)
            }
            let sizeAnimator = UIViewPropertyAnimator(duration: self.resizingDuration, curve: .easeInOut)
            sizeAnimator.addAnimations {
                fromView.frame.size = destinationFrame.size
                fromView.layoutIfNeeded()
                fromView.transform = fromView.transform.concatenating(CGAffineTransform(translationX: xDiff, y: 0))
            }
            fromVC.dismissingView?(
                sizeAnimator: sizeAnimator,
                positionAnimator: positionAnimator,
                fromFrame: originFrame,
                toFrame: destinationFrame
            )
            let completionHandler: (UIViewAnimatingPosition) -> Void = { _ in
                fromView.removeFromSuperview()
                toChild.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            if (self.positioningDuration > self.resizingDuration) {
                positionAnimator.addCompletion(completionHandler)
            } else {
                sizeAnimator.addCompletion(completionHandler)
            }
            positionAnimator.startAnimation()
            sizeAnimator.startAnimation()
        } else {

        }
    }
}
extension XScaleNavAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return max(self.resizingDuration, self.positioningDuration)
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.operationType == .push {
            self.presentTransition(transitionContext)
        } else if self.operationType == .pop {
            self.dismissTransition(transitionContext)
        }
    }
}
