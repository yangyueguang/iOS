//
//  WXChatFileViewController.swift
//  Freedom
import MWPhotoBrowser
import Foundation
class WXChatFileCell: UICollectionViewCell {
    var message: WXMessage = WXMessage() {
        didSet {
            if message.messageType == .image {
                let me = message as! WXImageMessage
                let imagePath = me.content.path
                let imageURL = me.content.url
                if !imagePath.isEmpty {
                    let imagePatha = FileManager.pathUserChatImage(imagePath)
                    imageView.image = UIImage(named: imagePatha)
                } else if !imageURL.isEmpty {
                    imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "userLogo"))
                } else {
                    imageView.image = nil
                }
            }
        }
    }
    private var imageView = UIImageView()
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

class WXChatFileHeaderView: UICollectionReusableView {
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
        bgView.alpha = 0.8
        return bgView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        return titleLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(bgView)
        addSubview(titleLabel)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class WXChatFileViewController: WXBaseViewController {
    var collectionView: BaseCollectionView!
    var partnerID = "" {
        didSet {
            WXMessageManager.shared.chatFiles(forPartnerID: partnerID, completed: { data in
                self.data.removeAll()
                self.mediaData = []
                self.data.append(contentsOf: data)
                self.collectionView.reloadData()
            })
        }
    }
    var data: [[WXMessage]] = []
    lazy var mediaData: [WXMessage] = {
        var mediaData: [WXMessage] = []
        for array in data {
            for message: WXMessage in array {
                if message.messageType == .image {
                    mediaData.append(message)
                    var url: URL?
                    let me = message as! WXImageMessage
                    let path = me.content.path
                    if !path.isEmpty {
                        let imagePath = FileManager.pathUserChatImage(path)
                        url = URL(fileURLWithPath: imagePath)
                    } else {
                        url = URL(string: me.content.url)
                    }
                    let photo = MWPhoto(url: url)
                    browserData.append(photo!)
                }
            }
        }
        return mediaData
    }()
    lazy var browserData: [MWPhoto] = {
        var browserData = [MWPhoto]()
        for message: WXMessage in mediaData {
            if message.messageType == .image {
                var url: URL?
                let imagePath = message.content.path
                if !imagePath.isEmpty {
                    let imagePatha = FileManager.pathUserChatImage(imagePath)
                    url = URL(fileURLWithPath: imagePatha)
                } else {
                    url = URL(string: message.content.url)
                }
                let photo = MWPhoto(url: url)
                browserData.append(photo!)
            }
        }
        return browserData
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "聊天文件"
        view.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
        let layout = UICollectionViewFlowLayout()
        if Float(UIDevice.current.systemVersion) ?? 0 >= 9.0 {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        layout.itemSize = CGSize(width: APPW / 4 * 0.98, height: APPW / 4 * 0.98)
        layout.minimumInteritemSpacing = (APPW - APPW / 4 * 0.98 * 4) / 3
        layout.minimumLineSpacing = (APPW - APPW / 4 * 0.98 * 4) / 3
        layout.headerReferenceSize = CGSize(width: APPW, height: 28)
        layout.footerReferenceSize = CGSize(width: APPW, height: 0)
        collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        let rightBarButton = UIBarButtonItem(title: "选择", action: {
            
        })
        navigationItem.rightBarButtonItem = rightBarButton
        collectionView.register(WXChatFileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TLChatFileHeaderView")
        collectionView.register(WXChatFileCell.self, forCellWithReuseIdentifier: "TLChatFileCell")
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
}
extension WXChatFileViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsIncollectionView(_ collectionView: UICollectionView) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let temp = data[section]
        return temp.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let message = data[indexPath.section][indexPath.row] as WXMessage
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TLChatFileHeaderView", for: indexPath) as! WXChatFileHeaderView
        headerView.title = message.date.timeToNow()
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = data[indexPath.section][indexPath.row] as WXMessage
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLChatFileCell", for: indexPath) as! WXChatFileCell
        cell.message = message
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = data[indexPath.section][indexPath.row] as WXMessage
        if message.messageType == .image {
            var index: Int = -1
            for i in 0..<mediaData.count {
                if (message.messageID == mediaData[i].messageID) {
                    index = i
                    break
                }
            }
            if index >= 0 {
                let browser = MWPhotoBrowser(photos: browserData)
                browser?.displayNavArrows = true
                browser?.setCurrentPhotoIndex(UInt(index))
                let broserNavC = WXNavigationController(rootViewController: browser!)
                present(broserNavC, animated: false)
            }
        }
    }
}
