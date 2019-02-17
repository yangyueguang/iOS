//
//  TLEmojiKeyboard.swift
//  Freedom
import SnapKit
import XExtension
import Foundation
@objc protocol XKeyboardDelegate: NSObjectProtocol {
    @objc optional func chatKeyboardWillShow(_ keyboard: Any)
    @objc optional func chatKeyboardDidShow(_ keyboard: Any)
    @objc optional func chatKeyboardWillDismiss(_ keyboard: Any)
    @objc optional func chatKeyboardDidDismiss(_ keyboard: Any)
    @objc optional func chatKeyboard(_ keyboard: Any, didChangeHeight height: CGFloat)
}
protocol XEmojiGroupControlDelegate: NSObjectProtocol {
    func emojiGroupControl(_ emojiGroupControl: TLEmojiGroupControl, didSelectedGroup group: TLEmojiGroup)
    func emojiGroupControlEditButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
    func emojiGroupControlEditMyEmojiButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
    func emojiGroupControlSendButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
}
@objc protocol XEmojiKeyboardDelegate: NSObjectProtocol {
    func chatInputViewHasText() -> Bool
    @objc optional func emojiKeyboard(_ emojiKB: XEmojiKeyboard, didTouchEmojiItem emoji: TLEmoji, at rect: CGRect)
    @objc optional func emojiKeyboardCancelTouchEmojiItem(_ emojiKB: XEmojiKeyboard)
    @objc optional func emojiKeyboard(_ emojiKB: XEmojiKeyboard, didSelectedEmojiItem emoji: TLEmoji)
    @objc optional func emojiKeyboardSendButtonDown()
    @objc optional func emojiKeyboardEmojiEditButtonDown()
    @objc optional func emojiKeyboardMyEmojiEditButtonDown()
    @objc optional func emojiKeyboard(_ emojiKB: XEmojiKeyboard, selectedEmojiGroupType type: TLEmojiType)
}
class XEmojiKeyboard: UIView {
    static let shared = XEmojiKeyboard()
    weak var delegate: XEmojiKeyboardDelegate?
    weak var keyboardDelegate: XKeyboardDelegate?
    var emojiGroupData: [[TLEmojiGroup]] = [] {
        didSet {
            groupControl.emojiGroupData = emojiGroupData
        }
    }
    // 布局属性
    private var cellSize = CGSize.zero
    private var headerReferenceSize = CGSize.zero
    private var footerReferenceSize = CGSize.zero
    private var minimumLineSpacing: CGFloat = 0.0
    private var minimumInteritemSpacing: CGFloat = 0.0
    private var sectionInsets: UIEdgeInsets = UIEdgeInsets.zero

