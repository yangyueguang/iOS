//
//  WXHelpAndFeedbackViewController.swift
//  Freedom
import Foundation
class WXHelpAndFeedbackViewController: WXWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(image:Image.more.image, style: .plain, target: self, action: #selector(WXHelpAndFeedbackViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        self.url = "https://github.com/tbl00c/TLChat/issues"
    }
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
}
