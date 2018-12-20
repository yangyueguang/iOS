//
//  WXChatFileViewController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/20.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
class WXChatFileCell: UICollectionViewCell {
    var message: WXMessage?
    private var imageView: UIImageView?

    override init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aView = imageView {
            contentView.addSubview(aView)
        }
        p_addMasonry()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setMessage(_ message: WXMessage?) {
        self.message = message
        if message?.messageType == TLMessageTypeImage {
            let me = message as? WXImageMessage
            let imagePath = me?.content["path"]
            let imageURL = me?.content["url"]
            if (imagePath?.count ?? 0) > 0 {
                let imagePatha = FileManager.pathUserChatImage(imagePath)
                imageView?.image = UIImage(named: imagePatha)
            } else if (imageURL?.count ?? 0) > 0 {
                imageView?.sd_setImage(with: URL(string: imageURL ?? ""), placeholderImage: UIImage(named: "userLogo"))
            } else {
                imageView?.image = nil
            }
        }
    }
    func p_addMasonry() {
        imageView?.mas_makeConstraints({ make in
            make?.edges.mas_equalTo(self.contentView)
        })
    }

    // MARK: - Getter -
    var imageView: UIImageView? {
        if imageView == nil {
            imageView = UIImageView()
        }
        return imageView
    }




    
}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
class WXChatFileHeaderView: UICollectionReusableView {
    var title = ""
    var bgView: UIView?
    var titleLabel: UILabel?

    override init(frame: CGRect) {
        //if super.init(frame: frame)

        backgroundColor = UIColor.clear
        if let aView = bgView {
            addSubview(aView)
        }
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }
        p_addMasonry()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func setTitle(_ title: String?) {
        self.title = title
        titleLabel?.text = title
    }

    // MARK: - Private Methods -
    func p_addMasonry() {
        bgView()?.mas_makeConstraints({ make in
            make?.edges.mas_equalTo(self)
        })
        titleLabel?.mas_makeConstraints({ make in
            make?.edges.mas_equalTo(self).mas_offset(UIEdgeInsetsMake(0, 10, 0, 10))
        })
    }

    // MARK: - Getter -
    func bgView() -> UIView? {
        if bgView == nil {
            bgView = UIView()
            bgView.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
            bgView.alpha = 0.8
        }
        return bgView
    }
    var titleLabel: UILabel? {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        }
        return titleLabel
    }


}
class WXChatFileViewController: WXBaseViewController {
    var partnerID = ""
    var data: [AnyHashable] = []
    var mediaData: [AnyHashable] = []
    var browserData: [AnyHashable] = []
    var collectionView: UICollectionView?
    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem?.title = "聊天文件"
        view.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
        let layout = UICollectionViewFlowLayout()
        if Float(UIDevice.current.systemVersion) ?? 0.0 >= 9.0 {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        layout.itemSize = CGSize(width: APPW / 4 * 0.98, height: APPW / 4 * 0.98)
        layout.minimumInteritemSpacing = (APPW - APPW / 4 * 0.98 * 4) / 3
        layout.minimumLineSpacing = (APPW - APPW / 4 * 0.98 * 4) / 3
        layout.headerReferenceSize = CGSize(width: APPW, height: 28)
        layout.footerReferenceSize = CGSize(width: APPW, height: 0)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true

        view.addSubview(collectionView)
        p_addMasonry()

        let rightBarButton = UIBarButtonItem(title: "选择", style: UIBarButtonItem.Style.plain, actionBlick: {

        })
        navigationItem?.rightBarButtonItem = rightBarButton
        collectionView.register(WXChatFileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TLChatFileHeaderView")
        collectionView.register(WXChatFileCell.self, forCellWithReuseIdentifier: "TLChatFileCell")
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func setPartnerID(_ partnerID: String?) {
        self.partnerID = partnerID
        weak var weakSelf = self
        WXMessageManager.sharedInstance().chatFiles(forPartnerID: partnerID, completed: { data in
            weakSelf.data.removeAll()
            weakSelf.mediaData = nil
            if let aData = data as? [AnyHashable] {
                weakSelf.data.append(contentsOf: aData)
            }
            weakSelf.collectionView.reloadData()
        })
    }

    // MARK: - Delegate -
    //MARK: UIcollectionViewDataSource
    func numberOfSectionsIncollectionView(_ collectionView: UICollectionView?) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let temp = data?[section]
        return temp.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let message = data[indexPath.section][indexPath.row] as? WXMessage
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TLChatFileHeaderView", for: indexPath) as? WXChatFileHeaderView
        headerView?.title = message?.date.timeToNow()
        return headerView!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = data[indexPath.section][indexPath.row] as? WXMessage
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLChatFileCell", for: indexPath) as? WXChatFileCell
        cell?.message = message
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = data[indexPath.section][indexPath.row] as? WXMessage
        if message?.messageType == TLMessageTypeImage {
            var index: Int = -1
            for i in 0..<mediaData.count {
                if (message?.messageID == mediaData[i].messageID) {
                    index = i
                    break
                }
            }
            if index >= 0 {
                let browser = MWPhotoBrowser(photos: browserData)
                browser.displayNavArrows = true
                browser.currentPhotoIndex = index
                let broserNavC = WXNavigationController(rootViewController: browser)
                present(broserNavC, animated: false)
            }
        }
    }
    func p_addMasonry() {
        collectionView.mas_makeConstraints({ make in
            make?.left.and().right().and().top().mas_equalTo(self.view)
            make?.bottom.mas_equalTo(self.view)
        })
    }

    // MARK: - Getter -
    func data() -> [AnyHashable]? {
        if data == nil {
            data = [AnyHashable]()
        }
        return data
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func mediaData() -> [AnyHashable]? {
        if mediaData == nil {
            mediaData = [AnyHashable]()
            for array: [Any]? in data {
                for message: WXMessage? in array as? [WXMessage?] ?? [] {
                    if message?.messageType == TLMessageTypeImage {
                        if let aMessage = message {
                            mediaData.append(aMessage)
                        }
                        var url: URL?
                        let me = message as? WXImageMessage
                        if me?.content["path"] != nil {
                            let imagePath = FileManager.pathUserChatImage(me?.content["path"])
                            url = URL(fileURLWithPath: imagePath)
                        } else {
                            url = URL(string: me?.content["url"] ?? "")
                        }
                        let photo = MWPhoto(url: url)
                        browserData.append(photo)
                    }
                }
            }
        }
        return mediaData
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func browserData() -> [AnyHashable]? {
        if browserData == nil {
            browserData = [AnyHashable]()
            for message: WXMessage? in mediaData {
                if message?.messageType == TLMessageTypeImage {
                    var url: URL?
                    let imagePath = message?.content["path"]
                    if imagePath != nil {
                        let imagePatha = FileManager.pathUserChatImage(imagePath)
                        url = URL(fileURLWithPath: imagePatha)
                    } else {
                        url = URL(string: message?.content["url"] ?? "")
                    }
                    let photo = MWPhoto(url: url)
                    browserData.append(photo)
                }
            }
        }
        return browserData
    }



}
