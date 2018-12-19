//
//  NIOSOPresentViewController.swift
//  SOKit
//
//  Created by Tao.liu on 2018/9/9.
//  Copyright © 2018年 NIO. All rights reserved.
//

import Foundation
import UIKit

public class XAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {
    public func presentBottom(_ vc: XAlertViewController ) {
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present = PresentBottom(presentedViewController: presented, presenting: presenting)
        return present
    }
}
public class PresentBottom:UIPresentationController {
    lazy var blackView: UIView = {
        let view = UIView(frame: self.containerView?.bounds ?? UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hidPresent))
        view.addGestureRecognizer(gesture)
        return view
    }()
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    public override func presentationTransitionWillBegin() {
        blackView.alpha = 0
        containerView?.addSubview(blackView)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
        }
    }
    public override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
        }
    }
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        blackView.removeFromSuperview()
    }
    public override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    @objc func hidPresent() {
        self.presentedViewController.dismiss(animated: true) { }
    }
    
}

