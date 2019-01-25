//
//  Circular3DStarView.swift
import UIKit
struct StarMatrix {
    var row: Int = 0
    var column: Int = 0
    var matrix: [[CGFloat]] = []
    mutating func mutiply(_ a: StarMatrix) {
        var resultMatrix: [[CGFloat]] = []
        for _ in 0..<column {
            var temp: [CGFloat] = []
            for _ in 0..<a.row {
                temp.append(0)
            }
            resultMatrix.append(temp)
        }
        for i in 0..<column {
            for j in 0..<a.row {
                for k in 0..<row {
                    resultMatrix[i][j] += matrix[i][k] * a.matrix[k][j]
                }
            }
        }
        row = a.row
        matrix = resultMatrix
    }
}
struct StarPoint {
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var z: CGFloat = 0.0
    mutating func rotation(direction d: StarPoint, angle: CGFloat) {
        if angle == 0 { return }
        let temp = [[x, y, z, 1]]
        var result = StarMatrix(row: 4, column: 1, matrix: temp)
        if d.z * d.z + d.y * d.y != 0 {
            let c = d.z / sqrt(d.z * d.z + d.y * d.y)
            let s = d.y / sqrt(d.z * d.z + d.y * d.y)
            let t = [[1, 0, 0, 0],[0, c, s, 0],[0,-s, c, 0],[0, 0, 0, 1]]
            result.mutiply(StarMatrix(row: 4, column: 4, matrix: t))
        }
        if d.x * d.x + d.y * d.y + d.z * d.z != 0 {
            let c = sqrt(d.y * d.y + d.z * d.z) / sqrt(d.x * d.x + d.y * d.y + d.z * d.z)
            let s = -d.x / sqrt(d.x * d.x + d.y * d.y + d.z * d.z)
            let t = [[c, 0,-s, 0],[0, 1, 0, 0],[s, 0, c, 0],[0, 0, 0, 1]]
            result.mutiply(StarMatrix(row: 4, column: 4, matrix: t))
        }
        let c = cos(angle), s = sin(angle)
        let t = [[c, s, 0, 0],[-s,c, 0, 0],[0, 0, 1, 0],[0, 0, 0, 1]]
        result.mutiply(StarMatrix(row: 4, column: 4, matrix: t))
        if d.x * d.x + d.y * d.y + d.z * d.z != 0 {
            let c = sqrt(d.y * d.y + d.z * d.z) / sqrt(d.x * d.x + d.y * d.y + d.z * d.z)
            let s = -d.x / sqrt(d.x * d.x + d.y * d.y + d.z * d.z)
            let t = [[c, 0, s, 0],[0, 1, 0, 0],[-s, 0, c, 0],[0, 0, 0, 1]]
            result.mutiply(StarMatrix(row: 4, column: 4, matrix: t))
        }
        if d.z * d.z + d.y * d.y != 0 {
            let c = d.z / sqrt(d.z * d.z + d.y * d.y)
            let s = d.y / sqrt(d.z * d.z + d.y * d.y)
            let t = [[1, 0, 0, 0],[0, c, -s, 0],[0, s, c, 0],[0, 0, 0, 1]]
            result.mutiply(StarMatrix(row: 4, column: 4, matrix: t))
        }
        x = result.matrix[0][0]
        y = result.matrix[0][1]
        z = result.matrix[0][2]
    }
}

class Circular3DStarView: UIView, UIGestureRecognizerDelegate {
    private var coordinate: [StarPoint] = []
    private var normalDirection = StarPoint()
    private var last = CGPoint.zero
    private var velocity: CGFloat = 0.0
    private var timer: CADisplayLink?
    private var inertia: CADisplayLink?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        addGestureRecognizer(gesture)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func timerStart() {
        timer = CADisplayLink(target: self, selector: #selector(self.autoTurnRotation))
        timer?.add(to: RunLoop.main, forMode: .default)
    }
    func timerStop() {
        timer?.invalidate()
        timer = nil
    }
    var stars: [UIView] = [] {
        didSet {
            subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            stars.forEach { (view) in
                view.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
                addSubview(view)
            }
            let p1 = CGFloat.pi * (3 - sqrt(5))
            let p2 = 2.0 / CGFloat(stars.count)
            for i in 0..<stars.count {
                let y = CGFloat(i) * p2 - 1 + (p2 / 2)
                let r = sqrt(1 - y * y)
                let p3 = CGFloat(i) * p1
                let point = StarPoint(x: cos(p3) * r, y: y, z: sin(p3) * r)
                coordinate.append(point)
                let time = TimeInterval((Double(arc4random() % 10) + 10.0) / 20.0)
                UIView.animate(withDuration: time, delay: 0.0, options: .curveEaseOut, animations: {
                    self.setTagOf(point, andIndex: i)
                }) { finished in
                }
            }
            let a = CGFloat(Int(arc4random()) % 10 - 5)
            let b = CGFloat(Int(arc4random()) % 10 - 5)
            normalDirection = StarPoint(x: a, y: b, z: 0)
            timerStart()
        }
    }
    //FIXME: 以下是私有函数
    private func updateFrameOfPoint(_ index: Int, direction: StarPoint, andAngle angle: CGFloat) {
        var point = coordinate[index]
        point.rotation(direction: direction, angle: angle)
        coordinate[index] = point
        setTagOf(point, andIndex: index)
    }
    private func setTagOf(_ point: StarPoint, andIndex index: Int) {
        let view = stars[index]
        view.center = CGPoint(x: (point.x + 1) * (frame.size.width / 2.0), y: (point.y + 1) * frame.size.width / 2.0)
        let transform: CGFloat = (point.z + 2) / 3
        view.transform = CGAffineTransform.identity.scaledBy(x: transform, y: transform)
        view.layer.zPosition = transform
        view.alpha = transform
        if point.z < 0 {
            view.isUserInteractionEnabled = false
        } else {
            view.isUserInteractionEnabled = true
        }
    }
    @objc private func autoTurnRotation() {
        for i in 0..<stars.count {
            updateFrameOfPoint(i, direction: normalDirection, andAngle: 0.002)
        }
    }
    @objc private func inertiaStep() {
        if velocity <= 0 {
            inertia?.invalidate()
            inertia = nil
            timerStart()
        } else {
            velocity -= 70.0
            let angle: CGFloat = velocity / frame.size.width * 2.0 * CGFloat(inertia?.duration ?? 0)
            for i in 0..<stars.count {
                updateFrameOfPoint(i, direction: normalDirection, andAngle: angle)
            }
        }
    }
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            last = gesture.location(in: self)
            timerStop()
            inertia?.invalidate()
            inertia = nil
            timerStart()
        } else if gesture.state == .changed {
            let current = gesture.location(in: self)
            let direction = StarPoint(x: last.y - current.y, y: current.x - last.x, z: 0)
            let distance = sqrt(direction.x * direction.x + direction.y * direction.y)
            let angle: CGFloat = distance / (frame.size.width / 2.0)
            for i in 0..<stars.count {
                updateFrameOfPoint(i, direction: direction, andAngle: angle)
            }
            normalDirection = direction
            last = current
        } else if gesture.state == .ended {
            let velocityP = gesture.velocity(in: self)
            velocity = sqrt(velocityP.x * velocityP.x + velocityP.y * velocityP.y)
            timerStop()
            inertia = CADisplayLink(target: self, selector: #selector(self.inertiaStep))
            inertia?.add(to: RunLoop.main, forMode: .default)
        }
    }
}
