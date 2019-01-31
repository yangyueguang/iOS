//
//  ToutiaoHomeSampleViewController.swift
//  Freedom
import UIKit
import RxSwift
import XExtension
import XCarryOn
class ToutiaoHomeSampleViewCell:BaseTableViewCell<TopicModel.TopicNew> {
    override func initUI() {
        icon = UIImageView(frame: CGRect(x: 10, y: 0, width: 80, height: 80))
        title = UILabel(frame: CGRect(x:100, y: 10, width: 300, height: 80))
        title.numberOfLines = 0
        addSubviews([icon,title])
        viewModel.subscribe(onNext: {[weak self] (news) in
            guard let `self` = self else { return }
            if news.media.count > 1 {
//                let me = news.media[0]
//                let img = me.sUrl
//                self.icon.kf.setImage(with: URL(string: img))
            }
            self.title.text = news.title
        }).disposed(by: disposeBag)
    }
}
class ToutiaoHomeSampleViewController: ToutiaoBaseViewController {
    var topicModel = BaseModel()
    var model = TopicModel()
    let viewModel = PublishSubject<TopicModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH), style: .grouped)
        tableView.register(ToutiaoHomeSampleViewCell.self)
//        tableView.dataSource = self;
//        tableView.delegate = self;
        tableView.rowHeight = 90
        view.addSubview(tableView)
        viewModel.subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            self.model = model
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        XNetKit.topicNewsList(topicModel.url, next: viewModel)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.lists.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return model.top.count > 0 ? 120 : 0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var icons: [String] = []
        for topNew in model.top {
            icons.append(topNew.mp_img)
        }
        let headBanner = BaseScrollView(banner: CGRect(x: 0, y: 0, width: APPW, height: 120), icons: icons)
        headBanner.selectBlock = {(index,dict) in
            print("\(index)\(String(describing: dict))")
        }
        return headBanner;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ToutiaoHomeSampleViewCell.self)
        cell.viewModel.onNext(model.lists[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topNew = model.lists[indexPath.row]
        push(ToutiaoHomeDetailViewController(), info:topNew, title: topNew.title)
    }
}
