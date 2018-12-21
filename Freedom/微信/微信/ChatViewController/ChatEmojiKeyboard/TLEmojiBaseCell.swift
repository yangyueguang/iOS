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
    var type = TLEmojiType.emoji
    var groupID = ""
    var emojiID = ""
    var emojiName = ""
    var emojiURL = ""
    var size: CGFloat = 0.0
    class func replacedKeyFromPropertyName() -> [AnyHashable : Any] {
        return ["emojiID": "pId", "emojiURL": "Url", "emojiName": "credentialName", "emojiPath": "imageFile", "size": "size"]
    }
    var emojiPath: String {
        let groupPath = FileManager.pathExpression(forGroupID: groupID)
        return "\(groupPath)\(emojiID)"
    }
}

class TLEmojiGroup: NSObject, WXPictureCarouselProtocol {
    var type = TLEmojiType.emoji
    /// 基本信息
    var groupID = ""
    var groupName = ""
    lazy var path = FileManager.pathExpression(forGroupID: self.groupID)
    lazy var groupIconPath = "\(path)icon_\(groupID)"
    var groupIconURL = ""
    var bannerID = ""
    var bannerURL = ""/// 总数
    var count: Int = 0/// 详细信息
    var groupInfo = ""
    var groupDetailInfo = ""
    var date: Date
    var status = TLEmojiGroupStatus.unDownload/// 作者
    var authName = ""
    var authID = ""
    var data: [AnyHashable] = []/// 每页个数
    var pageItemCount: Int = 0/// 页数
    var pageNumber: Int = 0/// 行数
    var rowNumber: Int = 0/// 列数
    var colNumber: Int = 0
    class func replacedKeyFromPropertyName() -> [AnyHashable : Any] {
        return ["groupID": "eId", "groupIconURL": "coverUrl", "groupName": "eName", "groupInfo": "memo", "groupDetailInfo": "memo1", "count": "picCount", "bannerID": "aId", "bannerURL": "URL"]
    }
    override init() {
        super.init()
        self.type = .imageWithTitle
    }
    func setType(_ type: TLEmojiType) {
        self.type = type
        switch type {
        case .other:
            return
        case .face, .emoji:
            rowNumber = 3
            colNumber = 7
        case .image, .favorite, .imageWithTitle:
            rowNumber = 2
            colNumber = 4
        default:
            break
        }
        pageItemCount = rowNumber * colNumber
        pageNumber = count / pageItemCount + (count % pageItemCount == 0 ? 0 : 1)
    }
    
    func setData(_ data: [AnyHashable]) {
        self.data = data
        count = data.count
        pageItemCount = rowNumber * colNumber
        pageNumber = count / pageItemCount + (count % pageItemCount == 0 ? 0 : 1)
    }
    func object(at index: Int) -> Any {
        return data[index]
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
    var emojiItem: TLEmoji = TLEmoji()
    var bgView = UIImageView()
    var highlightImage: UIImage?
    var showHighlightImage = false
}

class TLEmojiFaceItemCell: TLEmojiBaseCell {
    private var imageView = UIImageView()
    override var emojiItem: TLEmoji {
        didSet {
            imageView.image = emojiItem.emojiName.isEmpty ? nil : UIImage(named: emojiItem.emojiName)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        p_addMasonry()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func p_addMasonry() {
        imageView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self)
        })
    }
}

class TLEmojiImageItemCell: TLEmojiBaseCell {
    private var imageView = UIImageView()
    override var emojiItem: TLEmoji {
        didSet {
            imageView.image = emojiItem.emojiPath.isEmpty ? nil : UIImage(named: emojiItem.emojiPath)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        highlightImage = UIImage(named: "emoji_hl_background")
        imageView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(2, 2, 2, 2))
        })
    }
}

class TLEmojiImageTitleItemCell: TLEmojiBaseCell {
    private var imageView = UIImageView()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setHighlight(UIImage(named: "emoji_hl_background"))
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        p_addMasonry()

    }
    func setEmojiItem(_ emojiItem: TLEmoji) {
        super.setEmojiItem(emojiItem)
        imageView.image = emojiItem.emojiPath == nil ? nil : UIImage(named: emojiItem.emojiPath)
        label.text = emojiItem.emojiName
    }
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
}

class TLEmojiItemCell: TLEmojiBaseCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25.0)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 5.0
        contentView.addSubview(label)
        contentView.addSubview(bgView)
        bgView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.contentView)
        })
        p_addMasonry()
    }

    func setEmojiItem(_ emojiItem: TLEmoji) {
        super.setEmojiItem(emojiItem)
        label.text = emojiItem.emojiName
    }
    func p_addMasonry() {
        label.mas_makeConstraints({ make in
            make.center.mas_equalTo(self)
        })
    }

    func setShowHighlightImage(_ showHighlightImage: Bool) {
        if showHighlightImage {
            bgView.image = highlightImage
        } else {
            bgView.image = nil
        }
    }
}

