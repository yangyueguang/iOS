//
//  TLEmojiBaseCell.swift
//  Freedom

import Foundation
enum TLEmojiGroupStatus : Int {
    case unDownload
    case downloaded
    case downloading
}

class TLEmoji: NSObject {
    var type: TLEmojiType
    var groupID = ""
    var emojiID = ""
    var emojiName = ""
    var emojiPath = ""
    var emojiURL = ""
    var size: CGFloat = 0.0
    class func replacedKeyFromPropertyName() -> [AnyHashable : Any] {
        return ["emojiID": "pId", "emojiURL": "Url", "emojiName": "credentialName", "emojiPath": "imageFile", "size": "size"]
    }

    func emojiPath() -> String {
        if _emojiPath == nil {
            let groupPath = FileManager.pathExpression(forGroupID: groupID)
            _emojiPath = "\(groupPath)\(emojiID)"
        }
        return _emojiPath
    }
}

class TLEmojiGroup: NSObject, WXPictureCarouselProtocol {
    var type: TLEmojiType
    /// 基本信息
    var groupID = ""
    var groupName = ""
    var path = ""
    var groupIconPath = ""
    var groupIconURL = ""
    /// Banner用
    var bannerID = ""
    var bannerURL = ""
    /// 总数
    var count: Int = 0
    /// 详细信息
    var groupInfo = ""
    var groupDetailInfo = ""
    var date: Date
    var status: TLEmojiGroupStatus
    /// 作者
    var authName = ""
    var authID = ""
    // MARK: - 本地信息
    var data: [AnyHashable] = []
// MARK: - 展示用
/// 每页个数
    var pageItemCount: Int = 0
    /// 页数
    var pageNumber: Int = 0
    /// 行数
    var rowNumber: Int = 0
    /// 列数
    var colNumber: Int = 0
    class func replacedKeyFromPropertyName() -> [AnyHashable : Any] {
        return ["groupID": "eId", "groupIconURL": "coverUrl", "groupName": "eName", "groupInfo": "memo", "groupDetailInfo": "memo1", "count": "picCount", "bannerID": "aId", "bannerURL": "URL"]
    }

    init() {
        super.init()

        self.type = TLEmojiTypeImageWithTitle

    }
    func setType(_ type: TLEmojiType) {
        self.type = type
        switch type {
        case TLEmojiTypeOther:
            return
        case TLEmojiTypeFace, TLEmojiTypeEmoji:
            rowNumber = 3
            colNumber = 7
        case TLEmojiTypeImage, TLEmojiTypeFavorite, TLEmojiTypeImageWithTitle:
            rowNumber = 2
            colNumber = 4
        default:
            break
        }
        pageItemCount = rowNumber * colNumber
        pageNumber = count / pageItemCount + (count % pageItemCount == 0  0 : 1)
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func setData(_ data: [AnyHashable]) {
        var data = data
        self.data = data
        count = data.count
        pageItemCount = rowNumber * colNumber
        pageNumber = count / pageItemCount + (count % pageItemCount == 0  0 : 1)
    }

    func object(at index: Int) -> Any {
        return data[index]
    }

    func path() -> String {
        if path == nil && groupID != nil {
            path = FileManager.pathExpression(for: groupID)
        }
        return path
    }

    func groupIconPath() -> String {
        if groupIconPath == nil && path() != nil {
            groupIconPath = "\(path()  "")icon_\(groupID)"
        }
        return groupIconPath
    }

    func pictureURL() -> String {
        return bannerURL
    }







    
}
enum TLGroupControlSendButtonStatus : Int {
    case gray
    case blue
    case none
}

class TLEmojiBaseCell: UICollectionViewCell {
    var emojiItem: TLEmoji
    var bgView: UIImageView
    //选中时的背景图片，默认nil
    var highlightImage: UIImage
    var showHighlightImage = false
}

class TLEmojiFaceItemCell: TLEmojiBaseCell {
    private var imageView: UIImageView

    init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aView = imageView {
            contentView.addSubview(aView)
        }
        p_addMasonry()

    }

    func setEmojiItem(_ emojiItem: TLEmoji) {
        super.setEmojiItem(emojiItem)
        imageView.image = emojiItem.emojiName == nil  nil : UIImage(named: emojiItem.emojiName  "")
    }

