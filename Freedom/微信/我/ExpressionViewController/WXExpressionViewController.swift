//
//  WXExpressionViewController.swift
//  Freedom
import SnapKit
import XExtension
import Foundation
class WXExpressionViewController: WXBaseViewController {
    var expChosenVC = WXExpressionChosenViewController()
    var expPublicVC = WXExpressionPublicViewController()
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["精选表情", "网络表情"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.titleView = segmentedControl
        view.addSubview(expChosenVC.view)
        addChild(expChosenVC)
        addChild(expPublicVC)
        let rightBarButton = UIBarButtonItem(image: Image.setting.image, style: .plain, target: self, action: #selector(self.rightBarButtonDown))
        navigationItem.rightBarButtonItem = rightBarButton
        if navigationController?.topViewController == self {
            let dismissBarButton = UIBarButtonItem(title: "取消", action: {
                self.dismiss(animated: true)
            })
            navigationItem.leftBarButtonItem = dismissBarButton
        }
    }
    @objc func rightBarButtonDown() {
        let myExpressionVC = WXMyExpressionViewController()
        navigationController?.pushViewController(myExpressionVC, animated: true)
    }
    func segmentedControlChanged(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            transition(from: expPublicVC, to: expChosenVC, duration: 0.5, options: .curveEaseInOut, animations: {
            }) { finished in
            }
        } else {
            transition(from: expChosenVC, to: expPublicVC, duration: 0.5, options: .curveEaseInOut, animations: {
            }) { finished in
            }
        }
    }
}