    private var curGroup = TLEmojiGroup()
    private var groupControl = TLEmojiGroupControl()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
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
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.center = CGPoint(x: center.x, y: pageControl.center.y)
        pageControl.pageIndicatorTintColor = UIColor.grayx
        pageControl.currentPageIndicatorTintColor = UIColor.grayx
        pageControl.addTarget(self, action: #selector(self.pageControlChanged(_:)), for: .valueChanged)
        return pageControl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        groupControl.delegate = self
        backgroundColor = UIColor.back
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(groupControl)
        collectionView.register(XEmojiCell.self, forCellWithReuseIdentifier: XEmojiCell.identifier)
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(_:)))
        collectionView.addGestureRecognizer(longPressGR)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(215.0 * 0.75 - 10)
        }
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.groupControl.snp.top)
            make.height.equalTo(215)
        }
        groupControl.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(215 * 0.17)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show(in view: UIView, withAnimation animation: Bool) {
        keyboardDelegate?.chatKeyboardWillShow?(self)
        view.addSubview(self)
        self.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
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
        updateSendButtonStatus()
        delegate?.emojiKeyboard?(self, selectedEmojiGroupType: curGroup.type)
    }
    func dismiss(withAnimation animation: Bool) {
        keyboardDelegate?.chatKeyboardWillDismiss?(self)
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.snp.makeConstraints({ (make) in
                    make.height.equalTo(0)
                    make.bottom.equalToSuperview()
                })
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
    //FIXME: 私有方法
    @objc private func pageControlChanged(_ pageControl: UIPageControl) {
        collectionView.scrollRectToVisible(CGRect(x: APPW * CGFloat(pageControl.currentPage), y: 0, width: APPW, height: 215), animated: true)
    }
    override func draw(_ rect: CGRect) { // 顶部直线
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.grayx.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: APPW, y: 0))
        context.strokePath()
    }
    private func transformModelIndex(_ index: Int) -> Int {
        var index = index
        let page: Int = index / curGroup.pageItemCount
        index = index % curGroup.pageItemCount
        let x: Int = index / curGroup.rowNumber
        let y: Int = index % curGroup.rowNumber
        return curGroup.colNumber * y + x + page * curGroup.pageItemCount
    }
    private func transformCellIndex(_ index: Int) -> Int {
        var index = index
        let page: Int = index / curGroup.pageItemCount
        index = index % curGroup.pageItemCount
        let x: Int = index / curGroup.colNumber
        let y: Int = index % curGroup.colNumber
        return curGroup.rowNumber * y + x + page * curGroup.pageItemCount
    }
    // 更新发送按钮状态
    private func updateSendButtonStatus() {
        if curGroup.type == .emoji || curGroup.type == .face {
            if delegate?.chatInputViewHasText() ?? false{
                groupControl.sendButtonStatus = .blue
            } else {
                groupControl.sendButtonStatus = .gray
            }
        } else {
            groupControl.sendButtonStatus = .none
        }
    }
    private func resetCollectionSize() {
        var cellHeight: CGFloat = 0
        var cellWidth: CGFloat = 0
        var topSpace: CGFloat = 0
        var btmSpace: CGFloat = 0
        var hfSpace: CGFloat = 0
        let rowNumberFloat = CGFloat(curGroup.rowNumber)
        let colNumberFloat = CGFloat(curGroup.colNumber)
        if curGroup.type == .face || curGroup.type == .emoji {
            cellHeight = ((215.0 * 0.75 - 10) / rowNumberFloat) * 0.55
            cellWidth = cellHeight
            topSpace = 11
            btmSpace = 19
            hfSpace = (APPW - cellWidth * colNumberFloat) / (colNumberFloat + 1) * 1.4
        } else if curGroup.type == .imageWithTitle {
            cellHeight = ((215.0 * 0.75 - 10) / rowNumberFloat) * 0.96
            cellWidth = cellHeight * 0.8
            hfSpace = (APPW - cellWidth * rowNumberFloat) / (rowNumberFloat + 1) * 1.2
        } else {
            cellHeight = ((215.0 * 0.75 - 10) / rowNumberFloat) * 0.72
            cellWidth = cellHeight
            topSpace = 8
            btmSpace = 16
            hfSpace = (APPW - cellWidth * rowNumberFloat) / (rowNumberFloat + 1) * 1.2
        }
        cellSize = CGSize(width: cellWidth, height: cellHeight)
        headerReferenceSize = CGSize(width: hfSpace, height: 215.0 * 0.75 - 10)
        footerReferenceSize = CGSize(width: hfSpace, height: 215.0 * 0.75 - 10)
        minimumLineSpacing = (APPW - hfSpace * 2 - cellWidth * colNumberFloat) / (colNumberFloat - 1)
        minimumInteritemSpacing = ((215.0 * 0.75 - 10) - topSpace - btmSpace - cellHeight * rowNumberFloat) / (rowNumberFloat - 1)
        sectionInsets = UIEdgeInsets(top: topSpace, left: 0, bottom: btmSpace, right: 0)
    }

    @objc private func longPressAction(_ sender: UILongPressGestureRecognizer) {
        var lastCell: UICollectionViewCell? = nil
        if sender.state == .ended || sender.state == .cancelled {
            delegate?.emojiKeyboardCancelTouchEmojiItem?(self)
        } else {
            let point = sender.location(in: collectionView)
            for cell in collectionView.visibleCells {
                if cell.frame.origin.x - minimumLineSpacing / 2.0 <= (point.x ) && cell.frame.origin.y - minimumInteritemSpacing / 2.0 <= (point.y) && cell.frame.origin.x + cell.frame.size.width + minimumLineSpacing / 2.0 >= (point.x) && cell.frame.origin.y + cell.frame.size.height + minimumInteritemSpacing / 2.0 >= (point.y) {
                    if lastCell == cell { return }
                    lastCell = cell
                    let indexPath = collectionView.indexPath(for: cell) ?? IndexPath(row: 0, section: 0)
                    let index = (indexPath.section) * curGroup.pageItemCount + indexPath.row
                    let tIndex = transformModelIndex(index)
                    if tIndex >= curGroup.count {
                        delegate?.emojiKeyboardCancelTouchEmojiItem?(self)
                        return
                    }
                    let emoji = curGroup.data[tIndex]
                    emoji.type = curGroup.type
                    var rect = cell.frame
                    rect.origin.x = rect.origin.x - frame.size.width * rect.origin.x / frame.size.width
                    delegate?.emojiKeyboard?(self, didTouchEmojiItem: emoji, at: rect)
                    return
                }
            }
            delegate?.emojiKeyboardCancelTouchEmojiItem?(self)
        }
    }
}
extension XEmojiKeyboard: XEmojiGroupControlDelegate {
    func emojiGroupControl(_ emojiGroupControl: TLEmojiGroupControl, didSelectedGroup group: TLEmojiGroup) {
        curGroup = group
        resetCollectionSize()
        pageControl.numberOfPages = group.pageNumber
        pageControl.currentPage = 0
        collectionView.reloadData()
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height), animated: false)
        updateSendButtonStatus()
        delegate?.emojiKeyboard?(self, selectedEmojiGroupType: group.type)
    }
    func emojiGroupControlEditMyEmojiButtonDown(_ emojiGroupControl: TLEmojiGroupControl) {
        delegate?.emojiKeyboardMyEmojiEditButtonDown?()
    }
    func emojiGroupControlEditButtonDown(_ emojiGroupControl: TLEmojiGroupControl) {
        delegate?.emojiKeyboardEmojiEditButtonDown!()
    }
    func emojiGroupControlSendButtonDown(_ emojiGroupControl: TLEmojiGroupControl) {
        updateSendButtonStatus()
        delegate?.emojiKeyboardSendButtonDown?()
    }
}

