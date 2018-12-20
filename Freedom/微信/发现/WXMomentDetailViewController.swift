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
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
enum TLMomentViewButtonType : Int {
    case avatar
    case userName
    case more
}

class WXMomentExtensionView: UIView, UITableViewDelegate, UITableViewDataSource {
    func registerCell(for tableView: UITableView) {
    }

    var `extension`: WXMomentExtension
    private var tableView: UITableView

    init(frame: CGRect) {
        //if super.init(frame: frame)

        backgroundColor = UIColor.clear
        if let aView = tableView {
            addSubview(aView)
        }
        tableView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self).mas_offset(5)
            make.left.and().right().mas_equalTo(self)
            make.bottom.mas_equalTo(self).priorityLow()
        })

        registerCell(for: tableView)

    }

    func setExtension(_ `extension`: WXMomentExtension) {
        _extension = `extension`
        tableView.reloadData()
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func draw(_ rect: CGRect) {
        let startX: CGFloat = 20
        let startY: CGFloat = 0
        let endY: CGFloat = 5
        let width: CGFloat = 6
        let context = UIGraphicsGetCurrentContext()
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
        var section: Int = extension.likedFriends.count > 0  1 : 0
        section += extension.comments.count > 0  1 : 0
        return section
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && extension.likedFriends.count > 0 {
            return 1
        } else {
            return extension.comments.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && extension.likedFriends.count > 0 {
            // 点赞
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMomentExtensionLikedCell") as WXMomentExtensionLikedCell
            cell.likedFriends = extension.likedFriends
            return cell!
        } else {
            // 评论
            let comment = extension.comments[indexPath.row] as WXMomentComment
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLMomentExtensionCommentCell") as WXMomentExtensionCommentCell
            cell.comment = comment
            return cell!
        }
        return (tableView.dequeueReusableCell(withIdentifier: "EmptyCell"))!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && extension.likedFriends.count > 0 {
            return extension.extensionFrame.heightLiked
        } else {
            let comment = extension.comments[indexPath.row] as WXMomentComment
            return comment.commentFrame.height  0.0
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
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear
        selectionStyle = .none
        setBottomLineStyle(TLCellLineStyleFill)

    }
}
class WXMomentExtensionCommentCell: WXTableViewCell {
    var comment: WXMomentComment

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear
        setBottomLineStyle(TLCellLineStyleNone)

    }
}
class WXMomentBaseView: UIView {
    weak var delegate: WXMomentViewDelegate
    var titleLabel: UILabel
    var detailContainerView: UIView
    var extensionContainerView: UIView
    var moment: WXMoment
    private var avatarView: UIButton
    private var usernameView: UIButton
    private var dateLabel: UILabel
    private var originLabel: UILabel
    private var moreButton: UIButton
    private var extensionView: WXMomentExtensionView

    init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aView = avatarView {
            addSubview(aView)
        }
        if let aView = usernameView {
            addSubview(aView)
        }
        addSubview(detailContainerView)
        addSubview(extensionContainerView)
        if let aLabel = dateLabel {
            addSubview(aLabel)
        }
        if let aLabel = originLabel {
            addSubview(aLabel)
        }
        if let aButton = moreButton {
            addSubview(aButton)
        }

        if let aView = extensionView {
            extensionContainerView.addSubview(aView)
        }

        p_addMasonry()

    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func setMoment(_ moment: WXMoment) {
        self.moment = moment
        avatarView.sd_setImage(with: URL(string: moment.user.avatarURL  ""), for: UIControl.State.normal)
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

    // MARK: - Event Response
    func buttonClicked(_ sender: UIButton) {
        if sender.tag == Int(TLMomentViewButtonTypeAvatar) {
        } else if sender.tag == Int(TLMomentViewButtonTypeUserName) {
        } else if sender.tag == Int(TLMomentViewButtonTypeMore) {
        }
    }
    func p_addMasonry() {
        mas_makeConstraints({ make in
            make.edges.mas_equalTo(self)
        })
        avatarView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self).mas_offset(15)
            make.left.mas_equalTo(self).mas_offset(10)
            make.size.mas_equalTo(CGSize(width: 40, height: 40))
        })
        usernameView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.avatarView)
            make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(10)
            make.right.mas_lessThanOrEqualTo(self).mas_offset(-10)
            make.height.mas_equalTo(15.0)
        })
        detailContainerView.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.usernameView)
            make.top.mas_equalTo(self.usernameView.mas_bottom).mas_offset(8)
            make.right.mas_equalTo(self).mas_offset(-10)
        })
        dateLabel.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.detailContainerView.mas_bottom).mas_offset(8)
            make.left.mas_equalTo(self.usernameView)
        })
        originLabel.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.dateLabel)
            make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(10)
        })
        moreButton.mas_makeConstraints({ make in
            make.centerY.mas_equalTo(self.dateLabel)
            make.right.mas_equalTo(self.detailContainerView)
            make.size.mas_equalTo(CGSize(width: 25, height: 25))
        })
        extensionContainerView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.dateLabel.mas_bottom).mas_offset(8)
            make.left.and().right().mas_equalTo(self.detailContainerView)
            make.height.mas_equalTo(0)
        })

        extensionView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(0)
        })
    }
    func avatarView() -> UIButton {
        if avatarView == nil {
            avatarView = UIButton()
            avatarView.tag = TLMomentViewButtonTypeAvatar
            avatarView.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        }
        return avatarView
    }

    func usernameView() -> UIButton {
        if usernameView == nil {
            usernameView = UIButton()
            usernameView.tag = TLMomentViewButtonTypeUserName
            usernameView.titleLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
            usernameView.setTitleColor(UIColor(74.0, 99.0, 141.0, 1.0), for: .normal)
            usernameView.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        }
        return usernameView
    }
    func detailContainerView() -> UIView {
        if detailContainerView == nil {
            detailContainerView = UIView()
        }
        return detailContainerView
    }

    func extensionContainerView() -> UIView {
        if extensionContainerView == nil {
            extensionContainerView = UIView()
        }
        return extensionContainerView
    }

    func dateLabel() -> UILabel {
        if dateLabel == nil {
            dateLabel = UILabel()
            dateLabel.textColor = UIColor.gray
            dateLabel.font = UIFont.systemFont(ofSize: 12.0)
        }
        return dateLabel
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func originLabel() -> UILabel {
        if originLabel == nil {
            originLabel = UILabel()
            originLabel.textColor = UIColor.gray
            originLabel.font = UIFont.systemFont(ofSize: 12.0)
        }
        return originLabel
    }

    func moreButton() -> UIButton {
        if moreButton == nil {
            moreButton = UIButton()
            moreButton.tag = TLMomentViewButtonTypeMore
            moreButton.setImage(UIImage(named: "moments_more"), for: .normal)
            moreButton.setImage(UIImage(named: "moments_moreHL"), for: .selected)
            moreButton.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        }
        return moreButton
    }

    func extensionView() -> WXMomentExtensionView {
        if extensionView == nil {
            extensionView = WXMomentExtensionView()
        }
        return extensionView
    }

    
}
class WXMomentMultiImageView: UIView {
    weak var delegate: WXMomentMultiImageViewDelegate
    var images: [Any] = []
    private var imageViews: [AnyHashable] = []
    func setImages(_ images: [Any]) {
        self.images = images
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
        for i in 0..<(images.count  0) {
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
                    
    func buttonClicked(_ sender: UIButton) {
        if delegate && delegate.responds(to: #selector(self.momentViewClickImage(_:atIndex:))) {
            delegate.momentViewClickImage(images, at: sender.tag)
        }
    }



}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXMomentDetailBaseView: UIView {
    weak var delegate: WXMomentDetailViewDelegate
    var detail: WXMomentDetail
}

class WXMomentDetailTextView: WXMomentDetailBaseView {
    var titleLabel: UILabel

    override init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aLabel = titleLabel {
            addSubview(aLabel)
        }

        titleLabel.mas_makeConstraints({ make in
            make.left.and().right().and().top().mas_equalTo(self)
        })

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setDetail(_ detail: WXMomentDetail) {
        super.setDetail(detail)
        titleLabel.text = detail.text
        titleLabel.mas_updateConstraints({ make in
            make.height.mas_equalTo(detail.detailFrame.heightText)
        })
    }

    // MARK: -
    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 15.0)
            titleLabel.numberOfLines = 0
        }
        return titleLabel
    }

}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXMomentDetailImagesView: WXMomentDetailTextView {
    var multiImageView: WXMomentMultiImageView

    init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aView = multiImageView {
            addSubview(aView)
        }

        multiImageView.mas_makeConstraints({ make in
            make.left.and().right().and().bottom().mas_equalTo(self)
            make.top.mas_equalTo(self.titleLabel.mas_bottom)
        })

    }

    func setDetail(_ detail: WXMomentDetail) {
        super.detail = detail
        multiImageView.images = detail.images
        let offset: CGFloat = detail.images.count  0 > 0  (detail.text.length  0 > 0  7.0 : 3.0) : 0.0
        multiImageView.mas_updateConstraints({ make in
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(offset)
        })
    }
    func setDelegate(_ delegate: WXMomentDetailViewDelegate) {
        super.setDelegate(delegate)
        multiImageView().setDelegate(delegate)
    }

    // MARK: -
    func multiImageView() -> WXMomentMultiImageView {
        if multiImageView == nil {
            multiImageView = WXMomentMultiImageView()
            multiImageView.setDelegate(delegate)
        }
        return multiImageView
    }

}
class WXMomentImageView: WXMomentBaseView {
    private var detailView: WXMomentDetailImagesView

