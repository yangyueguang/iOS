//
//  WXMomentDetailViewController.swift
//  Freedom
import SnapKit
import MJRefresh
import MWPhotoBrowser
import XExtension
import Foundation
protocol WXMomentMultiImageViewDelegate: NSObjectProtocol {
    func momentViewClickImage(_ images: [String], at index: Int)
}
protocol WXMomentDetailViewDelegate: WXMomentMultiImageViewDelegate {
}
protocol WXMomentViewDelegate: WXMomentDetailViewDelegate {
}
enum TLMomentViewButtonType : Int {
    case avatar
    case userName
    case more
}

class WXMomentExtensionView: UIView, UITableViewDelegate, UITableViewDataSource {
    var `extension`: WXMomentExtension = WXMomentExtension() {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(243.0, 243.0, 245.0, 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollsToTop = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.register(WXMomentExtensionCommentCell.self, forCellReuseIdentifier: "TLMomentExtensionCommentCell")
        tableView.register(WXMomentExtensionLikedCell.self, forCellReuseIdentifier: "TLMomentExtensionLikedCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCell")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let startX: CGFloat = 20
        let startY: CGFloat = 0
        let endY: CGFloat = 5
        let width: CGFloat = 6
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.move(to: CGPoint(x: startX, y: startY))
        context.addLine(to: CGPoint(x: startX + width, y: endY))
        context.addLine(to: CGPoint(x: startX - width, y: endY))
        context.closePath()
        UIColor(243.0, 243.0, 245.0, 1.0).setFill()
        UIColor(243.0, 243.0, 245.0, 1.0).setStroke()
        context.drawPath(using: .fillStroke)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        var section: Int = self.extension.likedFriends.count > 0 ? 1 : 0
        section += self.extension.comments.count > 0 ? 1 : 0
        return section
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && self.extension.likedFriends.count > 0 {
            return 1
        } else {
            return self.extension.comments.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && self.extension.likedFriends.count > 0 {// 点赞
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMomentExtensionLikedCell") as! WXMomentExtensionLikedCell
            cell.likedFriends = self.extension.likedFriends.array()
            return cell
        } else { // 评论
            let comment = self.extension.comments[indexPath.row] as WXMomentComment
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMomentExtensionCommentCell") as! WXMomentExtensionCommentCell
            cell.comment = comment
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && self.extension.likedFriends.count > 0 {
            return self.extension.extensionFrame.heightLiked
        } else {
            let comment = self.extension.comments[indexPath.row] as WXMomentComment
            return comment.commentFrame.height
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

class WXMomentExtensionLikedCell: WXTableViewCell {
    var likedFriends: [WXUser] = []
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        bottomLineStyle = .fill
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class WXMomentExtensionCommentCell: WXTableViewCell {
    var comment: WXMomentComment = WXMomentComment()
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        bottomLineStyle = .none
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class WXMomentBaseView: UIView {
    weak var delegate: WXMomentViewDelegate?
    var titleLabel = UILabel()
    var detailContainerView = UIView()
    var extensionContainerView = UIView()
    var moment: WXMoment = WXMoment() {
        didSet {
            avatarView.sd_setImage(with: URL(string: moment.user?.avatarURL ?? ""), for: UIControl.State.normal)
            usernameView.setTitle(moment.user?.showName, for: .normal)
            dateLabel.text = "1小时前"
            originLabel.text = "微博"
            extensionView.extension = moment.extension
            self.detailContainerView.snp.updateConstraints { (make) in
                make.height.equalTo(moment.momentFrame.heightDetail)
            }
            self.extensionContainerView.snp.updateConstraints { (make) in
                make.height.equalTo(moment.momentFrame.heightExtension)
            }
        }
    }
    private lazy var avatarView: UIButton = {
        let avatarView = UIButton()
        avatarView.tag = TLMomentViewButtonType.avatar.rawValue
        avatarView.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        return avatarView
    }()
    private lazy var usernameView: UIButton = {
        let usernameView = UIButton()
        usernameView.tag = TLMomentViewButtonType.userName.rawValue
        usernameView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        usernameView.setTitleColor(UIColor(74.0, 99.0, 141.0, 1.0), for: .normal)
        usernameView.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        return usernameView
    }()
    private lazy var dateLabel: UILabel =  {
        let dateLabel = UILabel()
        dateLabel.textColor = UIColor.gray
        dateLabel.font = UIFont.systemFont(ofSize: 12.0)
        return dateLabel
    }()
    private lazy var originLabel: UILabel = {
        let originLabel = UILabel()
        originLabel.textColor = UIColor.gray
        originLabel.font = UIFont.systemFont(ofSize: 12.0)
        return originLabel
    }()
    private lazy var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.tag = TLMomentViewButtonType.more.rawValue
        moreButton.setImage(UIImage(named: "moments_more"), for: .normal)
        moreButton.setImage(UIImage(named: "moments_moreHL"), for: .selected)
        moreButton.addTarget(self, action: #selector(WXMomentBaseView.buttonClicked(_:)), for: .touchUpInside)
        return moreButton
    }()
    private var extensionView = WXMomentExtensionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(avatarView)
        addSubview(usernameView)
        addSubview(detailContainerView)
        addSubview(extensionContainerView)
        addSubview(dateLabel)
        addSubview(originLabel)
        addSubview(moreButton)
        extensionContainerView.addSubview(extensionView)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        avatarView.snp.makeConstraints { (make) in
            make.topMargin.equalTo(15)
            make.leftMargin.equalTo(10)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        usernameView.snp.makeConstraints { (make) in
            make.topMargin.equalTo(self.avatarView)
            make.left.equalTo(self.avatarView.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().offset(-10)
            make.height.equalTo(15)
        }
        detailContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.usernameView)
            make.top.equalTo(self.usernameView.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-10)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.detailContainerView.snp.bottom).offset(8)
            make.left.equalTo(self.usernameView)
        }
        originLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateLabel)
            make.left.equalTo(self.dateLabel.snp.right).offset(10)
        }
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.dateLabel)
            make.right.equalTo(self.detailContainerView)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        extensionContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(8)
            make.left.right.equalTo(self.detailContainerView)
            make.height.equalTo(0)
        }
        extensionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonClicked(_ sender: UIButton) {
        if sender.tag == TLMomentViewButtonType.avatar.rawValue {
        } else if sender.tag == TLMomentViewButtonType.userName.rawValue {
        } else if sender.tag == TLMomentViewButtonType.more.rawValue {
        }
    }
}
class WXMomentMultiImageView: UIView {
    weak var delegate: WXMomentMultiImageViewDelegate?
    private var imageViews: [UIButton] = []
    var images: [String] = [] {
        didSet {
            for v: UIView in subviews {
                v.removeFromSuperview()
            }
            if images.count == 0 {
                return
            }
            var imageWidth: CGFloat
            var imageHeight: CGFloat
            if images.count == 1 {
                imageWidth = (APPW - 70) * 0.6
                imageHeight = imageWidth * 0.8
            } else {
                imageWidth = (APPW - 70) * 0.31
                imageHeight = imageWidth
            }
            var x: CGFloat = 0
            var y: CGFloat = 0
            for i in 0..<(images.count) {
                var imageView: UIButton
                if i < imageViews.count {
                    imageView = imageViews[i]
                } else {
                    imageView = UIButton()
                    imageView.tag = i
                    imageView.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
                    imageViews.append(imageView)
                }
                imageView.sd_setImage(with: URL(string:images[i]), for: UIControl.State.normal)
                imageView.frame = CGRect(x: x, y: y, width: imageWidth, height: imageHeight)
                addSubview(imageView)
                if (i != 0 && images.count != 4 && (i + 1) % 3 == 0) || (images.count == 4 && i == 1) {
                    y += imageHeight + 10
                    x = 0
                } else {
                    x += imageWidth + 10
                }
            }
        }
    }
    @objc func buttonClicked(_ sender: UIButton) {
        delegate?.momentViewClickImage(images, at: sender.tag)
    }
}

class WXMomentDetailBaseView: UIView {
    weak var delegate: WXMomentDetailViewDelegate?
    var detail: WXMomentDetail?
}

class WXMomentDetailTextView: WXMomentDetailBaseView {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    override var detail: WXMomentDetail? {
        didSet {
            titleLabel.text = detail?.text
            titleLabel.snp.updateConstraints { (make) in
                make.height.equalTo(detail?.detailFrame.heightText ?? 0)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class WXMomentDetailImagesView: WXMomentDetailTextView {
    var multiImageView = WXMomentMultiImageView()
    override var delegate: WXMomentDetailViewDelegate? {
        didSet {
            multiImageView.delegate = delegate
        }
    }
    override var detail: WXMomentDetail? {
        didSet {
            multiImageView.images = detail?.images.array() ?? []
            let offset: CGFloat = detail?.images.count ?? 0 > 0 ? (detail?.text.count ?? 0 > 0 ? 7.0 : 3.0) : 0.0
            multiImageView.snp.updateConstraints { (make) in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(offset)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        multiImageView.delegate = delegate
        addSubview(multiImageView)
        multiImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class WXMomentImageView: WXMomentBaseView {
    private var detailView = WXMomentDetailImagesView()
    override var moment: WXMoment {
        didSet {
            detailView.detail = moment.detail
        }
    }
    override var delegate: WXMomentViewDelegate? {
        didSet {
            detailView.delegate = delegate
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        detailContainerView.addSubview(detailView)
        detailView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.detailContainerView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WXMomentDetailViewController: WXBaseViewController ,WXMomentViewDelegate {
    private var scrollView = UIScrollView()
    private var momentView = WXMomentImageView()
    var moment: WXMoment = WXMoment() {
        didSet {
            momentView.moment = moment
            momentView.snp.updateConstraints { (make) in
                make.height.equalTo(moment.momentFrame.height)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "详情"
        view.backgroundColor = UIColor.white
        scrollView.alwaysBounceVertical = true
        momentView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(momentView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        momentView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.equalTo(self.view)
        }
    }
    func momentViewClickImage(_ images: [String], at index: Int) {
        var data: [MWPhoto] = []
        for imageUrl: String in images {
            let photo = MWPhoto(url: URL(string: imageUrl))
            data.append(photo!)
        }
        let browser = MWPhotoBrowser(photos: data)
        browser?.displayNavArrows = true
        browser?.setCurrentPhotoIndex(UInt(index))
        let broserNavC = WXNavigationController(rootViewController: browser!)
        present(broserNavC, animated: false)
    }
}
