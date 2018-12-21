//
//  WXMomentDetailViewController.swift
//  Freedom

import Foundation

protocol WXMomentMultiImageViewDelegate: NSObjectProtocol {
    func momentViewClickImage(_ images: [Any], at index: Int)
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
    var `extension`: WXMomentExtension {
        didSet {
            tableView.reloadData()
        }
    }
    private var tableView: UITableView
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(tableView)
        tableView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self).mas_offset(5)
            make.left.and().right().mas_equalTo(self)
            make.bottom.mas_equalTo(self).priorityLow()
        })
        registerCell(for: tableView)
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

    // MARK: -
    var tableView: UITableView! {
        if tableView == nil {
            tableView = UITableView()
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor(243.0, 243.0, 245.0, 1.0)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.scrollsToTop = false
            tableView.isScrollEnabled = false
        }
        return tableView
    }
    func registerCell(for tableView: UITableView) {
        tableView.register(WXMomentExtensionCommentCell.self, forCellReuseIdentifier: "TLMomentExtensionCommentCell")
        tableView.register(WXMomentExtensionLikedCell.self, forCellReuseIdentifier: "TLMomentExtensionLikedCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCell")
    }

    // MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        var section: Int = self.extension.likedFriends.count > 0  1 : 0
        section += extension.comments.count > 0  1 : 0
        return section
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && self.extension.likedFriends.count > 0 {
            return 1
        } else {
            return self.extension.comments.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && self.extension.likedFriends.count > 0 {
            // 点赞
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMomentExtensionLikedCell") as WXMomentExtensionLikedCell
            cell.likedFriends = self.extension.likedFriends
            return cell!
        } else {
            // 评论
            let comment = self.extension.comments[indexPath.row] as WXMomentComment
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMomentExtensionCommentCell") as WXMomentExtensionCommentCell
            cell.comment = comment
            return cell!
        }
        return (tableView.dequeueReusableCell(withIdentifier: "EmptyCell"))!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && self.extension.likedFriends.count > 0 {
            return self.extension.extensionFrame.heightLiked
        } else {
            let comment = self.extension.comments[indexPath.row] as WXMomentComment
            return comment.commentFrame.height
        }
        return 0.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

class WXMomentExtensionLikedCell: WXTableViewCell {
    var likedFriends: [Any] = []
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        setBottomLineStyle(.fill)
    }
}
class WXMomentExtensionCommentCell: WXTableViewCell {
    var comment: WXMomentComment
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        setBottomLineStyle(.none)
    }
}
class WXMomentBaseView: UIView {
    weak var delegate: WXMomentViewDelegate?
    var titleLabel = UILabel()
    var detailContainerView = UIView()
    var extensionContainerView = UIView()
    var moment: WXMoment {
        didSet {
            avatarView.sd_setImage(with: URL(string: moment.user.avatarURL), for: UIControl.State.normal)
            usernameView.setTitle(moment.user.showName, for: .normal)
            dateLabel.text = "1小时前"
            originLabel.text = "微博"
            extensionView.extension = moment.extension
            detailContainerView.mas_updateConstraints({ make in
                make.height.mas_equalTo(moment.momentFrame.heightDetail)
            })
            extensionContainerView.mas_updateConstraints({ make in
                make.height.mas_equalTo(moment.momentFrame.heightExtension)
            })
        }
    }
    private var avatarView: UIButton = {
        let avatarView = UIButton()
        avatarView.tag = .avatar
        avatarView.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        return avatarView
    }()
    private var usernameView: UIButton = {
        let usernameView = UIButton()
        usernameView.tag = .username
        usernameView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        usernameView.setTitleColor(UIColor(74.0, 99.0, 141.0, 1.0), for: .normal)
        usernameView.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        return usernameView
    }()
    private var dateLabel: UILabel =  {
        let dateLabel = UILabel()
        dateLabel.textColor = UIColor.gray
        dateLabel.font = UIFont.systemFont(ofSize: 12.0)
        return dateLabel
    }()
    private var originLabel: UILabel = {
        let originLabel = UILabel()
        originLabel.textColor = UIColor.gray
        originLabel.font = UIFont.systemFont(ofSize: 12.0)
        return originLabel
    }()
    private var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.tag = .more
        moreButton.setImage(UIImage(named: "moments_more"), for: .normal)
        moreButton.setImage(UIImage(named: "moments_moreHL"), for: .selected)
        moreButton.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
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
//        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func buttonClicked(_ sender: UIButton) {
        if sender.tag == .avatar {
        } else if sender.tag == .userName {
        } else if sender.tag == .more {
        }
    }