extension XEmojiKeyboard: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return curGroup.pageNumber
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curGroup.pageItemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.section * curGroup.pageItemCount + indexPath.row
        let cell = collectionView.dequeueCell(XEmojiCell.self, for: indexPath)
        let tIndex = transformModelIndex(index)
        let emojiItem = curGroup.count > tIndex ? curGroup.data[tIndex] : TLEmoji()
        cell.emojiItem = emojiItem
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / APPW)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index: Int = indexPath.section * curGroup.pageItemCount + indexPath.row
        let tIndex = transformModelIndex(index) // 矩阵坐标转置
        if tIndex < curGroup.count {
            let item = curGroup.data[tIndex]
            item.type = curGroup.type
            delegate?.emojiKeyboard!(self, didSelectedEmojiItem: item)
        }
        updateSendButtonStatus()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return headerReferenceSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return footerReferenceSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
class XEmojiCell: UICollectionViewCell {
    private var imageView = UIImageView()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.small
        label.textColor = UIColor.grayx
        label.textAlignment = .center
        return label
    }()
    var emojiItem: TLEmoji = TLEmoji() {
        didSet {
            label.text = nil
            switch emojiItem.type {
            case TLEmojiType.face:
                imageView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                imageView.image = emojiItem.emojiName.isEmpty ? nil : UIImage(named: emojiItem.emojiName)
            case .image:
                imageView.snp.makeConstraints { (make) in
                    make.edges.equalTo(self.contentView).offset(
                        UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2) as! ConstraintOffsetTarget)
                }
                imageView.image = emojiItem.emojiPath.isEmpty ? nil : UIImage(named: emojiItem.emojiPath)
            case .imageWithTitle:
                imageView.snp.makeConstraints { (make) in
                    make.left.top.equalTo(self.contentView).offset(3)
                    make.right.equalTo(self.contentView).offset(-3)
                    make.height.equalTo(self.imageView.snp.width)
                }
                label.snp.makeConstraints { (make) in
                    make.left.right.bottom.equalTo(self.contentView)
                }
                imageView.image = emojiItem.emojiPath.isEmpty ? nil : UIImage(named: emojiItem.emojiPath)
                label.text = emojiItem.emojiName
            case .emoji:
                label.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                }
                label.font = UIFont.systemFont(ofSize: 25.0)
                label.text = emojiItem.emojiName
            default:
                break
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TLEmojiGroupCell: UICollectionViewCell {
    var emojiGroup: TLEmojiGroup = TLEmojiGroup() {
        didSet {
            groupIconView.image = UIImage(named: emojiGroup.groupIconPath)
        }
    }
    private var groupIconView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.back
        selectedBackgroundView = selectedView
        contentView.addSubview(groupIconView)
        groupIconView.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.width.height.lessThanOrEqualTo(30)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.grayx.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: frame.size.width - 0.5, y: 5))
        context.addLine(to: CGPoint(x: frame.size.width - 0.5, y: frame.size.height - 5))
        context.strokePath()
    }
}


