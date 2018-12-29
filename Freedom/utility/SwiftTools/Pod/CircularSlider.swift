//
//  RangeCircularSlider.swift
//  Pods
import UIKit
struct Interval {
    var min: CGFloat = 0.0
    var max: CGFloat = 0.0
    var rounds: Int = 1
}
///🔘按钮
struct CircleRing {
    var ocWidth: CGFloat = 4 //外环宽度
    var ocColor: UIColor = .gray//外环颜色
    var ocHColor:UIColor = .blue//选中时候外环颜色
    var ooWidth: CGFloat = 12 //内环宽度
    var ooColor: UIColor = .red//内环颜色
    var image: UIImage?//图片
}
@IBDesignable
open class CircularSlider: UIControl {
    private let circleMinValue: CGFloat = 0
    private let circleMaxValue: CGFloat = CGFloat(2 * Double.pi)
    private var radius: CGFloat {
        return min(bounds.midX,bounds.midY)-max(lineWidth,(circleRadiu.ooWidth+circleRadiu.ocWidth))
    }
    ///🔘按钮
    var circleRadiu = CircleRing()
    //中心区域未选中内容填充色
    @IBInspectable open var fillColor: UIColor = .gray
    //中心区域选中内容填充色
    @IBInspectable open var fillSelectColor: UIColor = .clear
    //划过线宽
    @IBInspectable open var lineWidth: CGFloat = 5.0
    //划过的轨道宽
    @IBInspectable open var trackWidth: CGFloat = 5.0
    //未划过轨道填充色
    @IBInspectable open var trackColor: UIColor = .white
    //划过轨道填充色
    @IBInspectable open var trackSelectColor: UIColor = .green
    //可以有几圈
    @IBInspectable open var numberOfRounds: Int = 1 {
        didSet {
            assert(numberOfRounds > 0, "Number of rounds has to be positive value!")
            setNeedsDisplay()
        }
    }
    //最小值
    @IBInspectable open var minValue: CGFloat = 0.0 {
        didSet {
            balancePoint()
        }
    }
    //最大值
    @IBInspectable open var maxValue: CGFloat = 1.0 {
        didSet {
            balancePoint()
        }
    }
    //🔘所在值
    open var value: CGFloat = 0.5 {
        didSet {
            balancePoint()
            setNeedsDisplay()
        }
    }

