//
//  XCardsView.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/5.
//  Copyright © 2018 薛超. All rights reserved.
//

import UIKit
import SDWebImage
class CardModel: NSObject {
    var userName = ""
    var artPhoto = ""
}
protocol JLDragCardDelegate: NSObjectProtocol {
    func swipCard(_ cardView: JLDragCardView, direction isRight: Bool)
    func moveCards(_ distance: CGFloat)
    func moveBackCards()
    func adjustOtherCards()
}
class JLDragCardView: UIView {
    weak var delegate: JLDragCardDelegate?
    var originalTransform: CGAffineTransform!
    var pointFromCenter = CGPoint.zero
    var originalCenter = CGPoint.zero
    var headerImageView: UIImageView!
    var model: CardModel? {
        didSet {
            model?.artPhoto = "group1/M00/01/5D/CjNYDVi1dkyEcWFGAAAAAM3Rr8Q661.jpg"
            if let aPhoto = model?.artPhoto {
                headerImageView.sd_setImage(with: URL(string: "http://images.mfchao.com/\(aPhoto)"))
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        layer.cornerRadius = 4
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged(_:)))
        addGestureRecognizer(panGesture)
        headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: mj_h - 175))
        headerImageView.backgroundColor = UIColor.lightGray
        headerImageView.isUserInteractionEnabled = true
        addSubview(headerImageView)
        layer.allowsEdgeAntialiasing = true
        headerImageView.layer.allowsEdgeAntialiasing = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func beingDragged(_ gesture: UIPanGestureRecognizer) {
        pointFromCenter = gesture.translation(in: self)
        switch gesture.state {
        case .began:
            break
        case .changed:
            let rotationStrength = min(pointFromCenter.x / 414, 1)
            let rotationAngel: CGFloat = .pi / 8 * rotationStrength
            let scale = max(1 - abs(Float(rotationStrength)) / 4, 0.93)
            center = CGPoint(x: originalCenter.x + pointFromCenter.x, y: originalCenter.y + pointFromCenter.y)
            let transform = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transform.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
            self.transform = scaleTransform
            delegate?.moveCards(pointFromCenter.x)
        case .ended:
            followUpAction(withDistance: pointFromCenter.x, andVelocity: gesture.velocity(in: superview))
        default:
            break
        }
    }
    func followUpAction(withDistance distance: CGFloat, andVelocity velocity: CGPoint) {
        if pointFromCenter.x > 0 && (distance > 150 || velocity.x > 400) {
            rightAction(velocity)
        } else if pointFromCenter.x < 0 && (distance < -150 || velocity.x < -400) {
            leftAction(velocity)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.center = self.originalCenter
                self.transform = CGAffineTransform(rotationAngle: 0)
            })
            delegate?.moveBackCards()
        }
    }
    func rightAction(_ velocity: CGPoint) {
        let distanceX: CGFloat = UIScreen.main.bounds.size.width + 333 + originalCenter.x //横向移动距离
        let distanceY: CGFloat = distanceX * pointFromCenter.y / pointFromCenter.x //纵向移动距离
        let finishPoint = CGPoint(x: originalCenter.x + distanceX, y: originalCenter.y + distanceY) //目标center点
        let vel = sqrtf(Float(pow(velocity.x, 2) + pow(velocity.y, 2))) //滑动手势横纵合速度
        let displace = sqrt(pow(distanceX - pointFromCenter.x, 2) + pow(distanceY - pointFromCenter.y, 2)) //需要动画完成的剩下距离
        let duration = max(0.3, min(0.6, abs(Float(displace) / vel))) //动画时间
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: .pi / 8)
        }) { complete in
            self.delegate?.swipCard(self, direction: true)
        }
        delegate?.adjustOtherCards()
    }
    func leftAction(_ velocity: CGPoint) {
        let distanceX: CGFloat = -333 // - self.originalPoint.x;
        let distanceY: CGFloat = distanceX * pointFromCenter.y / pointFromCenter.x
        let finishPoint = CGPoint(x: originalCenter.x + distanceX, y: originalCenter.y + distanceY) //目标center点
        let vel = sqrtf(Float(pow(velocity.x, 2) + pow(velocity.y, 2)))
        let displace = sqrtf(Float(pow(distanceX - pointFromCenter.x, 2) + pow(distanceY - pointFromCenter.y, 2)))
        let duration = max(0.3, min(0.6, abs(Float(displace / vel)))) //动画时间
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: -.pi / 8)
        }) { finished in
            self.delegate?.swipCard(self, direction: false)
        }
        delegate?.adjustOtherCards()
    }
}
class XCardsView: UIView, JLDragCardDelegate {
    var lastCardCenter = CGPoint.zero
    var lastCardTransform: CGAffineTransform!
    var allCards: [JLDragCardView] = []
    var page: Int = 0