class TLEmojiGroupControl: UIView {
    weak var delegate: XEmojiGroupControlDelegate?
    var emojiGroupData: [[TLEmojiGroup]] = [] {
        didSet {
            collectionView.reloadData()
            if emojiGroupData.count > 0 {
                self.curIndexPath = IndexPath(row: 0, section: 0)
            }
        }
    }
    private var addButton = UIButton()
    private var sendButton = UIButton()
    private var curIndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            collectionView.selectItem(at: curIndexPath, animated: false, scrollPosition: [])
            let group = emojiGroupData[curIndexPath.section][curIndexPath.row]
            delegate?.emojiGroupControl(self, didSelectedGroup: group)
        }
    }
    var sendButtonStatus = TLGroupControlSendButtonStatus.none {
        didSet {
            if sendButtonStatus == .none {
                UIView.animate(withDuration: 1, animations: {
                    self.sendButton.snp.updateConstraints({ (make) in
                        make.right.equalToSuperview().offset(60)
                    })
                    self.layoutIfNeeded()
                })
            } else if sendButtonStatus == .blue {
                sendButton.setBackgroundImage(WXImage.add.image, for: .normal)
                sendButton.setBackgroundImage(WXImage.addHL.image, for: .highlighted)
                sendButton.setTitleColor(UIColor.white, for: .normal)
            } else if sendButtonStatus == .gray {
                sendButton.setBackgroundImage(WXImage.add.image, for: .normal)
                sendButton.setBackgroundImage(WXImage.addHL.image, for: .highlighted)
                sendButton.setTitleColor(UIColor.grayx, for: .normal)
            }
        }
    }
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whitex
        addButton.setImage(WXImage.add.image, for: .normal)
        addButton.addTarget(self, action: #selector(self.emojiAddButtonDown), for: .touchUpInside)
        addSubview(addButton)
        addSubview(collectionView)
        addSubview(sendButton)
        collectionView.register(TLEmojiGroupCell.self, forCellWithReuseIdentifier: TLEmojiGroupCell.identifier)
        addButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(46)
        }
        sendButton.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(60)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.addButton.snp.right)
            make.right.equalTo(self.sendButton.snp.left)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.grayx.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 46, y: 5))
        context.addLine(to: CGPoint(x: 46, y: frame.size.height - 5))
        context.strokePath()
    }
    @objc func emojiAddButtonDown() {
        delegate?.emojiGroupControlEditButtonDown(self)
    }
    @objc func sendButtonDown() {
        delegate?.emojiGroupControlSendButtonDown(self)
    }
}
extension TLEmojiGroupControl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiGroupData.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (emojiGroupData[section] as [Any]).count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(TLEmojiGroupCell.self, for: indexPath)
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
        let group = emojiGroupData[indexPath.section][indexPath.row]
        if group.type == .other {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.curIndexPath = self.curIndexPath
            })
            delegate?.emojiGroupControlEditMyEmojiButtonDown(self)
        } else {
            self.curIndexPath = indexPath
        }
    }
}
