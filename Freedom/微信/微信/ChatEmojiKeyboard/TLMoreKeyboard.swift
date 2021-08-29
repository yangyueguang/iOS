//
//  TLMoreKeyboard.swift
//  Freedom
import SnapKit
//import XExtension
import Foundation
// 使用
/*
    let keboard = TLMoreKeyboard.shared
    keboard.chatMoreKeyboardData = [TLMoreKeyboardItem()]
    keboard.show(in: UIView(), withAnimation: true)
    keboard.dismiss(withAnimation: true)
 */
struct TLMoreKeyboardItem {
    var type = TLMoreKeyboardItemType.image
    var title = ""
    var imagePath = ""
}

class TLMoreKeyboard: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    static let shared = TLMoreKeyboard()
    var clickBlock: ((_ item: TLMoreKeyboardItem) -> Void)?
    weak var keyboardDelegate: XKeyboardDelegate?
    var chatMoreKeyboardData: [TLMoreKeyboardItem] = [] {
        didSet {
            collectionView.reloadData()
            let pageNumber: Int = chatMoreKeyboardData.count / 8 + (chatMoreKeyboardData.count % 8 == 0 ? 0 : 1)
            pageControl.numberOfPages = pageNumber
        }
    }
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let h: CGFloat = (215.0 * 0.85 - 15) / 2 * 0.93
        let spaceX: CGFloat = (APPW - 60 * 4) / 5
        let spaceY: CGFloat = (215.0 * 0.85 - 15) - h * 2
        layout.itemSize = CGSize(width: 60, height: CGFloat(h))
        layout.minimumInteritemSpacing = CGFloat(spaceY)
        layout.minimumLineSpacing = CGFloat(spaceX)
        layout.headerReferenceSize = CGSize(width: CGFloat(spaceX), height: 215.0 * 0.85 - 15)
        layout.footerReferenceSize = CGSize(width: CGFloat(spaceX), height: 215.0 * 0.85 - 15)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        return collectionView
    }()
    lazy var pageControl: UIPageControl =  {
        let pageControl = UIPageControl()
        pageControl.center = CGPoint(x: center.x, y: pageControl.center.y)
        pageControl.pageIndicatorTintColor = UIColor.grayx
        pageControl.currentPageIndicatorTintColor = UIColor.grayx
        pageControl.addTarget(self, action: #selector(self.pageControlChanged(_:)), for: .valueChanged)
        return pageControl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.back
        addSubview(collectionView)
        addSubview(pageControl)
        collectionView.register(TLMoreKeyboardCell.self, forCellWithReuseIdentifier: TLMoreKeyboardCell.identifier)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(215 * 0.85 - 15)
        }
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.collectionView.snp.bottom)
            make.bottom.equalToSuperview().offset(-2)
        }
        self.chatMoreKeyboardData = WXMoreKBHelper().chatMoreKeyboardData
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show(in view: UIView, withAnimation animation: Bool) {
        keyboardDelegate?.chatKeyboardWillShow?(self)
        view.addSubview(self)
        self.snp.remakeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(215)
            make.bottom.equalTo(view).offset(215)
        }
        view.layoutIfNeeded()
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(view)
                })
                view.layoutIfNeeded()
                self.keyboardDelegate?.chatKeyboard?(self, didChangeHeight: (view.frame.size.height) - self.frame.origin.y)
            }) { finished in
                self.keyboardDelegate?.chatKeyboardDidShow?(self)
            }
        } else {
            self.snp.updateConstraints { (make) in
                make.bottom.equalTo(view)
            }
            view.layoutIfNeeded()
            keyboardDelegate?.chatKeyboardDidShow?(self)
        }
    }

    func dismiss(withAnimation animation: Bool) {
        keyboardDelegate?.chatKeyboardWillDismiss?(self)
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                if self.superview != nil {
                    self.snp.updateConstraints({ (make) in
                        make.bottom.equalToSuperview()
                        make.height.equalTo(0)
                    })
                }
                self.superview?.layoutIfNeeded()
                self.keyboardDelegate?.chatKeyboard?(self, didChangeHeight: (self.superview?.frame.size.height ?? 0) - self.frame.origin.y)
            }) { finished in
                self.removeFromSuperview()
                self.keyboardDelegate?.chatKeyboardDidDismiss?(self)
            }
        } else {
            removeFromSuperview()
            keyboardDelegate?.chatKeyboardDidDismiss?(self)
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: APPW, y: 0))
        context.strokePath()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(TLMoreKeyboardCell.self, for: indexPath)
        let index: Int = indexPath.section * 8 + indexPath.row
        let tIndex = transformIndex(index) // 矩阵坐标转置
        if tIndex >= chatMoreKeyboardData.count {
            cell.item = nil
        } else {
            cell.item = chatMoreKeyboardData[tIndex]
        }
        cell.clickBlock = clickBlock
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chatMoreKeyboardData.count / 8 + (chatMoreKeyboardData.count % 8 == 0 ? 0 : 1)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / APPW)
    }
    private func transformIndex(_ index: Int) -> Int {
        var index = index
        let page: Int = index / 8
        index = index % 8
        let x: Int = index / 2
        let y: Int = index % 2
        return 4 * y + x + page * 8
    }
    @objc private func pageControlChanged(_ pageControl: UIPageControl) {
        collectionView.scrollRectToVisible(CGRect(x: collectionView.frame.size.width * CGFloat(pageControl.currentPage), y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height), animated: true)
    }
}

