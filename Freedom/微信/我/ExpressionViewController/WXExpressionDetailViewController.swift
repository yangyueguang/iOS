//
//  WXExpressionDetailViewController.swift
//  Freedom

import Foundation
protocol WXExpressionDetailCellDelegate: NSObjectProtocol {
    func expressionDetailCellDownloadButtonDown(_ group: TLEmojiGroup)
}

class WXExpressionDetailCell: UICollectionViewCell {
    weak var delegate: WXExpressionDetailCellDelegate?
    var group: TLEmojiGroup = TLEmojiGroup() {
        didSet {
            if group.bannerURL.count > 0 {
                bannerView.sd_setImage(with: URL(string: group.bannerURL))
                bannerView.snp.updateConstraints { (make) in
                    make.height.equalTo(APPW * 0.45)
                }
            } else {
                bannerView.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            }
            titleLabel.text = group.groupName
            detailLabel.text = group.groupDetailInfo
            if group.status == .downloaded {
                downloadButton.setTitle("已下载", for: .normal)
                downloadButton.backgroundColor = UIColor.gray
            } else if group.status == .downloading {
                downloadButton.setTitle("下载中", for: .normal)
                downloadButton.backgroundColor = UIColor.green
            } else {
                downloadButton.setTitle("下载", for: .normal)
                downloadButton.backgroundColor = UIColor.green
            }
        }
    }
    var bannerView = UIImageView()
    var titleLabel = UILabel()
    lazy var downloadButton: UIButton = {
        let downloadButton = UIButton()
        downloadButton.setTitle("下载", for: .normal)
        downloadButton.backgroundColor = UIColor.green
        downloadButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        downloadButton.layer.masksToBounds = true
        downloadButton.layer.cornerRadius = 3.0
        downloadButton.layer.borderWidth = 1
        downloadButton.layer.borderColor = UIColor.gray.cgColor
        downloadButton.addTarget(self, action: #selector(self.downloadButtonDown(_:)), for: .touchUpInside)
        return downloadButton
    }()
    lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = UIFont.systemFont(ofSize: 13.0)
        detailLabel.textColor = UIColor.gray
        detailLabel.numberOfLines = 0
        return detailLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bannerView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(detailLabel)
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
        bannerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.contentView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.bannerView.snp.bottom).offset(25)
            make.left.equalTo(15)
            make.right.lessThanOrEqualTo(self.downloadButton.snp.right).offset(-15)
        }

        downloadButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLabel).offset(-2)
            make.right.equalTo(self.contentView).offset(-15)
            make.size.equalTo(CGSize(width: 75, height: 26))
        }
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.right.equalTo(self.contentView).offset(-15)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
        }
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(-5)
            make.left.equalTo(line1.snp.right).offset(5)
            make.right.equalTo(line1.snp.left).offset(-5)
        }
        line1.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalTo(15)
            make.centerY.equalTo(label)
            make.width.equalTo(line2)
        }
        line2.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.right.equalTo(-15)
            make.centerY.equalTo(label)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func downloadButtonDown(_ sender: UIButton) {
        sender.setTitle("下载中", for: .normal)
        delegate?.expressionDetailCellDownloadButtonDown(group)
    }

    class func cellHeight(forModel group: TLEmojiGroup) -> CGFloat {
        let detailHeight: CGFloat = group.groupDetailInfo.boundingRect(with: CGSize(width: APPW - 30, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)], context: nil).size.height
        let bannerHeight: CGFloat = group.bannerURL.count > 0 ? (APPW * 0.45) : 0
        let height: CGFloat = 105.0 + (detailHeight) + bannerHeight
        return height
    }
}