    // MARK: - Private Methods -
    func p_addMasonry() {
        imageView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self)
        })
    }

    var imageView: UIImageView {
        if imageView == nil {
            imageView = UIImageView()
        }
        return imageView
    }
    
}

class TLEmojiImageItemCell: TLEmojiBaseCell {
    private var imageView: UIImageView

    init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aView = imageView {
            contentView.addSubview(aView)
        }
        setHighlight(UIImage(named: "emoji_hl_background"))
        p_addMasonry()

    }

    func setEmojiItem(_ emojiItem: TLEmoji) {
        super.setEmojiItem(emojiItem)
        imageView.image = emojiItem.emojiPath == nil  nil : UIImage(named: emojiItem.emojiPath  "")
    }
    func p_addMasonry() {
        imageView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(2, 2, 2, 2))
        })
    }

    var imageView: UIImageView {
        if imageView == nil {
            imageView = UIImageView()
        }
        return imageView
    }


    
}

class TLEmojiImageTitleItemCell: TLEmojiBaseCell {
    private var imageView: UIImageView
    private var label: UILabel

    init(frame: CGRect) {
        //if super.init(frame: frame)

        setHighlight(UIImage(named: "emoji_hl_background"))
        if let aView = imageView {
            contentView.addSubview(aView)
        }
        if let aLabel = label {
            contentView.addSubview(aLabel)
        }
        p_addMasonry()

    }
    func setEmojiItem(_ emojiItem: TLEmoji) {
        super.setEmojiItem(emojiItem)
        imageView.image = emojiItem.emojiPath == nil  nil : UIImage(named: emojiItem.emojiPath  "")
        label.text = emojiItem.emojiName
    }

    // MARK: - Private Methods -
    func p_addMasonry() {
        bgView.mas_remakeConstraints({ make in
            make.left.and().right().and().top().mas_equalTo(self.contentView)
            make.height.mas_equalTo(self.bgView.mas_width)
        })
        imageView.mas_makeConstraints({ make in
            make.left.and().top().mas_equalTo(self.contentView).mas_offset(3)
            make.right.mas_equalTo(self.contentView).mas_offset(-3)
            make.height.mas_equalTo(self.imageView.mas_width)
        })
        label.mas_makeConstraints({ make in
            make.left.and().right().and().bottom().mas_equalTo(self.contentView)
        })
    }
    var imageView: UIImageView {
        if imageView == nil {
            imageView = UIImageView()
        }
        return imageView
    }

    func label() -> UILabel {
        if label == nil {
            label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.textColor = UIColor.gray
            label.textAlignment = .center
        }
        return label
    }

}

class TLEmojiItemCell: TLEmojiBaseCell {
    private var label: UILabel

    init(frame: CGRect) {
        //if super.init(frame: frame)

        if let aLabel = label {
            contentView.addSubview(aLabel)
        }
        p_addMasonry()

    }

    func setEmojiItem(_ emojiItem: TLEmoji) {
        super.setEmojiItem(emojiItem)
        label.text = emojiItem.emojiName
    }

    // MARK: - Private Methods -
    func p_addMasonry() {
        label.mas_makeConstraints({ make in
            make.center.mas_equalTo(self)
        })
    }
    func label() -> UILabel {
        if label == nil {
            label = UILabel()
            label.font = UIFont.systemFont(ofSize: 25.0)
        }
        return label
    }
    init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bgView)
        bgView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.contentView)
        })

    }

    func setShowHighlightImage(_ showHighlightImage: Bool) {
        if showHighlightImage {
            bgView.image = highlightImage
        } else {
            bgView.image = nil
        }
    }
    func bgView() -> UIImageView {
        if bgView == nil {
            bgView = UIImageView()
            bgView.layer.masksToBounds = true
            bgView.layer.cornerRadius = 5.0
        }
        return bgView
    }




    
}

class TLEmojiGroupCell: UICollectionViewCell {
    var emojiGroup: TLEmojiGroup
    private var groupIconView: UIImageView

