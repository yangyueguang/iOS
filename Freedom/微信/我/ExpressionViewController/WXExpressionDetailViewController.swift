//
//  WXExpressionDetailViewController.swift
//  Freedom

import Foundation
protocol WXExpressionDetailCellDelegate: NSObjectProtocol {
    func expressionDetailCellDownloadButtonDown(_ group: TLEmojiGroup)
}

class WXExpressionDetailCell: UICollectionViewCell {
    weak var delegate: WXExpressionDetailCellDelegate
    var group: TLEmojiGroup

    class func cellHeight(forModel group: TLEmojiGroup) -> CGFloat {
    }

    var bannerView: UIImageView
    var titleLabel: UILabel
    var downloadButton: UIButton
    var detailLabel: UILabel
    init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bannerView)
        if let aLabel = titleLabel {
            contentView.addSubview(aLabel)
        }
        contentView.addSubview(downloadButton)
        contentView.addSubview(detailLabel)

        p_addMasonry()

    }
    func setGroup(_ group: TLEmojiGroup) {
        self.group = group
        if group.bannerURL.length > 0 {
            bannerView.sd_setImage(with: URL(string: group.bannerURL))
            bannerView.mas_updateConstraints({ make in
                make.height.mas_equalTo((APPW * 0.45))
            })
        } else {
            bannerView.mas_updateConstraints({ make in
                make.height.mas_equalTo(0)
            })
        }
        titleLabel.text = group.groupName
        detailLabel.text = group.groupDetailInfo
        if group.status == TLEmojiGroupStatusDownloaded {
            downloadButton.setTitle("已下载", for: .normal)
            downloadButton.backgroundColor = UIColor.gray
        } else if group.status == TLEmojiGroupStatusDownloading {
            downloadButton.setTitle("下载中", for: .normal)
            downloadButton.backgroundColor = UIColor.green
        } else {
            downloadButton.setTitle("下载", for: .normal)
            downloadButton.backgroundColor = UIColor.green
        }
    }
    func p_addMasonry() {
        bannerView.mas_makeConstraints({ make in
            make.left.and().right().and().top().mas_equalTo(self.contentView)
        })
        titleLabel.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.bannerView.mas_bottom).mas_offset(25.0)
            make.left.mas_equalTo(15.0)
            make.right.mas_lessThanOrEqualTo(self.downloadButton.mas_right).mas_offset(-15)
        })
        downloadButton.mas_makeConstraints({ make in
            make.centerY.mas_equalTo(self.titleLabel).mas_offset(-2)
            make.right.mas_equalTo(self.contentView).mas_offset(-15.0)
            make.size.mas_equalTo(CGSize(width: 75, height: 26))
        })
        detailLabel.mas_makeConstraints({ make in
            make.left.mas_equalTo(self.titleLabel)
            make.right.mas_equalTo(self.contentView).mas_offset(-15)
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20)
        })
        let line1 = UIView()
        line1.backgroundColor = UIColor.gray
        contentView.addSubview(line1)
        let line2 = UIView()
        line2.backgroundColor = UIColor.gray
        contentView.addSubview(line2)
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.text = "长按表情可预览"
        contentView.addSubview(label)
        label.mas_makeConstraints({ make in
            make.bottom.mas_equalTo(-5.0)
            make.left.mas_equalTo(line1.mas_right).mas_offset(5.0)
            make.right.mas_equalTo(line2.mas_left).mas_offset(-5.0)
        })
        line1.mas_makeConstraints({ make in
            make.height.mas_equalTo(1)
            make.left.mas_equalTo(15.0)
            make.centerY.mas_equalTo(label)
            make.width.mas_equalTo(line2)
        })
        line2.mas_makeConstraints({ make in
            make.height.mas_equalTo(1)
            make.right.mas_equalTo(-15.0)
            make.centerY.mas_equalTo(label)
        })
    }
    func downloadButtonDown(_ sender: UIButton) {
        sender.setTitle("下载中", for: .normal)
        if delegate && delegate.responds(to: #selector(self.expressionDetailCellDownloadButtonDown(_:))) {
            delegate.expressionDetailCellDownloadButtonDown(group)
        }
    }

    // MARK: - Getter
    func bannerView() -> UIImageView {
        if bannerView == nil {
            bannerView = UIImageView()
        }
        return bannerView
    }

    var titleLabel: UILabel {
        if titleLabel == nil {
            titleLabel = UILabel()
        }
        return titleLabel
    }
    func downloadButton() -> UIButton {
        if downloadButton == nil {
            downloadButton = UIButton()
            downloadButton.setTitle("下载", for: .normal)
            downloadButton.backgroundColor = UIColor.green
            downloadButton.titleLabel.font = UIFont.systemFont(ofSize: 13.0)
            downloadButton.layer.masksToBounds = true
            downloadButton.layer.cornerRadius = 3.0
            downloadButton.layer.borderWidth = 1
            downloadButton.layer.borderColor = UIColor.gray.cgColor
            downloadButton.addTarget(self, action: #selector(self.downloadButtonDown(_:)), for: .touchUpInside)
        }
        return downloadButton
    }
    func detailLabel() -> UILabel {
        if detailLabel == nil {
            detailLabel = UILabel()
            detailLabel.font = UIFont.systemFont(ofSize: 13.0)
            detailLabel.textColor = UIColor.gray
            detailLabel.numberOfLines = 0
        }
        return detailLabel
    }

    // MARK: - Class Methods
    class func cellHeight(forModel group: TLEmojiGroup) -> CGFloat {
        let detailHeight: CGFloat = group.groupDetailInfo.boundingRect(with: CGSize(width: APPW - 30, height: MAXFLOAT), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)], context: nil).size.height
        let bannerHeight: CGFloat = group.bannerURL.length > 0 ? (APPW * 0.45) : 0
        let height: CGFloat = 105.0 + (detailHeight) + bannerHeight
        return height
    }
}