class WXExpressionItemCell: UICollectionViewCell {
    var emoji: TLEmoji = TLEmoji() {
        didSet {
            let image = UIImage(named: emoji.emojiPath)
            if image != nil {
                imageView.image = image
            } else {
                imageView.sd_setImage(with: URL(string: emoji.emojiURL))
            }
        }
    }
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3.0
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class WXExpressionDetailViewController: WXBaseViewController {
    var kPageIndex: Int = 0
    var group: TLEmojiGroup = TLEmojiGroup() {
        didSet {
            navigationItem.title = group.groupName
        }
    }
    var emojiDisplayView = WXImageExpressionDisplayView()
    var proxy = WXExpressionHelper.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        collectionView = BaseCollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(WXExpressionItemCell.self, forCellWithReuseIdentifier: "TLExpressionItemCell")
        collectionView.register(WXExpressionDetailCell.self, forCellWithReuseIdentifier: "TLExpressionDetailCell")
        let longPressGR = UILongPressGestureRecognizer()
        longPressGR.minimumPressDuration = 1.0
        longPressGR.addTarget(self, action: #selector(self.didLongPressScreen(_:)))
        collectionView.addGestureRecognizer(longPressGR)
        let tapGR = UITapGestureRecognizer()
        tapGR.numberOfTapsRequired = 5
        tapGR.numberOfTouchesRequired = 1
        tapGR.addTarget(self, action: #selector(self.didTap5TimesScreen(_:)))
        collectionView.addGestureRecognizer(tapGR)
        view.addSubview(collectionView)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if group.data.count <= 0 {
            XHud.show()
            kPageIndex = 1
            proxy.requestExpressionGroupDetail(byGroupID: group.groupID, pageIndex: kPageIndex, success: { data in
                XHud.hide()
                self.group.data = data
                self.collectionView.reloadData()
            }, failure: { error in
                XHud.hide()
            })
        }
    }
    func didLongPressScreen(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended || sender.state == .cancelled {// 长按停止
            emojiDisplayView.removeFromSuperview()
        } else {
            let point: CGPoint = sender.location(in: collectionView)
            for cell: UICollectionViewCell in collectionView.visibleCells {
                if cell.frame.origin.x <= (point.x) && cell.frame.origin.y <= (point.y) && cell.frame.origin.x + cell.frame.size.width >= (point.x) && cell.frame.origin.y + cell.frame.size.height >= (point.y) {
                    let indexPath: IndexPath = collectionView.indexPath(for: cell) ?? IndexPath(row: 0, section: 0)
                    let emoji = group.data[indexPath.row]
                    var rect: CGRect = cell.frame
                    rect.origin.y -= collectionView.contentOffset.y + 13
                    emojiDisplayView.removeFromSuperview()
                    emojiDisplayView.display(emoji, at: rect)
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
                let indexPath: IndexPath = collectionView.indexPath(for: cell) ?? IndexPath(row: 0, section: 0)
                let emoji = group.data[indexPath.row]
                XHud.show(.withDetail(message: "正在将表情保存到系统相册"))
                let urlString = "http://123.57.155.230:8080/ibiaoqing/admin/expre/download.dopId=\(emoji.emojiID)"
                var data = try? Data(contentsOf: URL(string: urlString)!)
                if data == nil {
                    data = try? Data(contentsOf: URL(fileURLWithPath: emoji.emojiPath))
                }
                let image = UIImage(data: data!)
                UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                break
            }
        }
    }
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
        if error != nil {
            noticeError("保存图片到系统相册失败\n\(String(describing: error?.localizedDescription))")
        } else {
            noticeSuccess("已保存到系统相册")
        }
    }
}
extension WXExpressionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,WXExpressionDetailCellDelegate{
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLExpressionDetailCell", for: indexPath) as! WXExpressionDetailCell
            cell.group = group
            cell.delegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLExpressionItemCell", for: indexPath) as! WXExpressionItemCell
        let emoji = group.data[indexPath.row]
        cell.emoji = emoji
        return cell
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
        return section == 0 ? .zero : UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    func expressionDetailCellDownloadButtonDown(_ group: TLEmojiGroup) {
        WXExpressionHelper.shared.downloadExpressions(withGroupInfo: group, progress: { progress in
        }, success: { group in
            group.status = .downloaded
            self.collectionView.reloadData()
            let ok = WXExpressionHelper.shared.addExpressionGroup(group)
            if !ok {
                self.noticeError("表情 \(group.groupName) 存储失败！")
            }
        }, failure: { group, error in
            group.status = .unDownload
            self.collectionView.reloadData()
            self.noticeError("\(group.groupName) 下载失败: \(error)")
        })
    }
}
