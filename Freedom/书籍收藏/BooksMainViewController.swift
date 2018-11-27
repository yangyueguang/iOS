//
//  BooksMainViewController.swift
//  Freedom
//
//  Created by Super on 6/14/18.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import XExtension
class BooksMainViewController: BooksBaseViewController {
    var leftViewController: UIViewController!
    var centerViewController: UIViewController!
    var rightViewController: UIViewController!
    var leftWidth: CGFloat = 0.0
    var rightWidth: CGFloat = 0.0
    var rightMaskView: UIView!
    //右半透明蒙版
    var leftMaskView: UIView!
    //左半透明蒙版
    var leftGesture: UIPanGestureRecognizer?
    var rightGesture: UIPanGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let bookshelf = BooksViewController()
        let na = UINavigationController(rootViewController: bookshelf)
        let leftVC = BookFriendsViewController()
        let rightVC = E_ScrollViewController()
        leftViewController = leftVC
        centerViewController = na
        rightViewController = rightVC
        view.addSubview(leftVC.view)
        view.addSubview(rightVC.view)
        view.addSubview(na.view)
        leftWidth = APPW * 0.8
        rightWidth = APPW
        view.backgroundColor = UIColor.gray
        //初始位置
        leftViewController.view.frame = CGRect(x: -APPW * 0.3, y: 0, width: APPW, height: APPH)
        rightViewController.view.frame = CGRect(x: APPW * 0.8, y: 0, width: APPW, height: APPH)
        rightMaskView = UIView(frame: UIScreen.main.bounds)
        rightMaskView.backgroundColor = UIColor.black
        leftMaskView = UIView(frame: UIScreen.main.bounds)
        leftMaskView.backgroundColor = UIColor.black
        rightViewController.view.addSubview(rightMaskView)
        leftViewController.view.addSubview(leftMaskView)
        //中间视图设置手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(_:)))
        centerViewController.view.addGestureRecognizer(panGesture)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        edgesForExtendedLayout = [.left, .right, .bottom]
    }
    //显示左侧视图
    func showSide(withAnimation animation: Bool) {
        UIView.animate(withDuration: animation ? 0.5 : 0, animations: {
            self.leftViewController.view.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH)
            self.centerViewController.view.frame = CGRect(x: APPW * 0.8, y: 0, width: APPW, height: APPH)
            self.leftMaskView.alpha = self.alpha(withOffsetX: self.centerViewController.view.frame.origin.x, totalOffsetX: APPW * 0.8)
        }) { finished in
            //左侧视图设置手势
            self.leftGesture = UIPanGestureRecognizer(target: self, action: #selector(self.leftPaneGesture(_:)))
            self.leftViewController.view.addGestureRecognizer(self.leftGesture!)
        }
    }
    //关闭左侧视图
    func dismissSide(withAnimation animation: Bool) {
        UIView.animate(withDuration: animation ? 0.5 : 0, animations: {
            self.leftViewController.view.frame = CGRect(x: -APPW * 0.3, y: 0, width: APPW, height: APPH)
            self.centerViewController.view.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH)
            self.leftMaskView.alpha = self.alpha(withOffsetX: self.centerViewController.view.frame.origin.x, totalOffsetX: APPW * 0.8)
        }) { finished in
            self.leftViewController.view.removeGestureRecognizer(self.leftGesture!)
        }
    }
    //显示右侧视图
    func showRightView(withAnimation animation: Bool) {
        UIView.animate(withDuration: animation ? 0.5 : 0, animations: {
            self.rightViewController.view.frame = CGRect(x: APPW - APPW, y: 0, width: APPW, height: APPH)
            self.centerViewController.view.frame = CGRect(x: -APPW, y: 0, width: APPW, height: APPH)
            self.rightMaskView.alpha = self.alpha(withOffsetX: self.centerViewController.view.frame.origin.x, totalOffsetX: APPW)
        }) { finished in
            //右侧视图设置手势
            self.rightGesture = UIPanGestureRecognizer(target: self, action: #selector(self.rightPanGesture(_:)))
            self.rightViewController.view.addGestureRecognizer(self.rightGesture!)
        }
    }
    //关闭右侧视图
    func dismissRigthView(withAnimation animation: Bool) {
        UIView.animate(withDuration: animation ? 0.5 : 0, animations: {
            self.rightViewController.view.frame = CGRect(x: 0.8 * APPW, y: 0, width: APPW, height: APPH)
            self.centerViewController.view.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH)
            self.rightMaskView.alpha = self.alpha(withOffsetX: self.rightViewController.view.frame.origin.x, totalOffsetX: APPW)
        }) { finished in
            self.rightViewController.view.removeGestureRecognizer(self.rightGesture!)
        }
    }
    //中间视图手势事件
    func panGesture(_ pan: UIPanGestureRecognizer?) {
        let transion: CGPoint? = pan?.translation(in: centerViewController.view)
        let offSetX: CGFloat? = transion?.x
        if (offSetX ?? 0.0) < 0 && centerViewController.view.frame.origin.x > 0 {
            //左滑关闭左视图
            leftViewController.view.frame = leftViewFrame(withOffsetX: offSetX!)
            centerViewController.view.frame = centerViewFrame(withOffsetX: offSetX!)
            leftMaskView.alpha = alpha(withOffsetX: centerViewController.view.frame.origin.x, totalOffsetX: 0.8 * APPW)
        } else if (offSetX ?? 0.0) < 0 && centerViewController.view.frame.origin.x <= 0 {
            //左滑显示右视图
            rightMaskView.isHidden = false
            rightViewController.view.frame = rightViewFrame(withOffsetX: offSetX!)
            centerViewController.view.frame = centerViewFrame(withOffsetX: offSetX!)
            rightMaskView.alpha = alpha(withOffsetX: centerViewController.view.frame.origin.x, totalOffsetX: APPW)
        } else if offSetX! > 0 && centerViewController.view.frame.origin.x >= 0 {
            //右滑显示左视图
            leftMaskView.isHidden = false
            leftMaskView.alpha = alpha(withOffsetX: centerViewController.view.frame.origin.x, totalOffsetX: 0.8 * APPW)
            leftViewController.view.frame = leftViewFrame(withOffsetX: offSetX!)
            centerViewController.view.frame = centerViewFrame(withOffsetX: offSetX!)
        } else {
            //油滑关闭右视图
            rightMaskView.alpha = alpha(withOffsetX: rightViewController.view.frame.origin.x, totalOffsetX: APPW)
            rightViewController.view.frame = rightViewFrame(withOffsetX: offSetX!)
            centerViewController.view.frame = centerViewFrame(withOffsetX: offSetX!)
        }
        pan?.setTranslation(CGPoint.zero, in: centerViewController.view)
        //手势操作结束 判断该显示还是该关闭
        if pan?.state == .ended {
            leftMaskView.isHidden = false
            rightMaskView.isHidden = false
            if centerViewController.view.frame.origin.x > 0 {
                if centerViewController.view.frame.origin.x > APPW * 0.8 / 2 {
                    showSide(withAnimation: true)
                } else {
                    dismissSide(withAnimation: true)
                }
            } else {
                if centerViewController.view.frame.origin.x < -APPW / 2 {
                    showRightView(withAnimation: true)
                } else {
                    dismissRigthView(withAnimation: true)
                }
            }
        }
    }
    //右侧视图的手势事件 右拉显示中间视图
    func rightPanGesture(_ pan: UIPanGestureRecognizer?) {
        let point: CGPoint? = pan?.translation(in: rightViewController.view)
        let offsetX: CGFloat? = point?.x
        //右侧视图禁止左滑
        if (offsetX ?? 0.0) < 0 {
            return
        }
        if (offsetX ?? 0.0) > 0 {
            centerViewController.view.frame = centerViewFrame(withOffsetX: offsetX!)
            rightViewController.view.frame = rightViewFrame(withOffsetX: offsetX!)
            rightMaskView.alpha = alpha(withOffsetX: centerViewController.view.frame.origin.x, totalOffsetX: APPW)
        }
        pan?.setTranslation(CGPoint.zero, in: rightViewController.view)
        if pan?.state == .ended {
            if centerViewController.view.frame.origin.x >= -0.5 * APPW {
                dismissRigthView(withAnimation: true)
            } else {
                showRightView(withAnimation: true)
            }
        }
    }
    //左侧视图的手势事件 左拉显示中间视图
    func leftPaneGesture(_ pan: UIPanGestureRecognizer?) {
        let point: CGPoint? = pan?.translation(in: leftViewController.view)
        let offsetX: CGFloat? = point?.x
        //左侧视图 禁止向左滑手势
        if (offsetX ?? 0.0) > 0 {
            return
        }
        if (offsetX ?? 0.0) < 0 {
            centerViewController.view.frame = centerViewFrame(withOffsetX: offsetX!)
            leftViewController.view.frame = leftViewFrame(withOffsetX: offsetX!)
            leftMaskView.alpha = alpha(withOffsetX: centerViewController.view.frame.origin.x, totalOffsetX: 0.8 * APPW)
        }
        pan?.setTranslation(CGPoint.zero, in: leftViewController.view)
        if pan?.state == .ended {
            if centerViewController.view.frame.origin.x <= 0.4 * APPW {
                dismissSide(withAnimation: true)
            } else {
                showSide(withAnimation: true)
            }
        }
    }
    //根据当前偏移量和总偏移量动态改变蒙版的alpha值
    func alpha(withOffsetX offsetX: CGFloat, totalOffsetX: CGFloat) -> CGFloat {
        let m = CGFloat(fabs(Float(offsetX))) / totalOffsetX
        var alpha: CGFloat = 1 - m
        if alpha > 0.5 {
            alpha = 0.5
        }
        return alpha
    }
    //根据偏移量动态改变视图的frame
    func centerViewFrame(withOffsetX offsetX: CGFloat) -> CGRect {
        var perframe: CGRect = centerViewController.view.frame
        perframe.origin.x += offsetX
        return perframe
    }
    func leftViewFrame(withOffsetX offsetX: CGFloat) -> CGRect {
        var perframe: CGRect = leftViewController.view.frame
        perframe.origin.x += offsetX * 0.5
        if perframe.origin.x >= 0 {
            perframe.origin.x = 0
        }
        return perframe
    }
    func rightViewFrame(withOffsetX offsetX: CGFloat) -> CGRect {
        var perframe: CGRect = rightViewController.view.frame
        perframe.origin.x += offsetX
        return perframe
    }
}
