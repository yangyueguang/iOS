
import UIKit
class BaseViewController : UIViewController {
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white ,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func push(_ controller: BaseViewController, title: String, tabBarHid abool: Bool = true) -> BaseViewController {
        controller.title = title
        controller.hidesBottomBarWhenPushed = abool
        navigationController?.pushViewController(controller, animated: true)
        return controller
    }

    func popTo(_ name: String) {
        print("返回到 \(name) 页面")
        let vcs = navigationController?.viewControllers ?? []
        for vc in vcs where String(describing: vc) == name {
            navigationController?.popToViewController(vc, animated: true)
        }
    }

    func goback() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }else {
            dismiss(animated: true, completion: nil)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}