class WXExpressionItemCell: UICollectionViewCell {
    private var _emoji: TLEmoji
    var emoji: TLEmoji {
        get {
            return _emoji
        }
        set(emoji) {
            _emoji = emoji
            let image = UIImage(named: emoji.emojiPath)
            if image != nil {
                imageView.image = image
            } else {
                imageView.sd_setImage(with: URL(string: emoji.emojiURL))
            }
        }
    }
    var imageView: UIImageView

    override init(frame: CGRect) {
        super.init(frame: frame)

        if let aView = imageView {
            contentView.addSubview(aView)
        }

        p_addMasonry()

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func p_addMasonry() {
        imageView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.contentView)
        })
    }

    // MARK: - Getter
    var imageView: UIImageView {
        if imageView == nil {
            imageView = UIImageView()
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 3.0
        }
        return imageView
    }

}
class WXExpressionDetailViewController: WXBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WXExpressionDetailCellDelegate {
    var kPageIndex: Int = 0

    var group: TLEmojiGroup
    var emojiDisplayView: WXImageExpressionDisplayView
    var proxy: WXExpressionHelper
    var collectionView: UICollectionView
    func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true

        view.addSubview(collectionView)

        registerCell(for: collectionView)

        let longPressGR = UILongPressGestureRecognizer()
        longPressGR.minimumPressDuration = 1.0
        longPressGR.addTarget(self, action: #selector(self.didLongPressScreen(_:)))
        collectionView.addGestureRecognizer(longPressGR)

        let tapGR = UITapGestureRecognizer()
        tapGR.numberOfTapsRequired = 5
        tapGR.numberOfTouchesRequired = 1
        tapGR.addTarget(self, action: #selector(self.didTap5TimesScreen(_:)))
        collectionView.addGestureRecognizer(tapGR)
    }
    
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if group.data == nil {
            SVProgressHUD.show()
            p_loadData()
        }
    }

    func setGroup(_ group: TLEmojiGroup) {
        self.group = group
        navigationItem.title = group.groupName
        //    [self.collectionView reloadData];
    }

    // MARK: - Private Methods
    func p_loadData() {
        kPageIndex = 1
        weak var weakSelf = self
        proxy.requestExpressionGroupDetail(by: group.groupID, pageIndex: kPageIndex, success: { data in
            SVProgressHUD.dismiss()
            weakSelf.group.data = data
            weakSelf.collectionView.reloadData()
        }, failure: { error in
            SVProgressHUD.dismiss()
        })
    }
    func proxy() -> WXExpressionHelper {
        if proxy == nil {
            proxy = WXExpressionHelper.shared()
        }
        return proxy
    }

    func emojiDisplayView() -> WXImageExpressionDisplayView {
        if emojiDisplayView == nil {
            emojiDisplayView = WXImageExpressionDisplayView()
        }
        return emojiDisplayView
    }