    init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aView = detailView {
            detailContainerView.addSubview(aView)
        }

        detailView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.detailContainerView)
        })

    }

    func setMoment(_ moment: WXMoment) {
        super.moment = moment
        detailView.detail = moment.detail
    }

    func setDelegate(_ delegate: WXMomentViewDelegate) {
        super.delegate = delegate
        detailView.delegate = delegate
    }

    func detailView() -> WXMomentDetailImagesView {
        if detailView == nil {
            detailView = WXMomentDetailImagesView()
        }
        return detailView
    }

    
}

class WXMomentDetailViewController: WXBaseViewController ,WXMomentViewDelegate {
    private var scrollView: UIScrollView
    private var momentView: WXMomentImageView

    var moment: WXMoment
    init() {
        //if super.init()

        navigationItem.title = "详情"
        view.backgroundColor = UIColor.white
        if let aView = scrollView {
            view.addSubview(aView)
        }
        if let aView = momentView {
            scrollView.addSubview(aView)
        }

        p_addMasonry()

    }

    func setMoment(_ moment: WXMoment) {
        _moment = moment
        momentView.moment = moment
        momentView.mas_updateConstraints({ make in
            make.height.mas_equalTo(moment.momentFrame.height)
        })
    }
    func momentViewClickImage(_ images: [Any], at index: Int) {
        var data = [AnyHashable](repeating: 0, count: images.count  0)
        for imageUrl: String in images as [String]  [] {
            let photo = MWPhoto(url: URL(string: imageUrl  ""))
            data.append(photo)
        }
        let browser = MWPhotoBrowser(photos: data)
        browser.displayNavArrows = true
        browser.currentPhotoIndex = index
        let broserNavC = WXNavigationController(rootViewController: browser)
        present(broserNavC, animated: false)
    }

    // MARK: -
    func p_addMasonry() {
        scrollView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(0)
        })
        momentView.mas_makeConstraints({ make in
            make.top.and().left().mas_equalTo(0)
            make.width.mas_equalTo(self.view)
        })
    }
    func momentView() -> WXMomentImageView {
        if momentView == nil {
            momentView = WXMomentImageView()
            momentView.delegate = self
        }
        return momentView
    }

    var scrollView: UIScrollView {
        if scrollView == nil {
            scrollView = UIScrollView()
            scrollView.alwaysBounceVertical = true
        }
        return scrollView
    }


    
}