class TLMoreKeyboardCell: UICollectionViewCell {
    var clickBlock: ((_ item: TLMoreKeyboardItem) -> Void)?
    var item: TLMoreKeyboardItem? {
        didSet {
            if item == nil {
                titleLabel.isHidden = true
                iconButton.isHidden = true
                isUserInteractionEnabled = false
                return
            }
            isUserInteractionEnabled = true
            titleLabel.isHidden = false
            iconButton.isHidden = false
            titleLabel.text = item?.title
            iconButton.setImage(item?.imagePath.image, for: .normal)
        }
    }
    private lazy var iconButton: UIButton = {
        let iconButton = UIButton()
        iconButton.layer.masksToBounds = true
        iconButton.layer.cornerRadius = 5.0
        iconButton.layer.borderWidth = 1
        iconButton.layer.borderColor = UIColor.grayx.cgColor
        iconButton.setBackgroundImage(UIImage.imageWithColor(UIColor.grayx), for: .highlighted)
        iconButton.addTarget(self, action: #selector(self.iconButtonDown(_:)), for: .touchUpInside)
        return iconButton
    }()
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.small
        titleLabel.textColor = UIColor.grayx
        return titleLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconButton)
        contentView.addSubview(titleLabel)
        iconButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(self.contentView)
            make.height.equalTo(self.iconButton.snp.width)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc func iconButtonDown(_ sender: UIButton) {
        clickBlock?(item!)
    }
}

class WXMoreKBHelper: NSObject {
    var chatMoreKeyboardData: [TLMoreKeyboardItem] = []
    override init() {
        super.init()
        let imageItem = TLMoreKeyboardItem(type: .image, title: "照片", imagePath: "moreKB_image")
        let cameraItem = TLMoreKeyboardItem(type: .camera, title: "拍摄", imagePath: "moreKB_video")
        let videoItem = TLMoreKeyboardItem(type: .video, title: "小视频", imagePath: "moreKB_sight")
        let videoCallItem = TLMoreKeyboardItem(type: .videoCall, title: "视频聊天", imagePath: "moreKB_video_call")
        let walletItem = TLMoreKeyboardItem(type: .wallet, title: "红包", imagePath: "moreKB_wallet")
        let transferItem = TLMoreKeyboardItem(type: .transfer, title: "转账", imagePath: "moreKB_pay")
        let positionItem = TLMoreKeyboardItem(type: .position, title: "位置", imagePath: "moreKB_location")
        let favoriteItem = TLMoreKeyboardItem(type: .favorite, title: "收藏", imagePath: "moreKB_favorite")
        let businessCardItem = TLMoreKeyboardItem(type: .businessCard, title: "个人名片", imagePath: "moreKB_friendcard")
        let voiceItem = TLMoreKeyboardItem(type: .voice, title: "语音输入", imagePath: "moreKB_voice")
        let cardsItem = TLMoreKeyboardItem(type: .cards, title: "卡券", imagePath: "moreKB_wallet")
        chatMoreKeyboardData.append(contentsOf: [imageItem, cameraItem, videoItem, videoCallItem, walletItem, transferItem, positionItem, favoriteItem, businessCardItem, voiceItem, cardsItem])
    }
}