    func registerCell(for collectionView: UICollectionView) {
        collectionView.register(WXExpressionItemCell.self, forCellWithReuseIdentifier: "TLExpressionItemCell")
        collectionView.register(WXExpressionDetailCell.self, forCellWithReuseIdentifier: "TLExpressionDetailCell")
    }
    func didLongPressScreen(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended || sender.state == .cancelled {
            // 长按停止
            emojiDisplayView.removeFromSuperview()
        } else {
            let point: CGPoint = sender.location(in: collectionView)
            for cell: UICollectionViewCell in collectionView.visibleCells {
                if cell.frame.origin.x <= (point.x) && cell.frame.origin.y <= (point.y) && cell.frame.origin.x + cell.frame.size.width >= (point.x) && cell.frame.origin.y + cell.frame.size.height >= (point.y) {
                    let indexPath: IndexPath = collectionView.indexPath(for: cell)
                    let emoji = group[indexPath.row] as TLEmoji
                    let rect: CGRect = cell.frame
                    rect.origin.y -= collectionView.contentOffset.y + 13
                    emojiDisplayView.removeFromSuperview()
                    emojiDisplayView.displayEmoji(emoji, atRect: rect)
                    view.addSubview(emojiDisplayView)
                    break
                }
            }
        }
    }
    func didTap5TimesScreen(_ sender: UITapGestureRecognizer) {
        let point: CGPoint = sender.location(in: collectionView)
        for cell: UICollectionViewCell in collectionView.visibleCells {
            if cell.frame.origin.x <= (point.x) && cell.frame.origin.y <= (point.y) && cell.frame.origin.x + cell.frame.size.width >= (point.x) && cell.frame.origin.y + cell.frame.size.height >= (point.y) {
                let indexPath: IndexPath = collectionView.indexPath(for: cell)
                let emoji = group[indexPath.row] as TLEmoji
                SVProgressHUD.show(withStatus: "正在将表情保存到系统相册")
                var urlString: String = nil
                if let anID = emoji.emojiID {
                    urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(anID)"
                }
                var data: Data = nil
                if let aString = URL(string: urlString) {
                    data = Data(contentsOf: aString)
                }
                if data == nil {
                    data = NSData(contentsOfFile: emoji.emojiPath) as Data
                }
                if data != nil {
                    var image: UIImage = nil
                    if let aData = data {
                        image = UIImage(data: aData)
                    }
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
                break
            }
        }
    }
    func image(_ image: UIImage, didFinishSavingWithError error: Error, contextInfo: UnsafeMutableRawPointer) {
        if error != nil {
            if let aDescription = error.description() {
                SVProgressHUD.showError(withStatus: "保存图片到系统相册失败\n\(aDescription)")
            }
        } else {
            SVProgressHUD.showSuccess(withStatus: "已保存到系统相册")
        }
    }

    // MARK: - Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return group.data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLExpressionDetailCell", for: indexPath) as WXExpressionDetailCell
            cell.group = group
            cell.delegate = self
            return cell!
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLExpressionItemCell", for: indexPath) as WXExpressionItemCell
        let emoji = group[indexPath.row] as TLEmoji
        cell.emoji = emoji
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let height = WXExpressionDetailCell.cellHeight(forModel: group)
            return CGSize(width: collectionView.frame.size.width, height: height)
        } else {
            return CGSize(width: (APPW - 20 * 2 - 15 * 3.0) / 4.0, height: (APPW - 20 * 2 - 15 * 3.0) / 4.0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? .zero : UIEdgeInsetsMake(20, 20, 20, 20)
    }
    func expressionDetailCellDownloadButtonDown(_ group: TLEmojiGroup) {
        WXExpressionHelper.shared().downloadExpressions(withGroupInfo: group, progress: { progress in

        }, success: { group in
            group.status = TLEmojiGroupStatusDownloaded
            self.collectionView.reloadData()
            let ok = WXExpressionHelper.shared().addExpressionGroup(group)
            if !ok {
                if let aName = group.groupName {
                    SVProgressHUD.showError(withStatus: "表情 \(aName) 存储失败！")
                }
            }
        }, failure: { group, error in
            group.status = TLEmojiGroupStatusUnDownload
            self.collectionView.reloadData()
            if let aName = group.groupName {
                SVProgressHUD.showError(withStatus: "\"\(aName)\" 下载失败: \(error)")
            }
        })
    }




}
