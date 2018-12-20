//
//  WXExpressionViewController.swift
//  Freedom

import Foundation
class WXExpressionViewController: WXBaseViewController {
    var segmentedControl: UISegmentedControl
    var expChosenVC: WXExpressionChosenViewController
    var expPublicVC: WXExpressionPublicViewController


    func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.titleView = segmentedControl
        view.addSubview(expChosenVC.view)
        addChild(expChosenVC)
        addChild(expPublicVC)

        let rightBarButton = UIBarButtonItem(image: UIImage(named: "nav_setting"), style: .plain, target: self, action: #selector(self.rightBarButtonDown))
        navigationItem.rightBarButtonItem = rightBarButton

        if navigationController.topViewController == self {
            let dismissBarButton = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, actionBlick: {
                self.dismiss(animated: true)
            })
            navigationItem.leftBarButtonItem = dismissBarButton
        }
    }
    func rightBarButtonDown() {
        let myExpressionVC = WXMyExpressionViewController()
        hidesBottomBarWhenPushed = true
        navigationController.pushViewController(myExpressionVC, animated: true)
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


    func segmentedControl() -> UISegmentedControl {
        if segmentedControl == nil {
            segmentedControl = UISegmentedControl(items: ["精选表情", "网络表情"])
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.addTarget(self, action: #selector(self.segmentedControlChanged(_:)), for: .valueChanged)
        }
        return segmentedControl
    }

    func expChosenVC() -> WXExpressionChosenViewController {
        if expChosenVC == nil {
            expChosenVC = WXExpressionChosenViewController()
        }
        return expChosenVC
    }

    func expPublicVC() -> WXExpressionPublicViewController {
        if expPublicVC == nil {
            expPublicVC = WXExpressionPublicViewController()
        }
        return expPublicVC
    }


    
}
