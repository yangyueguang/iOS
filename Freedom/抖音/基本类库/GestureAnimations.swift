//
//  GestureAnimations.swift
//  Douyin
//
//  Created by Chao Xue 薛超 on 2018/11/26.
//  Copyright © 2018 Qiao Shi. All rights reserved.
//
class ScalePresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to) as! AwemeListController
        let fromVC = transitionContext.viewController(forKey: .from) as! UINavigationController
        let userHomePageController = fromVC.viewControllers.first as! DouyinMeViewController
        let selectCell = userHomePageController.collectionView?.cellForItem(at: IndexPath.init(item: userHomePageController.selectIndex, section: 1))

        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)

        let initialFrame = userHomePageController.collectionView?.convert(selectCell?.frame ?? .zero, to: userHomePageController.collectionView?.superview) ?? .zero
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let duration:TimeInterval = self.transitionDuration(using: transitionContext)

        toVC.view.center = CGPoint.init(x: initialFrame.origin.x + initialFrame.size.width/2, y: initialFrame.origin.y + initialFrame.size.height/2)
        toVC.view.transform = CGAffineTransform.init(scaleX: initialFrame.size.width/finalFrame.size.width, y: initialFrame.size.height/finalFrame.size.height)

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
            toVC.view.center = CGPoint.init(x: finalFrame.origin.x + finalFrame.size.width/2, y: finalFrame.origin.y + finalFrame.size.height/2)
            toVC.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }) { finished in
            transitionContext.completeTransition(true)
        }

    }
}

class ScaleDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    let centerFrame = CGRect.init(x: (screenWidth - 5)/2, y: (screenHeight - 5)/2, width: 5, height: 5)

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from) as! AwemeListController
        let toVC = transitionContext.viewController(forKey: .to) as! UINavigationController

        let userHomePageController = toVC.viewControllers.first as! DouyinMeViewController

        var snapshotView:UIView?
        var scaleRatio:CGFloat = 1.0
        var finalFrame:CGRect = centerFrame
        if let selectCell = userHomePageController.collectionView?.cellForItem(at: IndexPath.init(item: fromVC.currentIndex, section: 1)) {
            snapshotView = selectCell.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.width/selectCell.frame.width
            snapshotView?.layer.zPosition = 20
            finalFrame = userHomePageController.collectionView?.convert(selectCell.frame, to: userHomePageController.collectionView?.superview) ?? centerFrame
        } else {
            snapshotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.width/screenWidth
            finalFrame = centerFrame
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(snapshotView!)

        let duration = self.transitionDuration(using: transitionContext)

        fromVC.view.alpha = 0.0
        snapshotView?.center = fromVC.view.center
        snapshotView?.transform = CGAffineTransform.init(scaleX: scaleRatio, y: scaleRatio)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            snapshotView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            snapshotView?.frame = finalFrame
        }) { finished in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            snapshotView?.removeFromSuperview()
        }
    }


}

class SwipeLeftInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var interacting:Bool = false
    var presentingVC:UIViewController?
    var viewControllerCenter:CGPoint = .zero

    func wireToViewController(viewController:AwemeListController) {
        presentingVC = viewController
        presentingVC?.view.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(handlerGesture(gestureRecognizer:))))
        viewControllerCenter = presentingVC?.view.center ?? CGPoint.init(x: screenWidth/2, y: screenHeight/2)
    }

    override var completionSpeed: CGFloat {
        set {}
        get {
            return 1 - self.percentComplete
        }
    }

    @objc func handlerGesture(gestureRecognizer:UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        if !interacting && (translation.x < 0 || translation.y < 0 || translation.x < translation.y) {
            return
        }
        switch gestureRecognizer.state {
        case .began:
            interacting = true
            break
        case .changed:
            var progress:CGFloat = translation.x / screenWidth
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

            let ratio:CGFloat = 1.0 - (progress * 0.5)
            presentingVC?.view.center = CGPoint.init(x: viewControllerCenter.x + translation.x * ratio, y: viewControllerCenter.y + translation.y * ratio)
            presentingVC?.view.transform = CGAffineTransform.init(scaleX: ratio, y: ratio)
            update(progress)
            break
        case .cancelled, .ended:
            var progress:CGFloat = translation.x / screenWidth
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

            if progress < 0.2 {
                UIView.animate(withDuration: TimeInterval(progress), delay: 0.0, options: .curveEaseOut, animations: {
                    self.presentingVC?.view.center = CGPoint.init(x: screenWidth / 2, y: screenHeight / 2)
                    self.presentingVC?.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                }) { finished in
                    self.interacting = false
                    self.cancel()
                }
            }else {
                interacting = false
                finish()
                presentingVC?.dismiss(animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
}
