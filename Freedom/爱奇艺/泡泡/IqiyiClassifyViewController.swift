//
//  Freedom
import UIKit
//import XExtension
import MJRefresh
//import XCarryOn
class IqiyiClassifyCell: BaseTableViewCell<IqiyiClassifyModel> {
    override func initUI() {
        viewModel.subscribe(onNext: {[weak self] (model) in
            self?.imageView?.sd_setImage(with: URL(string: model.image_at_bottom))
            self?.textLabel?.text = model.image_at_top
        }).disposed(by: disposeBag)
    }
}
class TEMPBASEC:BaseTableViewCell<Any> {
    override func initUI() {
        viewModel.subscribe(onNext: { (model) in

        }).disposed(by: disposeBag)
    }
}
final class IqiyiClassifyViewController: IqiyiBaseViewController {
    let urlStr = "urlWithclassifyData"
    var dataSource = [AnyHashable]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64), style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsets.zero
        view.addSubview(tableView)
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {() -> Void in
        })
        tableView.mj_header?.beginRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueCell(IqiyiClassifyCell.self)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = IqiyiWebViewController()
        webVC.urlStr = TestWebURL
        navigationController?.pushViewController(webVC, animated: true)
    }
}
