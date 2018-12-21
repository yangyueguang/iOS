//
//  TLEmojiKeyboard.swift
//  Freedom

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
    var sectionInsets: UIEdgeInsets

    var emojiGroupData: [AnyHashable] = []
    weak var delegate: TLEmojiKeyboardDelegate
    weak var keyboardDelegate: TLKeyboardDelegate
    var curGroup: TLEmojiGroup
    var collectionView: UICollectionView
    var pageControl: UIPageControl
    var groupControl: TLEmojiGroupControl
    
    class func keyboard() -> TLEmojiKeyboard {
        // TODO: [Swiftify] ensure that the code below is executed only once (`dispatch_once()` is deprecated)
        {
            emojiKB = TLEmojiKeyboard()
        }
        return emojiKB
    }

    init() {
        super.init()

        backgroundColor = UIColor(245.0, 245.0, 247.0, 1.0)
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(groupControl)
        p_addMasonry()

        registerCellClass()
        addGusture()

    }

    func setEmojiGroupData(_ emojiGroupData: [AnyHashable]) {
        var emojiGroupData = emojiGroupData
        groupControl.setEmojiGroupData(emojiGroupData)
    }
    func show(in view: UIView, withAnimation animation: Bool) {
        if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardWillShow(_:))) {
            keyboardDelegate.chatKeyboardWillShow(self)
        }
        view.addSubview(self)
        mas_remakeConstraints({ make in
            make.left.and().right().mas_equalTo(view)
            make.height.mas_equalTo(215.0)
            make.bottom.mas_equalTo(view).mas_offset(215.0)
        })
        view.layoutIfNeeded()
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.mas_updateConstraints({ make in
                    make.bottom.mas_equalTo(view)
                })
                view.layoutIfNeeded()
                if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboard(_:didChangeHeight:))) {
                    keyboardDelegate.chatKeyboard(self, didChangeHeight: (view.frame.size.height) - self.frame.origin.y)
                }
            }) { finished in
                if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardDidShow(_:))) {
                    keyboardDelegate.chatKeyboardDidShow(self)
                }
            }
        } else {
            mas_updateConstraints({ make in
                make.bottom.mas_equalTo(view)
            })
            view.layoutIfNeeded()
            if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardDidShow(_:))) {
                keyboardDelegate.chatKeyboardDidShow(self)
            }
        }
        updateSendButtonStatus()
        if delegate && delegate.responds(to: #selector(self.emojiKeyboard(_:selectedEmojiGroupType:))) {
            delegate.emojiKeyboard(self, selectedEmojiGroupType: curGroup.type)
        }
    }
    func dismiss(withAnimation animation: Bool) {
        if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardWillDismiss(_:))) {
            keyboardDelegate.chatKeyboardWillDismiss(self)
        }
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.mas_updateConstraints({ make in
                    make.bottom.mas_equalTo(self.superview).mas_offset(215.0)
                })
                self.superview.layoutIfNeeded()
                if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboard(_:didChangeHeight:))) {
                    keyboardDelegate.chatKeyboard(self, didChangeHeight: self.superview.frame.size.height - self.frame.origin.y)
                }
            }) { finished in
                self.removeFromSuperview()
                if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardDidDismiss(_:))) {
                    keyboardDelegate.chatKeyboardDidDismiss(self)
                }
            }
        } else {
            removeFromSuperview()
            if keyboardDelegate && keyboardDelegate.responds(to: #selector(self.chatKeyboardDidDismiss(_:))) {
                keyboardDelegate.chatKeyboardDidDismiss(self)
            }
        }
    }
    func reset() {
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height), animated: false)
        // 更新发送按钮状态
        updateSendButtonStatus()
    }

    // MARK: - Event Response -
    func pageControlChanged(_ pageControl: UIPageControl) {
        collectionView.scrollRectToVisible(CGRect(x: CGFloat(APPW * (pageControl.currentPage)), y: 0, width: APPW, height: 215), animated: true)
    }
    func p_addMasonry() {
        collectionView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self).mas_offset(10)
            make.left.and().right().mas_equalTo(self)
            make.height.mas_equalTo((215.0 * 0.75 - 10))
        })
        pageControl.mas_makeConstraints({ make in
            make.left.and().right().mas_equalTo(self)
            make.bottom.mas_equalTo(self.groupControl.mas_top)
            make.height.mas_equalTo(215)
        })
        groupControl.mas_makeConstraints({ make in
            make.left.and().right().and().bottom().mas_equalTo(self)
            make.height.mas_equalTo(215 * 0.17)
        })
    }
    func draw(_ rect: CGRect) {
        super.draw(rect)
        // 顶部直线
        let context = UIGraphicsGetCurrentContext()
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: APPW, y: 0))
        context.strokePath()
    }
    var collectionView: UICollectionView! {
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.clear
            collectionView.isPagingEnabled = true
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.scrollsToTop = false
        }
        return collectionView
    }
    func pageControl() -> UIPageControl {
        if pageControl == nil {
            pageControl = UIPageControl()
            pageControl.center = CGPoint(x: center.x, y: pageControl.center.y)
            pageControl.pageIndicatorTintColor = UIColor.gray
            pageControl.currentPageIndicatorTintColor = UIColor.gray
            pageControl.addTarget(self, action: #selector(self.pageControlChanged(_:)), for: .valueChanged)
        }
        return pageControl
    }

    func groupControl() -> TLEmojiGroupControl {
        if groupControl == nil {
            groupControl = TLEmojiGroupControl()
            groupControl.delegate = self
        }
        return groupControl
    }
    func registerCellClass() {
        collectionView.register(TLEmojiItemCell.self, forCellWithReuseIdentifier: "TLEmojiItemCell")
        collectionView.register(TLEmojiFaceItemCell.self, forCellWithReuseIdentifier: "TLEmojiFaceItemCell")
        collectionView.register(TLEmojiImageItemCell.self, forCellWithReuseIdentifier: "TLEmojiImageItemCell")
        collectionView.register(TLEmojiImageTitleItemCell.self, forCellWithReuseIdentifier: "TLEmojiImageTitleItemCell")
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

    // MARK: - Delegate -
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return curGroup.pageNumber
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curGroup.pageItemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index: Int = indexPath.section * curGroup.pageItemCount + indexPath.row
        var cell: TLEmojiBaseCell
        if curGroup.type == TLEmojiTypeEmoji {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLEmojiItemCell", for: indexPath)
        } else if curGroup.type == TLEmojiTypeFace {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLEmojiFaceItemCell", for: indexPath)
        } else if curGroup.type == TLEmojiTypeImageWithTitle {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLEmojiImageTitleItemCell", for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLEmojiImageItemCell", for: indexPath)
        }
        let tIndex = transformModelIndex(index) // 矩阵坐标转置
        let emojiItem = curGroup.count > tIndex  curGroup[tIndex] : nil as TLEmoji
        cell.emojiItem = emojiItem
        return cell
    }
    func resetCollectionSize() {
        var cellHeight: Float
        var cellWidth: Float
        var topSpace: Float = 0
        var btmSpace: Float = 0
        var hfSpace: Float = 0
        if curGroup.type == TLEmojiTypeFace || curGroup.type == TLEmojiTypeEmoji {
            cellHeight = ((215.0 * 0.75 - 10) / curGroup.rowNumber) * 0.55
            cellWidth = cellHeight
            topSpace = 11
            btmSpace = 19
            hfSpace = (APPW - cellWidth * curGroup.colNumber) / (curGroup.colNumber + 1) * 1.4
        } else if curGroup.type == TLEmojiTypeImageWithTitle {
            cellHeight = ((215.0 * 0.75 - 10) / curGroup.rowNumber) * 0.96
            cellWidth = cellHeight * 0.8
            hfSpace = (APPW - cellWidth * curGroup.colNumber) / (curGroup.colNumber + 1) * 1.2
        } else {
            cellHeight = ((215.0 * 0.75 - 10) / curGroup.rowNumber) * 0.72
            cellWidth = cellHeight
            topSpace = 8
            btmSpace = 16
            hfSpace = (APPW - cellWidth * curGroup.colNumber) / (curGroup.colNumber + 1) * 1.2
        }

        cellSize = CGSize(width: cellWidth, height: cellHeight)
        headerReferenceSize = CGSize(width: hfSpace, height: 215.0 * 0.75 - 10)
        footerReferenceSize = CGSize(width: hfSpace, height: 215.0 * 0.75 - 10)
        minimumLineSpacing = (APPW - hfSpace * 2 - cellWidth * curGroup.colNumber) / (curGroup.colNumber - 1)
        minimumInteritemSpacing = ((215.0 * 0.75 - 10) - topSpace - btmSpace - cellHeight * curGroup.rowNumber) / (curGroup.rowNumber - 1)
        sectionInsets = UIEdgeInsetsMake(topSpace, 0, btmSpace, 0)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / APPW)
    }

    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index: Int = indexPath.section * curGroup.pageItemCount + indexPath.row
        let tIndex = transformModelIndex(index) // 矩阵坐标转置
        if tIndex < curGroup.count {
            let item = curGroup[tIndex] as TLEmoji
            if delegate && delegate.responds(to: #selector(self.emojiKeyboard(_:didSelectedEmojiItem:))) {
                //FIXME: 表情类型
                item.type = curGroup.type
                delegate.emojiKeyboard(self, didSelectedEmojiItem: item)
            }
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

    // MARK: - Public Methods -
    func updateSendButtonStatus() {
        if curGroup.type == TLEmojiTypeEmoji || curGroup.type == TLEmojiTypeFace {
            if delegate.chatInputViewHasText() {
                groupControl.sendButtonStatus = TLGroupControlSendButtonStatusBlue
            } else {
                groupControl.sendButtonStatus = TLGroupControlSendButtonStatusGray
            }
        } else {
            groupControl.sendButtonStatus = TLGroupControlSendButtonStatusNone
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
        if delegate && delegate.responds(to: #selector(self.emojiKeyboard(_:selectedEmojiGroupType:))) {
            delegate.emojiKeyboard(self, selectedEmojiGroupType: group.type)
        }
    }
    func emojiGroupControlEditMyEmojiButtonDown(_ emojiGroupControl: TLEmojiGroupControl) {
        if delegate && delegate.responds(to: #selector(self.emojiKeyboardMyEmojiEditButtonDown)) {
            delegate.emojiKeyboardMyEmojiEditButtonDown()
        }
    }

    func emojiGroupControlEditButtonDown(_ emojiGroupControl: TLEmojiGroupControl) {
        if delegate && delegate.responds(to: #selector(self.emojiKeyboardEmojiEditButtonDown)) {
            delegate.emojiKeyboardEmojiEditButtonDown()
        }
    }

    func emojiGroupControlSendButtonDown(_ emojiGroupControl: TLEmojiGroupControl) {
        if delegate && delegate.responds(to: #selector(self.emojiKeyboardSendButtonDown)) {
            delegate.emojiKeyboardSendButtonDown()
        }
        // 更新发送按钮状态
        updateSendButtonStatus()
    }
    func addGusture() {
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(_:)))
        collectionView.addGestureRecognizer(longPressGR)
    }
    func longPressAction(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended || sender.state == .cancelled {
            // 长按停止
            lastCell = nil
            if delegate && delegate.responds(to: #selector(self.emojiKeyboardCancelTouchEmojiItem(_:))) {
                delegate.emojiKeyboardCancelTouchEmojiItem(self)
            }
        } else {
            let point: CGPoint = sender.location(in: collectionView)

            for cell: UICollectionViewCell in collectionView.visibleCells {
                if cell.frame.origin.x - minimumLineSpacing / 2.0 <= (point.x ) && cell.frame.origin.y - minimumInteritemSpacing / 2.0 <= (point.y) && cell.frame.origin.x + cell.frame.size.width + minimumLineSpacing / 2.0 >= (point.x) && cell.frame.origin.y + cell.frame.size.height + minimumInteritemSpacing / 2.0 >= (point.y) {
                    if lastCell == cell {
                        return
                    }
                    lastCell = cell
                    let indexPath: IndexPath = collectionView.indexPath(for: cell)
                    let index: Int = (indexPath.section) * curGroup.pageItemCount + (indexPath.row)
                    let tIndex = transformModelIndex(index) // 矩阵坐标转置
                    if tIndex >= curGroup.count {
                        if delegate && delegate.responds(to: #selector(self.emojiKeyboardCancelTouchEmojiItem(_:))) {
                            delegate.emojiKeyboardCancelTouchEmojiItem(self)
                        }
                        return
                    }
                    let emoji = curGroup[tIndex] as TLEmoji
                    if delegate && delegate.responds(to: #selector(self.emojiKeyboard(_:didTouchEmojiItem:atRect:))) {
                        emoji.type = curGroup.type
                        let rect: CGRect = cell.frame
                        rect.origin.x = rect.origin.x - CGFloat(frame.size.width * Int(rect.origin.x / frame.size.width))
                        delegate.emojiKeyboard(self, didTouchEmojiItem: emoji, atRect: rect)
                    }
                    return
                }
            }

            lastCell = nil
            if delegate && delegate.responds(to: #selector(self.emojiKeyboardCancelTouchEmojiItem(_:))) {
                delegate.emojiKeyboardCancelTouchEmojiItem(self)
            }
        }
    }


    
}
