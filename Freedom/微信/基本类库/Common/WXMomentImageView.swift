//
//  WXMomentImageView.swift
//  Freedom
import UIKit
import RxSwift
class WXMomentExtensionCommentCell: BaseTableViewCell<WXMomentComment> {
    override func initUI() {
        super.initUI()
        addSubviews([icon,title])
        icon.frame = CGRect(x: 10, y: 0, width: 50, height: 50)
        title.frame = CGRect(x: 100, y: 10, width: APPW, height: 20)
        viewModel.subscribe(onNext: {[weak self] (moment) in
            self?.icon.kf.setImage(with: moment.user.avatarURL.url)
            self?.title.text = moment.user.showName
        }).disposed(by: disposeBag)
    }
}
class WXMomentImageView: UIView {
    @IBOutlet weak var titleLabel: UILabel!//usernameView
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var extensionContainerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imagesContainView: UIView!
    @IBOutlet weak var peoplesView: UIView!
    @IBOutlet weak var tableView: UITableView!
    private var momentModel = WXMoment()
    private let disposeBag = DisposeBag()
    let moment = PublishSubject<WXMoment>()

    override func awakeFromNib() {
        super.awakeFromNib()
        moment.subscribe(onNext: {[weak self] (moment) in
            guard let `self` = self else { return }
            self.momentModel = moment
            self.titleLabel.text = moment.user.showName
            self.avatarView.kf.setImage(with: moment.user.avatarURL.url)
            self.titleLabel.text = moment.user.showName
            self.dateLabel.text = "1小时前"
            self.originLabel.text = "微博"
            self.imagesContainView.subviews.forEach({ (sv) in
                sv.removeFromSuperview()
            })
            for i in 0..<moment.extension.likedFriends.count {
                let user = moment.extension.likedFriends[i]
                let userAvatar = UIImageView()
                self.imagesContainView.addSubview(userAvatar)
            }
            self.extensionContainerView.snp.updateConstraints { (make) in
                make.height.equalTo(CGFloat(moment.extension.comments.count) * 36.0 + 100.0)
            }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(momentModel.extension.comments.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(WXMomentExtensionCommentCell.self)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
