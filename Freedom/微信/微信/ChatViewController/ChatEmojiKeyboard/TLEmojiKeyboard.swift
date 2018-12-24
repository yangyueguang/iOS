//
//  TLEmojiKeyboard.swift
//  Freedom
import SnapKit
import XExtension
import Foundation
@objc protocol TLKeyboardDelegate: NSObjectProtocol {
    @objc optional func chatKeyboardWillShow(_ keyboard: Any)
    @objc optional func chatKeyboardDidShow(_ keyboard: Any)
    @objc optional func chatKeyboardWillDismiss(_ keyboard: Any)
    @objc optional func chatKeyboardDidDismiss(_ keyboard: Any)
    @objc optional func chatKeyboard(_ keyboard: Any, didChangeHeight height: CGFloat)
}
@objc protocol TLEmojiKeyboardDelegate: NSObjectProtocol {
    func chatInputViewHasText() -> Bool
    @objc optional func emojiKeyboard(_ emojiKB: TLEmojiKeyboard, didTouchEmojiItem emoji: TLEmoji, at rect: CGRect)
    @objc optional func emojiKeyboardCancelTouchEmojiItem(_ emojiKB: TLEmojiKeyboard)
    @objc optional func emojiKeyboard(_ emojiKB: TLEmojiKeyboard, didSelectedEmojiItem emoji: TLEmoji)
    @objc optional func emojiKeyboardSendButtonDown()
    @objc optional func emojiKeyboardEmojiEditButtonDown()
    @objc optional func emojiKeyboardMyEmojiEditButtonDown()
    @objc optional func emojiKeyboard(_ emojiKB: TLEmojiKeyboard, selectedEmojiGroupType type: TLEmojiType)
}
class TLEmojiKeyboard: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TLEmojiGroupControlDelegate {
    var cellSize = CGSize.zero
    var headerReferenceSize = CGSize.zero
    var footerReferenceSize = CGSize.zero
    var minimumLineSpacing: CGFloat = 0.0
    var minimumInteritemSpacing: CGFloat = 0.0
    var sectionInsets: UIEdgeInsets = UIEdgeInsets.zero
    var curGroup = TLEmojiGroup()
    var groupControl = TLEmojiGroupControl()
    var keyboard = TLEmojiKeyboard()
    weak var delegate: TLEmojiKeyboardDelegate?
    weak var keyboardDelegate: TLKeyboardDelegate?
    var emojiGroupData: [[TLEmojiGroup]] = [] {
        didSet {
            groupControl.emojiGroupData = emojiGroupData
        }
    }
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
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.gray
        pageControl.addTarget(self, action: #selector(self.pageControlChanged(_:)), for: .valueChanged)
        return pageControl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        groupControl.delegate = self
        backgroundColor = UIColor(245.0, 245.0, 247.0, 1.0)
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(groupControl)

        collectionView.register(TLEmojiItemCell.self, forCellWithReuseIdentifier: "TLEmojiItemCell")
        collectionView.register(TLEmojiFaceItemCell.self, forCellWithReuseIdentifier: "TLEmojiFaceItemCell")
        collectionView.register(TLEmojiImageItemCell.self, forCellWithReuseIdentifier: "TLEmojiImageItemCell")
        collectionView.register(TLEmojiImageTitleItemCell.self, forCellWithReuseIdentifier: "TLEmojiImageTitleItemCell")

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
        keyboardDelegate?.chatKeyboardWillShow!(self)
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
                self.keyboardDelegate?.chatKeyboard!(self, didChangeHeight: (view.frame.size.height) - self.frame.origin.y)
            }) { finished in
                self.keyboardDelegate?.chatKeyboardDidShow!(self)
            }
        } else {
            self.snp.updateConstraints { (make) in
                make.bottom.equalTo(view)
            }
            view.layoutIfNeeded()
            keyboardDelegate?.chatKeyboardDidShow!(self)
        }
        updateSendButtonStatus()
        delegate?.emojiKeyboard!(self, selectedEmojiGroupType: curGroup.type)
    }
    func dismiss(withAnimation animation: Bool) {
        keyboardDelegate?.chatKeyboardWillDismiss!(self)
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.snp.makeConstraints({ (make) in
                    make.bottom.equalToSuperview().offset(215)
                })
                self.superview?.layoutIfNeeded()
                self.keyboardDelegate?.chatKeyboard!(self, didChangeHeight: self.superview?.frame.size.height ?? 0 - self.frame.origin.y)
            }) { finished in
                self.removeFromSuperview()
                self.keyboardDelegate?.chatKeyboardDidDismiss!(self)
            }
        } else {
            removeFromSuperview()
            keyboardDelegate?.chatKeyboardDidDismiss!(self)
        }
    }
    func reset() {
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height), animated: false)
        // 更新发送按钮状态
        updateSendButtonStatus()
    }
    @objc func pageControlChanged(_ pageControl: UIPageControl) {
        collectionView.scrollRectToVisible(CGRect(x: APPW * CGFloat(pageControl.currentPage), y: 0, width: APPW, height: 215), animated: true)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 顶部直线
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: APPW, y: 0))
        context.strokePath()
    }
    func transformModelIndex(_ index: Int) -> Int {
        var index = index
        let page: Int = index / curGroup.pageItemCount
        index = index % curGroup.pageItemCount
        let x: Int = index / curGroup.rowNumber
        let y: Int = index % curGroup.rowNumber
        return curGroup.colNumber * y + x + page * curGroup.pageItemCount
    }
    func transformCellIndex(_ index: Int) -> Int {
        var index = index
        let page: Int = index / curGroup.pageItemCount
        index = index % curGroup.pageItemCount
        let x: Int = index / curGroup.colNumber
        let y: Int = index % curGroup.colNumber
        return curGroup.rowNumber * y + x + page * curGroup.pageItemCount
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return curGroup.pageNumber
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curGroup.pageItemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index: Int = indexPath.section * curGroup.pageItemCount + indexPath.row
        var cell: TLEmojiBaseCell
        if curGroup.type == .emoji {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLEmojiItemCell", for: indexPath) as! TLEmojiBaseCell
        } else if curGroup.type == .face {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLEmojiFaceItemCell", for: indexPath) as! TLEmojiBaseCell
        } else if curGroup.type == .imageWithTitle {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLEmojiImageTitleItemCell", for: indexPath) as! TLEmojiBaseCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLEmojiImageItemCell", for: indexPath) as! TLEmojiBaseCell
        }
        let tIndex = transformModelIndex(index) // 矩阵坐标转置
        let emojiItem = curGroup.count > tIndex ? curGroup.data[tIndex] : TLEmoji()
        cell.emojiItem = emojiItem
        return cell
    }
    func resetCollectionSize() {
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
    //FIXME: collectionViewDelegate
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
    func updateSendButtonStatus() {
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
    func emojiGroupControl(_ emojiGroupControl: TLEmojiGroupControl, didSelectedGroup group: TLEmojiGroup) {
        // 显示Group表情
        curGroup = group
        resetCollectionSize()
        pageControl.numberOfPages = group.pageNumber
        pageControl.currentPage = 0
        collectionView.reloadData()
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height), animated: false)
        // 更新发送按钮状态
        updateSendButtonStatus()
        // 更新chatBar的textView状态
        delegate?.emojiKeyboard!(self, selectedEmojiGroupType: group.type)
    }
    func emojiGroupControlEditMyEmojiButtonDown(_ emojiGroupControl: TLEmojiGroupControl) {
        delegate?.emojiKeyboardMyEmojiEditButtonDown!()
    }

    func emojiGroupControlEditButtonDown(_ emojiGroupControl: TLEmojiGroupControl) {
        delegate?.emojiKeyboardEmojiEditButtonDown!()
    }

    func emojiGroupControlSendButtonDown(_ emojiGroupControl: TLEmojiGroupControl) {
        delegate?.emojiKeyboardSendButtonDown!()
        // 更新发送按钮状态
        updateSendButtonStatus()
    }
    @objc func longPressAction(_ sender: UILongPressGestureRecognizer) {
        var lastCell: UICollectionViewCell?
        if sender.state == .ended || sender.state == .cancelled {
            // 长按停止
            lastCell = nil
            delegate?.emojiKeyboardCancelTouchEmojiItem!(self)
        } else {
            let point: CGPoint = sender.location(in: collectionView)

            for cell: UICollectionViewCell in collectionView.visibleCells {
                if cell.frame.origin.x - minimumLineSpacing / 2.0 <= (point.x ) && cell.frame.origin.y - minimumInteritemSpacing / 2.0 <= (point.y) && cell.frame.origin.x + cell.frame.size.width + minimumLineSpacing / 2.0 >= (point.x) && cell.frame.origin.y + cell.frame.size.height + minimumInteritemSpacing / 2.0 >= (point.y) {
                    if lastCell == cell {
                        return
                    }
                    lastCell = cell
                    let indexPath: IndexPath = collectionView.indexPath(for: cell) ?? IndexPath(row: 0, section: 0)
                    let index: Int = (indexPath.section) * curGroup.pageItemCount + (indexPath.row)
                    let tIndex = transformModelIndex(index) // 矩阵坐标转置
                    if tIndex >= curGroup.count {
                        delegate?.emojiKeyboardCancelTouchEmojiItem!(self)
                        return
                    }
                    let emoji = curGroup.data[tIndex]
                        emoji.type = curGroup.type
                        var rect: CGRect = cell.frame
                        rect.origin.x = rect.origin.x - frame.size.width * rect.origin.x / frame.size.width
                    delegate?.emojiKeyboard!(self, didTouchEmojiItem: emoji, at: rect)
                    return
                }
            }
            lastCell = nil
            delegate?.emojiKeyboardCancelTouchEmojiItem!(self)
        }
    }
}
