//
//  XRefreshHeader.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/5.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
import MJRefresh

class MJDIYHeader: MJRefreshHeader {
    private var offsetX: CGFloat = 0.0
    private var link: CADisplayLink?
    private var backView: UIScrollView!
    private var icon: UIImageView!
    private var birdShadow: UIImageView!
    private var PicW: CGFloat = 932
    override func prepare() {
        super.prepare()
        // 设置控件的高度
        mj_h = 120
        backView = UIScrollView(frame: CGRect(x: 0, y: 0, width: APPW, height: 83))
        let a = UIImageView(frame: CGRect(x: 0, y: 0, width: CGFloat(PicW), height: 83))
        let b = UIImageView(frame: CGRect(x: CGFloat(PicW), y: 0, width: CGFloat(PicW), height: 83))
        a.image = UIImage(named: "bk")
        b.image = UIImage(named: "bk")
        backView?.addSubview(a)
        backView?.addSubview(b)
        offsetX = PicW - APPW
        backView?.contentSize = CGSize(width: Int(PicW) * 2, height: 83)
        backView?.contentOffset = CGPoint(x: offsetX, y: 0)
        addSubview(backView!)
        icon = UIImageView(frame: CGRect(x: APPW / 2 - 15, y: 10, width: 30, height: 27.5))
        icon.image = UIImage(named: "bird_03")
        addSubview(icon)
        birdShadow = UIImageView(frame: CGRect(x: APPW / 2 - 12, y: 100, width: 24, height: 7.5))
        birdShadow.image = UIImage(named: "touying")
        addSubview(birdShadow)
    }
    override func placeSubviews() {
        super.placeSubviews()
        backView.frame = CGRect(x: 0, y: 0, width: APPW, height: 83)
        //    self.icon.frame = CGRectMake(APPW/2-15, 30, 30, 27.5);
        //    self.icon.center = self.center;
        birdShadow.frame = CGRect(x: APPW / 2 - 12, y: 100, width: 24, height: 7.5)
    }

    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
    }

    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewContentSizeDidChange(change)
    }

    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewPanStateDidChange(change)
    }
    func showAnimation() {
        let fly = CABasicAnimation(keyPath: "transform.translation.y")
        fly.timingFunction = CAMediaTimingFunction(name: .linear)
        fly.fromValue = nil
        fly.toValue = 20
        fly.duration = 1
        fly.repeatCount = 100
        fly.autoreverses = true
        fly.speed = 1.0
        fly.beginTime = 0.0
        icon.layer.add(fly, forKey: "fly")
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0 //这是透明度。
        animation.autoreverses = true
        animation.duration = 1
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        birdShadow?.layer.add(animation, forKey: "shadow")
        link = CADisplayLink(target: self, selector: #selector(self.backAnimationaa))
        link?.isPaused = false
        link?.add(to: RunLoop.current, forMode: .common)
    }

    @objc func backAnimationaa() {
        backView.contentOffset = CGPoint(x: offsetX, y: 0)
        offsetX -= 2
        if offsetX <= 0 {
            backView.contentOffset = CGPoint(x: CGFloat(PicW), y: 0)
            offsetX = PicW
        }
    }

    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                icon.layer.removeAllAnimations()
                birdShadow.layer.removeAllAnimations()
                link?.invalidate()
                link = nil
            case .pulling:
                break
            case .refreshing:
                showAnimation()
            default:
                icon.layer.removeAllAnimations()
                birdShadow.layer.removeAllAnimations()
                link?.invalidate()
                link = nil
            }
        }
    }
    override var pullingPercent: CGFloat {
        didSet {
            icon.y = 30 * pullingPercent
        }
    }

}

class MyRefresh: UIControl {

    private let DefaultHeight: CGFloat = 100.0
    private var sunImageView: UIImageView!
    private var scrollView: UIScrollView!
    private var forbidSunSet = false


    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: APPW, height: CGFloat(DefaultHeight)))
        let refreshHead = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: CGFloat(DefaultHeight)))
        sunImageView = UIImageView(frame: CGRect(x: 100, y: 20, width: 100, height: 100))
        sunImageView.image = UIImage(named: "compasspointer")
        refreshHead.addSubview(sunImageView)
        clipsToBounds = true
        refreshHead.backgroundColor = UIColor.red
        addSubview(refreshHead)
        layer.addSublayer(refreshHead.layer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.frame = CGRect(x: 0.0, y: 0.0, width: APPW, height: scrollView.contentOffset.y)
        if scrollView.contentOffset.y <= CGFloat(-DefaultHeight) {
            if scrollView.contentOffset.y < -120 {
                scrollView.contentOffset = CGPoint(x: 0.0, y: -120)
            }
            let buildigsScaleRatio: CGFloat = (DefaultHeight / 100.0) * -scrollView.contentOffset.y / 100.0
            if buildigsScaleRatio <= 1.7 {
                let skyScale: CGFloat = 0.85 + (1 - buildigsScaleRatio)
                UIView.animate(withDuration: 0.5, animations: {
                    self.sunImageView.transform = CGAffineTransform(scaleX: skyScale, y: skyScale)
                })
            }
            if !forbidSunSet {
                forbidSunSet = true
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.toValue = .pi * 2.0
                rotationAnimation.duration = 0.9
                rotationAnimation.autoreverses = false
                rotationAnimation.repeatCount = 100
                rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
                sunImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
                sendActions(for: .valueChanged)
            }
        }
        if !scrollView.isDragging && forbidSunSet && scrollView.isDecelerating {
            beginRefreshing()
        }
        if !forbidSunSet {
            let rotationAngle: CGFloat = (360.0 / 100.0) * (DefaultHeight / 100.0) * -scrollView.contentOffset.y
            sunImageView.transform = CGAffineTransform(rotationAngle: (.pi * (rotationAngle) / 180.0))
        }
    }
    func attach(to scrollView: UIScrollView?) {
        if let aView = scrollView {
            self.scrollView = aView
        }
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        self.frame = CGRect(x: 0.0, y: 0.0, width: APPW, height: 0.0)
        scrollView?.addSubview(self)
    }

    func beginRefreshing() {
        scrollView.contentInset = UIEdgeInsets(top: DefaultHeight, left: 0, bottom: 0, right: 0)
        scrollView.setContentOffset(CGPoint(x: 0.0, y: CGFloat(-DefaultHeight)), animated: true)
    }

    func endRefreshing() {
        if scrollView.contentOffset.y > CGFloat(-DefaultHeight) {
            perform(#selector(self.returnToDefaultState), with: nil, afterDelay: 1)
        } else {
            returnToDefaultState()
        }
    }
    @objc func returnToDefaultState() {
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: .curveLinear, animations: {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
        forbidSunSet = false
        sunImageView.layer.removeAnimation(forKey: "rotationAnimation")
    }


    
}
