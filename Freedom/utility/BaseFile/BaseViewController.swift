
import UIKit
import XExtension
import SVProgressHUD
import Alamofire
@objcMembers
open class BaseViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @objc open var userInfo: Any!
    open var otherInfo: Any!
    open var tableView: BaseTableView!
    open var collectionView: BaseCollectionView!
    override open func loadView() {
        super.loadView()
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white ,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]


        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = UIRectEdge.all;
        let appearance = UINavigationBar.appearance()
        appearance.backIndicatorImage = UIImage(named:"u_cellLeft")?.withRenderingMode(.alwaysOriginal);
        appearance.backIndicatorTransitionMaskImage = UIImage(named:"u_cellLeft")?.withRenderingMode(.alwaysOriginal);
        let backItem: UIBarButtonItem = UIBarButtonItem()
        backItem.title = "返回"
        self.navigationItem.backBarButtonItem = backItem;
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
    public func push(_ controller: BaseViewController=BaseViewController(), withInfo info: Any="", withTitle title: String, withOther other: Any="", tabBarHid abool: Bool=true) -> BaseViewController {
        print("跳转到 \(title) 页面Base UserInfo:\(info)Base OtherInfo:\(String(describing: other))")
        if controller.responds(to: #selector(setter: userInfo)) {
            controller.userInfo = info
            controller.otherInfo = other
        }
        controller.title = title
        controller.hidesBottomBarWhenPushed = abool
        navigationController?.pushViewController(controller, animated: true)
        return controller
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
//    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.dataArray.count
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell.getInstance() as? BaseTableViewCell
        }
        return cell!
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    //MARK: 子类重写
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("请子类重写这个方法")
    }
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 1 添加一个删除按钮
        let deleteRowAction = UITableViewRowAction(style: .destructive, title: "删除", handler: {(_ action: UITableViewRowAction, _ indexPath: IndexPath) -> Void in
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        deleteRowAction.backgroundColor = .lightGray
        return [deleteRowAction]
    }
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }else {
            tableView.insertRows(at: [indexPath], with: .left)
        }
    }
    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("请子类重写这个方法")
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