    init(frame: CGRect) {
        //if super.init(frame: frame)

        backgroundColor = UIColor.clear
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(245.0, 245.0, 247.0, 1.0)
        selectedBackgroundView = selectedView

        if let aView = groupIconView {
            contentView.addSubview(aView)
        }
        p_addMasonry()

    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func setEmojiGroup(_ emojiGroup: TLEmojiGroup) {
        self.emojiGroup = emojiGroup
        groupIconView.image = UIImage(named: emojiGroup.groupIconPath  "")
    }

    // MARK: - Private Methods -
    func p_addMasonry() {
        groupIconView.mas_makeConstraints({ make in
            make.center.mas_equalTo(self.contentView)
            make.width.and().height().mas_lessThanOrEqualTo(30)
        })
    }

    func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: frame.size.width - 0.5, y: 5))
        context.addLine(to: CGPoint(x: frame.size.width - 0.5, y: frame.size.height - 5))
        context.strokePath()
    }
    func groupIconView() -> UIImageView {
        if groupIconView == nil {
            groupIconView = UIImageView()
        }
        return groupIconView
    }



    
}
protocol TLEmojiGroupControlDelegate: NSObjectProtocol {
    func emojiGroupControl(_ emojiGroupControl: TLEmojiGroupControl, didSelectedGroup group: TLEmojiGroup)
    func emojiGroupControlEditButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
    func emojiGroupControlEditMyEmojiButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
    func emojiGroupControlSendButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
}

