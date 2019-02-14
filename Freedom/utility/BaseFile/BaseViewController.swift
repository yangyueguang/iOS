
import UIKit
import RxSwift
import XExtension
import Alamofire
@objcMembers
open class BaseViewController : UIViewController {
    @objc open var userInfo: Any!
    let disposeBag = DisposeBag()
    override open func loadView() {
        super.loadView()
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = UIRectEdge.all;
        let appearance = UINavigationBar.appearance()
        appearance.backIndicatorImage = UIImage(named:"u_cell_left")?.withRenderingMode(.alwaysOriginal);
        appearance.backIndicatorTransitionMaskImage = UIImage(named:"u_cell_left")?.withRenderingMode(.alwaysOriginal);
        appearance.backItem?.title = "返回"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", action: {
        })
    }
    private func monitorNetworkStatus() {
        let net = NetworkReachabilityManager()
        net?.listener = { status in
            switch status {
            case .notReachable:
                print("断网")
            case .reachable(.ethernetOrWiFi):
                print("WiFi网络")
            case .reachable(.wwan):
                print("4G网络")
            default:
                print("未知网络")
            }
        }
        net?.startListening()
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    public func push(_ VC: UIViewController?, info: Any = "", title: String, tabBarHid: Bool = true) {
        guard let vc = VC, let nav = navigationController else { return }
        print("跳转到 \(title) 页面Base UserInfo:\(info)")
        if vc.responds(to: #selector(setter: userInfo)) {
            (vc as! BaseViewController).userInfo = info
        }
        vc.title = title
        vc.hidesBottomBarWhenPushed = tabBarHid
        nav.pushViewController(vc, animated: true)
    }
    public func pop(toControllerNamed controllerstr: String, withSel sel: Selector?, withObj info: Any?) {
        print("返回到 \(controllerstr) 页面")
        for controller: UIViewController in (navigationController?.viewControllers)! {
            if (String(describing: controller) == controllerstr) {
                if controller.responds(to: sel) {
                    controller.perform(sel!, with: info, afterDelay: 0.01)
                }
                navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    public func goback() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
    //MARK: UItableViewDelegagte
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    // 开始摇一摇
    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.showRadialMenu()
    }
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion != .motionShake {
            return
        }
        print("结束摇一摇")
    }
    override open func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("取消摇一摇")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