    var sourceObject: [CardModel] = [] {
        didSet {
            allCards = [JLDragCardView]()
            addCards()
            if self.sourceObject.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.6) / Double(NSEC_PER_SEC), execute: {
                    self.loadAllCards()
                })
            }
        }
    }

    func refreshAllCards() {
        sourceObject = []
        page = 0
        for i in 0..<allCards.count {
            let card: JLDragCardView = allCards[i]
            let finishPoint = CGPoint(x: -333, y: 2 * 120 + card.frame.origin.y)
            UIView.animateKeyframes(withDuration: 0.5, delay: 0.06 * Double(i), options: .calculationModeLinear, animations: {
                card.center = finishPoint
                card.transform = CGAffineTransform(rotationAngle: -.pi / 8)
            }) { finished in
                card.transform = CGAffineTransform(rotationAngle: .pi / 8)
                card.isHidden = true
                card.center = CGPoint(x: UIScreen.main.bounds.size.width + 333, y: self.center.y)
                if i == self.allCards.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(2) / Double(NSEC_PER_SEC), execute: {
                        self.loadAllCards()
                    })
                }
            }
        }
    }
    func loadAllCards() {
        for i in 0..<allCards.count {
            let draggableView = allCards[i]
            let model = sourceObject.first
            draggableView.model = model
            sourceObject.remove(at: 0)
            if let aModel = model {
                sourceObject.append(aModel)
            }
            let finishPoint = CGPoint(x: center.x, y: (APPH - 64 - 49 - 80) / 2 + 20)
            UIView.animateKeyframes(withDuration: 0.5, delay: 0.06 * Double(i), options: .calculationModeLinear, animations: {
                draggableView.center = finishPoint
                draggableView.transform = CGAffineTransform(rotationAngle: 0)
                if i > 0 && i < 4 - 1 {
                    let preDraggableView = self.allCards[i - 1]

                    let scale: CGFloat = pow(0.95, CGFloat(i))

                    draggableView.transform = draggableView.transform.scaledBy(x: scale, y: scale)
                    var frame: CGRect = draggableView.frame
                    frame.origin.y = preDraggableView.frame.origin.y + (preDraggableView.frame.size.height - frame.size.height) + 10 * pow(0.7, CGFloat(i))
                    draggableView.frame = frame
                } else if i == 4 - 1 {
                    let preDraggableView = self.allCards[i - 1]
                    draggableView.transform = preDraggableView.transform
                    draggableView.frame = preDraggableView.frame
                }
            }) { finished in
            }
            draggableView.originalCenter = draggableView.center
            draggableView.originalTransform = draggableView.transform
            if i == 4 - 1 {
                lastCardCenter = draggableView.center
                lastCardTransform = draggableView.transform
            }
        }
    }
    func addCards() {
        for i in 0..<4 {
            let draggableView = JLDragCardView(frame: CGRect(x: UIScreen.main.bounds.size.width + APPW - 40, y: center.y - (APPH - 64 - 49 - 80) / 2, width: APPW - 40, height: APPH - 64 - 49 - 80))
            if i > 0 && i < 4 - 1 {
                let scale: CGFloat = pow(0.95, CGFloat(i))
                draggableView.transform = draggableView.transform.scaledBy(x: scale, y: scale)
            } else if i == 4 - 1 {
                let scale: CGFloat = pow(0.95, CGFloat(i - 1))
                draggableView.transform = draggableView.transform.scaledBy(x: scale, y: scale)
            }
            draggableView.transform = CGAffineTransform(rotationAngle: .pi / 8)
            draggableView.delegate = self
            allCards.append(draggableView)
        }
        var i = Int(4) - 1
        while i >= 0 {
            addSubview(allCards[i])
            i -= 1
        }
    }
    ///FIXME:代理
    //滑动中更改其他卡片位置
    func moveCards(_ distance: CGFloat) {
        if abs(Float(distance)) <= 120 {
            for i in 1..<4 - 1 {
                let draggableView = allCards[i]
                let preDraggableView = allCards[i - 1]
                let temp = abs(distance / 120.0)
                let scale: CGFloat = 1.0 + (1.0 / 0.95 - 1.0) * temp * 0.6
                draggableView.transform = draggableView.originalTransform.scaledBy(x: scale, y: scale)
                var center: CGPoint = draggableView.center
                center.y = CGFloat(draggableView.originalCenter.y - (draggableView.originalCenter.y - preDraggableView.originalCenter.y) * abs(distance / 120.0) * 0.6)
                draggableView.center = center
            }
        }
    }
    //滑动后调整其他卡片位置
    func adjustOtherCards() {
        UIView.animate(withDuration: 0.2, animations: {
            for i in 1..<4 - 1 {
                let draggableView = self.allCards[i]
                let preDraggableView = self.allCards[i - 1]
                draggableView.transform = preDraggableView.originalTransform
                draggableView.center = preDraggableView.originalCenter
            }
        }) { complete in
        }
    }
    //滑动后续操作
    func swipCard(_ cardView: JLDragCardView, direction isRight: Bool) {
        allCards.removeAll(where: { element in element == cardView })
        cardView.transform = lastCardTransform
        cardView.center = lastCardCenter
        if let anObject = allCards.last {
            insertSubview(cardView, belowSubview: anObject)
        }
        allCards.append(cardView)
        if sourceObject.first != nil {
            cardView.model = sourceObject.first
            let model = sourceObject.first
            sourceObject.remove(at: 0)
            if let aModel = model {
                sourceObject.append(aModel)
            }
            cardView.layoutSubviews()
            if sourceObject.count < 10 {
                refreshAllCards()
            }
        } else {
            refreshAllCards()
        }
        for i in 0..<4 {
            let draggableView = allCards[i]
            draggableView.originalCenter = draggableView.center
            draggableView.originalTransform = draggableView.transform
        }
    }
    //滑动终止后复原其他卡片
    func moveBackCards() {
        for i in 1..<4 - 1 {
            let draggableView = allCards[i]
            UIView.animate(withDuration: 0.3, animations: {
                draggableView.transform = draggableView.originalTransform
                draggableView.center = draggableView.originalCenter
            })
        }
    }
}