class TLEmojiGroupControl: UIView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var sendButtonStatus: TLGroupControlSendButtonStatus
    var emojiGroupData: [AnyHashable] = []
    weak var delegate: TLEmojiGroupControlDelegate

    private var curIndexPath: IndexPath
    private var addButton: UIButton
    private var collectionView: UICollectionView
    private var sendButton: UIButton

    init() {
        //if super.init()

        backgroundColor = UIColor.white
        if let aButton = addButton {
            addSubview(aButton)
        }
        if let aView = collectionView {
            addSubview(aView)
        }
        if let aButton = sendButton {
            addSubview(aButton)
        }
        p_addMasonry()

        collectionView.register(TLEmojiGroupCell.self, forCellWithReuseIdentifier: "TLEmojiGroupCell")

    }
    func setSendButtonStatus(_ sendButtonStatus: TLGroupControlSendButtonStatus) {
        if self.sendButtonStatus != sendButtonStatus {
            if self.sendButtonStatus == TLGroupControlSendButtonStatusNone {
                UIView.animate(withDuration: 1, animations: {
                    self.sendButton.mas_updateConstraints({ make in
                        make.right.mas_equalTo(self)
                    })
                    self.layoutIfNeeded()
                })
            }

            self.sendButtonStatus = sendButtonStatus
            if sendButtonStatus == TLGroupControlSendButtonStatusNone {
                UIView.animate(withDuration: 1, animations: {
                    self.sendButton.mas_updateConstraints({ make in
                        make.right.mas_equalTo(self).mas_offset(60)
                    })
                    self.layoutIfNeeded()
                })
            } else if sendButtonStatus == TLGroupControlSendButtonStatusBlue {
                sendButton.setBackgroundImage(UIImage(named: "emojiKB_sendBtn_blue"), for: .normal)
                sendButton.setBackgroundImage(UIImage(named: "emojiKB_sendBtn_blueHL"), for: .highlighted)
                sendButton.setTitleColor(UIColor.white, for: .normal)
            } else if sendButtonStatus == TLGroupControlSendButtonStatusGray {
                sendButton.setBackgroundImage(UIImage(named: "emojiKB_sendBtn_gray"), for: .normal)
                sendButton.setBackgroundImage(UIImage(named: "emojiKB_sendBtn_gray"), for: .highlighted)
                sendButton.setTitleColor(UIColor.gray, for: .normal)
            }
        }
    }
    func setEmojiGroupData(_ emojiGroupData: [AnyHashable]) {
        var emojiGroupData = emojiGroupData
        if let aData = emojiGroupData {
            if self.emojiGroupData == emojiGroupData || (self.emojiGroupData == aData) {
                return
            }
        }
        self.emojiGroupData = emojiGroupData
        collectionView.reloadData()
        if emojiGroupData != nil && (emojiGroupData.count  0) > 0 {
            setCurIndexPath(IndexPath(row: 0, section: 0))
        }
    }

    func setCurIndexPath(_ curIndexPath: IndexPath) {
        collectionView.selectItem(at: curIndexPath, animated: false, scrollPosition: [])
        if self.curIndexPath && self.curIndexPath.section == curIndexPath.section && self.curIndexPath.row == curIndexPath.row {
            return
        }
        self.curIndexPath = curIndexPath
        if delegate && delegate.responds(to: #selector(self.emojiGroupControl(_:didSelectedGroup:))) {
            let group = (emojiGroupData[curIndexPath.section  0])[curIndexPath.row  0] as TLEmojiGroup
            delegate.emojiGroupControl(self, didSelectedGroup: group)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiGroupData.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (emojiGroupData[section] as [Any]).count  0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLEmojiGroupCell", for: indexPath) as TLEmojiGroupCell
        let group = emojiGroupData[indexPath.section][indexPath.row] as TLEmojiGroup
        cell.emojiGroup = group
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 46, height: frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == emojiGroupData.count - 1 {
            return CGSize(width: 46 * 2, height: frame.size.height)
        }
        return CGSize.zero
    }

    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = emojiGroupData[indexPath.section][indexPath.row] as TLEmojiGroup
        if group.type == TLEmojiTypeOther {
            //: 存在冲突：用户选中cellA,再此方法中立马调用方法选中cellB时，所有cell都不会被选中
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.curIndexPath = curIndexPath
            })
            p_eidtMyEmojiButtonDown()
        } else {
            self.curIndexPath = indexPath
        }
    }
    func p_addMasonry() {
        addButton.mas_makeConstraints({ make in
            make.left.and().top().and().bottom().mas_equalTo(self)
            make.width.mas_equalTo(46)
        })

        sendButton.mas_makeConstraints({ make in
            make.top.and().bottom().and().right().mas_equalTo(self)
            make.width.mas_equalTo(60)
        })

        collectionView.mas_makeConstraints({ make in
            make.top.and().bottom().mas_equalTo(self)
            make.left.mas_equalTo(self.addButton.mas_right)
            make.right.mas_equalTo(self.sendButton.mas_left)
        })
    }
    func p_eidtMyEmojiButtonDown() {
        if delegate && delegate.responds(to: #selector(self.emojiGroupControlEditMyEmojiButtonDown(_:))) {
            delegate.emojiGroupControlEditMyEmojiButtonDown(self)
        }
    }

    func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 46, y: 5))
        context.addLine(to: CGPoint(x: 46, y: frame.size.height - 5))
        context.strokePath()
    }

    // MARK: - Event Response -
    func emojiAddButtonDown() {
        if delegate && delegate.responds(to: #selector(self.emojiGroupControlEditButtonDown(_:))) {
            delegate.emojiGroupControlEditButtonDown(self)
        }
    }
    func sendButtonDown() {
        if delegate && delegate.responds(to: #selector(self.emojiGroupControlSendButtonDown(_:))) {
            delegate.emojiGroupControlSendButtonDown(self)
        }
    }

    // MARK: - Getter -
    func addButton() -> UIButton {
        if addButton == nil {
            addButton = UIButton()
            addButton.setImage(UIImage(named: "emojiKB_groupControl_add"), for: .normal)
            addButton.addTarget(self, action: #selector(self.emojiAddButtonDown), for: .touchUpInside)
        }
        return addButton
    }
    var collectionView: UICollectionView! {
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.clear
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.scrollsToTop = false
        }
        return collectionView
    }
    func sendButton() -> UIButton {
        if sendButton == nil {
            sendButton = UIButton()
            sendButton.titleLabel.font = UIFont.systemFont(ofSize: 15.0)
            sendButton.setTitle("  发送", for: .normal)
            sendButton.setTitleColor(UIColor.gray, for: .normal)
            sendButton.backgroundColor = UIColor.clear
            sendButton.setBackgroundImage(UIImage(named: "emojiKB_sendBtn_gray"), for: .normal)
            sendButton.setBackgroundImage(UIImage(named: "emojiKB_sendBtn_gray"), for: .highlighted)
            sendButton.addTarget(self, action: #selector(self.sendButtonDown), for: .touchUpInside)
        }
        return sendButton
    }

    
}