class TLEmojiGroupCell: UICollectionViewCell {
    var emojiGroup: TLEmojiGroup {
        didSet {
            groupIconView.image = UIImage(named: emojiGroup.groupIconPath)
        }
    }
    private var groupIconView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(245.0, 245.0, 247.0, 1.0)
        selectedBackgroundView = selectedView
        contentView.addSubview(groupIconView)
//        groupIconView.mas_makeConstraints({ make in
//            make.center.mas_equalTo(self.contentView)
//            make.width.and().height().mas_lessThanOrEqualTo(30)
//        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: frame.size.width - 0.5, y: 5))
        context.addLine(to: CGPoint(x: frame.size.width - 0.5, y: frame.size.height - 5))
        context.strokePath()
    }
}
protocol TLEmojiGroupControlDelegate: NSObjectProtocol {
    func emojiGroupControl(_ emojiGroupControl: TLEmojiGroupControl, didSelectedGroup group: TLEmojiGroup)
    func emojiGroupControlEditButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
    func emojiGroupControlEditMyEmojiButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
    func emojiGroupControlSendButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
}

class TLEmojiGroupControl: UIView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var sendButtonStatus = TLGroupControlSendButtonStatus.none
    var emojiGroupData: [[TLEmojiGroup]] = [] {
        didSet {
            collectionView.reloadData()
            if emojiGroupData.count > 0 {
                setCurIndexPath(IndexPath(row: 0, section: 0))
            }
        }
    }
    weak var delegate: TLEmojiGroupControlDelegate?
    private var curIndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            collectionView.selectItem(at: curIndexPath, animated: false, scrollPosition: [])
            if self.curIndexPath && self.curIndexPath.section == curIndexPath.section && self.curIndexPath.row == curIndexPath.row {
                return
            }
            self.curIndexPath = curIndexPath
            let group = (emojiGroupData[curIndexPath.section])[curIndexPath.row] as TLEmojiGroup
            delegate?.emojiGroupControl(self, didSelectedGroup: group)
        }
    }
    private lazy var addButton : UIButton = {
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "emojiKB_groupControl_add"), for: .normal)
        addButton.addTarget(self, action: #selector(self.emojiAddButtonDown), for: .touchUpInside)
        return addButton
    }()
    private lazy var collectionView: UICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        return collectionView
    }()

    private lazy var sendButton:UIButton = {
        let sendButton = UIButton()
        sendButton.titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        sendButton.setTitle("发送", for: .normal)
        sendButton.setTitleColor(UIColor.gray, for: .normal)
        sendButton.backgroundColor = UIColor.clear
        sendButton.setBackgroundImage(UIImage(named: "emojiKB_sendBtn_gray"), for: .normal)
        sendButton.setBackgroundImage(UIImage(named: "emojiKB_sendBtn_gray"), for: .highlighted)
        sendButton.addTarget(self, action: #selector(self.sendButtonDown), for: .touchUpInside)
        return sendButton
    }()

    init() {
        super.init()
        backgroundColor = UIColor.white
        addSubview(addButton)
        addSubview(collectionView)
        addSubview(sendButton)
//        p_addMasonry()
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiGroupData.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (emojiGroupData[section] as [Any]).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLEmojiGroupCell", for: indexPath) as! TLEmojiGroupCell
        let group = emojiGroupData[indexPath.section][indexPath.row] as TLEmojiGroup
        cell.emojiGroup = group
        return cell
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = emojiGroupData[indexPath.section][indexPath.row] as TLEmojiGroup
        if group.type == .other {
            //: 存在冲突：用户选中cellA,再此方法中立马调用方法选中cellB时，所有cell都不会被选中
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.curIndexPath = self.curIndexPath
            })
            p_eidtMyEmojiButtonDown()
        } else {
            self.curIndexPath = indexPath
        }
    }
//    func p_addMasonry() {
//        addButton.mas_makeConstraints({ make in
//            make.left.and().top().and().bottom().mas_equalTo(self)
//            make.width.mas_equalTo(46)
//        })
//        sendButton.mas_makeConstraints({ make in
//            make.top.and().bottom().and().right().mas_equalTo(self)
//            make.width.mas_equalTo(60)
//        })
//        collectionView.mas_makeConstraints({ make in
//            make.top.and().bottom().mas_equalTo(self)
//            make.left.mas_equalTo(self.addButton.mas_right)
//            make.right.mas_equalTo(self.sendButton.mas_left)
//        })
//    }
    func p_eidtMyEmojiButtonDown(){
        delegate?.emojiGroupControlEditMyEmojiButtonDown(self)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 46, y: 5))
        context.addLine(to: CGPoint(x: 46, y: frame.size.height - 5))
        context.strokePath()
    }
    @objc func emojiAddButtonDown() {
        delegate?.emojiGroupControlEditButtonDown(self)
    }
    func sendButtonDown() {
        delegate?.emojiGroupControlSendButtonDown(self)
    }
}