//    func p_addMasonry() {
//        mas_makeConstraints({ make in
//            make.edges.mas_equalTo(self)
//        })
//        avatarView.mas_makeConstraints({ make in
//            make.top.mas_equalTo(self).mas_offset(15)
//            make.left.mas_equalTo(self).mas_offset(10)
//            make.size.mas_equalTo(CGSize(width: 40, height: 40))
//        })
//        usernameView.mas_makeConstraints({ make in
//            make.top.mas_equalTo(self.avatarView)
//            make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(10)
//            make.right.mas_lessThanOrEqualTo(self).mas_offset(-10)
//            make.height.mas_equalTo(15.0)
//        })
//        detailContainerView.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self.usernameView)
//            make.top.mas_equalTo(self.usernameView.mas_bottom).mas_offset(8)
//            make.right.mas_equalTo(self).mas_offset(-10)
//        })
//        dateLabel.mas_makeConstraints({ make in
//            make.top.mas_equalTo(self.detailContainerView.mas_bottom).mas_offset(8)
//            make.left.mas_equalTo(self.usernameView)
//        })
//        originLabel.mas_makeConstraints({ make in
//            make.top.mas_equalTo(self.dateLabel)
//            make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(10)
//        })
//        moreButton.mas_makeConstraints({ make in
//            make.centerY.mas_equalTo(self.dateLabel)
//            make.right.mas_equalTo(self.detailContainerView)
//            make.size.mas_equalTo(CGSize(width: 25, height: 25))
//        })
//        extensionContainerView.mas_makeConstraints({ make in
//            make.top.mas_equalTo(self.dateLabel.mas_bottom).mas_offset(8)
//            make.left.and().right().mas_equalTo(self.detailContainerView)
//            make.height.mas_equalTo(0)
//        })
//        extensionView.mas_makeConstraints({ make in
//            make.edges.mas_equalTo(0)
//        })
//    }
}
class WXMomentMultiImageView: UIView {
    weak var delegate: WXMomentMultiImageViewDelegate?
    private var imageViews: [UIButton] = []
    var images: [Any] = [] {
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
                imageView.sd_setImage(withURL: images[i], for: UIControl.State.normal)
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
    func buttonClicked(_ sender: UIButton) {
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
            titleLabel.text = detail.text
            titleLabel.mas_updateConstraints({ make in
                make.height.mas_equalTo(detail.detailFrame.heightText)
            })
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.mas_makeConstraints({ make in
            make.left.and().right().and().top().mas_equalTo(self)
        })
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
            multiImageView.images = detail.images
            let offset: CGFloat = detail.images.count > 0 ? (detail.text.length > 0 ? 7.0 : 3.0) : 0.0
            multiImageView.mas_updateConstraints({ make in
                make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(offset)
            })
        }
    }
    init(frame: CGRect) {
        super.init(frame: frame)
        multiImageView.setDelegate(delegate)
        addSubview(multiImageView)
        multiImageView.mas_makeConstraints({ make in
            make.left.and().right().and().bottom().mas_equalTo(self)
            make.top.mas_equalTo(self.titleLabel.mas_bottom)
        })
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
    init(frame: CGRect) {
        super.init(frame: frame)
        detailContainerView.addSubview(detailView)
        detailView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.detailContainerView)
        })
    }
}

class WXMomentDetailViewController: WXBaseViewController ,WXMomentViewDelegate {
    private var scrollView = UIScrollView()
    private var momentView = WXMomentImageView()
    var moment: WXMoment {
        didSet {
            momentView.moment = moment
            momentView.mas_updateConstraints({ make in
                make.height.mas_equalTo(moment.momentFrame.height)
            })
        }
    }
    init() {
        super.init()
        navigationItem.title = "详情"
        view.backgroundColor = UIColor.white
        scrollView.alwaysBounceVertical = true
        momentView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(momentView)
//        scrollView.mas_makeConstraints({ make in
//            make.edges.mas_equalTo(0)
//        })
//        momentView.mas_makeConstraints({ make in
//            make.top.and().left().mas_equalTo(0)
//            make.width.mas_equalTo(self.view)
//        })
    }
    func momentViewClickImage(_ images: [String], at index: Int) {
        var data: [MWPhoto] = []
        for imageUrl: String in images {
            let photo = MWPhoto(url: URL(string: imageUrl))
            data.append(photo)
        }
        let browser = MWPhotoBrowser(photos: data)
        browser.displayNavArrows = true
        browser.currentPhotoIndex = index
        let broserNavC = WXNavigationController(rootViewController: browser)
        present(broserNavC, animated: false)
    }
}