    //FIXME: 以下不再动
    struct Circle {
        var origin = CGPoint.zero
        var radius: CGFloat = 0
    }
    struct Arc {
        var circle = Circle(origin: CGPoint.zero, radius: 0)
        var startAngle: CGFloat = 0.0
        var endAngle: CGFloat = 0.0
    }
    private func balancePoint() {
        if value < minValue {
            value = minValue
        }
        if value > maxValue {
            value = maxValue
        }
    }
    override open var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override open func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        drawCircularSlider(inContext: context)
        let valuesInterval = Interval(min: minValue, max: maxValue, rounds: numberOfRounds)
        let angleInterval = Interval(min: circleMinValue, max: circleMaxValue, rounds: numberOfRounds)
        let endAngle = self.scaleValue(value, fromInterval: valuesInterval, toInterval: angleInterval) - CGFloat(Double.pi / 2)
        drawFilledArc(fromAngle: -CGFloat(Double.pi / 2), toAngle: endAngle, inContext: context)
        circleRadiu.ocColor.setFill()
        (isHighlighted == true) ? circleRadiu.ocHColor.setStroke() : circleRadiu.ooColor.setStroke()
        guard let image = circleRadiu.image else {
            drawThumb(withAngle: endAngle, inContext: context)
            return
        }
        drawThumb(withImage: image, angle: endAngle, inContext: context)
    }
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        sendActions(for: .editingDidBegin)
        return true
    }
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPosition = touch.location(in: self)
        let startPoint = CGPoint(x: bounds.midX, y: 0)
        value = newValue(from: value, touch: touchPosition, start: startPoint)
        sendActions(for: .valueChanged)
        return true
    }
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        sendActions(for: .editingDidEnd)
    }

    private func newValue(from oldValue: CGFloat, touch touchPosition: CGPoint, start startPosition: CGPoint) -> CGFloat {
        let u = CGVector(dx: startPosition.x - bounds.midX, dy: startPosition.y - bounds.midY)
        let v = CGVector(dx: touchPosition.x - bounds.midX, dy: touchPosition.y - bounds.midY)
        let dotProduct = u.dx * v.dx + u.dy * v.dy
        let determinant = v.dx * u.dy - u.dx * v.dy
        var angle = atan2(determinant, dotProduct)
        angle = (angle < 0) ? -angle : CGFloat(Double.pi * 2) - angle
        let interval = Interval(min: minValue, max: maxValue, rounds: numberOfRounds)
        let angleInterval = Interval(min: circleMinValue, max: circleMaxValue, rounds: numberOfRounds)
        let alpha = self.scaleValue(oldValue, fromInterval: interval, toInterval: angleInterval)
        let halfValue = circleMaxValue/2
        let offset = alpha >= halfValue ? circleMaxValue - alpha : -alpha
        var deltaAngle = angle + offset
        if deltaAngle > halfValue {
            deltaAngle -= circleMaxValue
        }
        let deltaValue = self.scaleValue(deltaAngle, fromInterval: angleInterval, toInterval: interval)
        var newValue = oldValue + deltaValue
        let range = maxValue - minValue
        if newValue > maxValue {
            newValue -= range
        } else if newValue < minValue {
            newValue += range
        }
        return newValue
    }
    private func scaleValue(_ value: CGFloat, fromInterval source: Interval, toInterval destination: Interval) -> CGFloat {
        let sourceRange = (source.max - source.min) / CGFloat(source.rounds)
        let destinationRange = (destination.max - destination.min) / CGFloat(destination.rounds)
        let scaledValue = source.min + (value - source.min).truncatingRemainder(dividingBy: sourceRange)
        let newValue =  (((scaledValue - source.min) * destinationRange) / sourceRange) + destination.min
        return  newValue
    }
    // 画外环
    private static func drawArc(withArc arc: Arc, lineWidth: CGFloat = 2, mode: CGPathDrawingMode = .fillStroke, inContext context: CGContext) {
        let circle = arc.circle
        let origin = circle.origin
        UIGraphicsPushContext(context)
        context.beginPath()
        context.setLineWidth(lineWidth)
        context.setLineCap(CGLineCap.round)
        context.addArc(center: origin, radius: circle.radius, startAngle: arc.startAngle, endAngle: arc.endAngle, clockwise: false)
        context.move(to: CGPoint(x: origin.x, y: origin.y))
        context.drawPath(using: mode)
        UIGraphicsPopContext()
    }
    // 画内环
    private static func drawDisk(withArc arc: Arc, inContext context: CGContext) {
        let circle = arc.circle
        let origin = circle.origin
        UIGraphicsPushContext(context)
        context.beginPath()
        context.setLineWidth(0)
        context.addArc(center: origin, radius: circle.radius, startAngle: arc.startAngle, endAngle: arc.endAngle, clockwise: false)
        context.addLine(to: CGPoint(x: origin.x, y: origin.y))
        context.drawPath(using: .fill)
        UIGraphicsPopContext()
    }
    // 画轨道
    private func drawCircularSlider(inContext context: CGContext) {
        fillColor.setFill()
        trackColor.setStroke()
        let circle = Circle(origin: CGPoint(x: bounds.midX, y: bounds.midY), radius: self.radius)
        let sliderArc = Arc(circle: circle, startAngle: circleMinValue, endAngle: circleMaxValue)
        CircularSlider.drawArc(withArc: sliderArc, lineWidth: trackWidth, inContext: context)
    }
    /// 画外环选中轨道
    private func drawFilledArc(fromAngle startAngle: CGFloat, toAngle endAngle: CGFloat, inContext context: CGContext) {
        fillSelectColor.setFill()
        trackSelectColor.setStroke()
        let circle = Circle(origin: CGPoint(x: bounds.midX, y: bounds.midY), radius: self.radius)
        let arc = Arc(circle: circle, startAngle: startAngle, endAngle: endAngle)
        CircularSlider.drawDisk(withArc: arc, inContext: context)
        CircularSlider.drawArc(withArc: arc, lineWidth: lineWidth, mode: .stroke, inContext: context)
    }
    // 画外环未选中轨道
    private func drawShadowArc(fromAngle startAngle: CGFloat, toAngle endAngle: CGFloat, inContext context: CGContext) {
        let origin = CGPoint(x: bounds.midX, y: bounds.midY)
        let circle = Circle(origin: origin, radius: self.radius)
        let arc = Arc(circle: circle, startAngle: startAngle, endAngle: endAngle)
        // stroke Arc
        CircularSlider.drawArc(withArc: arc, lineWidth: lineWidth, mode: .stroke, inContext: context)
    }
    // 画🔘颜色
    @discardableResult
    private func drawThumb(withAngle angle: CGFloat, inContext context: CGContext) -> CGPoint {
        let circle = Circle(origin: CGPoint(x: bounds.midX, y: bounds.midY), radius: self.radius)
        let x = circle.radius * cos(angle) + circle.origin.x // cos(α) = x / radius
        let y = circle.radius * sin(angle) + circle.origin.y // sin(α) = y / radius
        let thumbOrigin = CGPoint(x: x, y: y)
        let thumbCircle = Circle(origin: thumbOrigin, radius: circleRadiu.ooWidth)
        let thumbArc = Arc(circle: thumbCircle, startAngle: circleMinValue, endAngle: circleMaxValue)
        CircularSlider.drawArc(withArc: thumbArc, lineWidth: circleRadiu.ocWidth, inContext: context)
        return thumbOrigin
    }
    // 画🔘图片
    @discardableResult
    private func drawThumb(withImage image: UIImage, angle: CGFloat, inContext context: CGContext) -> CGPoint {
        UIGraphicsPushContext(context)
        context.beginPath()
        let circle = Circle(origin: CGPoint(x: bounds.midX, y: bounds.midY), radius: self.radius)
        let x = circle.radius * cos(angle) + circle.origin.x // cos(α) = x / radius
        let y = circle.radius * sin(angle) + circle.origin.y // sin(α) = y / radius
        let thumbOrigin = CGPoint(x: x, y: y)
        let imageSize = image.size
        let imageFrame = CGRect(x: thumbOrigin.x - (imageSize.width / 2), y: thumbOrigin.y - (imageSize.height / 2), width: imageSize.width, height: imageSize.height)
        image.draw(in: imageFrame)
        UIGraphicsPopContext()
        return thumbOrigin
    }
}
