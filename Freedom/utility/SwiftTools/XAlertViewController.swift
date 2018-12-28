//
//  XAlertViewController.swift
import UIKit
enum XAlertStyle : Int {
    case alert
    case sheet
}
private class XAlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting = false
    init(isPresenting: Bool) {
        super.init()
        self.isPresenting = isPresenting
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            presentAnimationTransition(transitionContext)
        } else {
            dismissAnimationTransition(transitionContext)
        }
    }
    private func presentAnimationTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let alertVC = transitionContext.viewController(forKey: .to) as! XAlertViewController
        alertVC.backgroundView.alpha = 0.0
        switch alertVC.alertStyle {
        case .alert:
            alertVC.alertView.alpha = 0.0
            alertVC.alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        case .sheet:
            alertVC.alertView.transform = CGAffineTransform(translationX: 0, y: alertVC.alertView.frame.height)
        }
        let containerView: UIView = transitionContext.containerView
        containerView.addSubview(alertVC.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            alertVC.backgroundView.alpha = 1.0
            switch alertVC.alertStyle {
            case .alert:
                alertVC.alertView.alpha = 1.0
                alertVC.alertView.transform = CGAffineTransform.identity
            case .sheet:
                alertVC.alertView.transform = CGAffineTransform.identity
            }
        }) { finished in
            transitionContext.completeTransition(true)
        }
    }
    private func dismissAnimationTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let alertVC = transitionContext.viewController(forKey: .from) as! XAlertViewController
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            alertVC.backgroundView.alpha = 0.0
            switch alertVC.alertStyle {
            case .alert:
                alertVC.alertView.alpha = 0.0
                alertVC.alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            case .sheet:
                alertVC.alertView.transform = CGAffineTransform(translationX: 0, y: alertVC.alertView.frame.height)
            }
        }) { finished in
            transitionContext.completeTransition(true)
        }
    }
}

class XAlertViewController: UIViewController ,UIViewControllerTransitioningDelegate {
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.sigleTap(_:)))
    private lazy var alertCenterYConstraint = NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)
    var alertView: UIView!
    var alertStyle: XAlertStyle = .alert
    var dismissCompleteClosure: (() -> Void)?
    var backgroundView = UIView()
    var tapBackgroundDismissEnable = true {
        didSet {
            tapGesture.isEnabled = tapBackgroundDismissEnable
        }
    }
    required public init(withAlert alertView: UIView, preferredStyle: XAlertStyle) {
        super.init(nibName: nil, bundle: nil)
        self.alertView = alertView
        self.alertStyle = preferredStyle
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        providesPresentationContextTransitionStyle = true// 是否视图控制器定义它呈现视图控制器的过渡风格
        definesPresentationContext = true
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if alertView == nil { return }
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        view.insertSubview(backgroundView, at: 0)
        view.addSubview(alertView)
        backgroundView.addGestureRecognizer(tapGesture)
        addAlertViewControllerConstraints()
    }
    // 下面设置约束
    private func addAlertViewControllerConstraints() {
        func addConstraint(_ item: UIView, attributes: [NSLayoutConstraint.Attribute], constant: CGFloat = 0) {
            for attr in attributes {
                view.addConstraint(NSLayoutConstraint(item: item, attribute: attr, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: constant))
            }
        }
        func addAlertConstraint(_ attrbute: NSLayoutConstraint.Attribute, constant: CGFloat){
            guard let leftAttribute = NSLayoutConstraint.Attribute(rawValue: 0), constant > 0 else {
                return
            }
            let constraint = NSLayoutConstraint(item: alertView, attribute: attrbute, relatedBy: .equal, toItem: nil, attribute: leftAttribute, multiplier: 1, constant: constant)
            alertView.addConstraint(constraint)
        }
        alertView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(backgroundView, attributes: [.top, .left, .right, .bottom])
        // alert 约束为居中，如果没有宽度或宽度约束则左右各留15像素
        if alertStyle == .alert {
            let centerXConstraint = NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
            view.addConstraint(centerXConstraint)
            if !alertView.frame.size.equalTo(CGSize.zero) {
                addAlertConstraint(.width, constant: alertView.frame.width)
                addAlertConstraint(.height, constant: alertView.frame.height)
            } else {
                var findAlertViewWidConstraint = false
                for constraint in alertView.constraints where constraint.firstAttribute == .width {
                    findAlertViewWidConstraint = true
                    break
                }
                if !findAlertViewWidConstraint {
                    addAlertConstraint(.width, constant: view.frame.width - 2 * 15)
                }
            }
            view.addConstraint(alertCenterYConstraint)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }else{// sheet 约束为左右下紧贴
            for constraint in alertView.constraints where constraint.firstAttribute == .width {
                alertView.removeConstraint(constraint)
                break
            }
            addConstraint(alertView, attributes: [.left,.right,.bottom])
            addAlertConstraint(.height, constant: alertView.frame.height)
        }
        if alertView.translatesAutoresizingMaskIntoConstraints {
            alertView.translatesAutoresizingMaskIntoConstraints = false
        }
        view.layoutIfNeeded()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func sigleTap(_ tap: UITapGestureRecognizer) {
        dismiss(animated: true)
        dismissCompleteClosure?()
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardRect: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let alertViewBottomEdge = (view.frame.height - alertView.frame.height) / 2
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let differ = keyboardRect.height - alertViewBottomEdge
        if alertCenterYConstraint.constant == -differ - statusBarHeight { return }
        if differ >= 0 {
            alertCenterYConstraint.constant = -differ - statusBarHeight
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardWillHide(_ note: Notification) {
        alertCenterYConstraint.constant = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XAlertAnimation(isPresenting: true)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XAlertAnimation(isPresenting: false)
    }
}
