//
//  XRadiaMenu.swift
//  Freedom
//
//  Created by Super on 6/27/18.
//  Copyright © 2018 薛超. All rights reserved.
//
import UIKit
class PopoutModel:NSObject{
    var view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var Id = ""
    var name = ""
    var model:Any?
    var action:(()->Void)?
    ///不用设置,自动被设置的
    var index:Int = 0
    convenience init(_ view:UIView?,_ name:String = "") {
        self.init()
        if let av = view{
            self.view = av
        }
        self.name = name
    }
}
class XRadiaMenu: UIView {
    var startAngle: Double = -75
    var stagger: TimeInterval = 0.1
    var animationDuration: Double = 0.4
    var distanceFromCenter: Double = 100.0
    var distanceBetweenPopouts: Double = 2 * 180 / 10
    ///如果didExpand就是结束发射了,如果didRetract就是结束收起了,如果两者都是NO,才是被点击了.
    var didSelectBlock: ((_ menu: XRadiaMenu, _ didExpand: Bool, _ didRetract: Bool, _ item: PopoutModel?) -> Void)?
    private var popViewArray = [[PopoutModel]]()
    private var lastTapnumber: Int = 0
    private var menuIsExpanded = false
    private var popoutViews = [PopoutModel]()
    lazy var centerView: UIView = {
        let newValue = UIImageView(frame: self.bounds)
        newValue.image = UIImage(named: "ZUAN")
        newValue.layer.cornerRadius = frame.size.width / 2
        newValue.layer.shadowColor = UIColor.black.cgColor
        newValue.layer.shadowOpacity = 0.6
        newValue.layer.shadowRadius = 2.0
        newValue.layer.shadowOffset = CGSize(width: 0, height: 3)
        newValue.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer()
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        singleTap.addTarget(self, action: #selector(self.didTapCenterView(_:)))
        newValue.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.addTarget(self, action: #selector(self.didTapCenterView(_:)))
        newValue.addGestureRecognizer(doubleTap)
        let thirdTap = UITapGestureRecognizer()
        thirdTap.numberOfTapsRequired = 3
        thirdTap.numberOfTouchesRequired = 1
        thirdTap.addTarget(self, action: #selector(self.didTapCenterView(_:)))
        newValue.addGestureRecognizer(thirdTap)
        singleTap.require(toFail: doubleTap)
        doubleTap.require(toFail: thirdTap)
        let panner = UIPanGestureRecognizer()
        panner.addTarget(self, action: #selector(self.didPanCenterView(_:)))
        newValue.addGestureRecognizer(panner)
        let longP = UILongPressGestureRecognizer(target: self, action: #selector(self.didLongpressCenterView))
        longP.minimumPressDuration = 0.5
        newValue.addGestureRecognizer(longP)
        return newValue
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(centerView)
        print(String(format: "半径: %.02f\n起始角度: %.02f\n间距: %.02f\n动画时间间距: %.02f\n动画总时间: %.02f", distanceFromCenter, startAngle, distanceBetweenPopouts, stagger, animationDuration))
    }
    //FIXME:公开方法
    func getCurrentViewController() -> UIViewController? {
        var next: UIResponder? = self.next
        repeat {
            if (next is UIViewController) {
                return next as? UIViewController
            }
            next = next?.next
        } while next != nil
        return nil
    }
    //发射按钮
    func expand() {
        var j:Int = 0
        for pmode in popoutViews {
            UIView.animate(withDuration: TimeInterval(animationDuration), delay: TimeInterval(stagger * Double(pmode.index)), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
                pmode.view.alpha = 1
                pmode.view.transform = self.getTransformForPopupView(pmode)
            }) { finished in
                j += 1
                if j == self.popoutViews.count{
                    if let block = self.didSelectBlock {
                        block(self, true, false, nil)
                    }
                }
            }
        }
        menuIsExpanded = true
    }
    //收回按钮
    func retract() {
        var j:Int = 0
        for pmode in popoutViews {
            UIView.animate(withDuration: TimeInterval(animationDuration), delay: TimeInterval(stagger * Double(pmode.index)), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
                pmode.view.transform = .identity
                pmode.view.alpha = 0
            }) { finished in
                j += 1
                if j == self.popoutViews.count{
                    if let block = self.didSelectBlock {
                        block(self, false, true, nil)
                    }
                }
            }
        }
        menuIsExpanded = false
    }
    //单次点击弹出的按钮
    func addPopoutModel(_ popModel:PopoutModel) {
        popModel.index = popoutViews.count
        configPop(popModel)
        popoutViews.append(popModel)
    }
    //增加多次点击弹出的按钮
    func addPopoutModels(_ popModels: [PopoutModel]) {
        if popViewArray.count == 0 {
            popViewArray.append(self.popoutViews)
        }
        for i in 0..<popModels.count{
            let pmode = popModels[i]
            pmode.index = i
            configPop(pmode)
        }
        popViewArray.append(popModels)
    }
    func distanceSliderChanged(_ sender: UISlider) {
        if !menuIsExpanded {
            expand()
        }
        distanceBetweenPopouts = Double(sender.value)
        print(String(format: "距离: %.02f", distanceBetweenPopouts))
        for pmode in popoutViews {
            pmode.view.transform = getTransformForPopupView(pmode)
        }
    }
    //FIXME:私有接口
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if bounds.contains(point) {
            return true
        }
        for pmode in popoutViews {
            if pmode.view.frame.contains(point) {
                return true
            }
        }
        return false
    }
    private func configPop(_ pmode: PopoutModel) {
        let popoutView = pmode.view
        let tap: UIGestureRecognizer = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(self.didTapPopoutView(_:)))
        let panner = UIPanGestureRecognizer()
        panner.addTarget(self, action: #selector(self.didPanPopout(_:)))
        popoutView.addGestureRecognizer(panner)
        popoutView.isUserInteractionEnabled = true
        popoutView.addGestureRecognizer(tap)
        popoutView.alpha = 0
        popoutView.center = CGPoint(x: bounds.origin.x + bounds.size.width / 2, y: bounds.origin.y + bounds.size.height / 2)
        addSubview(popoutView)
//            bringSubview(toFront: popoutView)
        sendSubviewToBack(popoutView)
    }
    private func getTransformForPopupView(_ pmode:PopoutModel) -> CGAffineTransform {
        distanceBetweenPopouts = Double(2 * 180 / popoutViews.count)
        let newAngle = startAngle + (distanceBetweenPopouts * Double(pmode.index))
        let deltaY = -distanceFromCenter * cos(newAngle / 180.0 * .pi)
        let deltaX = distanceFromCenter * sin(newAngle / 180.0 * .pi)
        return CGAffineTransform(translationX: CGFloat(deltaX), y: CGFloat(deltaY))
    }
    @objc private func didPanCenterView(_ sender: UIPanGestureRecognizer) {
        center = sender.location(in: window)
        sender.view?.center = sender.location(in: self)
    }
    @objc private func didLongpressCenterView() {
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController? = StoryBoard.instantiateViewController(withIdentifier: "FirstViewController")
        let animation = CATransition()
        animation.duration = 2.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType(rawValue: "rippleEffect")
        getCurrentViewController()?.view.window?.layer.add(animation, forKey: nil)
        let win: UIWindow? = UIApplication.shared.keyWindow
        win?.rootViewController = vc
        win?.makeKeyAndVisible()
    }
    @objc private func didTapCenterView(_ sender: UITapGestureRecognizer) {
        let tapNumber: Int = sender.numberOfTapsRequired - 1
        print("=====\(tapNumber)")
        if lastTapnumber != tapNumber && popViewArray.count > 0 {
            lastTapnumber = tapNumber
            if menuIsExpanded {
                retract()
            }
            if tapNumber < popViewArray.count{
                popoutViews = popViewArray[tapNumber]
            }else{
                popoutViews = popViewArray.last!
            }
        }
        if menuIsExpanded {
            retract()
        } else {
            expand()
        }
    }
    @objc private func didTapPopoutView(_ sender: UITapGestureRecognizer) {
        let view = sender.view
        let pmodes = self.popoutViews.filter {  $0.view == view!}
        if let block = self.didSelectBlock {
            block(self, false, false, pmodes.first)
        }
    }
    @objc private func didPanPopout(_ sender: UIPanGestureRecognizer) {
        let view: UIView = sender.view!
        let pmodes = self.popoutViews.filter {  $0.view == view}
        let index :Double = Double(popoutViews.index(of: pmodes.first!)!)
        let point: CGPoint = sender.location(in: self)
        let centerX: CGFloat = bounds.origin.x + bounds.size.width / 2
        let centerY: CGFloat = bounds.origin.y + bounds.size.height / 2
        if sender.state == .changed {
            let deltaX: Double = Double((point.x ) - centerX)
            let deltaY: Double = Double((point.y ) - centerY)
            let angle: Double = atan2(deltaX, -deltaY) * 180.0 / .pi
            self.distanceFromCenter = Double(sqrt(pow(point.x - centerX, 2) + pow(point.y - centerY, 2)))
            startAngle = angle - distanceBetweenPopouts * index
            //    NSLog(@"半径: %.02f\n起始角度: %.02f", self.distanceFromCenter, self.startAngle);
            for pmode in popoutViews {
                pmode.view.transform = getTransformForPopupView(pmode)
            }
        } else if sender.state == .ended {
            view.center = CGPoint(x: centerX, y: centerY)
            for pmode in popoutViews {
                pmode.view.transform = getTransformForPopupView(pmode)
            }
        }
    }
}
